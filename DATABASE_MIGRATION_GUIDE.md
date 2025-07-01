# 🏗️ Spika Academy - Database Migration Guide

## 📋 Tổng quan

Hướng dẫn này sẽ giúp bạn khôi phục toàn bộ schema database cho hệ thống Spika Academy. Migration bao gồm tất cả các bảng, relationships, indexes, triggers, và policies cần thiết.

## 🗂️ Cấu trúc Database

### Các bảng chính:

1. **profiles** - Thông tin người dùng (admin, teacher, student)
2. **courses** - Thông tin khóa học
3. **classes** - Thông tin lớp học
4. **enrollments** - Đăng ký học
5. **lessons** - Buổi học
6. **assignments** - Bài tập
7. **assignment_submissions** - Bài nộp
8. **website_analytics** - Thống kê website

### Relationships:
- courses → classes (1:n)
- profiles → classes (teacher, 1:n)
- profiles → enrollments (student, 1:n)
- classes → enrollments (1:n)
- classes → lessons (1:n)
- lessons → assignments (1:n)
- assignments → assignment_submissions (1:n)
- profiles → assignment_submissions (student, 1:n)

## 🚀 Cách chạy Migration

### Phương pháp 1: Sử dụng HTML Tool (Khuyến nghị)

1. **Mở file `run-complete-migration.html`** trong trình duyệt
2. **Nhấn "Chạy Complete Migration"**
3. **Chờ quá trình hoàn thành** (khoảng 2-3 phút)
4. **Kiểm tra kết quả** bằng nút "Kiểm tra Database"

### Phương pháp 2: Sử dụng Node.js Script

```bash
# Cài đặt dependencies (nếu chưa có)
npm install @supabase/supabase-js

# Set environment variable
export SUPABASE_SERVICE_KEY="your-service-role-key"

# Chạy migration
node scripts/run-migration.js
```

### Phương pháp 3: Chạy trực tiếp SQL

1. **Copy nội dung file** `supabase/migrations/20241201000000_create_complete_schema.sql`
2. **Paste vào Supabase SQL Editor**
3. **Chạy từng phần** (chia nhỏ để tránh timeout)

## 📊 Load Sample Data

Sau khi migration thành công, bạn có thể load dữ liệu mẫu:

### Sử dụng HTML Tool:
1. **Mở file `load-sample-data.html`** trong trình duyệt
2. **Nhấn "Load Sample Data"**
3. **Chờ quá trình hoàn thành**

### Dữ liệu mẫu bao gồm:
- **1 Admin:** admin@spika.edu.vn (password: 123456)
- **3 Teachers:** Các giáo viên chuyên ngành khác nhau
- **5 Students:** Học viên ở các năm học khác nhau
- **4 Courses:** React Web, React Native, Data Science, DevOps
- **4 Classes:** Các lớp học đang hoạt động
- **Enrollments, Lessons, Assignments:** Dữ liệu liên quan

## 🔐 Thông tin đăng nhập mẫu

### Admin:
- **Email:** admin@spika.edu.vn
- **Password:** 123456
- **Role:** admin

### Teachers:
- **Email:** nguyenvana@spika.edu.vn
- **Password:** 123456
- **Role:** teacher

### Students:
- **Email:** student1@gmail.com
- **Password:** 123456
- **Role:** student

## 🛠️ Kiểm tra Migration

### 1. Kiểm tra bảng:
```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;
```

### 2. Kiểm tra indexes:
```sql
SELECT schemaname, tablename, indexname 
FROM pg_indexes 
WHERE schemaname = 'public' 
ORDER BY tablename, indexname;
```

### 3. Kiểm tra policies:
```sql
SELECT schemaname, tablename, policyname 
FROM pg_policies 
WHERE schemaname = 'public' 
ORDER BY tablename, policyname;
```

### 4. Kiểm tra dữ liệu:
```sql
-- Đếm số lượng records trong mỗi bảng
SELECT 
  'profiles' as table_name, COUNT(*) as count FROM profiles
UNION ALL
SELECT 
  'courses' as table_name, COUNT(*) as count FROM courses
UNION ALL
SELECT 
  'classes' as table_name, COUNT(*) as count FROM classes
-- ... tiếp tục cho các bảng khác
```

## 🔧 Troubleshooting

### Lỗi thường gặp:

#### 1. "Permission denied"
- **Nguyên nhân:** Không có quyền admin hoặc service role
- **Giải pháp:** Sử dụng service role key thay vì anon key

#### 2. "Table already exists"
- **Nguyên nhân:** Bảng đã tồn tại từ trước
- **Giải pháp:** Migration sử dụng `CREATE TABLE IF NOT EXISTS` nên an toàn

#### 3. "Function exec_sql does not exist"
- **Nguyên nhân:** Supabase project chưa enable SQL execution
- **Giải pháp:** Enable trong Dashboard > Settings > API

#### 4. "Timeout"
- **Nguyên nhân:** Migration quá lớn
- **Giải pháp:** Chia nhỏ migration hoặc tăng timeout

### Debug steps:

1. **Kiểm tra connection:**
```javascript
const { data, error } = await supabase.from('profiles').select('count');
console.log('Connection test:', { data, error });
```

2. **Kiểm tra permissions:**
```sql
SELECT current_user, current_setting('role');
```

3. **Xem logs chi tiết:**
- Mở Developer Tools (F12)
- Xem Console tab để thấy lỗi chi tiết

## 📁 Cấu trúc Files

```
/
├── supabase/
│   └── migrations/
│       ├── 20241201000000_create_complete_schema.sql  # Migration chính
│       └── 20241201000001_sample_data.sql             # Dữ liệu mẫu
├── scripts/
│   └── run-migration.js                               # Node.js script
├── run-complete-migration.html                        # HTML tool chính
├── load-sample-data.html                             # HTML tool load data
├── view-database.html                                # Tool xem database
└── DATABASE_MIGRATION_GUIDE.md                       # File này
```

## 🎯 Kết quả mong đợi

Sau khi migration thành công:

- ✅ **8 bảng** được tạo với đầy đủ cấu trúc
- ✅ **20+ indexes** để tối ưu performance
- ✅ **7 triggers** tự động cập nhật timestamps
- ✅ **15+ RLS policies** bảo mật dữ liệu
- ✅ **Comments** mô tả chi tiết cho tất cả bảng/cột
- ✅ **Sample data** sẵn sàng để testing

## 🔄 Backup & Restore

### Backup trước khi migration:
```bash
# Sử dụng Supabase CLI
supabase db dump --file backup.sql

# Hoặc sử dụng pg_dump
pg_dump "postgresql://..." > backup.sql
```

### Restore nếu cần:
```bash
# Sử dụng Supabase CLI
supabase db reset --file backup.sql

# Hoặc sử dụng psql
psql "postgresql://..." < backup.sql
```

## 📞 Hỗ trợ

Nếu gặp vấn đề:

1. **Kiểm tra logs** trong HTML tools
2. **Xem Developer Console** (F12) để debug
3. **Kiểm tra Supabase Dashboard** > Logs
4. **Thử chạy từng phần** migration thay vì toàn bộ

---

**Chúc bạn migration thành công! 🎉**
