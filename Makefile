INSTALL_DIR ?= /usr/local/bin
CONFIG_DIR ?= /usr/local/etc
ZSH_COMPLETION_DIR ?= /usr/local/share/zsh/site-functions

install:
	@echo "install dump script..."
	install -m 755 dump.sh $(INSTALL_DIR)/dump
	@echo "install zsh completion..."
	@mkdir -p $(ZSH_COMPLETION_DIR)
	install -m 644 zsh-completion.sh $(ZSH_COMPLETION_DIR)/_dump
	@echo "install configuration..."
	install -m 644 dump.cfg $(CONFIG_DIR)/dump.cfg
	@echo "installation finished."

uninstall:
	@echo "remove mind-dump Skript..."
	rm -f $(INSTALL_DIR)/dump
	@echo "remove bash completion..."
	rm -f $(ZSH_COMPLETION_DIR)/_dump
	@echo "remove configuration..."
	rm -f $(CONFIG_DIR)/dump.cfg
	@echo "de-installation finished."