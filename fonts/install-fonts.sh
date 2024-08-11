set -e

FONT_DIR=~/.local/share/fonts

go run gh-download.go --owner ryanoasis --repo nerd-fonts --asset 'NerdFontsSymbolsOnly\.zip'
unzip '/tmp/NerdFontsSymbolsOnly.zip' '*.ttf' -d "$FONT_DIR"

go run gh-download.go --owner be5invis --repo Iosevka --asset '^PkgTTC-Iosevka-\d+\.\d+\.\d+\.zip$'
unzip '/tmp/PkgTTC-Iosevka-*.zip' '*.ttc' -d "$FONT_DIR"

fc-cache -f
