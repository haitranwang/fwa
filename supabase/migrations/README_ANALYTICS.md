# Website Analytics Schema

## 📋 Tổng quan

Thư mục này chứa các file schema và migration cho tính năng **Website Analytics** - hệ thống thống kê lượt truy cập website.

## 📁 Cấu trúc Files

```
supabase/migrations/
├── schema.sql                           # Schema chính (đã được khôi phục về trạng thái ban đầu)
├── schema_analytics.sql                 # Schema riêng cho Website Analytics
├── 20241202000000_add_website_analytics.sql  # Migration file để thêm bảng analytics
└── README_ANALYTICS.md                  # File hướng dẫn này
```

## 🚀 Cách sử dụng

### 1. **Chạy Migration (Khuyến nghị)**

```bash
# Chạy migration để thêm bảng website_analytics
supabase db push

# Hoặc chạy migration cụ thể
psql -h localhost -p 54322 -U postgres -d postgres -f supabase/migrations/20241202000000_add_website_analytics.sql
```

### 2. **Chạy Schema riêng (Tùy chọn)**

```bash
# Nếu muốn chạy riêng schema analytics
psql -h localhost -p 54322 -U postgres -d postgres -f supabase/migrations/schema_analytics.sql
```

## 🗃️ Cấu trúc Bảng

### `website_analytics`

| Cột | Kiểu dữ liệu | Mô tả |
|-----|-------------|-------|
| `id` | UUID | ID duy nhất (Primary Key) |
| `date` | DATE | Ngày thống kê (Unique) |
| `visit_count` | INTEGER | Tổng lượt truy cập trong ngày |
| `unique_visitors` | INTEGER | Số người dùng duy nhất |
| `page_views` | INTEGER | Tổng lượt xem trang |
| `created_at` | TIMESTAMPTZ | Thời gian tạo |
| `updated_at` | TIMESTAMPTZ | Thời gian cập nhật |

## 🔒 Bảo mật (RLS Policies)

- **Admin View**: Chỉ admin mới xem được thống kê
- **System Insert/Update**: Chỉ service role mới insert/update được

## 📊 Truy vấn mẫu

```sql
-- Lấy thống kê 7 ngày gần đây
SELECT * FROM website_analytics
WHERE date >= CURRENT_DATE - INTERVAL '7 days'
ORDER BY date DESC;

-- Lấy tổng thống kê trong tháng
SELECT
    SUM(visit_count) as total_visits,
    SUM(unique_visitors) as total_unique_visitors,
    SUM(page_views) as total_page_views,
    AVG(visit_count) as avg_visits_per_day
FROM website_analytics
WHERE date >= DATE_TRUNC('month', CURRENT_DATE);

-- Insert dữ liệu mới (chỉ service role)
INSERT INTO website_analytics (date, visit_count, unique_visitors, page_views)
VALUES (CURRENT_DATE, 1500, 1000, 3000)
ON CONFLICT (date) DO UPDATE SET
    visit_count = EXCLUDED.visit_count,
    unique_visitors = EXCLUDED.unique_visitors,
    page_views = EXCLUDED.page_views,
    updated_at = NOW();
```

## 🔧 Tích hợp với Frontend

Bảng này được sử dụng bởi:
- `src/components/admin/AnalyticsTab.tsx` - Component hiển thị thống kê
- Admin Dashboard - Tab "Thống kê"

## ⚠️ Lưu ý quan trọng

1. **Đã có database**: File này được tạo để tránh conflict với database hiện tại
2. **Schema chính**: File `schema.sql` đã được khôi phục về trạng thái ban đầu
3. **Migration**: Sử dụng migration file để deploy an toàn
4. **Dữ liệu mẫu**: File chứa 7 ngày dữ liệu mẫu để test

## 🐛 Troubleshooting

### Lỗi "type already exists"
```sql
-- Nếu gặp lỗi type đã tồn tại, bỏ qua và tiếp tục
-- Migration file đã xử lý với IF NOT EXISTS
```

### Lỗi permissions
```sql
-- Đảm bảo có quyền postgres
GRANT ALL ON TABLE website_analytics TO postgres;
```

## 📞 Hỗ trợ

Nếu gặp vấn đề, kiểm tra:
1. Function `update_updated_at_column()` đã tồn tại
2. Bảng `profiles` với enum `user_role` đã có
3. Quyền truy cập database đúng
