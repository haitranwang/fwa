# 🚀 Quick Migration Guide - Khôi phục Database ngay lập tức

## ❌ Vấn đề gặp phải

Script Node.js gặp lỗi `exec_sql` function không tồn tại vì Supabase không hỗ trợ function này.

## ✅ Giải pháp nhanh nhất

### Phương pháp 1: Sử dụng Supabase Dashboard (Khuyến nghị)

1. **Mở Supabase Dashboard**
   - Truy cập: https://supabase.com/dashboard
   - Chọn project của bạn

2. **Vào SQL Editor**
   - Sidebar > SQL Editor
   - Hoặc: https://supabase.com/dashboard/project/[your-project-id]/sql

3. **Copy và chạy migration SQL**
   - Mở file `supabase/migrations/20241201000000_create_complete_schema.sql`
   - Copy toàn bộ nội dung
   - Paste vào SQL Editor
   - Nhấn "Run" (hoặc Ctrl+Enter)

4. **Chờ hoàn thành**
   - Migration sẽ chạy trong 1-2 phút
   - Kiểm tra kết quả trong Tables tab

### Phương pháp 2: Chia nhỏ migration (Nếu timeout)

Nếu migration quá lớn gây timeout, chia thành các phần:

#### Phần 1: ENUM Types và Tables
```sql
-- Copy từ dòng 1 đến dòng 126 trong file migration
-- (Tất cả CREATE TYPE và CREATE TABLE)
```

#### Phần 2: Indexes
```sql
-- Copy từ dòng 127 đến dòng 171
-- (Tất cả CREATE INDEX)
```

#### Phần 3: Functions và Triggers
```sql
-- Copy từ dòng 172 đến dòng 230
-- (CREATE FUNCTION và CREATE TRIGGER)
```

#### Phần 4: RLS và Policies
```sql
-- Copy từ dòng 231 đến dòng 490
-- (ALTER TABLE ENABLE RLS và CREATE POLICY)
```

#### Phần 5: Comments và Sample Data
```sql
-- Copy từ dòng 491 đến cuối file
-- (COMMENT ON và INSERT INTO)
```

### Phương pháp 3: Sử dụng Supabase CLI

```bash
# Cài đặt Supabase CLI (nếu chưa có)
npm install -g supabase

# Login
supabase login

# Link project
supabase link --project-ref your-project-id

# Chạy migration
supabase db push
```

## 🔍 Kiểm tra kết quả

Sau khi migration thành công:

### 1. Kiểm tra Tables
```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;
```

Kết quả mong đợi:
- assignment_submissions
- assignments
- classes
- courses
- enrollments
- lessons
- profiles
- website_analytics

### 2. Kiểm tra dữ liệu
```sql
SELECT 
  'profiles' as table_name, COUNT(*) as count FROM profiles
UNION ALL
SELECT 
  'courses' as table_name, COUNT(*) as count FROM courses
UNION ALL
SELECT 
  'website_analytics' as table_name, COUNT(*) as count FROM website_analytics;
```

### 3. Test đăng nhập
Nếu đã load sample data:
- Admin: admin@spika.edu.vn / 123456
- Teacher: nguyenvana@spika.edu.vn / 123456
- Student: student1@gmail.com / 123456

## 📊 Load Sample Data

Sau khi migration chính thành công:

1. **Mở SQL Editor** trong Supabase Dashboard
2. **Copy nội dung** file `supabase/migrations/20241201000001_sample_data.sql`
3. **Paste và Run**

Hoặc sử dụng file `load-sample-data.html` (nhưng cũng có thể gặp lỗi tương tự).

## 🎯 Kết quả mong đợi

Sau khi hoàn thành:
- ✅ 8 bảng được tạo
- ✅ 20+ indexes
- ✅ 7 triggers
- ✅ 15+ RLS policies
- ✅ Sample data (nếu load)

## 🚨 Lưu ý quan trọng

1. **Backup trước khi chạy** (nếu có dữ liệu quan trọng)
2. **Sử dụng service role key** nếu cần quyền admin
3. **Chạy từng phần** nếu gặp timeout
4. **Kiểm tra logs** trong Dashboard > Logs nếu có lỗi

## 💡 Tips

- **Supabase Dashboard** là cách đáng tin cậy nhất
- **SQL Editor** có syntax highlighting và error checking
- **Tables tab** để xem kết quả trực quan
- **Logs tab** để debug nếu có lỗi

---

**Chúc bạn migration thành công! 🎉**

Nếu vẫn gặp vấn đề, hãy sử dụng Supabase Dashboard - đây là phương pháp đáng tin cậy nhất.
