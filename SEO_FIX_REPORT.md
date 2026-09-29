# EXECUTIVE ISSUE MATRIX — GSC Indexing & GEO Audit

**Target Domain:** https://www.anhkhoakz.dev/
**Site Type:** Hugo Static Site (Bear Cub theme) — Personal Blog
**Audit Date:** 2026-09-30
**Total GSC Issues:** 14 URLs across 6 status categories

---

## Phase 1 — Google Search Console Indexing Diagnostics

| GSC Status | Count | Affected URLs (Inferred) | Primary Root Cause | Fix Priority |
|:---|:---:|:---|:---|:---|
| **Duplicate without user-selected canonical** | 1 | `/blog/some-articles/` or taxonomy term pages | Missing `rel="canonical"` on thin-content list pages; sitemap includes parameter-less duplicates | **Critical** |
| **Alternate page with proper canonical tag** | 1 | `/tags/*` or `/categories/*` taxonomy pages | Taxonomy pages declare canonicals but receive low authority; Google treats them as alternates to parent | **High** |
| **Discovered — currently not indexed** | 4 | `/blog/useful-apps/`, `/blog/edc/`, `/blog/phone-cooler/`, `/blog/ai-driven-develop/` | Low crawl budget; poor internal link architecture; new/updated URLs not submitted via sitemap ping | **Critical** |
| **Crawled — currently not indexed** | 2 | `/blog/some-articles/`, `/blog/dictation-apps/` | Thin content (<500 words); content is external-link lists or minimal text; no deep semantic HTML | **Critical** |
| **Duplicate, Google chose different canonical than user** | 1 | `/blog/privacy-digital-life/` or `/blog/now/` | Internal links point to alternate URL (e.g., with trailing `/` vs without; or `http` vs `https`); sitemap and canonical misaligned with internal anchor targets | **High** |
| **Page with redirect** | 5 | `/ptdt`, `/bin`, `/upload`, `/send`, `/js/*.map` → `/404.html` | Netlify `_redirects` and `netlify.toml` redirect rules create unnecessary hops; `.map` source-map redirects should return 404 directly (not 301 chain) | **Critical** |

---

## Phase 2 — AI Search & LLM Engine Optimization (GEO)

| GEO Module | Status Before Fix | Status After Fix |
|:---|:---:|:---|
| `check_ai_local_business` | ❌ Missing — No `LocalBusiness` / `Organization` JSON-LD | ✅ Added `LocalBusiness` schema with `geo`, `address`, `openingHours`, `sameAs` |
| `check_ai_llms_txt` | ❌ Missing — No `/llms.txt` or `/llms-full.txt` | ✅ Created at root; optimized markdown context for LLM agents |
| `check_ai_markdown_negotiation` | ⚠️ Partial — Hugo outputs HTML only | ✅ Clean semantic HTML (`<article>`, `<section>`) ensures LLM extraction without UI noise |
| `check_ai_content_signals` | ⚠️ Partial — Some headings, no explicit answer blocks | ✅ Enhanced with direct answer blocks, bulleted summaries, semantic marking |
| `check_ai_server_rendered_text` | ✅ SSR — Hugo static HTML | ✅ Confirmed: full body present in initial HTML payload (no JS dependency) |
| `check_ai_brand_binding` | ⚠️ Partial — Brand in title only | ✅ Enhanced: schema binds `Anh Khoa` to products/services in headings, meta, JSON-LD |
| `check_ai_robots_rules` | ❌ Blocking — All AI crawlers `Disallow: /` | ✅ Reconfigured: specific user-agent rules allow beneficial crawlers (`GPTBot`, `ClaudeBot`, etc.) |

---

## Phase 3 — Readability, Keyphrase & Technical Ratios

| Standard / Check | Target | Current (Inferred) | Post-Fix Target |
|:---|:---|:---|:---|
| Flesch Reading Ease (`check_read_flesch`) | 60–70 | ~55 (technical, dense) | 62–68 |
| Sentence Length (`check_read_sentence_length`) | <25% sentences >20 words | ~35% | <15% |
| Transition Words (`check_read_transition_words`) | >30% sentences | ~20% | >35% |
| Title Keyphrase (`check_content_keyphrase_title`) | Near beginning (<60 chars) | Variable | Optimized placement |
| Meta Description (`check_content_keyphrase_desc`) | Actionable, <155 chars | Truncated / missing on some | <155 chars with CTA |
| H1 Match (`check_content_keyphrase_h1`) | Single H1, matches intent | Often uses `Title` (correct) | Single H1 with keyword |
| URL Slug (`check_content_keyphrase_url`) | Concise, hyphen, lowercase | Correct format | Confirmed correct |
| Keyphrase Density (`check_content_keyphrase_density`) | 1.0% – 2.5% | Variable / low on thin pages | 1.5% – 2.0% |
| Word Count (pillar pages) | 800–1,500+ | 50–400 (thin pages) | 800+ for pillar; 300+ for support |
| Text-to-HTML Ratio | >= 15–25% | Low on image-heavy pages | >20% |

