-- =====================================================
-- SPIKA ACADEMY - SAMPLE DATA
-- Dữ liệu mẫu để testing hệ thống
-- =====================================================

-- =====================================================
-- 1. DỮ LIỆU MẪU CHO BẢNG PROFILES
-- =====================================================

-- Admin user
INSERT INTO public.profiles (id, username, email, password, fullname, role, age, phone_number, info) VALUES
('550e8400-e29b-41d4-a716-446655440000', 'admin', 'admin@spika.edu.vn', '$2b$10$rQZ8kHp.TB.It.NvGLGxaOKvr/8B6UYGFYsKGxQm8N2QvJ8mK5K5e', 'Quản trị viên hệ thống', 'admin', 35, '0901234567', 'Quản trị viên chính của hệ thống Spika Academy')
ON CONFLICT (id) DO NOTHING;

-- Teachers
INSERT INTO public.profiles (id, username, email, password, fullname, role, age, phone_number, info) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'teacher1', 'nguyenvana@spika.edu.vn', '$2b$10$rQZ8kHp.TB.It.NvGLGxaOKvr/8B6UYGFYsKGxQm8N2QvJ8mK5K5e', 'Nguyễn Văn A', 'teacher', 32, '0901234568', 'Giáo viên chuyên ngành Lập trình Web'),
('550e8400-e29b-41d4-a716-446655440002', 'teacher2', 'tranthib@spika.edu.vn', '$2b$10$rQZ8kHp.TB.It.NvGLGxaOKvr/8B6UYGFYsKGxQm8N2QvJ8mK5K5e', 'Trần Thị B', 'teacher', 29, '0901234569', 'Giáo viên chuyên ngành Mobile Development'),
('550e8400-e29b-41d4-a716-446655440003', 'teacher3', 'lequangc@spika.edu.vn', '$2b$10$rQZ8kHp.TB.It.NvGLGxaOKvr/8B6UYGFYsKGxQm8N2QvJ8mK5K5e', 'Lê Quang C', 'teacher', 38, '0901234570', 'Giáo viên chuyên ngành Data Science')
ON CONFLICT (id) DO NOTHING;

-- Students
INSERT INTO public.profiles (id, username, email, password, fullname, role, age, phone_number, info) VALUES
('550e8400-e29b-41d4-a716-446655440010', 'student1', 'student1@gmail.com', '$2b$10$rQZ8kHp.TB.It.NvGLGxaOKvr/8B6UYGFYsKGxQm8N2QvJ8mK5K5e', 'Phạm Văn D', 'student', 22, '0901234571', 'Sinh viên năm 3 chuyên ngành CNTT'),
('550e8400-e29b-41d4-a716-446655440011', 'student2', 'student2@gmail.com', '$2b$10$rQZ8kHp.TB.It.NvGLGxaOKvr/8B6UYGFYsKGxQm8N2QvJ8mK5K5e', 'Hoàng Thị E', 'student', 21, '0901234572', 'Sinh viên năm 2 chuyên ngành CNTT'),
('550e8400-e29b-41d4-a716-446655440012', 'student3', 'student3@gmail.com', '$2b$10$rQZ8kHp.TB.It.NvGLGxaOKvr/8B6UYGFYsKGxQm8N2QvJ8mK5K5e', 'Vũ Minh F', 'student', 23, '0901234573', 'Sinh viên năm 4 chuyên ngành CNTT'),
('550e8400-e29b-41d4-a716-446655440013', 'student4', 'student4@gmail.com', '$2b$10$rQZ8kHp.TB.It.NvGLGxaOKvr/8B6UYGFYsKGxQm8N2QvJ8mK5K5e', 'Đặng Thị G', 'student', 20, '0901234574', 'Sinh viên năm 1 chuyên ngành CNTT'),
('550e8400-e29b-41d4-a716-446655440014', 'student5', 'student5@gmail.com', '$2b$10$rQZ8kHp.TB.It.NvGLGxaOKvr/8B6UYGFYsKGxQm8N2QvJ8mK5K5e', 'Bùi Văn H', 'student', 24, '0901234575', 'Sinh viên năm 4 chuyên ngành CNTT')
ON CONFLICT (id) DO NOTHING;

-- =====================================================
-- 2. DỮ LIỆU MẪU CHO BẢNG COURSES
-- =====================================================

