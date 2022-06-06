# discord-debian-patched
A patched version of Discord that uses `libayatana-appindicator3-1` instead of `libappindicator1`.

## Why
Debian does not ship `libappindicator1` anymore so the purpose of this is to replace it with `libayatana-appindicator3-1` which is compatible.

## Install
Copy paste these commands:
```sh
git clone https://github.com/saenai255/discord-debian-patched
cd discord-debian-patched/
make
make install
```

## Uninstall
Copy paste these commands:
```sh
cd path/to/discord-debian-patched/
make uninstall
```
**or**
```
rm -rf path/to/discord-debian-patched/
sudo apt remove discord
```