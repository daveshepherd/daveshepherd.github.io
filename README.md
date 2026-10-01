# daveshepherd.uk

Source for [daveshepherd.uk](https://daveshepherd.uk), a personal blog built with [Jekyll](https://jekyllrb.com/) and hosted on GitHub Pages.

## Running locally

### With Ruby installed

The Ruby version is pinned in [`.ruby-version`](.ruby-version) (use rbenv, asdf, chruby or similar).

```bash
bundle install
bundle exec jekyll serve
```

Then open <http://127.0.0.1:4000>. Posts and pages reload on save; changes to `_config.yml` need a restart.

### With Docker

If you'd rather not install Ruby:

```bash
docker run -it --rm -v "$(pwd)":/usr/src -w /usr/src -p 4000:4000 ruby:3.3 /bin/bash
```

Then, inside the container:

```bash
bundle install
bundle exec jekyll serve --host 0.0.0.0
```

## Project layout

| Path | Purpose |
| --- | --- |
| `_posts/` | Blog posts, named `YYYY-MM-DD-slug.markdown` |
| `assets/` | Images referenced by posts |
| `_layouts/`, `_includes/` | Page templates (`default`, `page`, `post`) and shared partials |
| `_sass/`, `css/` | Stylesheets |
| `index.html`, `about.md`, `404.md`, `rss.xml` | Top-level pages and the RSS feed |
| `_config.yml` | Site settings, pagination and permalink format |
| `scripts/` | Local check and link-checking scripts |
| `_site/` | Generated output (git-ignored; don't edit) |

## Writing a post

Create `_posts/YYYY-MM-DD-slug.markdown` with front matter like this:

```yaml
---
layout: post
title:  "A tale about object encryption"
summary: >
  A short excerpt shown on the home page.
image: "padlock.jpg"        # optional, file in assets/
image_alt: "A padlock"      # optional, defaults to the title
date:   2020-05-13 10:00:00
tags: encryption aws kms
---
```

Put any images in `assets/`. Posts are published at `/:year-:month-:title`. Changing the filename or date changes the URL, so don't rename existing posts. `future: true` is set, so posts with a future date are still built.

## Checks before pushing

```bash
scripts/local-check.sh
```

This runs the same checks as CI:

1. `bundle install`
2. `bundle exec jekyll doctor`
3. `JEKYLL_ENV=production bundle exec jekyll build`
4. HTML-Proofer on `_site` with external links disabled (via `scripts/run-htmlproofer.sh`)

To also upload Percy visual snapshots (needs Node.js and a Percy token):

```bash
PERCY_TOKEN=your_token scripts/local-check.sh --percy
```

To check external links too, which is what the weekly scheduled job does:

```bash
JEKYLL_ENV=production bundle exec jekyll build
scripts/run-htmlproofer.sh ./_site
```

Sites that block automated checkers (LinkedIn, Medium and others) are on the ignore list in `scripts/run-htmlproofer.sh`.

## CI and deployment

- **[Build and deploy](.github/workflows/build.yml)** runs on pull requests and on pushes to `main`. It builds the site, runs HTML-Proofer, takes Percy snapshots when site files have changed, and deploys to GitHub Pages from `main`. Percy snapshots count against a monthly quota, so they are skipped, with a `snapshot-skipped` status, when only repo files change (`README.md`, `.github/`, `scripts/`, `.mergify.yml` and so on) and when Mergify merges `main` into a PR before merging it. Pushes to `main` always take snapshots so Percy's baseline stays current. `.percy.yml` leaves the pagination pages out.
- **[Weekly strict link checks](.github/workflows/weekly-link-check.yml)** runs every Monday at 02:00 UTC. It runs HTML-Proofer with external links enabled.
- **Dependabot** opens weekly PRs for gems and GitHub Actions.
- **Mergify** squash-merges a PR once it is approved or has the `queue` label, and `build`, `test` and Percy (or `snapshot-skipped`) pass. Dependabot PRs are queued automatically. Add the `do-not-merge` label to hold a PR back.
