# 🚀 Quick Deploy với GitHub Pages - Auto Update

Hướng dẫn setup deploy tự động với GitHub Pages. Mỗi khi push code mới, website sẽ tự động build và update.

## 📋 Tổng quan

- ✅ **Miễn phí hoàn toàn**
- ✅ **Auto deploy** khi push code
- ✅ **Custom domain** support
- ✅ **HTTPS** tự động
- ✅ **CDN** global

## 🔧 Setup Auto Deploy

### Bước 1: Kiểm tra GitHub Workflow

File `.github/workflows/deploy.yml` đã được tạo sẵn với cấu hình:

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [ main ]  # Tự động deploy khi push vào branch main
  pull_request:
    branches: [ main ]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout
      uses: actions/checkout@v4

    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '18'
        cache: 'npm'

    - name: Install dependencies
      run: npm ci

    - name: Build
      run: npm run build

    - name: Deploy to GitHub Pages
      uses: peaceiris/actions-gh-pages@v3
      if: github.ref == 'refs/heads/main'
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_dir: ./dist
```

### Bước 2: Enable GitHub Pages

1. **Vào GitHub Repository**
   - Mở repository trên GitHub
   - Click tab **Settings**

2. **Cấu hình Pages**
   - Scroll xuống phần **Pages** (bên trái)
   - **Source**: Chọn `Deploy from a branch`
   - **Branch**: Chọn `gh-pages`
   - **Folder**: Chọn `/ (root)`
   - Click **Save**

### Bước 3: Push Code và Test

```bash
# Commit workflow file
git add .github/workflows/deploy.yml
git commit -m "Add GitHub Pages auto deploy workflow"

# Push để trigger deploy
git push origin main
```

### Bước 4: Kiểm tra Deploy

1. **Xem Actions**
   - Vào tab **Actions** trên GitHub
   - Xem workflow "Deploy to GitHub Pages" đang chạy

2. **Kiểm tra website**
   - URL: `https://[username].github.io/[repository-name]`
   - Ví dụ: `https://haitranwang.github.io/fwa`

## 🌐 Custom Domain (Tùy chọn)

### Nếu có domain riêng:

1. **Tạo file CNAME**
```bash
echo "yourdomain.com" > public/CNAME
```

2. **Cấu hình DNS**
   - Tạo CNAME record: `www` → `[username].github.io`
   - Hoặc A record: `@` → `185.199.108.153`

3. **Cấu hình trên GitHub**
   - Settings → Pages → Custom domain
   - Nhập domain và Save

## 🔄 Workflow Tự Động

### Khi nào website sẽ update?

- ✅ **Push vào branch `main`**
- ✅ **Merge Pull Request vào `main`**
- ✅ **Direct commit vào `main`**

### Thời gian deploy:

- **Build time**: ~2-3 phút
- **Deploy time**: ~1-2 phút
- **Total**: ~5 phút từ push đến live

## 📊 Monitoring Deploy

### Cách theo dõi:

1. **GitHub Actions**
   - Tab Actions → Xem workflow runs
   - Click vào run để xem chi tiết

2. **Email notifications**
   - GitHub sẽ gửi email nếu deploy fail

3. **Status badge** (tùy chọn)
   ```markdown
   ![Deploy Status](https://github.com/[username]/[repo]/workflows/Deploy%20to%20GitHub%20Pages/badge.svg)
   ```

## 🛠️ Troubleshooting

### Lỗi thường gặp:

#### 1. **Build failed**
```bash
# Kiểm tra local build
npm run build

# Fix lỗi và push lại
git add .
git commit -m "Fix build errors"
git push origin main
```

#### 2. **Permission denied**
- Vào Settings → Actions → General
- Workflow permissions → Read and write permissions
- Save

#### 3. **404 Page Not Found**
- Kiểm tra branch `gh-pages` đã được tạo
- Kiểm tra Settings → Pages → Source

#### 4. **Assets không load**
- Thêm vào `vite.config.ts`:
```typescript
export default defineConfig({
  base: '/[repository-name]/', // Thêm dòng này
  // ... other config
});
```

## 🚀 Quick Commands

### Deploy:
```bash
# Method 1: Manual
git add .
git commit -m "Update website"
git push origin main

# Method 2: Using script
npm run deploy
```

## 📝 Notes

- **Free tier**: 1GB storage, 100GB bandwidth/tháng
- **Build time**: Tối đa 6 giờ/tháng (đủ dùng)
- **Public repos**: Miễn phí hoàn toàn
- **Private repos**: Cần GitHub Pro ($4/tháng)

## 🎯 Next Steps

1. ✅ Push code để test auto deploy
2. ✅ Kiểm tra website update
3. ✅ Setup custom domain (tùy chọn)

---

**🎉 Hoàn thành!**

Website tự động update khi push code mới.

**URL**: `https://haitranwang.github.io/fwa`
