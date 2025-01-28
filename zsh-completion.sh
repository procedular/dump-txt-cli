#compdef dump

_dump() {
  local cur contexts config_file dump_file

  cur="${words[CURRENT]}"

  config_file="${DUMP_TXT_CONFIG_FILE:-/usr/local/etc/dump.cfg}"
  if [[ -f $config_file ]]; then
    source $config_file
  else
    echo "Missing configuration: $config_file" >&2
    return 1
  fi

  contexts=($(grep -o "@[a-zA-Z0-9_]*" "$DUMP_FILE" 2>/dev/null | sort | uniq))
  _describe 'contexts' contexts
}
