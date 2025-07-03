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