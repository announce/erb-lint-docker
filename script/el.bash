#!/usr/bin/env bash

function el () {
  set -u
  readonly TAG="announced/erb-lint:v0.0.24"

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
    docker run --rm -i hadolint/hadolint < Dockerfile
  }

  lint-shell () {
    docker run --rm -v "$PWD:/mnt" koalaman/shellcheck:stable script/*.bash
  }

  build () {
    docker build -t "${TAG}" .
  }

  run () {
    docker run --rm -i "${TAG}" --version
  }

  release () {
    lint \
    && build \
    && docker push "${TAG}"
  }

  clean () {
    docker system prune
  }

  usage () {
    SELF="$(basename "$0")"
    echo -e "${SELF} -- elb-lint-docker
    \nUsage: ${SELF} [arguments]
    \nArguments:"
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
