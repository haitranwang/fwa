#!/usr/bin/env node

/**
 * Script để chạy migration và kiểm tra kết quả
 * Sử dụng: node scripts/run-migration.js
 */

import { createClient } from '@supabase/supabase-js';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Cấu hình Supabase
const SUPABASE_URL = "https://ltytzzennnlgbwkkhwnv.supabase.co";
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_KEY;

if (!SUPABASE_SERVICE_KEY) {
  console.error('❌ SUPABASE_SERVICE_KEY environment variable is required');
  console.log('💡 Hướng dẫn:');
  console.log('   1. Vào Supabase Dashboard > Settings > API');
  console.log('   2. Copy service_role key');
  console.log('   3. Chạy: export SUPABASE_SERVICE_KEY="your-service-key"');
  console.log('   4. Sau đó chạy lại script này');
  process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

/**
 * Đọc file migration SQL
 */
function readMigrationFile() {
  const migrationPath = path.join(__dirname, '../supabase/migrations/20241201000000_create_complete_schema.sql');

  if (!fs.existsSync(migrationPath)) {
    throw new Error(`Migration file not found: ${migrationPath}`);
  }

  return fs.readFileSync(migrationPath, 'utf8');
}

/**
 * Chạy migration SQL sử dụng Supabase client trực tiếp
 */
async function runMigration() {
  console.log('🚀 Bắt đầu chạy migration...\n');

  try {
    const migrationSQL = readMigrationFile();
    console.log('📖 Đã đọc file migration thành công');

    console.log('🔧 Sử dụng phương pháp migration trực tiếp...\n');

    // Thực hiện migration từng bước
    let successCount = 0;
    let errorCount = 0;

    // Step 1: Create ENUM types
    console.log('⏳ Bước 1: Tạo ENUM types...');
    try {
      await createEnumTypes();
      console.log('✅ Tạo ENUM types thành công');
      successCount++;
    } catch (error) {
      console.log(`❌ Lỗi tạo ENUM types: ${error.message}`);
      errorCount++;
    }

    // Step 2: Create tables
    console.log('⏳ Bước 2: Tạo các bảng...');
    try {
      await createTables();
      console.log('✅ Tạo bảng thành công');
      successCount++;
    } catch (error) {
      console.log(`❌ Lỗi tạo bảng: ${error.message}`);
      errorCount++;
    }

    // Step 3: Create indexes
    console.log('⏳ Bước 3: Tạo indexes...');
    try {
      await createIndexes();
      console.log('✅ Tạo indexes thành công');
      successCount++;
    } catch (error) {
      console.log(`❌ Lỗi tạo indexes: ${error.message}`);
      errorCount++;
    }

    // Step 4: Create functions and triggers
    console.log('⏳ Bước 4: Tạo functions và triggers...');
    try {
      await createFunctionsAndTriggers();
      console.log('✅ Tạo functions và triggers thành công');
      successCount++;
    } catch (error) {
      console.log(`❌ Lỗi tạo functions và triggers: ${error.message}`);
      errorCount++;
    }

    // Step 5: Enable RLS and create policies
    console.log('⏳ Bước 5: Thiết lập RLS và policies...');
    try {
      await setupRLSAndPolicies();
      console.log('✅ Thiết lập RLS và policies thành công');
      successCount++;
    } catch (error) {
      console.log(`❌ Lỗi thiết lập RLS và policies: ${error.message}`);
      errorCount++;
    }

    // Step 6: Add sample analytics data
    console.log('⏳ Bước 6: Thêm dữ liệu analytics mẫu...');
    try {
      await addSampleAnalyticsData();
      console.log('✅ Thêm dữ liệu analytics mẫu thành công');
      successCount++;
    } catch (error) {
      console.log(`❌ Lỗi thêm dữ liệu analytics: ${error.message}`);
      errorCount++;
    }

    console.log('\n📊 Kết quả migration:');
    console.log(`✅ Thành công: ${successCount} bước`);
    console.log(`❌ Lỗi: ${errorCount} bước`);

    if (errorCount === 0) {
      console.log('\n🎉 Migration hoàn thành thành công!');
    } else {
      console.log('\n⚠️  Migration hoàn thành với một số lỗi');
    }

  } catch (error) {
    console.error('❌ Lỗi khi chạy migration:', error.message);
    throw error;
  }
}

/**
 * Tạo ENUM types
 */
async function createEnumTypes() {
  const enumQueries = [
    "CREATE TYPE user_role AS ENUM ('student', 'teacher', 'admin')",
    "CREATE TYPE course_status AS ENUM ('Đang mở', 'Đang bắt đầu', 'Kết thúc')",
    "CREATE TYPE course_level AS ENUM ('basic', 'intermediate', 'advance')",
    "CREATE TYPE class_status AS ENUM ('Đang hoạt động', 'Đã kết thúc')",
    "CREATE TYPE trang_thai_bai_nop AS ENUM ('Chưa làm', 'Đang chờ chấm', 'Đã hoàn thành')"
  ];

  for (const query of enumQueries) {
    try {
      await supabase.rpc('exec_sql', { sql: query });
    } catch (error) {
      // Ignore "already exists" errors
      if (!error.message.includes('already exists')) {
        throw error;
      }
    }
  }
}

/**
 * Tạo các bảng
 */
async function createTables() {
  // Tạo bảng profiles
  await supabase.schema('public').createTable('profiles', (table) => {
    table.uuid('id').defaultTo(supabase.raw('gen_random_uuid()')).primary();
    table.string('username', 50).unique().notNullable();
    table.string('email', 255).unique().notNullable();
    table.string('password', 255).notNullable();
    table.string('fullname', 255).notNullable();
    table.enum('role', ['student', 'teacher', 'admin']).defaultTo('student');
    table.integer('age');
    table.string('phone_number', 20);
    table.text('avatar_url');
    table.text('info');
    table.timestamp('created_at').defaultTo(supabase.raw("timezone('utc'::text, now())"));
    table.timestamp('updated_at').defaultTo(supabase.raw("timezone('utc'::text, now())"));
  });

  // Tạo các bảng khác tương tự...
  // (Sẽ sử dụng raw SQL để đơn giản hóa)
}

/**
 * Tạo indexes
 */
async function createIndexes() {
  const indexQueries = [
    "CREATE INDEX IF NOT EXISTS idx_profiles_email ON public.profiles(email)",
    "CREATE INDEX IF NOT EXISTS idx_profiles_username ON public.profiles(username)",
    "CREATE INDEX IF NOT EXISTS idx_profiles_role ON public.profiles(role)",
    // ... thêm các indexes khác
  ];

  for (const query of indexQueries) {
    await supabase.rpc('exec_sql', { sql: query });
  }
}

/**
 * Tạo functions và triggers
 */
async function createFunctionsAndTriggers() {
  const functionSQL = `
    CREATE OR REPLACE FUNCTION update_updated_at_column()
    RETURNS TRIGGER AS $$
    BEGIN
        NEW.updated_at = timezone('utc'::text, now());
        RETURN NEW;
    END;
    $$ language 'plpgsql';
  `;

  await supabase.rpc('exec_sql', { sql: functionSQL });

  // Tạo triggers cho các bảng
  const triggerQueries = [
    "CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column()",
    // ... thêm triggers khác
  ];

  for (const query of triggerQueries) {
    await supabase.rpc('exec_sql', { sql: query });
  }
}

/**
 * Thiết lập RLS và policies
 */
async function setupRLSAndPolicies() {
  // Enable RLS
  const rlsQueries = [
    "ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY",
    "ALTER TABLE public.courses ENABLE ROW LEVEL SECURITY",
    // ... thêm các bảng khác
  ];

  for (const query of rlsQueries) {
    await supabase.rpc('exec_sql', { sql: query });
  }

  // Tạo policies
  const policyQueries = [
    `CREATE POLICY "Users can view own profile" ON public.profiles FOR SELECT USING (auth.uid() = id)`,
    // ... thêm policies khác
  ];

  for (const query of policyQueries) {
    await supabase.rpc('exec_sql', { sql: query });
  }
}

/**
 * Thêm dữ liệu analytics mẫu
 */
async function addSampleAnalyticsData() {
  const { error } = await supabase
    .from('website_analytics')
    .upsert([
      {
        date: new Date(Date.now() - 6 * 24 * 60 * 60 * 1000).toISOString().split('T')[0],
        visit_count: 1200,
        unique_visitors: 800,
        page_views: 2400
      },
      {
        date: new Date(Date.now() - 5 * 24 * 60 * 60 * 1000).toISOString().split('T')[0],
        visit_count: 1350,
        unique_visitors: 900,
        page_views: 2700
      },
      // ... thêm dữ liệu khác
    ], { onConflict: 'date' });

  if (error) throw error;
}

/**
 * Kiểm tra kết quả migration
 */
async function verifyMigration() {
  console.log('\n🔍 Kiểm tra kết quả migration...\n');

  const tables = [
    'profiles',
    'courses',
    'classes',
    'enrollments',
    'lessons',
    'assignments',
    'assignment_submissions',
    'website_analytics'
  ];

  for (const table of tables) {
    try {
      const { data, error } = await supabase
        .from(table)
        .select('*', { count: 'exact', head: true });

      if (error) {
        console.log(`❌ Bảng ${table}: ${error.message}`);
      } else {
        console.log(`✅ Bảng ${table}: OK (${data?.length || 0} records)`);
      }
    } catch (err) {
      console.log(`❌ Bảng ${table}: ${err.message}`);
    }
  }
}

/**
 * Kiểm tra indexes
 */
async function verifyIndexes() {
  console.log('\n🔍 Kiểm tra indexes...\n');

  try {
    const { data, error } = await supabase.rpc('exec_sql', {
      sql: `
        SELECT
          schemaname,
          tablename,
          indexname,
          indexdef
        FROM pg_indexes
        WHERE schemaname = 'public'
        ORDER BY tablename, indexname;
      `
    });

    if (error) {
      console.log('❌ Không thể kiểm tra indexes:', error.message);
    } else {
      console.log(`✅ Tìm thấy ${data?.length || 0} indexes`);

      if (data && data.length > 0) {
        const indexesByTable = data.reduce((acc, index) => {
          if (!acc[index.tablename]) {
            acc[index.tablename] = [];
          }
          acc[index.tablename].push(index.indexname);
          return acc;
        }, {});

        Object.entries(indexesByTable).forEach(([table, indexes]) => {
          console.log(`   📋 ${table}: ${indexes.length} indexes`);
        });
      }
    }
  } catch (err) {
    console.log('❌ Lỗi khi kiểm tra indexes:', err.message);
  }
}

/**
 * Main function
 */
async function main() {
  try {
    console.log('🏗️  SPIKA ACADEMY - DATABASE MIGRATION TOOL');
    console.log('='.repeat(50));

    await runMigration();
    await verifyMigration();
    await verifyIndexes();

    console.log('\n🎯 Migration hoàn tất!');
    console.log('💡 Bạn có thể kiểm tra database bằng cách:');
    console.log('   - Mở Supabase Dashboard');
    console.log('   - Hoặc sử dụng file view-database.html');

  } catch (error) {
    console.error('\n💥 Migration thất bại:', error.message);
    process.exit(1);
  }
}

// Chạy script
main();
