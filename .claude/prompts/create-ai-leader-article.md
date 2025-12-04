# Create AI Leader Deep-Dive Article

## Objective

Create a comprehensive deep-dive article about the next unmarked person from the AI 100 list, following LatePost
investigative journalism style.

---

## Complete Workflow Overview

### Phase 1: Planning & Setup

1. Identify target person from AI 100 list
2. Create TodoWrite task list for tracking progress
3. Research target person thoroughly

### Phase 2: Writing

4. Create date directory if needed
5. Write article using LatePost style
6. Ensure 10,000-12,000 word count

### Phase 3: Integration

7. Update AI 100 list with ✅ and hyperlink
8. Update this template file with current date

### Phase 4: Validation & Deployment

9. Run validation commands
10. Commit changes with proper message format
11. Push to GitHub

---

## Step 1: Identify Target Person

### 1.1 Check AI 100 List

Read the AI 100 list: https://digidai.github.io/2025/11/07/silicon-valley-ai-100-most-influential-2025/

**IMPORTANT:** The WebFetch result may be outdated. Always verify by reading the actual file:

```bash
Read: /Users/dai/Documents/CursorProjects/digidai.github.io/src/pages/2025/11/07/silicon-valley-ai-100-most-influential-2025.astro
```

### 1.2 Selection Criteria

Find the next person who:

