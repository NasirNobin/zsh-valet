# zsh-valet
#
# @author: NasirNobin
# @url https://github.com/NasirNobin/zsh-valet
# @url https://github.com/seanyeh/autosrc

valetphprc_run() {
    if [ "$VALETPHPRC_IGNORE" -eq 1 ]; then
        return
    fi

    local cur_pwd="$(pwd)"

    # If same dir, exit
    if [ "$OLDPWD" = "$cur_pwd" ]; then
        return
    fi

    # Get the PHP version for the previous directory
    if [ -n "$OLDPWD" ]; then
        prev_php_version=$(valet which-php "$OLDPWD" | sed 's/.*php@\([0-9]*\.[0-9]*\).*/\1/')
    fi

    # Get the PHP version for the current directory
    cur_php_version=$(valet which-php "$cur_pwd" | sed 's/.*php@\([0-9]*\.[0-9]*\).*/\1/')

    # If same PHP version, return
    if [ "$prev_php_version" = "$cur_php_version" ]; then
        return
    fi

    # Change PHP path for the current directory
    valetphprc_change_php "$cur_php_version"
}

valetphprc_change_php () {
    PHP_VERSION="${1:-$VALETPHPRC_DEFAULT_PHP}"
    PHP_VERSION_BIN_PATH="/opt/homebrew/opt/php@$PHP_VERSION/bin"
    if [ -d "$PHP_VERSION_BIN_PATH" ]; then
        PATH=$(echo $PATH | sed "s,/opt/homebrew/opt/php@.\../bin,$PHP_VERSION_BIN_PATH,g")

        if [[ "$PATH" != *"$PHP_VERSION"* ]]; then
            PATH="$PHP_VERSION_BIN_PATH:$PATH"
        fi

        if [ "$VALETPHPRC_SHOW_PHP_VERSION_CHANGE" -eq 1 ]; then
            echo "Using $(php -v | grep -m1 "PHP")"
        fi

        export VIRTUAL_ENV="php@${PHP_VERSION}"
        export PATH
    else
        unset VIRTUAL_ENV
    fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd valetphprc_run

# Change PHP path for the current directory on startup as well
cur_php_version=$(valet which-php "$(pwd)" | sed 's/.*php@\([0-9]*\.[0-9]*\).*/\1/')
valetphprc_change_php "$cur_php_version"