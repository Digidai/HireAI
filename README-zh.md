# HireAI - HR 相关 AI 产品收集项目

[![Awesome](https://awesome.re/badge.svg)](https://awesome.re)
[![GitHub Stars](https://img.shields.io/github/stars/Digidai/HireAI?style=social)](https://github.com/Digidai/HireAI/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/Digidai/HireAI?style=social)](https://github.com/Digidai/HireAI/network/members)
[![GitHub Issues](https://img.shields.io/github/issues/Digidai/HireAI)](https://github.com/Digidai/HireAI/issues)
[![GitHub License](https://img.shields.io/github/license/Digidai/HireAI)](https://github.com/Digidai/HireAI/blob/master/LICENSE)
[![Last Commit](https://img.shields.io/github/last-commit/Digidai/HireAI)](https://github.com/Digidai/HireAI/commits/master)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/Digidai/HireAI/pulls)
[![AI Powered](https://img.shields.io/badge/AI-Powered-blue.svg)](https://github.com/Digidai/HireAI)
[![HR Tech](https://img.shields.io/badge/HR-Tech-orange.svg)](https://github.com/Digidai/HireAI)

**阅读其他语言版本：** [English](README.md)

## 项目简介

本项目致力于收集和整理人力资源（HR）领域的 AI 产品和解决方案。它驱动 HireAI 网站与产品目录：产品数据维护在 `_data/products.yml`，分析文章以 Markdown 形式保存在仓库根目录。

## 本地开发

前置条件：Ruby + Bundler。

- 安装依赖：`bundle install`
- 运行数据校验：`ruby _scripts/check_site_data.rb`
- 本地预览：`bundle exec jekyll serve`
- 构建：`JEKYLL_ENV=production bundle exec jekyll build`

## 部署（GitHub Pages）

本仓库包含 GitHub Actions 工作流 `.github/workflows/jekyll-gh-pages.yml`，用于构建并部署到 GitHub Pages。请在 GitHub Pages 设置中将 **Build and deployment** → **Source** 设为 **GitHub Actions**。

## 项目结构

本项目将包含以下内容：

- **产品介绍** - 详细介绍各类 HR AI 产品的功能、特点和使用场景
- **研究报告** - 深入分析 HR AI 市场趋势、技术发展和行业应用
- **产品对比** - 不同 HR AI 产品之间的功能对比和评估
- **使用指南** - 如何选择和使用适合的 HR AI 工具

## 文档格式

所有的研究报告和产品介绍均采用 Markdown 格式编写，便于阅读和维护。

## 研究报告

### [HR AI 演进：从申请跟踪到智能体 AI 的全面分析](hr-ai-evolution-comprehensive-analysis.md)
通过 Josh Bersin 的五阶段技术演进框架，对 46 个 HR AI 产品和供应商进行全面分析，研究从 1990 年代 ATS 系统到 2024+ 智能体 AI 平台的发展历程。

## 产品目录

### [完整 HR AI 产品目录](product-directory.md)
按技术时代组织的 HR AI 产品综合目录，包含官方网站直接链接，并为每个产品提供对应的分析文章（部分为待扩写的 starter 文章）。

### 按类别分类

#### 1990年代 - 申请跟踪系统 (ATS)
- [Oracle Taleo](https://www.oracle.com/human-capital-management/taleo/)
- [SAP SuccessFactors](https://www.sap.com/products/human-resources-hcm.html)
- [PeopleFluent](https://www.peoplefluent.com/)
- [Workday Recruiting](https://www.workday.com/en-us/products/human-capital-management/recruiting.html)
- [Cornerstone OnDemand](https://www.cornerstoneondemand.com/)

#### 2000年代 - 候选人营销与评估
- [Glassdoor](https://www.glassdoor.com/)
- [ZipRecruiter](https://www.ziprecruiter.com/)
- [Textio](https://textio.com/)
- [IBM Kenexa](https://www.ibm.com/products/kenexa-employee-assessments)
- [SHL](https://www.shl.com/)
- [Talview](https://www.talview.com/)

#### 2010年代 - 入职/工作流/集成采购
- [Greenhouse](https://www.greenhouse.io/)
- [Lever](https://www.lever.co/)
- [SmartRecruiters](https://www.smartrecruiters.com/)
- [XOR](https://www.xor.ai/)
- [Harver](https://harver.com/)
- [HireVue](https://www.hirevue.com/)
- [Karat](https://karat.com/)

#### 2020年代 - 智能评估、多样性、职业发展
- [HackerRank](https://www.hackerrank.com/)
- [Yello](https://www.yello.co/)
- [Indeed](https://www.indeed.com/)
- [Avature](https://www.avature.net/)
- [Unitive](https://www.unitive.com/)

#### 2024+ - 智能体 AI 平台
- [Beamery](https://beamery.com/)
- [Eightfold.ai](https://eightfold.ai/)
- [HiredScore](https://www.hiredscore.com/)
- [iCIMS](https://www.icims.com/)
- [Paradox](https://www.paradox.ai/)
- [Phenom People](https://www.phenompeople.com/)
- [SeekOut](https://seekout.com/)
- [LinkedIn Talent Hub](https://business.linkedin.com/talent-solutions/talent-hub)
- [OpenJobs AI](https://www.openjobs-ai.com)

## 贡献指南

欢迎提交新的 HR AI 产品信息或改进现有内容。请确保：
1. 内容准确可靠
2. 格式规范统一
3. 信息及时更新
4. 如新增标签，请在 `tags/` 下补充对应标签页（slug：全小写，空格替换为 `-`）

## 许可证

本项目采用 MIT 许可证 - 详细信息请查看 [LICENSE](LICENSE) 文件。

## 联系方式

如有任何问题或建议，请通过 GitHub Issues 联系我们。

---

*本项目持续更新中，敬请关注*
