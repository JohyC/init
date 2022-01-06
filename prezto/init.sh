#!/usr/bin/env bash

set -e

BACKUP_TIMESTAMP=$(date "+%Y%m%d%H%M%S")
PREZTO_REPO='https://github.com/sorin-ionescu/prezto.git'
ZPREZTORC_URL='https://www.skydreve.cf:3000/Johy/init/raw/branch/master/prezto/zpreztorc'
ZSHRC_URL='https://www.skydreve.cf:3000/Johy/init/raw/branch/master/prezto/zshrc'
ZSHENV_URL='https://www.skydreve.cf:3000/Johy/init/raw/branch/master/prezto/.zshenv'

COMPLETION_PRLCTL='https://raw.githubusercontent.com/zchee/zsh-completions/main/src/zsh/_prlctl'
COMPLETION_PRLSRVCTL='https://raw.githubusercontent.com/zchee/zsh-completions/main/src/zsh/_prlsrvctl'

function pre_check(){
    if ! command -v zsh >/dev/null 2>&1; then
        err "zsh is not installed, please install zsh before init."
        exit 1
    fi
}

function change_default_shell(){
    info "change default shell to zsh..."
    chsh -s $(grep /zsh$ /etc/shells | tail -1)
}

function install_prezto(){
    info "install prezto..."
    if [ ! -f "$HOME/.zshenv" ]; then
	    curl ${ZSHENV_URL} > $HOME/.zshenv
    fi
    source $HOME/.zshenv
    zdot_home="${ZDOTDIR:-$HOME}/.zprezto"
    if [[ -d "${zdot_home}" ]]; then
        warn "backup [${zdot_home}] to [${zdot_home}-${BACKUP_TIMESTAMP}]"
        mv "${zdot_home}" "${zdot_home}-${BACKUP_TIMESTAMP}"
    fi

    git clone --recursive ${PREZTO_REPO} "${zdot_home}" 

    info "swicth zsh-history-substring-search to master branch..."
    (cd ${zdot_home}/modules/history-substring-search/external && git checkout master)

    info "link config..."
    for rcfile in $(ls ${ZDOTDIR:-$HOME}/.zprezto/runcoms/* | xargs -n 1 basename | grep -v README); do
        target="${ZDOTDIR:-$HOME}/.${rcfile:t}"
        ln -s "${ZDOTDIR:-$HOME}/.zprezto/runcoms/${rcfile}" "${target}"
    done
    echo "install_home: $ZDOTDIR"
    echo ".zprezto: $zdot_home"
}

function install_cutom_config(){
    info "install cutom config..."
    curl -sSL ${ZPREZTORC_URL} > "${ZDOTDIR:-$HOME}/.zpreztorc"
    curl -sSL ${ZSHRC_URL} > "${ZDOTDIR:-$HOME}/.zshrc"
    curl -sSL ${COMPLETION_PRLCTL} > "${ZDOTDIR:-$HOME}/.zprezto/modules/completion/external/src/_prlctl"
    curl -sSL ${COMPLETION_PRLSRVCTL} > "${ZDOTDIR:-$HOME}/.zprezto/modules/completion/external/src/_prlsrvctl"
}

function info(){
    echo -e "\033[32mINFO: $@\033[0m"
}

function warn(){
    echo -e "\033[33mWARN: $@\033[0m"
}

function err(){
    echo -e "\033[31mERROR: $@\033[0m"
}

pre_check
change_default_shell
install_prezto
install_cutom_config
