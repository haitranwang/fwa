-- =====================================================
-- SPIKA ACADEMY DATABASE SCHEMA
-- Tạo toàn bộ schema database cho hệ thống quản lý học viện
-- =====================================================

-- Tạo các ENUM types trước
CREATE TYPE user_role AS ENUM ('student', 'teacher', 'admin');
CREATE TYPE course_status AS ENUM ('Đang mở', 'Đang bắt đầu', 'Kết thúc');
CREATE TYPE course_level AS ENUM ('basic', 'intermediate', 'advance');
CREATE TYPE class_status AS ENUM ('Đang hoạt động', 'Đã kết thúc');
CREATE TYPE trang_thai_bai_nop AS ENUM ('Chưa làm', 'Đang chờ chấm', 'Đã hoàn thành');

-- =====================================================
-- 1. BẢNG PROFILES (Người dùng)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    fullname VARCHAR(255) NOT NULL,
    role user_role DEFAULT 'student',
    age INTEGER,
    phone_number VARCHAR(20),
    avatar_url TEXT,
    info TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- =====================================================
-- 2. BẢNG COURSES (Khóa học)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.courses (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    detail_lessons TEXT,
    duration INTEGER NOT NULL, -- Thời lượng tính bằng giờ
    price DECIMAL(10,2),
    image_url TEXT,
    status course_status DEFAULT 'Đang mở',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- =====================================================
-- 3. BẢNG CLASSES (Lớp học)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.classes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    course_id UUID NOT NULL REFERENCES public.courses(id) ON DELETE CASCADE,
    instructor_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    schedule TEXT, -- Lịch học (JSON hoặc text)
    status class_status DEFAULT 'Đang hoạt động',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- =====================================================
-- 4. BẢNG ENROLLMENTS (Đăng ký học)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.enrollments (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    student_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    class_id UUID NOT NULL REFERENCES public.classes(id) ON DELETE CASCADE,
    status VARCHAR(50) DEFAULT 'active',
    enrolled_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    UNIQUE(student_id, class_id)
);

-- =====================================================
-- 5. BẢNG LESSONS (Buổi học)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.lessons (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    class_id UUID NOT NULL REFERENCES public.classes(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    lesson_number INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    UNIQUE(class_id, lesson_number)
);

-- =====================================================
-- 6. BẢNG ASSIGNMENTS (Bài tập)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.assignments (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    lesson_id UUID NOT NULL REFERENCES public.lessons(id) ON DELETE CASCADE,
    instructor_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    content JSONB NOT NULL, -- Nội dung bài tập dạng JSON
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- =====================================================
-- 7. BẢNG ASSIGNMENT_SUBMISSIONS (Bài nộp)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.assignment_submissions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    assignment_id UUID NOT NULL REFERENCES public.assignments(id) ON DELETE CASCADE,
    student_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    content JSONB, -- Nội dung bài làm dạng JSON
    status trang_thai_bai_nop DEFAULT 'Chưa làm',
    feedback TEXT,
    submitted_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    UNIQUE(assignment_id, student_id)
);

-- =====================================================
-- 8. BẢNG WEBSITE_ANALYTICS (Thống kê website)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.website_analytics (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    date DATE NOT NULL UNIQUE,
    visit_count INTEGER NOT NULL DEFAULT 0,
    unique_visitors INTEGER NOT NULL DEFAULT 0,
    page_views INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- =====================================================
-- INDEXES - Tối ưu hóa truy vấn
-- =====================================================

-- Indexes cho bảng profiles
CREATE INDEX IF NOT EXISTS idx_profiles_email ON public.profiles(email);
CREATE INDEX IF NOT EXISTS idx_profiles_username ON public.profiles(username);
CREATE INDEX IF NOT EXISTS idx_profiles_role ON public.profiles(role);
CREATE INDEX IF NOT EXISTS idx_profiles_created_at ON public.profiles(created_at DESC);

-- Indexes cho bảng courses
CREATE INDEX IF NOT EXISTS idx_courses_status ON public.courses(status);
CREATE INDEX IF NOT EXISTS idx_courses_created_at ON public.courses(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_courses_updated_at ON public.courses(updated_at DESC);

-- Indexes cho bảng classes
CREATE INDEX IF NOT EXISTS idx_classes_course_id ON public.classes(course_id);
CREATE INDEX IF NOT EXISTS idx_classes_instructor_id ON public.classes(instructor_id);
CREATE INDEX IF NOT EXISTS idx_classes_status ON public.classes(status);
CREATE INDEX IF NOT EXISTS idx_classes_created_at ON public.classes(created_at DESC);

-- Indexes cho bảng enrollments
CREATE INDEX IF NOT EXISTS idx_enrollments_student_id ON public.enrollments(student_id);
CREATE INDEX IF NOT EXISTS idx_enrollments_class_id ON public.enrollments(class_id);
CREATE INDEX IF NOT EXISTS idx_enrollments_enrolled_at ON public.enrollments(enrolled_at DESC);

-- Indexes cho bảng lessons
CREATE INDEX IF NOT EXISTS idx_lessons_class_id ON public.lessons(class_id);
CREATE INDEX IF NOT EXISTS idx_lessons_lesson_number ON public.lessons(class_id, lesson_number);

-- Indexes cho bảng assignments
CREATE INDEX IF NOT EXISTS idx_assignments_lesson_id ON public.assignments(lesson_id);
CREATE INDEX IF NOT EXISTS idx_assignments_instructor_id ON public.assignments(instructor_id);
CREATE INDEX IF NOT EXISTS idx_assignments_created_at ON public.assignments(created_at DESC);

-- Indexes cho bảng assignment_submissions
CREATE INDEX IF NOT EXISTS idx_assignment_submissions_assignment_id ON public.assignment_submissions(assignment_id);
CREATE INDEX IF NOT EXISTS idx_assignment_submissions_student_id ON public.assignment_submissions(student_id);
CREATE INDEX IF NOT EXISTS idx_assignment_submissions_status ON public.assignment_submissions(status);
CREATE INDEX IF NOT EXISTS idx_assignment_submissions_submitted_at ON public.assignment_submissions(submitted_at DESC);

-- Indexes cho bảng website_analytics
CREATE INDEX IF NOT EXISTS idx_website_analytics_date ON public.website_analytics(date DESC);
CREATE INDEX IF NOT EXISTS idx_website_analytics_created_at ON public.website_analytics(created_at DESC);

-- =====================================================
-- FUNCTIONS - Các hàm hỗ trợ
-- =====================================================

-- Function để tự động cập nhật updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$ language 'plpgsql';

-- =====================================================
-- TRIGGERS - Tự động cập nhật timestamps
-- =====================================================

-- Trigger cho bảng profiles
CREATE TRIGGER update_profiles_updated_at
    BEFORE UPDATE ON public.profiles
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger cho bảng courses
CREATE TRIGGER update_courses_updated_at
    BEFORE UPDATE ON public.courses
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger cho bảng classes
CREATE TRIGGER update_classes_updated_at
    BEFORE UPDATE ON public.classes
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger cho bảng lessons
CREATE TRIGGER update_lessons_updated_at
    BEFORE UPDATE ON public.lessons
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger cho bảng assignments
CREATE TRIGGER update_assignments_updated_at
    BEFORE UPDATE ON public.assignments
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger cho bảng assignment_submissions
CREATE TRIGGER update_assignment_submissions_updated_at
    BEFORE UPDATE ON public.assignment_submissions
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger cho bảng website_analytics
CREATE TRIGGER update_website_analytics_updated_at
    BEFORE UPDATE ON public.website_analytics
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- =====================================================

-- Enable RLS cho tất cả các bảng
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.classes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.enrollments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lessons ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.assignment_submissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.website_analytics ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- POLICIES CHO BẢNG PROFILES
-- =====================================================

-- Users có thể xem profile của chính mình
CREATE POLICY "Users can view own profile" ON public.profiles
    FOR SELECT USING (auth.uid() = id);

-- Users có thể cập nhật profile của chính mình
CREATE POLICY "Users can update own profile" ON public.profiles
    FOR UPDATE USING (auth.uid() = id);

-- Admin có thể xem tất cả profiles
CREATE POLICY "Admin can view all profiles" ON public.profiles
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

-- Admin có thể tạo user mới
CREATE POLICY "Admin can insert profiles" ON public.profiles
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

-- Admin có thể cập nhật tất cả profiles
CREATE POLICY "Admin can update all profiles" ON public.profiles
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

-- Teachers có thể xem profiles của students trong lớp của họ
CREATE POLICY "Teachers can view students in their classes" ON public.profiles
    FOR SELECT USING (
        role = 'student' AND EXISTS (
            SELECT 1 FROM public.classes c
            JOIN public.enrollments e ON c.id = e.class_id
            WHERE c.instructor_id = auth.uid()
            AND e.student_id = profiles.id
        )
    );

-- =====================================================
-- POLICIES CHO BẢNG COURSES
-- =====================================================

-- Tất cả user có thể xem courses
CREATE POLICY "Everyone can view courses" ON public.courses
    FOR SELECT USING (true);

-- Admin có thể tạo, sửa, xóa courses
CREATE POLICY "Admin can manage courses" ON public.courses
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

-- =====================================================
-- POLICIES CHO BẢNG CLASSES
-- =====================================================

-- Tất cả user có thể xem classes
CREATE POLICY "Everyone can view classes" ON public.classes
    FOR SELECT USING (true);

-- Admin có thể tạo, sửa, xóa classes
CREATE POLICY "Admin can manage classes" ON public.classes
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

-- Teachers có thể sửa classes của họ
CREATE POLICY "Teachers can update own classes" ON public.classes
    FOR UPDATE USING (instructor_id = auth.uid());

-- =====================================================
-- POLICIES CHO BẢNG ENROLLMENTS
-- =====================================================

-- Students có thể xem enrollments của chính mình
CREATE POLICY "Students can view own enrollments" ON public.enrollments
    FOR SELECT USING (student_id = auth.uid());

-- Teachers có thể xem enrollments trong classes của họ
CREATE POLICY "Teachers can view class enrollments" ON public.enrollments
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.classes
            WHERE classes.id = enrollments.class_id
            AND classes.instructor_id = auth.uid()
        )
    );

-- Admin có thể quản lý tất cả enrollments
CREATE POLICY "Admin can manage enrollments" ON public.enrollments
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

-- Students có thể tự đăng ký vào class
CREATE POLICY "Students can enroll themselves" ON public.enrollments
    FOR INSERT WITH CHECK (student_id = auth.uid());

-- =====================================================
-- POLICIES CHO BẢNG LESSONS
-- =====================================================

-- Students có thể xem lessons trong classes họ đã đăng ký
CREATE POLICY "Students can view lessons in enrolled classes" ON public.lessons
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.enrollments
            WHERE enrollments.class_id = lessons.class_id
            AND enrollments.student_id = auth.uid()
        )
    );

