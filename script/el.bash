#!/usr/bin/env bash

function el () {
  set -u
  readonly VERSION_ERB_LINT="0.0.26"
  readonly TAG_AFFIX="announced/erb-lint"
  readonly TAG_VERSION="${TAG_AFFIX}:v${VERSION_ERB_LINT}"
  readonly TAG_LATEST="${TAG_AFFIX}:latest"

  init () {
    init-dependencies
  }

  init-dependencies () {
    local DEPENDENCIES=(
      "docker"
    )
    for TARGET in "${DEPENDENCIES[@]}"; do
      if [[ ! -x "$(command -v "${TARGET}")" ]]; then
      error "Install ${TARGET}."
    fi
    done
  }

  error () {
    MESSAGE="${1:-'Something went wrong.'}"
    echo "[$(basename "$0")] ERROR: ${MESSAGE}" >&2
    exit 1
  }

  lint () {
    lint-dockerfile \
    && lint-shell
  }

  lint-dockerfile () {
    docker run --rm -i hadolint/hadolint:v1.6.6 < Dockerfile
  }

  lint-shell () {
    docker run --rm -v "$PWD:/mnt" koalaman/shellcheck:v0.5.0 \
      --exclude=SC1090 \
      script/*.bash
  }

  build () {
    docker build \
      -t "${TAG_VERSION}" \
      -t "${TAG_LATEST}" \
      --build-arg VERSION_ERB_LINT="${VERSION_ERB_LINT}" \
      .
  }

  run () {
    docker run --rm -iv "$(pwd):/workdir" "${TAG_VERSION}" --version
  }

  release () {
    lint \
    && build \
    && docker push "${TAG_VERSION}" \
    && docker push "${TAG_LATEST}"
  }

  clean () {
    docker system prune
  }

  usage () {
    SELF="$(basename "$0")"
    echo -e "${SELF} -- elb-lint-docker
    \\nUsage: ${SELF} [arguments]
    \\nArguments:"
    declare -F | awk '{print "\t" $3}' | grep -v "${SELF}"
  }

  if [ $# = 0 ]; then
    usage
  elif [ "$(type -t "$1")" = "function" ]; then
    $1
  else
    usage
    error "Command not found."
  fi
}

el "$@"
