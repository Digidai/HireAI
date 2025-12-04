# Custom Prompts for AI Leader Article Creation

## Quick Start

To create a new AI leader deep-dive article, use this simple command:

```
Execute the create-ai-leader-article prompt
```

This will:

1. Find the next unmarked person from the AI 100 list
2. Research them using the LatePost writer skill
3. Create a comprehensive article (10,000+ words)
4. Update the AI 100 list with a link
5. Commit and push to GitHub

## What This Automates

- ✅ Identifies the next person to write about
- ✅ Uses correct file naming and directory structure
- ✅ Applies proper component props (avoids common errors)
- ✅ Validates HTML structure
- ✅ Updates the AI 100 list with hyperlinks
- ✅ Git commit and push with proper messages

## Available Prompts

### create-ai-leader-article.md

Comprehensive prompt for creating AI leader deep-dive articles.

**Usage:**

```
Execute the create-ai-leader-article prompt
```

**What it does:**

- Finds next unmarked person from AI 100 list
- Researches using latepost-writer skill
- Creates properly formatted .astro article
- Updates AI 100 list with link
- Commits and pushes to GitHub

**Key features:**

- Prevents component prop errors
- Validates HTML structure
- Includes pre-commit checklist
- Error prevention guidelines

## Common Issues Prevention

The prompts include checks for:

- Invalid ArticleMeta props (most common error)
- Missing url prop in ArticleLayout
- HTML tag mismatches
- Incorrect file structure
- Missing related articles

## Success Rate

By following these prompts, you should achieve:

- ✅ 100% valid component usage
- ✅ 100% proper HTML structure
- ✅ 100% correct file naming
- ✅ 0 rendering errors

## Troubleshooting

If something goes wrong, see:

- `/ARTICLE_TROUBLESHOOTING.md` - Detailed troubleshooting guide
- `/ARTICLE_QUALITY_CHECKLIST.md` - Quality standards

---

**Maintained by:** Gene Dai **Last Updated:** 2025-11-12
