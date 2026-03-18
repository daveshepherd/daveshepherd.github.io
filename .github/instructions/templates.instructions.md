---
applyTo: "_includes/**/*.html,_layouts/**/*.html,index.html,404.md,rss.xml"
description: "Use when editing Liquid templates, includes, and page templates for accessibility, SEO, and Jekyll compatibility."
---

# Templates Instructions

## Compatibility
- Keep templates compatible with GitHub Pages and the github-pages gem stack.
- Prefer minimal, surgical edits and preserve existing URL behaviour.

## Liquid and markup
- Maintain current Liquid style and indentation in touched files.
- Keep canonical URL generation intact when modifying head metadata.
- Prefer semantic HTML elements and meaningful landmarks.

## Accessibility
- Use buttons for toggles and controls, not anchor placeholders.
- Ensure keyboard accessibility for interactive elements.
- Ensure images include alt text or empty alt when decorative.

## SEO and feeds
- Prefer page-aware metadata with site-level fallbacks.
- Keep rss.xml valid and escaped where needed.

## Safety
- Avoid introducing JavaScript unless required by behaviour or accessibility.
- Do not modify _site output directly.
