---
applyTo: "_sass/**/*.scss,css/main.scss"
description: "Use when editing SCSS and CSS to prevent selector leaks, preserve responsive behaviour, and match project style conventions."
---

# Styles Instructions

## Scope and safety
- Scope selectors to avoid site-wide side effects.
- Avoid broad grouped selectors that leak styles globally.
- Keep changes local to the component or layout being edited.

## Conventions
- Reuse existing variables and mixins before adding new ones.
- Preserve existing spacing, typography, and responsive breakpoints unless asked to redesign.
- Keep formatting consistent with the surrounding SCSS style.

## Accessibility
- Preserve readable contrast and focus visibility.
- Do not rely on hover-only behaviour for critical interactions.

## Performance
- Prefer simple selectors over deeply nested or overly specific rules.
- Avoid unnecessary duplication of style blocks.