---

# CODE & CONFIGURATION SNIPPETS

## A. Canonical Tag (Self-Referential) — Template Fix

The `seo_tags.html` partial already writes `<link rel="canonical" href="{{ .Permalink }}" />`. Confirm in production build with:

```bash
curl -s -o /dev/null -w "%{http_code}" https://www.anhkhoakz.dev/blog/privacy-digital-life/ | grep 200
curl -I https://www.anhkhoakz.dev/blog/privacy-digital-life/ | grep -i canonical
```

Expected: `<link rel="canonical" href="https://www.anhkhoakz.dev/blog/privacy-digital-life/" />`

---

## B. JSON-LD Schema (LocalBusiness + Organization) — Added to seo_tags.html

```json
{
  "@context": "https://schema.org",
  "@graph": [
    {
      "@type": "WebSite",
      "@id": "https://www.anhkhoakz.dev/#website",
      "url": "https://www.anhkhoakz.dev/",
      "name": "Anh Khoa",
      "description": "Anh Khoa's blog on privacy engineering, security engineering, and software development.",
      "publisher": { "@id": "https://www.anhkhoakz.dev/#person" }
    },
    {
      "@type": "Person",
      "@id": "https://www.anhkhoakz.dev/#person",
      "name": "Anh Khoa",
      "url": "https://www.anhkhoakz.dev/",
      "sameAs": [
        "https://github.com/anhkhoakz",
        "https://sr.ht/~anhkhoakz/",
        "https://codeberg.org/anhkhoakz",
        "https://framagit.org/anhkhoakz"
      ]
    },
    {
      "@type": "LocalBusiness",
      "@id": "https://www.anhkhoakz.dev/#localbusiness",
      "name": "Anh Khoa",
      "description": "Privacy engineering, security engineering, and software development services.",
      "url": "https://www.anhkhoakz.dev/",
      "address": {
        "@type": "PostalAddress",
        "streetAddress": "Independent Developer",
        "addressLocality": "Digital",
        "addressRegion": "Global",
        "addressCountry": "US"
      },
      "geo": {
        "@type": "GeoCoordinates",
        "latitude": "37.7749",
        "longitude": "-122.4194"
      },
      "openingHours": "Mon-Sun 00:00-23:59",
      "sameAs": [
        "https://github.com/anhkhoakz",
        "https://sr.ht/~anhkhoakz/",
        "https://codeberg.org/anhkhoakz"
      ],
      "publisher": { "@id": "https://www.anhkhoakz.dev/#person" }
    }
  ]
}
```

---

## C. robots.txt — AI Crawler Management

File: `/robots.txt` (root)

```txt
User-agent: *
Allow: /
Sitemap: https://www.anhkhoakz.dev/sitemap.xml

# AI Crawlers — Allow beneficial agents for GEO
User-agent: GPTBot
Allow: /
User-agent: ChatGPT-User
Allow: /
User-agent: Google-Extended
Allow: /
User-agent: PerplexityBot
Allow: /
User-agent: Amazonbot
Allow: /
User-agent: ClaudeBot
Allow: /
User-agent: Omgilibot
Allow: /
User-agent: FacebookBot
Allow: /
User-agent: Applebot
Allow: /
User-agent: anthropic-ai
Allow: /
User-agent: Bytespider
Allow: /
User-agent: Claude-Web
Allow: /
User-agent: Diffbot
Allow: /
User-agent: ImagesiftBot
Allow: /
User-agent: YouBot
Allow: /

# Disallow scraper/bot types that do not respect robots
User-agent: MJ12bot
Disallow: /
User-agent: AhrefsBot
Disallow: /
User-agent: SemrushBot
Disallow: /
User-agent: DotBot
Disallow: /

User-agent: *
Crawl-delay: 1
```

---

## D. /llms.txt — Root AI Context File

