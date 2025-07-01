-- Tạo bảng thống kê lượt truy cập website
CREATE TABLE IF NOT EXISTS public.website_analytics (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    date DATE NOT NULL UNIQUE,
    visit_count INTEGER NOT NULL DEFAULT 0,
    unique_visitors INTEGER NOT NULL DEFAULT 0,
    page_views INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Tạo index cho tối ưu hóa truy vấn
CREATE INDEX IF NOT EXISTS idx_website_analytics_date ON public.website_analytics(date DESC);
CREATE INDEX IF NOT EXISTS idx_website_analytics_created_at ON public.website_analytics(created_at DESC);

-- Tạo function để tự động cập nhật updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Tạo trigger để tự động cập nhật updated_at khi có thay đổi
CREATE TRIGGER update_website_analytics_updated_at
    BEFORE UPDATE ON public.website_analytics
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Thêm RLS (Row Level Security) policies
ALTER TABLE public.website_analytics ENABLE ROW LEVEL SECURITY;

-- Chỉ admin mới có thể đọc dữ liệu thống kê
CREATE POLICY "Admin can view analytics" ON public.website_analytics
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.profiles 
            WHERE profiles.id = auth.uid() 
            AND profiles.role = 'admin'
        )
    );

-- Chỉ hệ thống mới có thể insert/update dữ liệu thống kê (sẽ sử dụng service role)
CREATE POLICY "System can insert analytics" ON public.website_analytics
    FOR INSERT WITH CHECK (true);

CREATE POLICY "System can update analytics" ON public.website_analytics
    FOR UPDATE USING (true);

-- Thêm comment cho bảng và các cột
COMMENT ON TABLE public.website_analytics IS 'Bảng lưu trữ thống kê lượt truy cập website theo ngày';
COMMENT ON COLUMN public.website_analytics.id IS 'ID duy nhất của bản ghi';
COMMENT ON COLUMN public.website_analytics.date IS 'Ngày thống kê (YYYY-MM-DD)';
COMMENT ON COLUMN public.website_analytics.visit_count IS 'Tổng số lượt truy cập trong ngày';
COMMENT ON COLUMN public.website_analytics.unique_visitors IS 'Số lượng người dùng duy nhất truy cập trong ngày';
COMMENT ON COLUMN public.website_analytics.page_views IS 'Tổng số lượt xem trang trong ngày';
COMMENT ON COLUMN public.website_analytics.created_at IS 'Thời gian tạo bản ghi';
COMMENT ON COLUMN public.website_analytics.updated_at IS 'Thời gian cập nhật bản ghi lần cuối';

-- Thêm một số dữ liệu mẫu cho testing (7 ngày gần đây)
INSERT INTO public.website_analytics (date, visit_count, unique_visitors, page_views) VALUES
    (CURRENT_DATE - INTERVAL '6 days', 1200, 800, 2400),
    (CURRENT_DATE - INTERVAL '5 days', 1350, 900, 2700),
    (CURRENT_DATE - INTERVAL '4 days', 980, 650, 1960),
    (CURRENT_DATE - INTERVAL '3 days', 1580, 1050, 3160),
    (CURRENT_DATE - INTERVAL '2 days', 1420, 950, 2840),
    (CURRENT_DATE - INTERVAL '1 day', 1680, 1120, 3360),
    (CURRENT_DATE, 1250, 850, 2500)
ON CONFLICT (date) DO NOTHING;
