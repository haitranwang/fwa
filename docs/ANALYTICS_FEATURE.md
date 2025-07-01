# Tính năng Thống kê Truy cập Website

## Tổng quan

Tính năng thống kê truy cập website cho phép quản trị viên theo dõi và phân tích lượt truy cập website thông qua biểu đồ đường trực quan. Chỉ có quản trị viên mới có quyền truy cập tính năng này.

## Tính năng chính

### 1. Biểu đồ thống kê trực quan
- **Biểu đồ đường**: Hiển thị xu hướng lượt truy cập theo thời gian
- **3 chỉ số chính**:
  - Lượt truy cập (Visits)
  - Người dùng duy nhất (Unique Visitors)  
  - Lượt xem trang (Page Views)

### 2. Bộ lọc thời gian
- 7 ngày qua
- 14 ngày qua
- 30 ngày qua

### 3. Thống kê tổng hợp
- Tổng lượt truy cập
- Tổng người dùng duy nhất
- Tổng lượt xem trang
- Tỷ lệ trang/phiên truy cập

### 4. Bảo mật và phân quyền
- Chỉ admin mới có thể xem thống kê
- Row Level Security (RLS) được áp dụng
- Error handling và loading states

## Cấu trúc Database

### Bảng `website_analytics`
```sql
CREATE TABLE website_analytics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    date DATE NOT NULL UNIQUE,
    visit_count INTEGER NOT NULL DEFAULT 0,
    unique_visitors INTEGER NOT NULL DEFAULT 0,
    page_views INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);
```

### Indexes
- `idx_website_analytics_date`: Tối ưu truy vấn theo ngày
- `idx_website_analytics_created_at`: Tối ưu truy vấn theo thời gian tạo

### RLS Policies
- `Admin can view analytics`: Chỉ admin mới có thể đọc dữ liệu
- `System can insert/update analytics`: Hệ thống có thể ghi dữ liệu

## Cấu trúc Code

### Components
- `src/components/admin/AnalyticsTab.tsx`: Component chính hiển thị thống kê
- `src/components/AnalyticsTracker.tsx`: Component tracking lượt truy cập

### API Functions
- `src/lib/analytics-api.ts`: Các hàm API để tương tác với database
- `src/lib/analytics-tracker.ts`: Hệ thống tracking lượt truy cập

### Key Functions
```typescript
// Lấy dữ liệu thống kê
getAnalyticsData(days: number): Promise<AnalyticsData[]>

// Tính toán thống kê tổng hợp
calculateAnalyticsStats(data: AnalyticsData[]): AnalyticsStats

// Track lượt truy cập
trackPageView(pagePath?: string): Promise<void>

// Tăng lượt truy cập hôm nay
incrementTodayVisits(visits, uniqueVisitors, pageViews): Promise<void>
```

## Hệ thống Tracking

### Cách hoạt động
1. **Session Tracking**: Sử dụng sessionStorage để track session
2. **Unique Visitor**: Sử dụng localStorage để track unique visitor theo ngày
3. **Page Views**: Track mỗi lần chuyển trang
4. **Anti-spam**: Chỉ cập nhật server khi cần thiết

### Local Storage Keys
- `fwa_visit_tracking`: Dữ liệu tracking chính
- `fwa_unique_visitor`: Thông tin unique visitor
- `fwa_session_id`: Session ID (sessionStorage)

## Cài đặt và Triển khai

### 1. Chạy Migration
```bash
# Chạy SQL migration để tạo bảng
psql -h your-supabase-host -U postgres -d postgres -f supabase/migrations/create_website_analytics.sql
```

### 2. Setup Test Data (Optional)
```bash
# Chạy script setup để tạo dữ liệu test
SUPABASE_SERVICE_KEY=your_service_key node scripts/setup-analytics.js
```

### 3. Kiểm tra Permissions
Đảm bảo RLS policies đã được áp dụng đúng cách:
- Admin có thể đọc dữ liệu
- Anonymous users không thể truy cập
- Service role có thể ghi dữ liệu

## Sử dụng

### 1. Truy cập Dashboard
1. Đăng nhập với tài khoản admin
2. Vào `/admin` hoặc click "Bảng điều khiển quản trị"
3. Click tab "Thống kê"

### 2. Xem Thống kê
- Chọn khoảng thời gian muốn xem (7/14/30 ngày)
- Xem biểu đồ và các chỉ số tổng hợp
- Click "Làm mới" để cập nhật dữ liệu

### 3. Hiểu Biểu đồ
- **Đường xanh dương**: Lượt truy cập
- **Đường xanh lá**: Người dùng duy nhất
- **Đường đỏ**: Lượt xem trang

## Tối ưu hóa Performance

### 1. Database
- Sử dụng indexes cho truy vấn nhanh
- Aggregate data theo ngày để giảm số lượng records
- RLS policies được tối ưu

### 2. Frontend
- Lazy loading cho component analytics
- Caching dữ liệu trong component state
- Debounce cho các API calls

### 3. Tracking
- Batch updates để giảm API calls
- Local storage để tránh duplicate tracking
- Error handling không ảnh hưởng UX

## Troubleshooting

### Lỗi thường gặp

1. **"Truy cập bị từ chối"**
   - Kiểm tra user có role admin không
   - Kiểm tra RLS policies

2. **"Không thể tải dữ liệu thống kê"**
   - Kiểm tra kết nối database
   - Kiểm tra bảng website_analytics đã tồn tại
   - Kiểm tra permissions

3. **Tracking không hoạt động**
   - Kiểm tra AnalyticsTracker component đã được import
   - Kiểm tra localStorage/sessionStorage
   - Kiểm tra network requests

### Debug Mode
Trong development mode, tracking sẽ log thông tin debug:
```javascript
console.log('Analytics tracking:', {
  pagePath,
  sessionId,
  isNewVisit,
  isUnique,
  pageViews
});
```

## Best Practices

### 1. Security
- Luôn kiểm tra permissions trước khi hiển thị dữ liệu
- Sử dụng service role key cho server-side operations
- Validate input data trước khi lưu database

### 2. Performance
- Không track quá thường xuyên (batch updates)
- Sử dụng indexes phù hợp
- Cache dữ liệu khi có thể

### 3. UX
- Hiển thị loading states
- Error handling graceful
- Responsive design cho mobile

## Mở rộng tương lai

### Tính năng có thể thêm
1. **Real-time analytics**: WebSocket updates
2. **Detailed tracking**: Track specific pages, user agents
3. **Export data**: CSV, PDF reports
4. **Alerts**: Thông báo khi có thay đổi bất thường
5. **Comparison**: So sánh với kỳ trước
6. **Geographic data**: Thống kê theo vị trí địa lý

### Technical improvements
1. **Data aggregation**: Pre-aggregate data for better performance
2. **Caching layer**: Redis for frequently accessed data
3. **Background jobs**: Process analytics data asynchronously
4. **Data retention**: Automatic cleanup of old data
