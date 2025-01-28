# dump.txt-cli

Inspired by todo.txt and motivated by the need of place to just dump some thoughts to have a free mind.

## Install

Currently only UNIX-based system supported.
Also, zsh is currently assumed, although there would be a completion script for a conventional bash... sorry.

```sh
(sudo) make install
```

### Uninstall

```sh
(sudo) make uninstall
```

### Custom configuration file location

```sh
(sudo) make install CONFIG_FILE="$HOME/.dump.cfg"
(sudo) make uninstall CONFIG_FILE="$HOME/.dump.cfg"
```

## Configure

Change value(s) in /usr/local/etc/dump.cfg or custom config file location.

## Usage

```sh
dump add "whatever comes to my mind about @context and @another_context"
```

```sh
dump ls (@context|<search-term>)
```

_Caution: no extra confirmation on delete..._

```sh
dump del 1
```
