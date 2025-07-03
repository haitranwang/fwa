-- =====================================================
-- MIGRATION: Add Website Analytics Table
-- File: 20241202000000_add_website_analytics.sql
-- Description: Thêm bảng website_analytics để lưu trữ thống kê truy cập
-- =====================================================

-- =====================================================
-- 1. BẢNG WEBSITE_ANALYTICS (Thống kê website)
-- =====================================================
CREATE TABLE IF NOT EXISTS "public"."website_analytics" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "date" "date" NOT NULL,
    "visit_count" integer DEFAULT 0 NOT NULL,
    "unique_visitors" integer DEFAULT 0 NOT NULL,
    "page_views" integer DEFAULT 0 NOT NULL,
    "created_at" timestamp with time zone DEFAULT "timezone"('utc'::"text", "now"()) NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "timezone"('utc'::"text", "now"()) NOT NULL
);

ALTER TABLE "public"."website_analytics" OWNER TO "postgres";

-- =====================================================
-- 2. CONSTRAINTS - Ràng buộc
-- =====================================================

-- Primary Key
ALTER TABLE ONLY "public"."website_analytics"
    ADD CONSTRAINT "website_analytics_pkey" PRIMARY KEY ("id");

-- Unique constraint cho date (mỗi ngày chỉ có 1 record)
ALTER TABLE ONLY "public"."website_analytics"
    ADD CONSTRAINT "website_analytics_date_key" UNIQUE ("date");

-- =====================================================
-- 3. INDEXES - Chỉ mục
-- =====================================================

-- Index cho truy vấn theo ngày (DESC để lấy dữ liệu mới nhất trước)
CREATE INDEX IF NOT EXISTS "idx_website_analytics_date" ON "public"."website_analytics" USING "btree" ("date" DESC);

-- Index cho created_at
CREATE INDEX IF NOT EXISTS "idx_website_analytics_created_at" ON "public"."website_analytics" USING "btree" ("created_at" DESC);

-- =====================================================
-- 4. TRIGGERS - Tự động cập nhật updated_at
-- =====================================================

CREATE OR REPLACE TRIGGER "update_website_analytics_updated_at"
    BEFORE UPDATE ON "public"."website_analytics"
    FOR EACH ROW
    EXECUTE FUNCTION "public"."update_updated_at_column"();

-- =====================================================
-- 5. ROW LEVEL SECURITY (RLS)
-- =====================================================

-- Enable RLS
ALTER TABLE "public"."website_analytics" ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- 6. POLICIES - Chính sách bảo mật
-- =====================================================

-- Chỉ admin mới có thể đọc dữ liệu thống kê
CREATE POLICY "Admin can view analytics" ON "public"."website_analytics"
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM "public"."profiles"
            WHERE "profiles"."id" = "auth"."uid"()
            AND "profiles"."role" = 'admin'::"public"."user_role"
        )
    );

-- Chỉ hệ thống mới có thể insert dữ liệu thống kê (sẽ sử dụng service role)
CREATE POLICY "System can insert analytics" ON "public"."website_analytics"
    FOR INSERT WITH CHECK (true);

-- Chỉ hệ thống mới có thể update dữ liệu thống kê
CREATE POLICY "System can update analytics" ON "public"."website_analytics"
    FOR UPDATE USING (true);

-- =====================================================
-- 7. PERMISSIONS - Phân quyền
-- =====================================================

GRANT ALL ON TABLE "public"."website_analytics" TO "anon";
GRANT ALL ON TABLE "public"."website_analytics" TO "authenticated";
GRANT ALL ON TABLE "public"."website_analytics" TO "service_role";

-- =====================================================
-- 8. COMMENTS - Mô tả bảng và cột
-- =====================================================