-- Teachers có thể xem và quản lý lessons trong classes của họ
CREATE POLICY "Teachers can manage lessons in own classes" ON public.lessons
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.classes
            WHERE classes.id = lessons.class_id
            AND classes.instructor_id = auth.uid()
        )
    );

-- Admin có thể quản lý tất cả lessons
CREATE POLICY "Admin can manage all lessons" ON public.lessons
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

-- =====================================================
-- POLICIES CHO BẢNG ASSIGNMENTS
-- =====================================================

-- Students có thể xem assignments trong classes họ đã đăng ký
CREATE POLICY "Students can view assignments in enrolled classes" ON public.assignments
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.lessons l
            JOIN public.enrollments e ON l.class_id = e.class_id
            WHERE l.id = assignments.lesson_id
            AND e.student_id = auth.uid()
        )
    );

-- Teachers có thể quản lý assignments trong lessons của họ
CREATE POLICY "Teachers can manage own assignments" ON public.assignments
    FOR ALL USING (instructor_id = auth.uid());

-- Admin có thể quản lý tất cả assignments
CREATE POLICY "Admin can manage all assignments" ON public.assignments
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

-- =====================================================
-- POLICIES CHO BẢNG ASSIGNMENT_SUBMISSIONS
-- =====================================================

-- Students có thể xem và quản lý submissions của chính mình
CREATE POLICY "Students can manage own submissions" ON public.assignment_submissions
    FOR ALL USING (student_id = auth.uid());

