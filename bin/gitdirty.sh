#!/bin/bash

if [ "${#}" = "0" ]; then
  echo "usage: ${0} [PATHS]" >&2
  echo >&2
  echo "Look for dirty git worktrees in named paths and show any modified or untracked files"
  echo >&2
fi

for dir in "${@}"; do
  stat=$(cd "${dir}" && git -c color.status=always status -s 2>/dev/null)
  if [ -n "${stat}" ]; then
    echo $'\e[1m'"${dir}"$'\e[0m'":"
    while read line; do echo "  ${line}"; done <<<"${stat}"
  fi
done