INSERT INTO public.courses (id, name, description, detail_lessons, duration, price, status) VALUES
('660e8400-e29b-41d4-a716-446655440000', 'Lập trình Web với React', 'Khóa học toàn diện về phát triển ứng dụng web hiện đại với React, bao gồm hooks, state management, và deployment.', 'Buổi 1: Giới thiệu React\nBuổi 2: Components và Props\nBuổi 3: State và Lifecycle\nBuổi 4: Hooks\nBuổi 5: Context API\nBuổi 6: Routing\nBuổi 7: State Management\nBuổi 8: Testing\nBuổi 9: Deployment\nBuổi 10: Dự án cuối khóa', 40, 2500000, 'Đang mở'),
('660e8400-e29b-41d4-a716-446655440001', 'Mobile Development với React Native', 'Học cách phát triển ứng dụng di động đa nền tảng với React Native, từ cơ bản đến nâng cao.', 'Buổi 1: Giới thiệu React Native\nBuổi 2: Navigation\nBuổi 3: UI Components\nBuổi 4: State Management\nBuổi 5: API Integration\nBuổi 6: Native Modules\nBuổi 7: Performance\nBuổi 8: Testing\nBuổi 9: Publishing\nBuổi 10: Dự án thực tế', 45, 3000000, 'Đang mở'),
('660e8400-e29b-41d4-a716-446655440002', 'Data Science với Python', 'Khóa học về khoa học dữ liệu, machine learning và data visualization với Python.', 'Buổi 1: Python cơ bản\nBuổi 2: NumPy và Pandas\nBuổi 3: Data Visualization\nBuổi 4: Statistics\nBuổi 5: Machine Learning\nBuổi 6: Deep Learning\nBuổi 7: NLP\nBuổi 8: Computer Vision\nBuổi 9: Model Deployment\nBuổi 10: Capstone Project', 50, 3500000, 'Đang bắt đầu'),
('660e8400-e29b-41d4-a716-446655440003', 'DevOps và Cloud Computing', 'Học cách triển khai và quản lý ứng dụng trên cloud với các công cụ DevOps hiện đại.', 'Buổi 1: Giới thiệu DevOps\nBuổi 2: Docker\nBuổi 3: Kubernetes\nBuổi 4: CI/CD\nBuổi 5: AWS Services\nBuổi 6: Monitoring\nBuổi 7: Security\nBuổi 8: Infrastructure as Code\nBuổi 9: Microservices\nBuổi 10: Best Practices', 48, 4000000, 'Đang mở')
ON CONFLICT (id) DO NOTHING;

-- =====================================================
-- 3. DỮ LIỆU MẪU CHO BẢNG CLASSES
-- =====================================================

INSERT INTO public.classes (id, course_id, instructor_id, name, description, schedule, status) VALUES
('770e8400-e29b-41d4-a716-446655440000', '660e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440001', 'React Web Development - Lớp K01', 'Lớp học React dành cho người mới bắt đầu', 'Thứ 2, 4, 6 - 19:00-21:00', 'Đang hoạt động'),
('770e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440001', 'React Web Development - Lớp K02', 'Lớp học React nâng cao', 'Thứ 3, 5, 7 - 19:00-21:00', 'Đang hoạt động'),
('770e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002', 'React Native Mobile - Lớp M01', 'Lớp học phát triển ứng dụng di động', 'Thứ 2, 4, 6 - 18:00-20:00', 'Đang hoạt động'),
('770e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440003', 'Data Science Python - Lớp D01', 'Lớp học khoa học dữ liệu', 'Thứ 3, 5, 7 - 18:30-20:30', 'Đang hoạt động')
ON CONFLICT (id) DO NOTHING;

-- =====================================================
-- 4. DỮ LIỆU MẪU CHO BẢNG ENROLLMENTS
-- =====================================================

INSERT INTO public.enrollments (id, student_id, class_id, status, enrolled_at) VALUES
('880e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440010', '770e8400-e29b-41d4-a716-446655440000', 'active', '2024-11-01 10:00:00+00'),
('880e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440011', '770e8400-e29b-41d4-a716-446655440000', 'active', '2024-11-01 11:00:00+00'),
('880e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440012', '770e8400-e29b-41d4-a716-446655440001', 'active', '2024-11-02 09:00:00+00'),
('880e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440013', '770e8400-e29b-41d4-a716-446655440002', 'active', '2024-11-03 14:00:00+00'),
('880e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440014', '770e8400-e29b-41d4-a716-446655440003', 'active', '2024-11-04 16:00:00+00'),
('880e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440010', '770e8400-e29b-41d4-a716-446655440002', 'active', '2024-11-05 10:30:00+00')
ON CONFLICT (id) DO NOTHING;

