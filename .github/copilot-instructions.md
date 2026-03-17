# Copilot Instructions for daveshepherd.github.io

## Project context
- This is a Jekyll site deployed with GitHub Pages.
- Primary stack: Liquid templates, Markdown posts, SCSS partials, and static assets.
- Dependency baseline is intentionally aligned with `github-pages` in `Gemfile`.

## What to prioritize
- Preserve existing site behaviour and URL structure.
- Prefer minimal, surgical changes over broad refactors.
- Keep accessibility and semantic HTML as first-class requirements.
- Keep edits compatible with the current GitHub Pages/Jekyll toolchain.

## File and content conventions
- Posts live in `_posts/` and use frontmatter + Markdown.
- Layouts and includes live in `_layouts/` and `_includes/`.
- SCSS partials live in `_sass/`; entrypoint is `css/main.scss`.
- Never manually edit generated output under `_site/`.
- Maintain existing Liquid style and indentation in touched files.

## HTML and accessibility rules
- Use semantic elements (`header`, `nav`, `main`, `article`, `footer`) where applicable.
- Add or preserve meaningful labels/attributes for interactive controls.
- Prefer real buttons for UI toggles, not `a href="#"`.
- Ensure images have `alt` text (or `alt=""` only when decorative).
- Avoid hover-only interactions for critical navigation.

## CSS/SCSS rules
- Scope selectors to avoid global side effects.
- Avoid broad selectors that can leak styles (for example, unscoped `a`/`em` in grouped selectors).
- Reuse existing variables and mixins before adding new ones.

## SEO and metadata
- Prefer page-aware metadata with site-level fallbacks.
- Preserve canonical URL generation and social metadata tags in `_includes/head.html`.

## Dependency and build rules
- Use HTTPS for external sources and links.
- Do not upgrade away from `github-pages` or Jekyll major versions unless explicitly asked.
- Treat Ruby Sass/html-pipeline/rubyzip post-install warnings as expected unless changing toolchain.

## Suggested validation
- For content/template/style edits, run a local build when possible:
  - `bundle install`
  - `bundle exec jekyll serve --host 0.0.0.0`
- If lint or diagnostics are available, resolve new warnings introduced by your changes.

## Pull request quality bar
- Explain what changed and why in plain language.
- Reference impacted templates/styles/content files explicitly.
- Call out any assumptions, tradeoffs, and follow-up opportunities.
