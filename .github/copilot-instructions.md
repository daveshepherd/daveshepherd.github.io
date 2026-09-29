# Copilot Instructions for daveshepherd.github.io

## Project context
- This is a Jekyll 4 site, built by GitHub Actions and deployed to GitHub Pages.
- Primary stack: Liquid templates, Markdown posts, SCSS partials, and static assets.
- Dependencies are declared explicitly in `Gemfile` (Jekyll plus the `jekyll-paginate` plugin); the `github-pages` gem is not used.

## What to prioritize
- Preserve existing site behaviour and URL structure.
- Prefer minimal, surgical changes over broad refactors.
- Keep accessibility and semantic HTML as first-class requirements.
- Keep edits compatible with the current Jekyll 4 toolchain and the plugins listed in `Gemfile`.

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
- Do not upgrade Jekyll major versions or add Jekyll plugins unless explicitly asked.
- Keep `Gemfile` and `Gemfile.lock` in sync when changing dependencies.

## Suggested validation
- For content/template/style edits, run a local build when possible:
  - `scripts/local-check.sh` (runs `jekyll doctor`, a production build and html-proofer)
  - `bundle exec jekyll serve --host 0.0.0.0` to preview
- If lint or diagnostics are available, resolve new warnings introduced by your changes.

## Pull request quality bar
- Explain what changed and why in plain language.
- Reference impacted templates/styles/content files explicitly.
- Call out any assumptions, tradeoffs, and follow-up opportunities.
