#!/bin/bash

# 🚀 Deploy to GitHub Pages
echo "🔧 Building project..."

npm run build

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo "📝 Committing changes..."

    git add .
    git commit -m "Deploy: $(date '+%Y-%m-%d %H:%M:%S')"
    git push origin main

    echo "✅ Deployed! Website will update in ~5 minutes"
else
    echo "❌ Build failed!"
    exit 1
fi
