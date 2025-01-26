#compdef dump

_dump() {
  local cur contexts dump_file

  cur="${words[CURRENT]}"

  # TODO config could be somewhere else
  if [[ -f /usr/local/etc/dump.cfg ]]; then
      source /usr/local/etc/dump.cfg
  else
      print "Konfigurationsdatei nicht gefunden: /usr/local/etc/dump.cfg" >&2
      return 1
  fi

  contexts=($(grep -o "@[a-zA-Z0-9_]*" "$DUMP_FILE" 2>/dev/null | sort | uniq))
  _describe 'contexts' contexts
}
