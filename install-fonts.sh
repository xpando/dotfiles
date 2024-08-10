FONT_DIR=~/.local/share/fonts

echo "Getting latest Iosevka release..."
curl -s 'https://api.github.com/repos/be5invis/Iosevka/releases/latest' -o /tmp/Iosevka.latest.json
URL=$(jq -r '.assets[] | .browser_download_url | select(test("/PkgTTC-Iosevka-.+\\.zip$"))' /tmp/Iosevka.latest.json)

echo "Downloading Iosevka font from $URL..."
curl -L "$URL" -o /tmp/Iosevka.zip

echo "Installing Iosevka font..."
unzip /tmp/Iosevka.zip '*.ttc' -d "$FONT_DIR" 
fc-cache -f

echo "Cleaning up..."
rm /tmp/Iosevka.latest.json
rm /tmp/Iosevka.zip


echo "Getting latest Nerd Fonts release..."
curl -s 'https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest' -o /tmp/NerdFonts.latest.json
URL=$(jq -r '.assets[] | .browser_download_url | select(test("/NerdFontsSymbolsOnly\\.zip$"))' /tmp/NerdFonts.latest.json)

echo "Downloading NerdFontsSymbolsOnly from $URL..."
curl -L "$URL" -o /tmp/NerdFontsSymbolsOnly.zip

echo "Installing NerdFontsSymbolsOnly..."
unzip -L /tmp/NerdFontsSymbolsOnly.zip '*.ttf' -d "$FONT_DIR"
fc-cache -f

echo "Cleaning up..."
rm /tmp/NerdFonts.latest.json
rm /tmp/NerdFontsSymbolsOnly.zip

echo "Done."
