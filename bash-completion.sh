CONFIG_DIR="/usr/local/etc"
if [[ -f $CONFIG_DIR/dump.cfg ]]; then
    source $CONFIG_DIR/dump.cfg
else
    echo "Missing condiguration: $CONFIG_DIR/dump.cfg" >&2
    return 1
fi

_dump() {
    local cur contexts
    cur="${COMP_WORDS[COMP_CWORD]}"
    contexts=$(grep -o "@[a-zA-Z0-9_]*" "$DUMP_FILE" 2>/dev/null | sort | uniq)
    COMPREPLY=( $(compgen -W "$contexts" -- "$cur") )
}
complete -F _dump dump.sh