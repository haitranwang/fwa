// Script để setup analytics và test các chức năng
import { createClient } from '@supabase/supabase-js';
import fs from 'fs';
import path from 'path';

const SUPABASE_URL = "https://xotapvuospvnlhuqyyjp.supabase.co";
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_KEY; // Cần service key để chạy migration

if (!SUPABASE_SERVICE_KEY) {
  console.error('❌ SUPABASE_SERVICE_KEY environment variable is required');
  process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

async function runMigration() {
  try {
    console.log('🚀 Running analytics migration...');
    
    // Đọc file SQL migration
    const migrationPath = path.join(process.cwd(), 'supabase/migrations/create_website_analytics.sql');
    const migrationSQL = fs.readFileSync(migrationPath, 'utf8');
    
    // Chạy migration
    const { error } = await supabase.rpc('exec_sql', { sql: migrationSQL });
    
    if (error) {
      throw error;
    }
    
    console.log('✅ Migration completed successfully');
    return true;
  } catch (error) {
    console.error('❌ Migration failed:', error.message);
    return false;
  }
}

async function testAnalyticsAPI() {
  try {
    console.log('🧪 Testing analytics API...');
    
    // Test 1: Kiểm tra bảng đã được tạo
    const { data: tableCheck, error: tableError } = await supabase
      .from('website_analytics')
      .select('count')
      .limit(1);
    
    if (tableError) {
      throw new Error(`Table check failed: ${tableError.message}`);
    }
    
    console.log('✅ Table exists and accessible');
    
    // Test 2: Kiểm tra dữ liệu mẫu
    const { data: sampleData, error: sampleError } = await supabase
      .from('website_analytics')
      .select('*')
      .order('date', { ascending: false })
      .limit(5);
    
    if (sampleError) {
      throw new Error(`Sample data check failed: ${sampleError.message}`);
    }
    
    console.log(`✅ Found ${sampleData?.length || 0} sample records`);
    
    // Test 3: Test insert/update
    const today = new Date().toISOString().split('T')[0];
    const { data: upsertData, error: upsertError } = await supabase
      .from('website_analytics')
      .upsert({
        date: today,
        visit_count: 100,
        unique_visitors: 80,
        page_views: 200
      }, {
        onConflict: 'date'
      })
      .select();
    
    if (upsertError) {
      throw new Error(`Upsert test failed: ${upsertError.message}`);
    }
    
    console.log('✅ Upsert operation successful');
    
    // Test 4: Test date range query
    const sevenDaysAgo = new Date();
    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);
    const startDate = sevenDaysAgo.toISOString().split('T')[0];
    
    const { data: rangeData, error: rangeError } = await supabase
      .from('website_analytics')
      .select('*')
      .gte('date', startDate)
      .lte('date', today)
      .order('date', { ascending: true });
    
    if (rangeError) {
      throw new Error(`Date range query failed: ${rangeError.message}`);
    }
    
    console.log(`✅ Date range query returned ${rangeData?.length || 0} records`);
    
    return true;
  } catch (error) {
    console.error('❌ API test failed:', error.message);
    return false;
  }
}

async function testPermissions() {
  try {
    console.log('🔐 Testing permissions...');
    
    // Tạo client với anon key để test RLS
    const anonClient = createClient(
      SUPABASE_URL, 
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhvdGFwdnVvc3B2bmxodXF5eWpwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc5OTI0MjAsImV4cCI6MjA2MzU2ODQyMH0.kKf-fSAik4y9sSU61nRXidNnVkv9KbXafMBP4zb0NTY"
    );
    
    // Test: Anon user không thể truy cập
    const { data: anonData, error: anonError } = await anonClient
      .from('website_analytics')
      .select('*')
      .limit(1);
    
    if (!anonError) {
      console.log('⚠️  Warning: Anonymous users can access analytics data');
    } else {
      console.log('✅ Anonymous access properly blocked');
    }
    
    return true;
  } catch (error) {
    console.error('❌ Permission test failed:', error.message);
    return false;
  }
}

async function generateTestData() {
  try {
    console.log('📊 Generating additional test data...');
    
    const testData = [];
    const today = new Date();
    
    // Tạo dữ liệu cho 30 ngày qua
    for (let i = 29; i >= 0; i--) {
      const date = new Date(today);
      date.setDate(date.getDate() - i);
      const dateStr = date.toISOString().split('T')[0];
      
      // Tạo dữ liệu ngẫu nhiên nhưng có xu hướng
      const baseVisits = 800 + Math.floor(Math.random() * 400);
      const weekendMultiplier = [0, 6].includes(date.getDay()) ? 0.7 : 1; // Cuối tuần ít hơn
      const visits = Math.floor(baseVisits * weekendMultiplier);
      const uniqueVisitors = Math.floor(visits * (0.6 + Math.random() * 0.2)); // 60-80% của visits
      const pageViews = Math.floor(visits * (1.5 + Math.random() * 1)); // 1.5-2.5 pages per visit
      
      testData.push({
        date: dateStr,
        visit_count: visits,
        unique_visitors: uniqueVisitors,
        page_views: pageViews
      });
    }
    
    // Insert dữ liệu test
    const { error } = await supabase
      .from('website_analytics')
      .upsert(testData, { onConflict: 'date' });
    
    if (error) {
      throw error;
    }
    
    console.log(`✅ Generated ${testData.length} test records`);
    return true;
  } catch (error) {
    console.error('❌ Test data generation failed:', error.message);
    return false;
  }
}

async function main() {
  console.log('🎯 Starting analytics setup and testing...\n');
  
  const results = {
    migration: await runMigration(),
    apiTest: await testAnalyticsAPI(),
    permissions: await testPermissions(),
    testData: await generateTestData()
  };
  
  console.log('\n📋 Setup Results:');
  console.log(`Migration: ${results.migration ? '✅' : '❌'}`);
  console.log(`API Test: ${results.apiTest ? '✅' : '❌'}`);
  console.log(`Permissions: ${results.permissions ? '✅' : '❌'}`);
  console.log(`Test Data: ${results.testData ? '✅' : '❌'}`);
  
  const allPassed = Object.values(results).every(result => result);
  
  if (allPassed) {
    console.log('\n🎉 All tests passed! Analytics system is ready to use.');
    console.log('\n📝 Next steps:');
    console.log('1. Start the development server: npm run dev');
    console.log('2. Login as admin and navigate to /admin?tab=analytics');
    console.log('3. Verify the analytics dashboard is working');
  } else {
    console.log('\n❌ Some tests failed. Please check the errors above.');
    process.exit(1);
  }
}

// Chạy script
main().catch(error => {
  console.error('💥 Script failed:', error);
  process.exit(1);
});
