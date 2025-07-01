# 📋 Copy-Paste Migration - Khôi phục Database trong 5 phút

## 🎯 Hướng dẫn nhanh

### Bước 1: Mở Supabase Dashboard
1. Truy cập: https://supabase.com/dashboard
2. Chọn project của bạn
3. Vào **SQL Editor** (trong sidebar)

### Bước 2: Copy Migration SQL
1. Mở file `supabase/migrations/20241201000000_create_complete_schema.sql`
2. **Select All** (Ctrl+A)
3. **Copy** (Ctrl+C)

### Bước 3: Chạy Migration
1. **Paste** vào SQL Editor (Ctrl+V)
2. **Nhấn "Run"** (hoặc Ctrl+Enter)
3. **Chờ 1-2 phút** để hoàn thành

### Bước 4: Kiểm tra kết quả
1. Vào tab **Tables** để xem các bảng đã tạo
2. Hoặc chạy query kiểm tra:

```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;
```

## ✅ Kết quả mong đợi

Sau khi migration thành công, bạn sẽ thấy 8 bảng:
- assignment_submissions
- assignments  
- classes
- courses
- enrollments
- lessons
- profiles
- website_analytics

## 📊 Load Sample Data (Tùy chọn)

Nếu muốn có dữ liệu mẫu để test:

### Bước 1: Copy Sample Data SQL
1. Mở file `supabase/migrations/20241201000001_sample_data.sql`
2. **Select All** (Ctrl+A)
3. **Copy** (Ctrl+C)

### Bước 2: Chạy Sample Data
1. **Paste** vào SQL Editor (Ctrl+V)
2. **Nhấn "Run"** (hoặc Ctrl+Enter)
3. **Chờ hoàn thành**

### Bước 3: Test đăng nhập
Sau khi load sample data, bạn có thể đăng nhập với:
- **Admin:** admin@spika.edu.vn / 123456
- **Teacher:** nguyenvana@spika.edu.vn / 123456
- **Student:** student1@gmail.com / 123456

## 🚨 Nếu gặp lỗi Timeout

Migration quá lớn có thể gây timeout. Hãy chia thành các phần nhỏ:

### Phần 1: ENUM Types và Tables (Chạy trước)
```sql
-- Copy từ dòng 1 đến dòng 126 trong file migration
-- Bao gồm: CREATE TYPE và CREATE TABLE
```

### Phần 2: Indexes (Chạy sau)
```sql
-- Copy từ dòng 127 đến dòng 171
-- Bao gồm: CREATE INDEX
```

### Phần 3: Functions và Triggers
```sql
-- Copy từ dòng 172 đến dòng 230
-- Bao gồm: CREATE FUNCTION và CREATE TRIGGER
```

### Phần 4: RLS và Policies
```sql
-- Copy từ dòng 231 đến dòng 490
-- Bao gồm: ALTER TABLE ENABLE RLS và CREATE POLICY
```

### Phần 5: Comments và Sample Data
```sql
-- Copy từ dòng 491 đến cuối file
-- Bao gồm: COMMENT ON và INSERT INTO
```

## 🔍 Kiểm tra chi tiết

### Kiểm tra số lượng bảng:
```sql
SELECT COUNT(*) as table_count
FROM information_schema.tables 
WHERE table_schema = 'public';
```
**Kết quả mong đợi:** 8

### Kiểm tra indexes:
```sql
SELECT COUNT(*) as index_count
FROM pg_indexes 
WHERE schemaname = 'public';
```
**Kết quả mong đợi:** 20+

### Kiểm tra dữ liệu (nếu đã load sample):
```sql
SELECT 
  'profiles' as table_name, COUNT(*) as count FROM profiles
UNION ALL
SELECT 
  'courses' as table_name, COUNT(*) as count FROM courses
UNION ALL
SELECT 
  'classes' as table_name, COUNT(*) as count FROM classes;
```

## 💡 Tips quan trọng

1. **Backup trước khi chạy** nếu có dữ liệu quan trọng
2. **Chạy migration chính trước**, sample data sau
3. **Kiểm tra logs** trong Dashboard nếu có lỗi
4. **Sử dụng service role key** nếu cần quyền admin
5. **Refresh browser** sau khi migration để thấy tables mới

## 🎉 Hoàn thành!

Sau khi migration thành công:
- ✅ Database schema hoàn chỉnh
- ✅ Tất cả relationships và constraints
- ✅ Security policies (RLS)
- ✅ Performance indexes
- ✅ Sample data (nếu load)

Bạn có thể bắt đầu sử dụng ứng dụng ngay lập tức!

---

**Chúc bạn migration thành công! 🚀**

*Nếu vẫn gặp vấn đề, hãy kiểm tra file `QUICK_MIGRATION_GUIDE.md` để biết thêm chi tiết.*
