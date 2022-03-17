# homebrew-instant-php-version-swap.zsh
#
# @author: NasirNobin
# @url https://gist.github.com/NasirNobin/3e5992608df21389dded1ac1661e1c7c
# @url https://github.com/seanyeh/autosrc

VALETPHPRC=".valetphprc"

valetphprc_find(){
    local curpath="$1"

    while [ "$curpath" != "/" ]; do
        local temp_file="$curpath/$VALETPHPRC"
        if [ -r "$temp_file" ]; then
            valetphprc_file="$temp_file"
            return 0
        fi

        curpath=$(dirname "$curpath")
    done

    return 1
}

valetphprc_run() {
    if [ "$VALETPHPRC_IGNORE" -eq 1 ]; then
        return
    fi

    local cur_pwd="$(pwd)"

    # If same dir, exit
    if [ "$OLDPWD" = "$cur_pwd" ]; then
        return
    fi

    valetphprc_find "$OLDPWD" && local prev_valetphprc="$valetphprc_file"
    valetphprc_find "$cur_pwd" && local cur_valetphprc="$valetphprc_file"

    # If same valetphprc, return
    if [ "$prev_valetphprc" = "$cur_valetphprc" ]; then
        return
    fi

    # change php path for default .valetphprc
    if [ -n "$prev_valetphprc" ] && [ -n $VALETPHPRC_DEFAULT_PHP ]; then
        valetphprc_change_php $VALETPHPRC_DEFAULT_PHP
    fi

    # change php path for current .valetphprc
    if [ -n "$cur_valetphprc" ]; then
        valetphprc_change_php $(cat $cur_valetphprc)
    fi
}

valetphprc_change_php () {
    PHP_VERSION="${1:-$VALETPHPRC_DEFAULT_PHP}"
    PHP_VERSION=$(echo $PHP_VERSION | sed "s,php,," | sed "s,@,,")
    PHP_VERSION_BIN_PATH="/opt/homebrew/opt/php@$PHP_VERSION/bin"
    if [ -d "$PHP_VERSION_BIN_PATH" ]; then
        export PATH=$(echo $PATH | sed "s,/opt/homebrew/opt/php@.\../bin,$PHP_VERSION_BIN_PATH,g")
        
        if [[ "$PATH" != *"$PHP_VERSION"* ]]; then
            export PATH="$PHP_VERSION_BIN_PATH:$PATH"
        fi

        if [ "$VALETPHPRC_DO_NOT_SHOW_PHP_VERSION" -ne 1 ]; then
            echo "Using $(php -v | grep -m1 "PHP")"
        fi
    fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd valetphprc_run

# change php path for current .valetphprc startup as well
valetphprc_find "$(pwd)" && valetphprc_change_php $(cat $valetphprc_file)