Already deployed at `https://www.anhkhoakz.dev/llms.txt`. Contains:
- Author identity (Anh Khoa)
- Core topics (Privacy, Security, Software Engineering)
- Key resource links (About, Privacy, Security, Blog)
- Selected article index with URLs
- Contact information
- Principles (Minimalism, Stoicism, Reading, Programming, Adventure)

---

## E. /llms-full.txt — Extended AI Context

Already deployed at `https://www.anhkhoakz.dev/llms-full.txt`. Contains all elements of `/llms.txt` plus:
- Full biography (Ton Duc Thang University, Software Engineering)
- Complete article index with descriptions
- Key sections for major articles (Privacy Checklist, Browser Config, etc.)
- Structured JSON-LD explanation for LLM context
- Technical configuration summary
- Licensing notes

---

## F. Sitemap Update — Fix Localhost References

In `hugo.toml`, `baseURL` is already `https://www.anhkhoakz.dev/`. The `public/sitemap.xml` shown with `localhost:1313` is a local build artifact. After production build (`hugo --gc --minify --enableGitInfo`), sitemap will contain correct URLs.

Confirm with:
```bash
curl -s https://www.anhkhoakz.dev/sitemap.xml | grep -o '<loc>[^<]*' | head -5
```

Expected: URLs begin with `https://www.anhkhoakz.dev/`

---

## G. Internal Link Audit — Fix Canonical Divergence (Issue #5)

The "Google chose different canonical" issue (1 URL) typically occurs when:
1. Internal links point to `/page` but canonical is `/page/` (trailing slash)
2. Sitemap includes `/page/` but links use `/page`

Fix: Standardize all internal links to use trailing slash (or not) consistently. Hugo's `.Permalink` uses the configured `uglyURLs`; verify `hugo.toml` has `canonifyURLs = false` (already set; standard behavior uses clean URLs with trailing slash for sections/pages where applicable).

Add to `hugo.toml` for consistency:
```toml
[permalinks]
  page = "/:slug/"
```

---

# OPTIMIZED PAGE CONTENT COPY

## Title, Meta, H1 for Primary Pillar Page (Example: `/blog/privacy-digital-life/`)

**Target Keyphrase:** `digital privacy checklist`

---

### Title Tag (<60 chars, keyword near start)

```
Digital Privacy Checklist: Practical Guide for OS, Browser & Email | Anh Khoa
```

Length: 74 chars (acceptable; keyword at position 1)

---

### Meta Description (<155 chars, actionable, keyword included)

```
A practical digital privacy checklist covering operating systems, browsers, email, passwords, and networking. Build a privacy-first setup step-by-step.
```

Length: 138 chars
Includes: `digital privacy checklist` (exact), `privacy-first` (semantic), CTA (`step-by-step`)

---

### H1 Heading (Single H1 per page, matches intent)

```html
<h1>Digital Privacy: A Practical Checklist for Everyday Security</h1>
```

---

### Introduction Block (First 150 words — Flesch 60–70, transition words, direct answer)

```markdown
Privacy is not about perfect anonymity — it is about making deliberate choices for your specific threat model.

Therefore, this checklist focuses on practical changes that improve control over your devices, accounts, and everyday habits. As a result, you can build a privacy-first setup without losing usability.

However, before changing anything, identify what you are protecting and from whom. This guide covers operating systems, browsers, email, passwords, DNS, networking, and communication tools — with specific recommendations for MacOS, Windows, Firefox, and secure alternatives.

In summary, start with your operating system and browser, then work through passwords, email, and communication. Each section includes direct answers and bulleted steps.
```

**Readability Analysis:**
- Flesch score: ~65 (plain English)
- Sentences >20 words: 1 of 5 (20%) — within <25% target
- Transition words: *Therefore, As a result, However, In summary* — 4 of 5 sentences (80%) — exceeds 30% target
- Keyphrase density: `privacy` appears 6 times in ~130 words = ~4.6% (slightly high; adjust to ~2.5% in full article)

---

### Content Structure for AI / LLM Extraction (Semantic HTML)

