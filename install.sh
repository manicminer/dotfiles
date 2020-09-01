#!/bin/bash

DIR="$(cd "$(dirname "$0")" && pwd)"

if [[ "$(ln --version 2>&1)" =~ "GNU" ]]; then
  LN_FLAGS="-sfnv"
else
  LN_FLAGS="-sfhv"
fi

out() {
  echo $'\e[0;34m===> '"${*}"$'\e[0m'
}

relative() {
  src=$1
  target=$2

  common_part="${src}"
  back=
  while [ "${target#$common_part}" = "${target}" ]; do
    common_part="$(dirname "${common_part}")"
    back=../"${back}"
  done

  echo "${back}${target#$common_part/}"
}

do_repo() {
  out Setting up ${2##*/}
  git_args="-c advice.detachedHead=false"
  if [ -d "${HOME}/${1}" ]; then
    if [ -d "${HOME}/${1}/.git" ]; then
      cd "${HOME}/${1}"
      git fetch
      [ -n "${3}" ] && git ${git_args} checkout "${3}"
      git branch | grep -q '^* (no branch)' || git pull
    fi
  else
    [ -n "${3}" ] && git_args="${git_args} --branch ${3}"
    git clone "${2}" "${HOME}/${1}" ${git_args}
  fi
}

get_file() {
  out Downloading ${1} to ${HOME}/${2}
  if which curl 2>/dev/null 1>/dev/null; then
    curl -o "${HOME}/${2}" "${1}"
  elif which wget 2>/dev/null 1>/dev/null; then
    wget -O "${HOME}/${2}" "${1}"
  else
    echo Unable to find curl or wget >&2
    exit 1
  fi
}

mkdir -pv "${HOME}/.azure"
mkdir -pv "${HOME}/.gnupg"
chmod 0700 "${HOME}/.gnupg"
mkdir -pv "${HOME}/.pyenv" && chmod 0755 "${HOME}/.pyenv"
mkdir -pv "${HOME}/.ssh" && chmod 0700 "${HOME}/.ssh"
chmod -v 0640 "${DIR}/ssh"/*
mkdir -pv "${HOME}/.vim"/{autoload,colors}
mkdir -pv "${HOME}/.zsh/completions"
mkdir -pv "${HOME}/bin" && chmod 0755 "${HOME}/bin"

#do_repo .asdf https://github.com/asdf-vm/asdf v0.5.0
#do_repo .authorize-aws https://github.com/manicminer/authorize-aws
#do_repo .base16-shell https://github.com/chriskempson/base16-shell
do_repo .goenv https://github.com/syndbg/goenv
do_repo .liquidprompt https://github.com/manicminer/liquidprompt
do_repo .pyenv https://github.com/yyuu/pyenv
do_repo .pyenv/plugins/pyenv-virtualenv https://github.com/yyuu/pyenv-virtualenv
#do_repo .rbenv https://github.com/rbenv/rbenv && mkdir -pv "${HOME}/.rbenv/plugins"
#do_repo .rbenv/plugins/ruby-build https://github.com/rbenv/ruby-build
do_repo .tfenv https://github.com/kamatama41/tfenv
do_repo .zsh/zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions
get_file https://raw.githubusercontent.com/Azure/azure-cli/dev/az.completion .az.completion

[ -e "${HOME}/bin/authorize-aws" ] || ln ${LN_FLAGS} "../.authorize-aws/authorize-aws" "${HOME}/bin/authorize-aws"

DOTFILES="aliases bash-completions bashrc colordiffrc curlrc-local env functions gitconfig gitignore_global ideavimrc iterm2_shell_integration.zsh liquidpromptrc my.cnf ssh/authorized_keys ssh/config ssh/rc tmux.conf vim/autoload/plug.vim vim/colors/base16*.vim vimrc zshrc"

out Linking dotfiles
echo -n $'\e[0;92m'
for D in $DOTFILES; do
  ln ${LN_FLAGS} "$(relative "$(dirname "${HOME}/.${D}")" "${DIR}/${D}")" "${HOME}/.${D}"
done
echo -n $'\e[0m'

if [[ "${PLATFORM}" == "MacOS" ]]; then
  for D in gnupg/gpg.conf gnupg/gpg-agent.conf; do
    ln ${LN_FLAGS} "$(relative "$(dirname "${HOME}/.${D}")" "${DIR}/${D}")" "${HOME}/.${D}"
  done
fi

out Linking zsh completions
echo -n $'\e[0;92m'

find "${DIR}/zsh/completions" -type f | while read C; do
  ln ${LN_FLAGS} "$(relative "${HOME}/.zsh/completions" "${C}")" "${HOME}/.zsh/completions/$(basename "${C}")"
done
echo -n $'\e[0m'

out Creating SSH directories
mkdir -pv "${HOME}/.ssh/"{config.d,controlmasters}

out Linking binfiles
echo -n $'\e[0;92m'
find "${DIR}/bin" -type f -not -path '*/\.*' | while read C; do
  ln ${LN_FLAGS} "$(relative "${HOME}/bin" "${C}")" "${HOME}/bin/$(basename "${C}")"
done
echo -n $'\e[0m'
exit

vim +PlugInstall +PlugUpdate +qall

# vim: set ts=2 sts=2 sw=2 et:
