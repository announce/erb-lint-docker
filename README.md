# erb-lint-docker

[![Build Status](https://travis-ci.org/announce/erb-lint-docker.svg?branch=master)](https://travis-ci.org/announce/erb-lint-docker)

A docker image for https://github.com/Shopify/erb-lint

### Usage

 ```bash
 docker run --rm -ti -v "$(pwd):/workdir" announced/erb-lint --config .erb-lint.yml __PATH_TO__/*.html.erb
 ```
