CONFIG_FILE="${DUMP_TXT_CONFIG_FILE:-/usr/local/etc/dump.cfg}"
if [[ -f $CONFIG_FILE ]]; then
  source $CONFIG_FILE
else
  echo "Missing configuration: $CONFIG_FILE" >&2
  return 1
fi

_dump() {
  local cur contexts
  cur="${COMP_WORDS[COMP_CWORD]}"
  
  contexts=()
  while IFS= read -r context; do
    contexts+=("$context")
  done < <(grep -o "@[^[:space:]]*" "$DUMP_FILE" 2>/dev/null | sort -u)

  COMPREPLY=( $(compgen -W "$contexts" -- "$cur") )
}
complete -F _dump dump.sh