-- =====================================================
-- 5. DỮ LIỆU MẪU CHO BẢNG LESSONS
-- =====================================================

-- Lessons cho React Web Development - Lớp K01
INSERT INTO public.lessons (id, class_id, title, content, lesson_number) VALUES
('990e8400-e29b-41d4-a716-446655440000', '770e8400-e29b-41d4-a716-446655440000', 'Giới thiệu React và JSX', 'Trong buổi học này, chúng ta sẽ tìm hiểu về React, JSX và cách tạo component đầu tiên.', 1),
('990e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440000', 'Components và Props', 'Học cách tạo và sử dụng components, truyền dữ liệu qua props.', 2),
('990e8400-e29b-41d4-a716-446655440002', '770e8400-e29b-41d4-a716-446655440000', 'State và Event Handling', 'Quản lý state trong component và xử lý các sự kiện người dùng.', 3)
ON CONFLICT (id) DO NOTHING;

-- Lessons cho React Native Mobile - Lớp M01
INSERT INTO public.lessons (id, class_id, title, content, lesson_number) VALUES
('990e8400-e29b-41d4-a716-446655440010', '770e8400-e29b-41d4-a716-446655440002', 'Giới thiệu React Native', 'Tìm hiểu về React Native và cách setup môi trường phát triển.', 1),
('990e8400-e29b-41d4-a716-446655440011', '770e8400-e29b-41d4-a716-446655440002', 'Navigation trong React Native', 'Học cách sử dụng React Navigation để điều hướng giữa các màn hình.', 2)
ON CONFLICT (id) DO NOTHING;

-- =====================================================
-- 6. DỮ LIỆU MẪU CHO BẢNG ASSIGNMENTS
-- =====================================================

INSERT INTO public.assignments (id, lesson_id, instructor_id, content) VALUES
('aa0e8400-e29b-41d4-a716-446655440000', '990e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440001', 
'{"blocks": [{"type": "text", "content": "Tạo một component React đơn giản hiển thị thông tin cá nhân của bạn bao gồm: tên, tuổi, email và sở thích."}, {"type": "text", "content": "Yêu cầu: Sử dụng JSX, props và styling cơ bản."}]}'),
('aa0e8400-e29b-41d4-a716-446655440001', '990e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001',
'{"blocks": [{"type": "text", "content": "Tạo một ứng dụng Todo List đơn giản với các chức năng: thêm, xóa, đánh dấu hoàn thành."}, {"type": "text", "content": "Yêu cầu: Sử dụng props, state và event handling."}]}')
ON CONFLICT (id) DO NOTHING;

-- =====================================================
-- 7. DỮ LIỆU MẪU CHO BẢNG ASSIGNMENT_SUBMISSIONS
-- =====================================================

INSERT INTO public.assignment_submissions (id, assignment_id, student_id, content, status, submitted_at, feedback) VALUES
('bb0e8400-e29b-41d4-a716-446655440000', 'aa0e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440010', 
'{"blocks": [{"type": "text", "content": "Đã hoàn thành component Profile với đầy đủ thông tin được yêu cầu."}]}', 'Đã hoàn thành', '2024-11-15 20:30:00+00', 'Bài làm tốt! Code clean và logic rõ ràng. Điểm: 9/10'),
('bb0e8400-e29b-41d4-a716-446655440001', 'aa0e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440011',
'{"blocks": [{"type": "text", "content": "Component Profile đã được tạo nhưng còn thiếu styling."}]}', 'Đang chờ chấm', '2024-11-16 19:45:00+00', NULL)
ON CONFLICT (id) DO NOTHING;

-- =====================================================
-- 8. DỮ LIỆU MẪU CHO BẢNG WEBSITE_ANALYTICS (đã có trong migration chính)
-- =====================================================

-- Dữ liệu analytics đã được thêm trong file migration chính

-- =====================================================
-- HOÀN THÀNH SAMPLE DATA
-- =====================================================
-- Sample data đã được thêm thành công!
