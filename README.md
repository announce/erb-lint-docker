# erb-lint-docker

[![Build Status](https://travis-ci.org/announce/erb-lint-docker.svg?branch=master)](https://travis-ci.org/announce/erb-lint-docker)

A docker image for [Shopify/erb-lint](https://github.com/Shopify/erb-lint).
The latest docker image is available at [announced/erb-lint-docker](https://hub.docker.com/r/announced/erb-lint-docker/).

### Usage

 ```bash
docker run --rm -iv "$(pwd):/workdir" announced/erb-lint --config .erb-lint.yml __PATH_TO__/*.html.erb
 ```
