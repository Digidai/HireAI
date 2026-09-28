# Contributing to HireAI

Thank you for your interest in contributing to HireAI! This document provides guidelines and instructions for contributing.

## Table of Contents

- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Project Structure](#project-structure)
- [Adding a New Product](#adding-a-new-product)
- [Writing Analysis Articles](#writing-analysis-articles)
- [Creating Tag Pages](#creating-tag-pages)
- [Code Style Guidelines](#code-style-guidelines)
- [Submitting Changes](#submitting-changes)

## Getting Started

### Prerequisites

- Ruby 2.7 or higher
- Bundler gem
- Git

### Development Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/Digidai/HireAI.git
   cd HireAI
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Run the development server**
   ```bash
   bundle exec jekyll serve --livereload
   ```

4. **Open in browser**
   ```
   http://localhost:4000
   ```

## Project Structure

```
HireAI/
├── _analyses/           # Product analysis articles (251 files)
├── _data/
│   ├── products.yml     # Main product database
│   └── tag_checklists.yml # Tag evaluation checklists
├── _includes/           # Reusable HTML components
├── _layouts/            # Page layout templates
├── _sass/               # SCSS modules
│   ├── _variables.scss  # CSS custom properties
│   ├── _base.scss       # Reset and base styles
│   ├── _sidebar.scss    # Navigation sidebar
│   ├── _components.scss # Cards, buttons, tags
│   ├── _layouts.scss    # Page layouts
│   ├── _product-detail.scss
│   ├── _markdown.scss   # Markdown content
│   └── _responsive.scss # Media queries
├── _scripts/            # Build and validation scripts
├── assets/
│   ├── css/main.scss    # Main stylesheet entry
│   ├── js/main.js       # JavaScript functionality
│   └── images/          # Static images
├── tags/                # Tag pages (61 files)
└── *.md                 # Root-level pages
```

## Adding a New Product

### Step 1: Add to Product Database

Edit `_data/products.yml` and add your product under the appropriate era category:

```yaml
- name: "Your Product Name"
  url: "https://product-website.com"
  description: "One sentence on what the product does. Do not add pricing or performance figures you have not sourced."
  tags:
    - "ATS"
    - "AI"
  analysis: "_analyses/your-product-analysis.md"
```

Add that entry under the matching era in `_data/products.yml`. The current eras are:

- `1990s - Applicant Tracking Systems (ATS)`
- `2000s - Candidate Marketing & Assessment`
- `2010s - Onboarding/Workflow/Integrated Sourcing`
- `2020s - Intelligent Assessment, Diversity, Career`
- `2024+ - Agentic AI Platforms`

### Step 2: Create Analysis Article

Create a new file in `_analyses/`:

```markdown
---
layout: analysis
title: "Your Product Name"
description: "One sentence copied from the directory record."
permalink: /your-product-analysis/
website: "https://product-website.com"
era: "2024+ - Agentic AI Platforms"
last_modified_at: 2026-09-28
tags: ["ATS", "AI"]
---

## Overview

**Your Product Name** — One sentence copied from the directory record.

## When to shortlist it

Name the job to be done. Do not rank the product.

## What to verify

- Confirm the workflow in a demo.
- Ask for integrations, permissions, audit logs, and a rollback path.

## Source

- Official website: https://product-website.com
```

### Step 3: Create Missing Tag Pages

If you introduced new tags, create corresponding pages in `tags/`:

```markdown
---
layout: tag_page
tag: "Your New Tag"
title: "Your New Tag"
description: "Products with Your New Tag capability"
permalink: /tags/your-new-tag/
---

Optional introductory content about this tag.
```

### Step 4: Validate Your Changes

Run the validation script:

```bash
ruby _scripts/check_site_data.rb
```

Expected output:
```
products=X
analysis_pages=X
tag_pages=X
OK
```

### Step 5: Bake Enrichment Content

Run the enrichment script to add related products and checklists:

```bash
ruby _scripts/bake_analysis_enrichment.rb
```

## Writing Analysis Articles

### Required Front Matter

```yaml
---
layout: analysis
title: "Product Name"
description: "One sentence copied from the directory record."
permalink: /product-name-analysis/
website: "https://product.com"
era: "2024+ - Agentic AI Platforms"
last_modified_at: 2026-09-28
tags:
  - "ATS"
  - "AI"
---
```

### Recommended structure

1. **Overview** — directory description and technology era
2. **When to shortlist it** — the job to be done, without a rank
3. **What to verify** — demo checks drawn from the product's tags
4. **Related products** — other directory entries that share tags
5. **Source** — official website and the date of the directory record

For `layout: analysis`, keep the baked enrichment block (`<!-- HireAI: baked-enrichment:start -->` through `<!-- HireAI: baked-enrichment:end -->`) and run the enrichment script after you edit tags.

### Writing tips

- State only what the directory or a cited vendor page supports
- Do not invent customers, pricing, or performance figures
- If a vendor publishes a speed or database claim, label it as vendor-reported
- Update `last_modified_at` when you change the page

## Creating Tag Pages

### Tag Page Template

```markdown
---
layout: tag_page
tag: "Tag Name"
title: "Tag Name"
description: "Description for SEO"
permalink: /tags/tag-slug/
---

Introduction paragraph about what this tag represents.
```

### Adding Tag Checklists

Edit `_data/tag_checklists.yml`:

```yaml
tag-slug:
  - "Checklist item 1"
  - "Checklist item 2"
  - "Checklist item 3"
```

## Code Style Guidelines

### SCSS

- Use CSS custom properties (variables) from `_variables.scss`
- Follow BEM-like naming: `.block`, `.block-element`, `.block--modifier`
- Keep selectors shallow (max 3 levels)
- Mobile-first media queries

### JavaScript

- Use ES6+ syntax
- Implement debounce for search inputs
- Check for element existence before attaching listeners
- No jQuery dependency

### Liquid Templates

- Escape user-generated content: `{{ value | escape }}`
- Use `{% if %}` guards for optional values
- Prefer includes for repeated HTML

## Submitting Changes

### Before Submitting

1. Run validation: `ruby _scripts/check_site_data.rb`
2. Test locally: `bundle exec jekyll serve`
3. Check mobile responsiveness
4. Verify all links work

### Pull Request Process

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Make your changes
4. Commit with clear messages
5. Push to your fork
6. Open a Pull Request

### Commit Message Format

```
type: brief description

- Detail 1
- Detail 2
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`

### Review Criteria

- [ ] Passes validation scripts
- [ ] Follows code style guidelines
- [ ] Mobile-responsive
- [ ] No broken links
- [ ] Clear documentation for new features

## Questions?

- Open an [Issue](https://github.com/Digidai/HireAI/issues)
- Check existing [Discussions](https://github.com/Digidai/HireAI/discussions)

Thank you for contributing!
