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
        highlighted_line=$(echo "$line" | sed -E 's/(@[^[:space:]]+)/\x1b[1m\1\x1b[0m/g')
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

    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i "" "${line_number}d" "$DUMP_FILE"
    else
        sed -i "${line_number}d" "$DUMP_FILE"
    fi
    echo "row #$line_number deleted."
  else
    echo "$DUMP_FILE not found." >&2
  fi
}

function to_todo() {
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

    if [[ -z "$TODO_CMD" ]]; then
      echo "missing configuration for TODO_CMD." >&2
      return 1
    fi

    if ! command -v "$TODO_CMD" >/dev/null 2>&1; then
        echo "command '$TODO_CMD' not found. Please check your configuration of TODO_CMD." >&2
        return 1
    fi

    local task_text
    task_text=$(sed -n "${line_number}p" "$DUMP_FILE")

    $TODO_CMD add "$task_text"

    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i "" "${line_number}d" "$DUMP_FILE"
    else
        sed -i "${line_number}d" "$DUMP_FILE"
    fi

    echo "dump #$line_number: '$task_text' has been converted to todo."
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
  todo)
    shift
    to_todo "$@"
    ;;
  *)
    echo "Usage: dump {ls|add|del|todo}"
    ;;
esac
