# daveshepherd.uk

To work with this project within docker run:

```
docker run -it -v $(pwd):/usr/src -p 4000:4000 ruby:3.1.3 /bin/bash
```

```
bundler install
bundle exec jekyll serve --host 0.0.0.0
```

Navigate to 127.0.0.1:4000