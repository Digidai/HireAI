# SEO 快速配置指南

## 🔧 立即配置项

### 1. 搜索引擎验证

在 `_config.yml` 中添加你的验证代码：

```yaml
# 在文件末尾添加
google_site_verification: "your_verification_code_here"
bing_site_verification: "your_bing_code_here"
```

**获取验证代码:**
- Google: [Search Console](https://search.google.com/search-console) → 资源 → 验证所有权
- Bing: [Webmaster Tools](https://www.bing.com/webmasters) → 添加站点 → 验证

### 2. 提交 Sitemap

**Google Search Console:**
1. 进入 [Search Console](https://search.google.com/search-console)
2. 选择你的站点
3. 左侧菜单 → 站点地图
4. 输入: `sitemap.xml`
5. 点击"提交"

**Bing Webmaster Tools:**
1. 进入 [Bing Webmasters](https://www.bing.com/webmasters)
2. 提交站点地图: `https://hireai.genedai.me/sitemap.xml`

### 3. 测试结构化数据

访问 [Rich Results Test](https://search.google.com/test/rich-results) 并测试:
- `https://hireai.genedai.me/FAQ/` - 应该显示 FAQ 富媒体结果
- 任意产品分析页 - 应该显示面包屑和文章信息

### 4. 性能检查

访问 [PageSpeed Insights](https://pagespeed.web.dev/) 并测试首页和产品目录页，目标:
- 移动端: >90 分
- 桌面端: >95 分

---

## 📊 SEO 监控检查表

### 每周检查 (5 分钟)
- [ ] Search Console 中的覆盖率和索引问题
- [ ] 查看是否有任何手动操作或安全问题
- [ ] 检查排名前 10 的关键词表现

### 每月检查 (30 分钟)
- [ ] 审查 Search Console 的性能报告
- [ ] 检查点击率 (CTR) 和展示次数
- [ ] 查看移动端可用性问题
- [ ] 分析结构化数据的出现频率

### 每季度检查 (2 小时)
- [ ] 完整的内容审计
- [ ] 竞争对手分析
- [ ] 关键词研究和优化
- [ ] 外链建设计划
- [ ] 技术审计（加载速度、移动友好性）

---

## 🎯 优先级任务

### 高优先级 (本周完成)
1. ✅ 配置 Google Search Console
2. ✅ 配置 Bing Webmaster Tools
3. ✅ 提交 sitemap.xml
4. ✅ 测试 FAQ 页面的结构化数据

### 中优先级 (本月完成)
1. 为所有产品页面优化 title 和 description
2. 检查并修复所有死链
3. 优化首页加载性能
4. 创建更多长尾关键词内容

### 低优先级 (持续进行)
1. 建立外链
2. 社交媒体推广
3. 社区参与
4. 内容营销

---

## 🔗 有用的链接

### SEO 工具
- [Google Search Console](https://search.google.com/search-console)
- [Google Analytics](https://analytics.google.com/)
- [Google PageSpeed Insights](https://pagespeed.web.dev/)
- [Rich Results Test](https://search.google.com/test/rich-results)
- [Schema Validator](https://validator.schema.org/)
- [Bing Webmaster Tools](https://www.bing.com/webmasters)

### 学习资源
- [Google 搜索中心文档](https://developers.google.com/search/docs)
- [Schema.org 官方文档](https://schema.org/)
- [Moz SEO 指南](https://moz.com/beginners-guide-to-seo)
- [Ahrefs SEO 博客](https://ahrefs.com/blog/seo/)

---

## 💡 快速提示

### 结构化数据验证
```bash
# 使用 curl 测试结构化数据
curl -s https://hireai.genedai.me/FAQ/ | grep -A 20 "application/ld+json"
```

### 检查索引状态
```bash
# 在 Google 搜索中
site:hireai.genedai.me

# 查找特定页面
site:hireai.genedai.me FAQ

# 查找死链
site:hireai.genedai.me 404
```

### Sitemap 验证
```bash
# 测试 sitemap 可访问性
curl -I https://hireai.genedai.me/sitemap.xml

# 应该返回 200 OK
```

---

## 📞 需要帮助？

如果你在配置过程中遇到问题:
1. 查看 [SEO 优化报告](./SEO-Optimization-Report.md) 了解详细信息
2. 检查 [Jekyll 文档](https://jekyllrb.com/docs/)
3. 在 [GitHub Issues](https://github.com/Digidai/HireAI/issues) 提问

---

**祝你的 SEO 之旅顺利！** 🚀