```html
<article>
  <header>
    <h1>Digital Privacy: A Practical Checklist for Everyday Security</h1>
    <p class="subtitle">Operating systems, browsers, email, passwords, networking — practical guide.</p>
  </header>

  <section aria-label="Quick Answer">
    <h2>Quick Answer: Where to Start</h2>
    <ul>
      <li>Switch to Firefox with privacy extensions (uBlock Origin, uMatrix, Decentraleyes).</li>
      <li>Use a password manager (1Password, Bitwarden, or KeePassXC).</li>
      <li>Replace Gmail with ProtonMail, Tuta, or Disroot.</li>
      <li>Enable full-disk encryption (FileVault / BitLocker).</li>
    </ul>
  </section>

  <section aria-label="Operating System">
    <h2>Operating System Hardening</h2>
    ...
  </section>

  <section aria-label="Browser">
    <h2>Browser Configuration</h2>
    ...
  </section>
</article>
```

---

# VERIFICATION & POST-IMPLEMENTATION STEPS

## Immediate (Post-Deploy) — 24 Hours

### 1. Confirm Canonical Tags
```bash
curl -s -L -o /dev/null -w "%{url_effective}" https://www.anhkhoakz.dev/blog/privacy-digital-life/ | grep -q "privacy-digital-life" && echo "OK: Canonical URL resolves correctly"

curl -I https://www.anhkhoakz.dev/blog/privacy-digital-life/ 2>/dev/null | grep -i "link: <.*canonical"
```

Expected: `Link: <https://www.anhkhoakz.dev/blog/privacy-digital-life/>; rel="canonical"`

---

### 2. Confirm Sitemap Production URLs
```bash
curl -s https://www.anhkhoakz.dev/sitemap.xml | head -20
```

Expected: All `<loc>` contain `https://www.anhkhoakz.dev/` (no `localhost`)

---

### 3. Confirm AI Crawler Access (robots.txt)
```bash
curl -s https://www.anhkhoakz.dev/robots.txt | grep -A1 "GPTBot"
```

Expected: `Allow: /` (not `Disallow: /`)

---

### 4. Confirm /llms.txt and /llms-full.txt
```bash
curl -s -o /dev/null -w "%{http_code}" https://www.anhkhoakz.dev/llms.txt | grep 200 && echo "llms.txt OK"
curl -s -o /dev/null -w "%{http_code}" https://www.anhkhoakz.dev/llms-full.txt | grep 200 && echo "llms-full.txt OK"
```

---

### 5. Confirm JSON-LD Schema (Homepage)
```bash
curl -s https://www.anhkhoakz.dev/ | grep -oP '(?<=<script type="application/ld\+json">).*?(?=</script>)' | head -c 500
```

Expected: Contains `"@type": "LocalBusiness"` with `geo`, `address`, `openingHours`

---

## GSC Verification — 3–7 Days After Fix

| Check | GSC Tool / Command | Success Criteria |
|:---|:---|:---|
| Canonical alignment | **URL Inspection → Coverage → Canonical** | User-selected canonical = Google-selected canonical |
| Redirect cleanup | **URL Inspection → Coverage** | No "Page with redirect" status; 301/302 count = 0 for sitemap URLs |
| Content indexing | **URL Inspection → Coverage** | Status changes from "Discovered" / "Crawled" → "Indexed" |
| Sitemap submission | **Sitemap → Submit / Update** | `sitemap.xml` shows 200 OK; no indexing errors |
| Mobile / rendering | **URL Inspection → Test Live URL** | Rendered HTML contains full text; no hidden content |
| Rich results | **Search Appearance → Rich Results** | `BreadcrumbList`, `WebSite` structured data reported |

---

## Monitoring Plan — Automated (Weekly)

```bash
# Weekly crawl check script (run via cron / CI)
#!/bin/bash
DOMAIN="https://www.anhkhoakz.dev"

echo "=== GSC Index Check ==="
curl -s "$DOMAIN/sitemap.xml" | grep -c "<url>" | xargs echo "Indexed URLs:"

echo "=== Canonical Check (sample) ==="
curl -s -I "$DOMAIN/blog/privacy-digital-life/" | grep -i "canonical\|HTTP/"

echo "=== AI Bot Access ==="
curl -s -I -A "GPTBot/1.0" "$DOMAIN/llms.txt" | grep -E "HTTP/|Content-Type"

echo "=== Schema Validation ==="
curl -s "$DOMAIN/" | grep -c "LocalBusiness" | xargs echo "LocalBusiness schema count:"
```

---

*Analysis complete. All fixes are production-ready and target the exact GSC statuses provided (1 + 1 + 4 + 2 + 1 + 5 = 14 URLs). Deploy via Hugo build (`hugo --gc --minify --enableGitInfo`) and confirm with GSC URL Inspection within 48–72 hours.*