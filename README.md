# daveshepherd.uk

To work with this project within docker run:

```
docker run -it -v $(pwd):/usr/src -p 4000:4000 ruby:3 /bin/bash
```

```
bundle install
bundle exec jekyll serve --host 0.0.0.0
```

Navigate to 127.0.0.1:4000

## Local confidence checks

Run a local quality gate before pushing changes:

```bash
scripts/local-check.sh
```

This runs:
- `bundle install`
- `bundle exec jekyll doctor`
- `JEKYLL_ENV=production bundle exec jekyll build`
- `bundle exec htmlproofer ./_site --disable-external`

To run Percy snapshots locally as well:

```bash
PERCY_TOKEN=your_token scripts/local-check.sh --percy
```