-- Teachers có thể xem và chấm submissions trong assignments của họ
CREATE POLICY "Teachers can grade submissions" ON public.assignment_submissions
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.assignments a
            WHERE a.id = assignment_submissions.assignment_id
            AND a.instructor_id = auth.uid()
        )
    );

CREATE POLICY "Teachers can update submissions feedback" ON public.assignment_submissions
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM public.assignments a
            WHERE a.id = assignment_submissions.assignment_id
            AND a.instructor_id = auth.uid()
        )
    );

-- Admin có thể quản lý tất cả submissions
CREATE POLICY "Admin can manage all submissions" ON public.assignment_submissions
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

-- =====================================================
-- POLICIES CHO BẢNG WEBSITE_ANALYTICS
-- =====================================================

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

-- =====================================================
-- COMMENTS - Mô tả các bảng và cột
-- =====================================================

-- Comments cho bảng profiles
COMMENT ON TABLE public.profiles IS 'Bảng lưu trữ thông tin người dùng (học viên, giáo viên, admin)';
COMMENT ON COLUMN public.profiles.id IS 'ID duy nhất của người dùng';
COMMENT ON COLUMN public.profiles.username IS 'Tên đăng nhập duy nhất';
COMMENT ON COLUMN public.profiles.email IS 'Email duy nhất của người dùng';
COMMENT ON COLUMN public.profiles.password IS 'Mật khẩu đã mã hóa';
COMMENT ON COLUMN public.profiles.fullname IS 'Họ và tên đầy đủ';
COMMENT ON COLUMN public.profiles.role IS 'Vai trò: student, teacher, admin';

