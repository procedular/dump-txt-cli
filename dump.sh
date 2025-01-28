#!/bin/bash

CONFIG_FILE="${DUMP_TXT_CONFIG_FILE:-/usr/local/etc/dump.cfg}"
if [[ -f $CONFIG_FILE ]]; then
  source $CONFIG_FILE
else
  echo "Missing configuration: $CONFIG_FILE" >&2
  return 1
fi

function add() {
  local thought="$1"
  echo "$thought" >> "$DUMP_FILE"
  echo "Dumped: $thought"
}

function list() {
  local search_term="$1"
  if [[ -f "$DUMP_FILE" ]]; then
    local line_number=1
    while IFS= read -r line; do
      if [[ -z "$search_term" || "$line" == *"$search_term"* ]]; then
        highlighted_line=$(echo "$line" | sed -E 's/(@[a-zA-Z0-9_]+)/\x1b[1m\1\x1b[0m/g')
        printf "%3d %s\n" "$line_number" "$highlighted_line"
      fi
      ((line_number++))
    done < "$DUMP_FILE"
  else
    echo "$DUMP_FILE not found." >&2
  fi
}

function delete() {
  local line_number="$1"
  if [[ -z "$line_number" || ! "$line_number" =~ ^[0-9]+$ ]]; then
    echo "invalid row index ($line_number)." >&2
    return 1
  fi

  if [[ -f "$DUMP_FILE" ]]; then
    local total_lines
    total_lines=$(wc -l < "$DUMP_FILE")

    if (( line_number < 1 || line_number > total_lines )); then
      echo "row index ($line_number) out of bounds (1-$total_lines)." >&2
      return 1
    fi

    sed -i "${line_number}d" "$DUMP_FILE"
    echo "row #$line_number deleted."
  else
    echo "$DUMP_FILE not found." >&2
  fi
}

case "$1" in
  add)
    shift
    add "$@"
    ;;
  ls)
    shift
    list "$@"
    ;;
  del)
    shift
    delete "$@"
    ;;
  *)
    echo "Usage: dump.sh {ls|add|del}"
    ;;
esac
