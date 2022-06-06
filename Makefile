all: dist/discord.deb

discord.deb:
	@echo "discord.deb: download"

	@if [ ! -z "${URL}" ]; then \
		echo "Downloading from url: ${URL}"; \
	else \
		echo "URL is required"; exit 1; \
	fi

	@wget "${URL}" -O discord.deb 

	@if [ ! -z "${CHECKSUM}" ]; then \
		echo "Checking checksum matches: ${CHECKSUM}"; \
	else \
		echo "CHECKSUM is required"; \
		exit 1; \
	fi

	@file_checksum="$(sha256sum ./discord.deb | cut -d ' ' -f 1)"
	@if [ "${file_checksum}" = "${CHECKSUM}" ]; then \
		@echo "Checksum OK" \
	else \
		rm discord.deb; \
		echo "Checksum mismatch"; \
		echo "Expected: ${CHECKSUM}"; \
		echo "Actual:   ${file_checksum}"; \
		exit 1; \
	fi
	
	
dist/discord.deb: discord.deb
	@echo "dist/discord.deb"
	@echo "Extracting..."
	@mkdir -p build
	@dpkg -x discord.deb ./build/discord
	@dpkg --control discord.deb
	@mv DEBIAN ./build/discord/DEBIAN
	@echo Patching Discord dependencies
	@sed -i 's/libappindicator1/libayatana-appindicator3-1/g' ./build/discord/DEBIAN/control
	@echo "Building..."
	@mkdir -p dist
	@dpkg -b ./build/discord ./dist/discord.deb
	@echo "Build complete"

install: dist/discord.deb
	@echo "Installing..."
	@sudo apt --fix-broken install ./dist/discord.deb -y

uninstall:
	@echo "Uninstalling..."
	@sudo apt remove discord
	@echo "Uninstall complete"

clean:
	@echo "clean: clean"
	@rm -rf build dist || true
	@rm discord.deb || true