INSTALL_DIR ?= /usr/local/bin
CONFIG_FILE ?= /usr/local/etc/dump.cfg
ZSH_COMPLETION_DIR ?= /usr/local/share/zsh/site-functions

install:
	@echo "install dump script..."
	mkdir -p "$(INSTALL_DIR)"
	install -m 755 dump.sh $(INSTALL_DIR)/dump
	@echo "install zsh completion..."
	@mkdir -p $(ZSH_COMPLETION_DIR)
	install -m 644 zsh-completion.sh $(ZSH_COMPLETION_DIR)/_dump
	@echo "install configuration..."
	install -m 644 dump.cfg $(CONFIG_FILE)
	@echo "installation finished."

uninstall:
	@echo "remove mind-dump Skript..."
	rm -f $(INSTALL_DIR)/dump
	@echo "remove bash completion..."
	rm -f $(ZSH_COMPLETION_DIR)/_dump
	@echo "remove configuration..."
	rm -f $(CONFIG_FILE)
	@echo "de-installation finished."