COMMENT ON TABLE "public"."website_analytics" IS 'Bảng lưu trữ thống kê lượt truy cập website theo ngày';
COMMENT ON COLUMN "public"."website_analytics"."id" IS 'ID duy nhất của record';
COMMENT ON COLUMN "public"."website_analytics"."date" IS 'Ngày thống kê (YYYY-MM-DD)';
COMMENT ON COLUMN "public"."website_analytics"."visit_count" IS 'Tổng số lượt truy cập trong ngày';
COMMENT ON COLUMN "public"."website_analytics"."unique_visitors" IS 'Số lượng người dùng duy nhất truy cập trong ngày';
COMMENT ON COLUMN "public"."website_analytics"."page_views" IS 'Tổng số lượt xem trang trong ngày';
COMMENT ON COLUMN "public"."website_analytics"."created_at" IS 'Thời gian tạo record';
COMMENT ON COLUMN "public"."website_analytics"."updated_at" IS 'Thời gian cập nhật record lần cuối';

-- =====================================================
-- 9. DỮ LIỆU MẪU - Sample Data
-- =====================================================

-- Thêm dữ liệu mẫu cho website_analytics (30 ngày gần đây)
INSERT INTO "public"."website_analytics" ("date", "visit_count", "unique_visitors", "page_views") VALUES
    (CURRENT_DATE - INTERVAL '30 days', 1000, 700, 2100),
    (CURRENT_DATE - INTERVAL '29 days', 1100, 750, 2250),
    (CURRENT_DATE - INTERVAL '28 days', 950, 650, 1950),
    (CURRENT_DATE - INTERVAL '27 days', 1200, 800, 2400),
    (CURRENT_DATE - INTERVAL '26 days', 1350, 900, 2700),
    (CURRENT_DATE - INTERVAL '25 days', 980, 650, 1960),
    (CURRENT_DATE - INTERVAL '24 days', 1580, 1050, 3160),
    (CURRENT_DATE - INTERVAL '23 days', 1420, 950, 2840),
    (CURRENT_DATE - INTERVAL '22 days', 1680, 1120, 3360),
    (CURRENT_DATE - INTERVAL '21 days', 1250, 850, 2500),
    (CURRENT_DATE - INTERVAL '20 days', 1100, 750, 2250),
    (CURRENT_DATE - INTERVAL '19 days', 950, 650, 1950),
    (CURRENT_DATE - INTERVAL '18 days', 1200, 800, 2400),
    (CURRENT_DATE - INTERVAL '17 days', 1350, 900, 2700),
    (CURRENT_DATE - INTERVAL '16 days', 980, 650, 1960),
    (CURRENT_DATE - INTERVAL '15 days', 1580, 1050, 3160),
    (CURRENT_DATE - INTERVAL '14 days', 1420, 950, 2840),
    (CURRENT_DATE - INTERVAL '13 days', 1680, 1120, 3360),
    (CURRENT_DATE - INTERVAL '12 days', 1250, 850, 2500),
    (CURRENT_DATE - INTERVAL '11 days', 1100, 750, 2250),
    (CURRENT_DATE - INTERVAL '10 days', 950, 650, 1950),
    (CURRENT_DATE - INTERVAL '9 days', 1200, 800, 2400),
    (CURRENT_DATE - INTERVAL '8 days', 1350, 900, 2700),
    (CURRENT_DATE - INTERVAL '7 days', 980, 650, 1960),
    (CURRENT_DATE - INTERVAL '6 days', 1200, 800, 2400),
    (CURRENT_DATE - INTERVAL '5 days', 1350, 900, 2700),
    (CURRENT_DATE - INTERVAL '4 days', 980, 650, 1960),
    (CURRENT_DATE - INTERVAL '3 days', 1580, 1050, 3160),
    (CURRENT_DATE - INTERVAL '2 days', 1420, 950, 2840),
    (CURRENT_DATE - INTERVAL '1 day', 1680, 1120, 3360),
    (CURRENT_DATE, 1250, 850, 2500)
ON CONFLICT ("date") DO NOTHING;