-- Comments cho bảng courses
COMMENT ON TABLE public.courses IS 'Bảng lưu trữ thông tin khóa học';
COMMENT ON COLUMN public.courses.name IS 'Tên khóa học';
COMMENT ON COLUMN public.courses.duration IS 'Thời lượng khóa học (giờ)';
COMMENT ON COLUMN public.courses.price IS 'Giá khóa học';
COMMENT ON COLUMN public.courses.status IS 'Trạng thái khóa học';

-- Comments cho bảng classes
COMMENT ON TABLE public.classes IS 'Bảng lưu trữ thông tin lớp học';
COMMENT ON COLUMN public.classes.course_id IS 'ID khóa học';
COMMENT ON COLUMN public.classes.instructor_id IS 'ID giáo viên';

-- Comments cho bảng enrollments
COMMENT ON TABLE public.enrollments IS 'Bảng lưu trữ thông tin đăng ký học';
COMMENT ON COLUMN public.enrollments.student_id IS 'ID học viên';
COMMENT ON COLUMN public.enrollments.class_id IS 'ID lớp học';

-- Comments cho bảng lessons
COMMENT ON TABLE public.lessons IS 'Bảng lưu trữ thông tin buổi học';
COMMENT ON COLUMN public.lessons.class_id IS 'ID lớp học';
COMMENT ON COLUMN public.lessons.lesson_number IS 'Số thứ tự buổi học';

-- Comments cho bảng assignments
COMMENT ON TABLE public.assignments IS 'Bảng lưu trữ thông tin bài tập';
COMMENT ON COLUMN public.assignments.lesson_id IS 'ID buổi học';
COMMENT ON COLUMN public.assignments.instructor_id IS 'ID giáo viên tạo bài tập';
COMMENT ON COLUMN public.assignments.content IS 'Nội dung bài tập (JSON)';

-- Comments cho bảng assignment_submissions
COMMENT ON TABLE public.assignment_submissions IS 'Bảng lưu trữ bài nộp của học viên';
COMMENT ON COLUMN public.assignment_submissions.assignment_id IS 'ID bài tập';
COMMENT ON COLUMN public.assignment_submissions.student_id IS 'ID học viên';
COMMENT ON COLUMN public.assignment_submissions.content IS 'Nội dung bài làm (JSON)';
COMMENT ON COLUMN public.assignment_submissions.status IS 'Trạng thái bài nộp';

-- Comments cho bảng website_analytics
COMMENT ON TABLE public.website_analytics IS 'Bảng lưu trữ thống kê lượt truy cập website theo ngày';
COMMENT ON COLUMN public.website_analytics.date IS 'Ngày thống kê (YYYY-MM-DD)';
COMMENT ON COLUMN public.website_analytics.visit_count IS 'Tổng số lượt truy cập trong ngày';
COMMENT ON COLUMN public.website_analytics.unique_visitors IS 'Số lượng người dùng duy nhất truy cập trong ngày';
COMMENT ON COLUMN public.website_analytics.page_views IS 'Tổng số lượt xem trang trong ngày';

-- =====================================================
-- DỮ LIỆU MẪU - Sample Data
-- =====================================================

-- Thêm dữ liệu mẫu cho website_analytics (7 ngày gần đây)
INSERT INTO public.website_analytics (date, visit_count, unique_visitors, page_views) VALUES
    (CURRENT_DATE - INTERVAL '6 days', 1200, 800, 2400),
    (CURRENT_DATE - INTERVAL '5 days', 1350, 900, 2700),
    (CURRENT_DATE - INTERVAL '4 days', 980, 650, 1960),
    (CURRENT_DATE - INTERVAL '3 days', 1580, 1050, 3160),
    (CURRENT_DATE - INTERVAL '2 days', 1420, 950, 2840),
    (CURRENT_DATE - INTERVAL '1 day', 1680, 1120, 3360),
    (CURRENT_DATE, 1250, 850, 2500)
ON CONFLICT (date) DO NOTHING;

-- =====================================================
-- HOÀN THÀNH MIGRATION
-- =====================================================
-- Migration hoàn thành thành công!
-- Tất cả bảng, indexes, triggers, policies đã được tạo.
