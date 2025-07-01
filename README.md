# 🏫 Spika Academy - Learning Management System

Hệ thống quản lý học viện trực tuyến được xây dựng với React, TypeScript, Supabase và Tailwind CSS.

## 🚀 Quick Start

### 1. Khôi phục Database Schema

**⚠️ Lưu ý:** Do hạn chế của Supabase, cách tốt nhất là sử dụng Supabase Dashboard:

**Cách khuyến nghị:**
1. Mở [Supabase Dashboard](https://supabase.com/dashboard)
2. Chọn project của bạn → SQL Editor
3. Copy toàn bộ nội dung file `supabase/migrations/20241201000000_create_complete_schema.sql`
4. Paste vào SQL Editor và nhấn "Run"
5. Chờ 1-2 phút để hoàn thành

**Hướng dẫn chi tiết:** Xem file `COPY_PASTE_MIGRATION.md`

### 2. Load Sample Data (Tùy chọn)

**Cách khuyến nghị:**
1. Trong Supabase SQL Editor
2. Copy nội dung file `supabase/migrations/20241201000001_sample_data.sql`
3. Paste và Run

### 3. Chạy ứng dụng

```bash
npm install
npm run dev
```

## 🔐 Tài khoản mẫu

- **Admin:** admin@spika.edu.vn / 123456
- **Teacher:** nguyenvana@spika.edu.vn / 123456
- **Student:** student1@gmail.com / 123456

## 📚 Tài liệu

- **[DATABASE_MIGRATION_GUIDE.md](./DATABASE_MIGRATION_GUIDE.md)** - Hướng dẫn chi tiết migration
- **[ANALYTICS_FEATURE.md](./docs/ANALYTICS_FEATURE.md)** - Tính năng analytics

## 🗂️ Database Schema

- **profiles** - Người dùng (admin, teacher, student)
- **courses** - Khóa học
- **classes** - Lớp học
- **enrollments** - Đăng ký học
- **lessons** - Buổi học
- **assignments** - Bài tập
- **assignment_submissions** - Bài nộp
- **website_analytics** - Thống kê

## 🛠️ Tech Stack

- **Frontend:** React 18, TypeScript, Vite
- **UI:** Tailwind CSS, Radix UI, Lucide Icons
- **Backend:** Supabase (PostgreSQL, Auth, Storage)
- **State:** React Query, Zustand
- **Forms:** React Hook Form, Zod

## 📁 Cấu trúc Project

```
src/
├── components/          # UI components
│   ├── admin/          # Admin components
│   ├── teacher/        # Teacher components
│   └── ui/             # Base UI components
├── pages/              # Page components
├── hooks/              # Custom hooks
├── lib/                # Utilities
└── integrations/       # Supabase integration
```

## 🔧 Development

```bash
# Install dependencies
npm install

# Start dev server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview
```

## 📊 Features

- ✅ **User Management** - Admin, Teacher, Student roles
- ✅ **Course Management** - CRUD operations
- ✅ **Class Management** - Schedule, enrollment
- ✅ **Assignment System** - Create, submit, grade
- ✅ **Analytics Dashboard** - Website statistics
- ✅ **Responsive Design** - Mobile-first approach
- ✅ **Real-time Updates** - Supabase subscriptions
- ✅ **Row Level Security** - Data protection

## 🚨 Migration Required

**Quan trọng:** Nếu bạn mất schema database, hãy khôi phục ngay:

1. **Mở Supabase Dashboard** → SQL Editor
2. **Copy file migration** `supabase/migrations/20241201000000_create_complete_schema.sql`
3. **Paste và Run** trong SQL Editor
4. **Load sample data** nếu cần (file `20241201000001_sample_data.sql`)

📋 **Hướng dẫn chi tiết:** `COPY_PASTE_MIGRATION.md`

---

**Happy coding! 🎉**

- Navigate to the main page of your repository.
- Click on the "Code" button (green button) near the top right.
- Select the "Codespaces" tab.
- Click on "New codespace" to launch a new Codespace environment.
- Edit files directly within the Codespace and commit and push your changes once you're done.

## What technologies are used for this project?

This project is built with:

- Vite
- TypeScript
- React
- shadcn-ui
- Tailwind CSS

## How can I deploy this project?

Simply open [Lovable](https://lovable.dev/projects/85794ffa-e4bc-4a9b-99ee-b3aab9875a91) and click on Share -> Publish.

## Can I connect a custom domain to my Lovable project?

Yes, you can!

To connect a domain, navigate to Project > Settings > Domains and click Connect Domain.

Read more here: [Setting up a custom domain](https://docs.lovable.dev/tips-tricks/custom-domain#step-by-step-guide)