- ❌ Does NOT have a ✅ checkmark yet
- ❌ Does NOT have a hyperlink on their name
- ✅ Is strategically important (prioritize #32-#50 over #80-#100)

### 1.3 Priority Guidelines

**High Priority (Write First):**

- Big Tech AI Leaders (Apple, Google, Microsoft, Meta, Amazon)
- Foundation Model Company Executives
- Notable Career Transitions (e.g., Google → Apple)

**Medium Priority:**

- Cloud Infrastructure Leaders
- AI Chip Company Executives
- Major AI Application Startup CEOs

**Lower Priority:**

- Investors (unless they have operational roles)
- Less prominent positions in large companies

### 1.4 Confirm Selection

Before proceeding, confirm:

- Person's full name
- Current company and title
- Approximate ranking in AI 100 list

---

## Step 2: Create Task Tracking

### 2.1 Initialize TodoWrite

**CRITICAL:** Always create TodoWrite task list at the very beginning. This helps track progress and ensures nothing is
forgotten.

```javascript
TodoWrite({
  todos: [
    {
      content: 'Research [Person Name] using latepost-writer skill',
      status: 'in_progress',
      activeForm: 'Researching [Person Name] using latepost-writer skill',
    },
    {
      content: 'Create article file with correct structure',
      status: 'pending',
      activeForm: 'Creating article file with correct structure',
    },
    {
      content: 'Update AI 100 list with ✅ and hyperlink',
      status: 'pending',
      activeForm: 'Updating AI 100 list with ✅ and hyperlink',
    },
    {
      content: "Update .claude/prompts/create-ai-leader-article.md with today's date",
      status: 'pending',
      activeForm: "Updating .claude/prompts/create-ai-leader-article.md with today's date",
    },
    { content: 'Run validation commands', status: 'pending', activeForm: 'Running validation commands' },
    { content: 'Commit and push to GitHub', status: 'pending', activeForm: 'Committing and pushing to GitHub' },
  ],
});
```

### 2.2 Update Tasks Regularly

- Mark tasks as "completed" IMMEDIATELY after finishing
- Update to "in_progress" when starting a new task
- Only ONE task should be "in_progress" at a time

---

## Step 3: Research Using LatePost Writer Skill

### 3.1 Activate LatePost Skill

```
Skill({ skill: "latepost-writer" })
```

### 3.2 Research Strategy

Execute comprehensive web searches covering:

**Core Biography:**

- Full name, education, early career
- Career trajectory and key positions
- Entrepreneurial ventures and exits

**Company Context:**

- Current role and responsibilities
- When they joined and why
- Major projects or initiatives they lead

**Strategic Positioning:**

- Industry impact and competitive positioning
- Relationships with other key players
- Strategic decisions and their consequences

**Recent Developments:**

- Latest news (2024-2025)
- Leadership changes or controversies
- Product launches or failures

**Comparative Analysis:**

- How their company compares to competitors
- Their strategy vs. industry trends
- On-device vs. cloud AI (for Apple/Google comparisons)

### 3.3 Recommended Web Searches (Parallel)

Execute 5-10 WebSearch calls in PARALLEL for efficiency:

```javascript
WebSearch({ query: '[Person Name] biography career education' });
WebSearch({ query: '[Person Name] [Company] [Year Joined] hire role' });
WebSearch({ query: '[Company] AI strategy [Product] 2024 2025' });
WebSearch({ query: '[Person Name] leadership challenges problems' });
WebSearch({ query: '[Company] vs [Competitor] AI strategy comparison' });
WebSearch({ query: '[Person Name] recent news 2025' });
WebSearch({ query: '[Company] [Technology] specifications performance' });
// Add more as needed based on the person
```

### 3.4 Research Depth Guidelines

**Minimum Required Information:**

- Career timeline (5+ positions)
- Educational background
- Key achievements (3-5 major accomplishments)
- Current strategic challenges (2-3 specific issues)
- Industry context and competitive landscape
- Recent developments (last 6-12 months)

**Aim for:**

- 10-15 web search results
- 5,000+ words of raw research material
- Multiple perspectives (company, competitors, analysts, critics)
- Specific data points (dates, numbers, quotes)

---

## Step 4: Create Article File

### 4.1 Prepare Directory

```bash
# Use today's date: YYYY/MM/DD format
mkdir -p /Users/dai/Documents/CursorProjects/digidai.github.io/src/pages/YYYY/MM/DD
```

**Example for November 13, 2025:**

```bash
mkdir -p /Users/dai/Documents/CursorProjects/digidai.github.io/src/pages/2025/11/13
```

### 4.2 File Naming Convention

**Format:** `firstname-lastname-company-keywords-deep-analysis.astro`

**Guidelines:**

- Use lowercase throughout
- Separate words with hyphens `-`
- Include 2-3 relevant keywords after company name
- End with `-deep-analysis.astro`

**Good Examples:**

- `john-giannandrea-apple-ai-chief-privacy-bet-deep-analysis.astro`
- `brad-lightcap-openai-coo-business-architect-deep-analysis.astro`
- `satya-nadella-microsoft-ceo-deep-analysis.astro`

**Bad Examples:**

- ❌ `JohnGiannandrea.astro` (no keywords, wrong case)
- ❌ `john_giannandrea_apple.astro` (underscores instead of hyphens)
- ❌ `giannandrea-analysis.astro` (missing first name and company)

### 4.3 Article Template Structure

**CRITICAL:** Use this EXACT template. Do not deviate from prop names or structure.

**⚠️ IMPORTANT - String Quoting:**

- ALWAYS use double quotes for title and description strings
- NEVER use single quotes (they require escaping apostrophes with `\'`)
- ✅ CORRECT: `const title = "Jensen Huang's AI Vision";`
- ❌ WRONG: `const title = 'Jensen Huang\'s AI Vision';`
- Escape characters like `\'` will appear in displayed titles if you use single quotes

```astro
---
import ArticleLayout from '../../../../components/ArticleLayout.astro';
import ArticleMeta from '../../../../components/ArticleMeta.astro';

const title = '[Person Name] and [Company]: [Compelling Angle]';
const description = '[Detailed 2-3 sentence description covering key points and story angle]';
const date = 'YYYY-MM-DD';
const keywords = '[person name], [company], [role], [technology], [other relevant keywords]';
const url = '/YYYY/MM/DD/filename-without-extension/';
---

<ArticleLayout title={title} description={description} keywords={keywords} date={date} url={url}>
  <ArticleMeta title={title} date={date} author="Gene Dai" />

  <div class="post-content">
    <!-- Article content starts here -->

    <h2>Opening Section Title</h2>

    <p>Opening paragraph with hook...</p>

    <!-- Main content sections with h2 and h3 headings -->

    <!-- Article content ends here -->

    <div class="post-footer">
      <p>
        <em
          >This comprehensive analysis is part of the "Silicon Valley AI 100 Most Influential 2025" series—deep-dive
          profiles of the leaders shaping artificial intelligence. Published [Month DD, YYYY] • [Word Count] words •
          [Reading Time]-minute read • Research based on [N]+ verified sources including academic publications,
          conference proceedings, company announcements, and industry analyses.</em
        >
      </p>

      <div class="related-links">
        <h3>Related Analysis:</h3>
        <ul>
          <li>
            <a href="/2025/11/07/silicon-valley-ai-100-most-influential-2025/"
              >Silicon Valley AI 100 Most Influential 2025: Complete Ranking</a
            >
          </li>
          <li><a href="/2025/11/XX/related-article-1/">Related Article Title 1</a></li>
          <li><a href="/2025/11/XX/related-article-2/">Related Article Title 2</a></li>
          <li><a href="/2025/11/XX/related-article-3/">Related Article Title 3</a></li>
        </ul>
      </div>

      <div class="author-bio">
        <h3>About the Author</h3>
        <p>
          <strong>Gene Dai</strong> is a Co-founder of <strong><a href="http://openjobs-ai.com">OpenJobs AI</a></strong
          >, an AI-powered recruitment platform revolutionizing talent acquisition. With deep expertise in AI systems,
          product strategy, and global HR technology markets, Gene specializes in analyzing how technological
          breakthroughs translate into business transformation. His research focuses on the intersection of artificial
          intelligence, infrastructure engineering, and organizational leadership—making sense of how individuals shape
          entire industries through technical vision and execution excellence.
        </p>
      </div>
    </div>
  </div>
</ArticleLayout>
```

### 4.4 Component Props - CRITICAL REQUIREMENTS

#### ArticleLayout Props (ALL REQUIRED):

```javascript
title = { title }; // ✅ REQUIRED - Article title
description = { description }; // ✅ REQUIRED - Meta description
keywords = { keywords }; // ✅ REQUIRED - SEO keywords
date = { date }; // ✅ REQUIRED - Publication date (YYYY-MM-DD)
url = { url }; // ✅ REQUIRED - Canonical URL path
```

**Common Mistakes:**

- ❌ Forgetting `url={url}` (causes rendering issues)
- ❌ Wrong date format (must be YYYY-MM-DD)
- ❌ Missing any of the five required props

#### ArticleMeta Props (ONLY THESE THREE):

```javascript
title = { title }; // ✅ REQUIRED
date = { date }; // ✅ REQUIRED
author = 'Gene Dai'; // ✅ REQUIRED - Always use this exact string
```

**CRITICAL - DO NOT ADD:**

- ❌ description (will break rendering)
- ❌ keywords (will break rendering)
- ❌ readingTime (will break rendering)
- ❌ Any other props

**Historical Bug:** Many articles failed to render because extra props were passed to ArticleMeta. ONLY pass title,
date, and author.

### 4.5 Title Crafting Guidelines

**Formula:** `[Person Name] and [Company]: [Compelling Angle/Question/Statement]`

**Good Patterns:**

- Question format: "Can Apple's 2 Billion Devices Overcome Its Late Start in the AI Arms Race?"
- Dramatic statement: "The $3 Trillion Privacy Bet That Failed to Deliver"
- Value proposition: "The Architect of AI-Driven Enterprise Transformation"
- Journey narrative: "From Google AI Chief to Apple's Most Embattled Executive"

**Title Checklist:**

- [ ] Includes person's full name
- [ ] Includes company name
- [ ] Creates intrigue or poses question
- [ ] Suggests specific insight or revelation
- [ ] Length: 60-120 characters

### 4.6 Description Best Practices

**Length:** 150-250 characters (2-3 sentences)

**Must Include:**

- Who the person is (role/background)
- What they're doing now (current challenge/project)
- Why it matters (stakes/implications)

**Good Example:**

```
The former Google AI chief who joined Apple in 2018 to revolutionize Siri and on-device intelligence now faces his most critical challenge: losing control of the products he was hired to fix. An investigation into how Apple's privacy-first AI strategy collided with market reality, and why the company is quietly searching for his replacement.
```

**Bad Examples:**

- ❌ "John Giannandrea is Apple's AI chief." (Too brief, no intrigue)
- ❌ "An article about AI leadership at Apple and Google." (Vague, no specifics)
- ❌ [300+ character description] (Too long for meta description)

### 4.7 Keywords Strategy

**Format:** Comma-separated list of 6-12 relevant keywords

**Must Include:**

- Person's full name
- Company name
- Current role/title
- Key technologies or products
- Relevant industry terms

**Example:**

```javascript
const keywords =
  'John Giannandrea, Apple, Siri, Apple Intelligence, on-device AI, privacy AI, Google AI, machine learning, Tim Cook, Apple Neural Engine, Core ML, Mike Rockwell, Vision Pro';
```

**Tips:**

- Start with most important (person, company)
- Include acronyms (AI, ML, AGI, LLM)
- Include related people if relevant
- Include specific products/technologies

---

## Step 5: Article Content Guidelines

### 5.1 Word Count Requirements

**Minimum:** 8,000 words **Target:** 10,000-12,000 words **Maximum:** 15,000 words

**Why This Length:**

- Demonstrates depth of research
- Provides comprehensive analysis
- Better SEO performance
- Justifies "deep-dive" positioning

### 5.2 Article Structure

**Recommended Structure (6-7 Parts):**

```
Part I: The Setup / Background (10-15%)
- Opening hook with recent event or dramatic moment
- Person's background and journey to current position
- Context setting

Part II: The Challenge / Core Issue (15-20%)
- Main strategic or operational challenge
- Why this matters
- Stakes involved

Part III: Deeper Analysis (20-25%)
- Technical deep dive
- Competitive landscape
- Strategic trade-offs

Part IV: Execution / Results (15-20%)
- What's actually happening
- Performance metrics
- Problems encountered

Part V: Future Implications (15-20%)
- What comes next
- Strategic options
- Industry implications

Part VI: Broader Context (10-15%)
- Lessons learned
- Patterns and trends
- Unanswered questions

Conclusion: Synthesis (5%)
- Summarize key insights
- Restate central tension
- Leave with thought-provoking question
```

### 5.3 LatePost Writing Style

**Core Principles:**

1. **Objective & Factual** - No editorializing, let facts speak
2. **Data-Driven** - Use specific numbers, dates, quotes
3. **Well-Sourced** - Attribute information clearly
4. **Investigative Tone** - Dig beneath surface narratives
5. **Cold & Analytical** - Avoid hyperbole and emotion

**Language Characteristics:**

- Short, declarative sentences
- Active voice preferred
- Specific rather than general
- Critical but fair analysis
- Direct attribution of claims

**Sourcing Phrases:**

- "According to [source]..."
- "[Number] people familiar with the matter told..."
- "Bloomberg reported that..."
- "In a [date] interview, [person] stated..."
- "[Company] announced on [date]..."

**Example of Good LatePost Style:**

```
In March 2025, Apple CEO Tim Cook made a decision that would have been unthinkable seven years earlier: he stripped Siri, the company's flagship voice assistant, from John Giannandrea's control.

Giannandrea, the former Google AI chief who had been recruited in 2018 with the explicit mission to rescue Apple's faltering artificial intelligence efforts, was no longer trusted to execute on the product that defined his mandate.
```

**Example of Poor Style (Too Dramatic):**

```
❌ In a shocking and unprecedented move that sent shockwaves through Silicon Valley, Apple's visionary CEO Tim Cook made the stunning decision to dramatically restructure his AI leadership team.
```

### 5.4 HTML Structure & Formatting

**⚠️ CRITICAL: ALWAYS USE HTML TAGS, NEVER MARKDOWN**

**Articles MUST use HTML format throughout:**

- ✅ Use `<h2>`, `<h3>`, `<p>`, `<strong>`, `<ul>`, `<ol>`, `<li>` tags
- ❌ DO NOT use Markdown format (##, ###, **bold**, - bullets)
- ❌ Markdown will NOT render in ArticleLayout - content will appear as plain text

**Why this matters:** Astro's ArticleLayout component does NOT automatically process Markdown. All content must be pure
HTML or it will display incorrectly (showing markdown syntax as plain text instead of formatted content).

**Heading Hierarchy:**

```html
<h2>Major Section Title</h2>
<h3>Subsection Title</h3>
<p>Body paragraph...</p>
```

**Common HTML Elements:**

```html
<p>Paragraph text</p>
<strong>Bold/emphasis</strong>
<em>Italics</em>
<ul>
  <li>Unordered list item</li>
</ul>
<ol>
  <li>Ordered list item</li>
</ol>
<a href="/path/">Link text</a>
```

**Format Comparison:**

```html
✅ CORRECT (HTML):
<h2>The Infrastructure Years</h2>
<p>Jeff Dean co-invented <strong>MapReduce</strong> in 2004.</p>
<ul>
  <li>First item</li>
  <li>Second item</li>
</ul>

❌ WRONG (Markdown - will not render): ## The Infrastructure Years Jeff Dean co-invented **MapReduce** in 2004. - First
item - Second item
```

**DO NOT USE:**

- ❌ `<h1>` (reserved for page title)
- ❌ `<h4>`, `<h5>`, `<h6>` (keep hierarchy simple)
- ❌ `<br>` tags (use `<p>` for paragraphs)
- ❌ Inline styles (e.g., `style="color: red"`)
- ❌ `<blockquote>` (use regular `<p>` with quotes)
- ❌ Markdown syntax (##, \*\*\*, -, etc.)

### 5.5 HTML Validation Rules

**CRITICAL CHECKS:**

1. **Matching Tags:**

```html
✅ <h2>Title</h2>
❌ <h2>Title</h3>

✅ <strong>text</strong>
❌ <strong>text</b>
```

2. **Proper Nesting:**

```html
✅ <p><strong>Bold text</strong> normal text.</p>
❌ <p><strong>Bold text</p></strong>
```

3. **Div Balance:**

- Every `<div>` MUST have closing `</div>`
- Count must match exactly
- Verify with grep: `grep -c "<div"` vs `grep -c "</div>"`

4. **Quote Style:**

```html
✅ 'straight single quotes' ✅ "straight double quotes" ❌ 'curly single quotes' ❌ "curly double quotes"
```

5. **List Formatting:**

```html
✅
<ul>
  <li>Item 1</li>
  <li>Item 2</li>
</ul>

❌
<ul>
  - Item 1 - Item 2
</ul>
```

### 5.6 Article Footer Structure (CRITICAL - Standard Format)

**⚠️ IMPORTANT:** All articles MUST use this standardized footer structure for consistency.

**Standard Footer Template:**

```html
<div class="post-footer">
  <p>
    <em
      >This comprehensive analysis is part of the "Silicon Valley AI 100 Most Influential 2025" series—deep-dive
      profiles of the leaders shaping artificial intelligence. Published [Month DD, YYYY] • [Word Count] words •
      [Reading Time]-minute read • Research based on [N]+ verified sources including academic publications, conference
      proceedings, company announcements, and industry analyses.</em
    >
  </p>

  <div class="related-links">
    <h3>Related Analysis:</h3>
    <ul>
      <li>
        <a href="/2025/11/07/silicon-valley-ai-100-most-influential-2025/"
          >Silicon Valley AI 100 Most Influential 2025: Complete Ranking</a
        >
      </li>
      <li>
        <a href="/2025/11/08/sam-altman-openai-comprehensive-deep-analysis/"
          >Sam Altman and OpenAI: Comprehensive Deep Analysis</a
        >
      </li>
      <li>
        <a href="/2025/11/11/sundar-pichai-google-ceo-deep-analysis/"
          >Sundar Pichai and Google: AI-First Strategy Deep Analysis</a
        >
      </li>
      <li><a href="/2025/11/11/other-related-article/">Other Related Article Title</a></li>
    </ul>
  </div>

  <div class="author-bio">
    <h3>About the Author</h3>
    <p>
      <strong>Gene Dai</strong> is a Co-founder of <strong><a href="http://openjobs-ai.com">OpenJobs AI</a></strong
      >, an AI-powered recruitment platform revolutionizing talent acquisition. With deep expertise in AI systems,
      product strategy, and global HR technology markets, Gene specializes in analyzing how technological breakthroughs
      translate into business transformation. His research focuses on the intersection of artificial intelligence,
      infrastructure engineering, and organizational leadership—making sense of how individuals shape entire industries
      through technical vision and execution excellence.
    </p>
  </div>
</div>
```

**CRITICAL Requirements:**

1. **Opening Paragraph (Publication Info):**
   - MUST be wrapped in `<p><em>...</em></p>`
   - Include: Series name, publication date, word count, reading time, source count
   - Use bullet separator `•` between metadata items
   - Example: `Published November 14, 2025 • 12,870 words • 45-minute read`

2. **Related Links Section:**
   - MUST wrap in `<div class="related-links">`
   - MUST include `<h3>Related Analysis:</h3>` header
   - Include 3-5 related articles
   - ALWAYS include link to main AI 100 ranking as first item
   - Use full article titles
   - Verify all URLs are correct

3. **Author Bio Section:**
   - MUST wrap in `<div class="author-bio">`
   - MUST include `<h3>About the Author</h3>` header
   - Use standard author bio (can customize second half if needed)

4. **Container:**
   - MUST wrap entire footer in `<div class="post-footer">`

**What NOT to Do (Common Mistakes):**

```html
<!-- ❌ WRONG - Using <hr> separators -->
<hr />
<p><strong>About the Author</strong></p>
<p>Gene Dai is...</p>
<hr />
<p>
  <strong>Published</strong>: Date<br />
  <strong>Word Count</strong>: Number
</p>

<!-- ❌ WRONG - No wrapper divs -->
<p><strong>Related Reading:</strong></p>
<ul>
  <li>Article 1</li>
</ul>

<!-- ❌ WRONG - Missing h3 headers -->
<div class="related-links">
  <ul>
    <li>Article 1</li>
  </ul>
</div>
```

**Historical Context:** Jeff Dean article (Nov 14, 2025) was initially written with non-standard footer structure (using
`<hr>` separators and no wrapper divs). It was standardized to match other articles (Satya Nadella, Folks HR, AI
Recruitment Era) which all use the same footer pattern.

**How to Find Related Articles:**

1. Same company (e.g., other Google executives)
2. Same role (e.g., other Chief Scientists or AI leaders)
3. Competitors (e.g., OpenAI vs Google vs Microsoft AI leaders)
4. Same time period or event
5. Main AI 100 ranking list (always include as first link)

---

## Step 6: Update AI 100 List

### 6.1 Locate Entry in AI 100 File

```bash
# Find the person's entry
grep -n "John Giannandrea" /Users/dai/Documents/CursorProjects/digidai.github.io/src/pages/2025/11/07/silicon-valley-ai-100-most-influential-2025.astro
```

### 6.2 Add ✅ Checkmark and Hyperlink

**Before:**

```html
<h3>32. John Giannandrea | Apple - SVP ML & AI</h3>
```

**After:**

```html
<h3>
  ✅ 32. <a href="/2025/11/13/john-giannandrea-apple-ai-chief-privacy-bet-deep-analysis/">John Giannandrea</a> | Apple -
  SVP ML & AI
</h3>
```

**Important Rules:**

- ✅ Add checkmark at the beginning
- ✅ Keep the number
- ✅ Hyperlink ONLY the person's name
- ✅ Keep company and title outside the link
- ✅ Match URL exactly from article file

### 6.3 Verification

After editing, verify:

```bash
# Check the edit worked
grep -A 1 "John Giannandrea" /path/to/ai-100-list.astro

# Should show:
# <h3>✅ 32. <a href="/.../">John Giannandrea</a> | Apple - SVP ML & AI</h3>
```

---

## Step 7: Update Template File Date

**CRITICAL:** Update ALL date references in this template file to today's date.

**Files to Update:**

```
/Users/dai/Documents/CursorProjects/digidai.github.io/.claude/prompts/create-ai-leader-article.md
```

**Lines to Update:**

1. File Naming Convention section: `Date: Use today's date (YYYY-MM-DD)`
2. Template example: `const date = 'YYYY-MM-DD';`
3. Template example: `const url = '/YYYY/MM/DD/...';`
4. Validation commands section (all date paths)
5. Git commit section (all date paths)
6. Bottom of file: `**Last Updated:** YYYY-MM-DD`

**Use Edit tool with replace_all: false** to update each occurrence carefully.

---

## Step 8: Pre-Commit Validation

### 8.1 Required Validation Commands

Run these commands IN ORDER:

```bash
# 1. Verify file exists and check size
ls -lh /Users/dai/Documents/CursorProjects/digidai.github.io/src/pages/YYYY/MM/DD/[article-filename].astro

# Expected: File should be 40KB+ (approximately 10,000+ words)

# 2. Check HTML div balance
echo "Opening divs:" && grep -c "<div" /Users/dai/Documents/CursorProjects/digidai.github.io/src/pages/YYYY/MM/DD/[article-filename].astro
echo "Closing divs:" && grep -c "</div>" /Users/dai/Documents/CursorProjects/digidai.github.io/src/pages/YYYY/MM/DD/[article-filename].astro

# Expected: Same count for opening and closing divs (usually 4 and 4)

# 3. Verify no Markdown syntax in content (CRITICAL)
grep -E "^##|^\*\*|^- " /Users/dai/Documents/CursorProjects/digidai.github.io/src/pages/YYYY/MM/DD/[article-filename].astro

# Expected: NO OUTPUT (if any lines appear, article has Markdown that needs conversion)
# If you see results, the article MUST be converted to HTML before committing

# 4. Verify HTML tags are being used
grep -c "<h2>" /Users/dai/Documents/CursorProjects/digidai.github.io/src/pages/YYYY/MM/DD/[article-filename].astro
grep -c "<p>" /Users/dai/Documents/CursorProjects/digidai.github.io/src/pages/YYYY/MM/DD/[article-filename].astro

# Expected: Multiple results (h2 count should be 6-10, p count should be 100+)
# If counts are 0, article is in Markdown format and needs conversion

# 5. Verify ArticleMeta props
grep -A 5 "ArticleMeta" /Users/dai/Documents/CursorProjects/digidai.github.io/src/pages/YYYY/MM/DD/[article-filename].astro

# Expected output should show ONLY:
#   <ArticleMeta
#     title={title}
#     date={date}
#     author="Gene Dai"
#   />

# 6. Verify ArticleLayout has url prop
grep -A 10 "<ArticleLayout" /Users/dai/Documents/CursorProjects/digidai.github.io/src/pages/YYYY/MM/DD/[article-filename].astro

# Expected: Should show url={url} in the props list

# 7. Verify standard footer structure (CRITICAL)
grep -A 2 '<div class="post-footer">' /Users/dai/Documents/CursorProjects/digidai.github.io/src/pages/YYYY/MM/DD/[article-filename].astro
grep '<div class="related-links">' /Users/dai/Documents/CursorProjects/digidai.github.io/src/pages/YYYY/MM/DD/[article-filename].astro
grep '<div class="author-bio">' /Users/dai/Documents/CursorProjects/digidai.github.io/src/pages/YYYY/MM/DD/[article-filename].astro

# Expected: All three divs should be found
# If any are missing, footer structure needs to be fixed

# 8. Check for non-standard footer elements (should return nothing)
grep '<hr>' /Users/dai/Documents/CursorProjects/digidai.github.io/src/pages/YYYY/MM/DD/[article-filename].astro

# Expected: NO OUTPUT (hr tags should not be used in article footers)
# If found, replace with standard footer structure
```

### 8.2 Validation Checklist

Before committing, verify:

- [ ] File exists and is 40KB+ in size
- [ ] Opening and closing div counts match
- [ ] **CRITICAL: Article uses HTML format, NOT Markdown**
- [ ] No Markdown syntax (##, \*\*, -) found in content
- [ ] HTML tags are present (<h2>, <p>, <ul>, etc.)
- [ ] ArticleMeta has ONLY title, date, author props
- [ ] ArticleLayout includes url={url} prop
- [ ] All `<h2>` tags have closing `</h2>` (not `</h3>`)
- [ ] No smart quotes (only straight quotes)
- [ ] **CRITICAL: Footer uses standard structure (post-footer, related-links, author-bio divs)**
- [ ] No `<hr>` tags in article footer
- [ ] Footer has h3 headers for "Related Analysis:" and "About the Author"
- [ ] Publication metadata consolidated in opening paragraph with `•` separators
- [ ] Main AI 100 ranking link included as first item in related links
- [ ] Related articles section has valid URLs
- [ ] Author bio is complete and correct

**If ANY validation fails:**

- ❌ DO NOT COMMIT
- ✅ Fix the issue first
- ✅ Re-run validation
- ✅ Only commit after all checks pass

---

## Step 9: Git Commit

### 9.1 Stage Files

**IMPORTANT:** Stage ALL three types of files:

```bash
git add src/pages/YYYY/MM/DD/[article-filename].astro
git add src/pages/2025/11/07/silicon-valley-ai-100-most-influential-2025.astro
git add .claude/prompts/create-ai-leader-article.md
```

**Do NOT forget:** the template update file (`.claude/prompts/create-ai-leader-article.md`)

### 9.2 Commit Message Format

**CRITICAL BUG:** The heredoc format causes issues with pre-commit hooks. Use multi-line -m flags instead.

**CORRECT Format:**

```bash
git commit \
  -m "Add deep-dive article on [Person Name] at [Company]" \
  -m "" \
  -m "- Created comprehensive [word count]+ word analysis of [person/topic]" \
  -m "- Covers [key topic 1]" \
  -m "- Investigates [key topic 2]" \
  -m "- Details [key topic 3]" \
  -m "- Analyzes [key topic 4]" \
  -m "- Examines [key topic 5]" \
  -m "- Updated AI 100 list with ✅ checkmark and hyperlink for #[number] [Person Name]" \
  -m "- Updated create-ai-leader-article.md template with today's date (YYYY-MM-DD)" \
  -m "- Follows LatePost investigative journalism style with deep research" \
  -m "" \
  -m "🤖 Generated with Claude Code" \
  -m "" \
  -m "Co-Authored-By: Claude <noreply@anthropic.com>"
```

**WRONG Format (DO NOT USE):**

```bash
❌ git commit -m "$(cat <<'EOF'
Add deep-dive article...
EOF
)"
# This causes: "can't create temp file for here document: operation not permitted"
```

### 9.3 Commit Message Template

Customize this template for each article:

```
Add deep-dive article on [Person Name] at [Company]

- Created comprehensive [word count]+ word analysis of [brief topic description]
- Covers [Person's] journey from [previous role/company] to [current position]
- Investigates [main strategic challenge or theme]
- Details [specific event or crisis, if any]
- Analyzes [technical or business aspect]
- Examines [future implications or current state]
- Updated AI 100 list with ✅ checkmark and hyperlink for #[number] [Person Name]
- Updated create-ai-leader-article.md template with today's date (YYYY-MM-DD)
- Follows LatePost investigative journalism style with deep research

🤖 Generated with Claude Code

Co-Authored-By: Claude <noreply@anthropic.com>
```

### 9.4 Handle Pre-Commit Hook

**What Happens:** After commit, a pre-commit hook will run that:

1. Detects `.astro` file changes
2. Generates updated `sitemap.xml`
3. Generates updated `robots.txt`
4. Generates updated `llms.txt`
5. Automatically adds these files to the commit

**Expected Output:**

```
🔄 运行 pre-commit hook...
📝 检测到 .astro 文件变更，正在更新 SEO 文件...
✅ sitemap.xml 已生成
✅ robots.txt 已生成
✅ llms.txt 已生成
✅ pre-commit hook 执行完成
```

**This is NORMAL and EXPECTED.** Do not be concerned about these extra files being added.

### 9.5 Verify Commit

```bash
# Check the commit was created
git log -1 --stat

# Should show:
# - Your article file
# - AI 100 list file
# - Template file
# Note: SEO files (sitemap.xml, robots.txt, llms.txt) will NOT be in this commit
# They need to be committed separately in the next step
```

---

## Step 10: Commit SEO Files (IMPORTANT)

### 10.1 Stage and Commit SEO Files

**CRITICAL:** The pre-commit hook generates SEO files but does NOT automatically add them to the commit. You must commit them separately.

```bash
# Stage the generated SEO files
git add public/build-info.json public/cache-buster.json public/llms.txt public/robots.txt public/sitemap/sitemap.xml

# Commit SEO files
git commit \
  -m "Update SEO files after adding [Person Name] article" \
  -m "" \
  -m "- Updated sitemap.xml with new article URL" \
  -m "- Updated robots.txt with latest sitemap reference" \
  -m "- Updated llms.txt with article metadata" \
  -m "- Updated build-info.json and cache-buster.json" \
  -m "" \
  -m "🤖 Generated with Claude Code" \
  -m "" \
  -m "Co-Authored-By: Claude <noreply@anthropic.com>"
```

**Why This Step is Necessary:**

The pre-commit hook runs AFTER you create the initial commit, so the generated SEO files are not included. You must commit them separately to ensure:
- Sitemap includes the new article URL
- Search engines can discover the new content
- llms.txt has the latest article metadata
- Cache busting works correctly

---

## Step 11: Git Push

### 11.1 Push to GitHub

```bash
git push
```

**Expected Output:**

```
To https://github.com/Digidai/digidai.github.io.git
   [old-hash]..[new-hash]  master -> master
```

### 11.2 Verify Push Success

**If push succeeds:**

- ✅ Article will be live after GitHub Pages deploys (2-5 minutes)
- ✅ Check website: `https://digidai.github.io/YYYY/MM/DD/article-slug/`

**If push fails:**

```bash
# Common issue: Behind remote
git pull --rebase
git push

# If conflicts occur, resolve them before pushing
```

### 11.3 Final Verification (Optional)

Wait 5 minutes for deployment, then verify:

```bash
# Check article is accessible
curl -I https://digidai.github.io/YYYY/MM/DD/article-slug/

# Should return: HTTP/1.1 200 OK
```

---

## Complete Success Criteria Checklist

### Research Phase

- [ ] TodoWrite task list created at the start
- [ ] 10+ web searches completed
- [ ] Research covers: biography, current role, challenges, strategy, recent news
- [ ] Notes include specific data points, dates, quotes

### Writing Phase

- [ ] Article is 10,000-12,000 words
- [ ] Uses LatePost investigative journalism style
- [ ] Has 6-7 major sections with clear structure
- [ ] Includes specific examples and data throughout
- [ ] Related articles section populated with 3-5 relevant links

### Technical Phase

- [ ] File created in correct date directory (YYYY/MM/DD/)
- [ ] Filename follows naming convention
- [ ] ArticleLayout has all 5 required props including url
- [ ] ArticleMeta has ONLY 3 props (title, date, author)
- [ ] HTML tags are properly balanced and closed
- [ ] No smart quotes (only straight quotes)

### Integration Phase

- [ ] AI 100 list updated with ✅ and hyperlink
- [ ] Template file dates updated to today
- [ ] All validation commands run and passed
- [ ] Git commit includes all 3 files (article, AI 100 list, template)
- [ ] Commit message follows multi-line format (not heredoc)
- [ ] **SEO files committed separately** (sitemap.xml, robots.txt, llms.txt, build-info.json, cache-buster.json)
- [ ] Push successful

### Post-Deploy Phase

- [ ] TodoWrite tasks all marked "completed"
- [ ] Article accessible on website (after 5 min wait)
- [ ] Article displays correctly (no rendering issues)

---

## Common Errors & Solutions

### Error 0: Article Content Shows Markdown Syntax as Plain Text ⚠️ CRITICAL

**Symptoms:**

- Page loads but shows `##` instead of headings
- Content shows `**bold**` instead of bold text
- Bullet lists show `- item` instead of formatted bullets
- Article looks like raw markdown code

**Example of what you'll see:**

```
## Part I: The Foundations

Jeff Dean was born on **July 23, 1968**.

- First achievement
- Second achievement
```

**Root Cause:** Article was written in Markdown format instead of HTML. ArticleLayout does NOT process Markdown - it
only renders HTML.

**Solution:** Convert ALL content from Markdown to HTML:

```bash
# Wrong format (Markdown):
## Heading
**bold text**
- list item

# Correct format (HTML):
<h2>Heading</h2>
<p><strong>bold text</strong></p>
<ul><li>list item</li></ul>
```

**Prevention:**

- Always write articles in HTML format from the start
- Use `<h2>`, `<h3>`, `<p>`, `<strong>`, `<ul>/<ol>`, `<li>` tags
- Never use `##`, `**`, `-` markdown syntax in article content
- Refer to Sarah Friar article as HTML formatting example

**Historical Case:** Jeff Dean article (Nov 14, 2025) was initially written in Markdown and had to be completely
converted to HTML with 998 insertions and 743 deletions.

### Error 1: Article Renders Only Title, No Content ⚠️ CRITICAL

**Symptoms:**

- Page loads but shows only title
- Main content is missing
- Footer doesn't appear

**Root Causes:**

1. Invalid props passed to ArticleMeta (most common)
2. Missing url prop in ArticleLayout
3. Unclosed HTML tags breaking parser

**Solution:**

```bash
# Check ArticleMeta props
grep -A 5 "ArticleMeta" [article-file]

# Should show ONLY:
#   <ArticleMeta
#     title={title}
#     date={date}
#     author="Gene Dai"
#   />

# If you see description, keywords, or readingTime - REMOVE THEM
```

### Error 2: Git Commit Fails with "can't create temp file"

**Symptoms:**

```
(eval):1: can't create temp file for here document: operation not permitted
```

**Root Cause:** Using heredoc (`<<EOF`) in git commit within sandbox environment

**Solution:** Use multiple `-m` flags instead:

```bash
git commit \
  -m "Title line" \
  -m "" \
  -m "- Bullet 1" \
  -m "- Bullet 2"
```

**DO NOT use:**

```bash
❌ git commit -m "$(cat <<'EOF'
...
EOF
)"
```

### Error 3: Unbalanced HTML Tags

**Symptoms:**

- Validation shows different counts for opening/closing tags
- Article may render incorrectly

**Solution:**

```bash
# Count divs
grep -c "<div" [file]
grep -c "</div>" [file]

# If counts don't match, manually review file and fix
```

**Prevention:**

- Always close tags immediately after opening
- Use consistent formatting/indentation
- Verify tags before committing

### Error 4: Wrong Date in Multiple Places

**Symptoms:**

- Article has yesterday's date
- URLs don't match actual directory structure
- Template file still has old date

**Root Cause:** Forgetting to update date in all locations

**Solution:** Update dates in:

1. Directory path: `/src/pages/YYYY/MM/DD/`
2. Article file: `const date = 'YYYY-MM-DD';`
3. Article file: `const url = '/YYYY/MM/DD/...';`
4. Template file: Multiple locations (use Edit tool)
5. Commit message: Template update date

### Error 5: AI 100 List Link Doesn't Work

**Symptoms:**

- Clicking name in AI 100 list returns 404
- Link exists but URL is wrong

**Root Cause:** Mismatch between URL in AI 100 list and actual article URL

**Solution:**

```bash
# Verify article URL exactly matches:
# 1. const url = '/YYYY/MM/DD/slug/' in article
# 2. href="/YYYY/MM/DD/slug/" in AI 100 list
# 3. Actual file path: src/pages/YYYY/MM/DD/slug.astro

# All three MUST match exactly
```

### Error 6: Missing ✅ Checkmark in AI 100 List

**Symptoms:**

- Article completed but no checkmark in list
- Name has hyperlink but missing ✅

**Solution:**

```html
<!-- CORRECT: -->
<h3>✅ 32. <a href="/.../">John Giannandrea</a> | Apple - SVP ML & AI</h3>

<!-- WRONG: -->
<h3>32. <a href="/.../">John Giannandrea</a> | Apple - SVP ML & AI</h3>
```

Always add ✅ at the start (before the number).

### Error 7: Pre-Commit Hook Errors

**Symptoms:**

```
Error: Cannot find module 'gray-matter'
npm ERR! code ELIFECYCLE
```

**Root Cause:** Missing Node.js dependencies for SEO generation scripts

**Solution:**

```bash
# Install dependencies
npm install

# Then retry commit
git commit ...
```

### Error 8: Related Articles Have Broken Links

**Symptoms:**

- Related articles section shows 404 errors
- URLs don't point to real articles

**Root Cause:** Copy-pasted example URLs without updating

**Solution:**

1. List actual published articles from same timeframe
2. Verify each URL exists before including
3. Test links after deployment

**Finding Related Articles:**

```bash
# List recent articles
ls -lt src/pages/2025/11/*/

# Search for articles about specific companies
grep -r "OpenAI\|Google\|Apple" src/pages/2025/11/*/
```

### Error 9: Non-Standard Article Footer Structure

**Symptoms:**

- Article footer doesn't match other articles on the site
- Missing wrapper divs or h3 headers
- Using `<hr>` separators instead of divs
- Publication metadata scattered or formatted inconsistently

**Example of Wrong Format:**

```html
❌ WRONG:
<hr />
<p><strong>About the Author</strong></p>
<p>Gene Dai is...</p>
<p><strong>Related Reading:</strong></p>
<ul>
  <li>Article 1</li>
</ul>
<hr />
<p>
  <strong>Published</strong>: Date<br />
  <strong>Word Count</strong>: Number
</p>
```

**Root Cause:** Not following the standardized footer template required for site consistency

**Solution:** Always use the standard footer structure:

```html
✅ CORRECT:
<div class="post-footer">
  <p>
    <em
      >This comprehensive analysis is part of the "Silicon Valley AI 100 Most Influential 2025" series—deep-dive
      profiles of the leaders shaping artificial intelligence. Published [Date] • [Word Count] words • [Reading
      Time]-minute read • Research based on [N]+ verified sources...</em
    >
  </p>

  <div class="related-links">
    <h3>Related Analysis:</h3>
    <ul>
      <li>
        <a href="/2025/11/07/silicon-valley-ai-100-most-influential-2025/"
          >Silicon Valley AI 100 Most Influential 2025: Complete Ranking</a
        >
      </li>
      <li>Other articles...</li>
    </ul>
  </div>

  <div class="author-bio">
    <h3>About the Author</h3>
    <p>
      <strong>Gene Dai</strong> is a Co-founder of <strong><a href="http://openjobs-ai.com">OpenJobs AI</a></strong
      >...
    </p>
  </div>
</div>
```

**Historical Case:** Jeff Dean article (Nov 14, 2025) was initially written with non-standard footer using `<hr>`
separators. It was standardized to match Satya Nadella, Folks HR, and AI Recruitment Era articles.

**Prevention:**

- Always copy footer template from Section 4.3 or Section 5.6
- Never use `<hr>` tags in article footers
- Always wrap sections in proper div containers with class names
- Always include h3 headers for "Related Analysis:" and "About the Author"
- Consolidate publication metadata into opening paragraph with `•` separators

### Error 10: Backslash Escape Characters in Article Titles

**Symptoms:**

- Article titles display with backslash escape sequences like `\'`
- Example: `"Jensen Huang\'s AI Vision"` instead of `"Jensen Huang's AI Vision"`
- SEO files (robots.txt, llms.txt, sitemap.xml) show escape characters in titles
- Looks unprofessional and confusing to readers

**Example of Wrong Format:**

```javascript
const title = "Rohit Prasad and Amazon: From Alexa's $25 Billion Loss";
const description = "The engineer who led Amazon's voice assistant...";
```

**Example of What You'll See:**

```
Rohit Prasad and Amazon: From Alexa\'s $25 Billion Loss to the Uncertain AGI Bet
Matt Garman and AWS: From Intern to CEO—Fighting to Keep Amazon\'s $100 Billion Cloud Empire
Jensen Huang and NVIDIA: The $176 Billion Kingmaker Who Controls AI\'s Future
```

**Root Cause:** Using single quotes for JavaScript strings that contain apostrophes requires escaping with backslash
(`\'`). While technically valid JavaScript, these escape characters can appear in rendered output and SEO files.

**Solution:** Always use double quotes for title and description strings:

```javascript
✅ CORRECT:
const title = "Rohit Prasad and Amazon: From Alexa's $25 Billion Loss";
const description = "The engineer who led Amazon's voice assistant...";

❌ WRONG:
const title = 'Rohit Prasad and Amazon: From Alexa\'s $25 Billion Loss';
const description = 'The engineer who led Amazon\'s voice assistant...';
```

**Prevention:**

- Always use double quotes (`"`) for title and description strings
- Never use single quotes (`'`) for strings containing apostrophes
- Check SEO files after generation to verify no escape characters appear
- Refer to Section 4.3 template which uses double quotes

**Historical Case:** Three articles on Nov 15, 2025 (Rohit Prasad, Matt Garman, Jensen Huang) were published with
single-quote strings, causing backslash escape characters to appear in titles. Fixed by converting to double-quote
strings.

---

## Best Practices Summary

### Before You Start

1. ✅ Always create TodoWrite task list first
2. ✅ Verify AI 100 list in file (not just WebFetch)
3. ✅ Choose strategically important person to write about

### During Research

4. ✅ Run 10+ web searches in parallel
5. ✅ Collect specific data (dates, numbers, quotes)
6. ✅ Look for recent news (2024-2025)
7. ✅ Find multiple perspectives (company, competitors, critics)

### During Writing

8. ✅ Aim for 10,000-12,000 words
9. ✅ Use LatePost style (objective, data-driven, investigative)
10. ✅ Structure in 6-7 major parts with clear narrative
11. ✅ Include specific examples throughout
12. ✅ Write compelling title following formula

### Technical Details

13. ✅ Use correct template with ALL required props
14. ✅ ArticleMeta: ONLY title, date, author (nothing else!)
15. ✅ ArticleLayout: Include url={url} prop
16. ✅ Balance all HTML tags (especially divs)
17. ✅ Use straight quotes only (no smart quotes)

### Integration

18. ✅ Update AI 100 list with ✅ and hyperlink
19. ✅ Update template file with today's date
20. ✅ Run ALL validation commands
21. ✅ Only commit after validation passes

### Git Operations

22. ✅ Stage all 3 files (article, AI 100 list, template)
23. ✅ Use multi-line commit format (not heredoc)
24. ✅ Let pre-commit hook run (adds SEO files)
25. ✅ Push to GitHub
26. ✅ Verify deployment after 5 minutes

### After Completion

27. ✅ Mark all TodoWrite tasks as completed
28. ✅ Verify article displays correctly on website
29. ✅ Check related links work

---

## Quick Reference Commands

### Setup

```bash
# Create date directory
mkdir -p /Users/dai/Documents/CursorProjects/digidai.github.io/src/pages/YYYY/MM/DD

# Check AI 100 list for next person
grep "^<h3>" /Users/dai/Documents/CursorProjects/digidai.github.io/src/pages/2025/11/07/silicon-valley-ai-100-most-influential-2025.astro | grep -v "✅"
```

### Validation

```bash
# File size check
ls -lh src/pages/YYYY/MM/DD/[article].astro

# Div balance check
echo "Opening:" && grep -c "<div" src/pages/YYYY/MM/DD/[article].astro
echo "Closing:" && grep -c "</div>" src/pages/YYYY/MM/DD/[article].astro

# ArticleMeta check
grep -A 5 "ArticleMeta" src/pages/YYYY/MM/DD/[article].astro

# ArticleLayout check
grep -A 10 "<ArticleLayout" src/pages/YYYY/MM/DD/[article].astro
```

### Git Operations

```bash
# Stage all files
git add src/pages/YYYY/MM/DD/[article].astro
git add src/pages/2025/11/07/silicon-valley-ai-100-most-influential-2025.astro
git add .claude/prompts/create-ai-leader-article.md

# Commit (use multi-line format)
git commit -m "Add deep-dive article on [Person] at [Company]" \
  -m "" \
  -m "- Created comprehensive analysis" \
  -m "- Updated AI 100 list" \
  -m "- Updated template" \
  -m "" \
  -m "🤖 Generated with Claude Code" \
  -m "" \
  -m "Co-Authored-By: Claude <noreply@anthropic.com>"

# Push
git push
```

---

## File Paths Reference

### Source Files

- AI 100 List:
  `/Users/dai/Documents/CursorProjects/digidai.github.io/src/pages/2025/11/07/silicon-valley-ai-100-most-influential-2025.astro`
- This Template: `/Users/dai/Documents/CursorProjects/digidai.github.io/.claude/prompts/create-ai-leader-article.md`
- Article Directory: `/Users/dai/Documents/CursorProjects/digidai.github.io/src/pages/YYYY/MM/DD/`

### Component Files

- ArticleLayout: `/Users/dai/Documents/CursorProjects/digidai.github.io/src/components/ArticleLayout.astro`
- ArticleMeta: `/Users/dai/Documents/CursorProjects/digidai.github.io/src/components/ArticleMeta.astro`

### Generated Files (by pre-commit hook)

- Sitemap: `/Users/dai/Documents/CursorProjects/digidai.github.io/public/sitemap.xml`
- Robots: `/Users/dai/Documents/CursorProjects/digidai.github.io/public/robots.txt`
- LLMs: `/Users/dai/Documents/CursorProjects/digidai.github.io/public/llms.txt`

---

## Version History

### v1.1 (2025-11-13)

- Added complete workflow documentation
- Added comprehensive error solutions
- Added TodoWrite task tracking requirement
- Added validation checklist
- Documented heredoc bug and solution
- Added best practices summary
- Added quick reference commands

### v1.0 (Initial)

- Basic template and structure

---

**Last Updated:** 2025-11-28 **Template Version:** 1.1 **Next Review Date:** 2025-12-17 (or after next 5 articles)

**Last Article Created:** 2025-11-28 - Daniel Gross and AI Pioneer Fund: From Jerusalem Teenager to the Architect of Meta's Superintelligence Future

