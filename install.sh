#!/bin/bash

echo "Iniciando la configuracion..."

# 1. Instalar programas base (ZSH, Alacritty, Neovim, utilidades)
echo "Instalando paquetes base..."
sudo apt update
sudo apt install -y zsh alacritty neovim git curl wget unzip fontconfig

# 2. Dependencias opcionales de Yazi
echo "Instalando dependencias de Yazi..."
sudo apt install -y ffmpeg 7zip jq poppler-utils fd-find ripgrep fzf zoxide imagemagick

# 3. Instalar Yazi (Download official binary release)
echo "Descargando el binario oficial de Yazi..."
wget -qO /tmp/yazi.zip https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip
unzip -q /tmp/yazi.zip -d /tmp/
sudo mv /tmp/yazi-x86_64-unknown-linux-gnu/yazi /usr/local/bin/
sudo mv /tmp/yazi-x86_64-unknown-linux-gnu/ya /usr/local/bin/
rm -rf /tmp/yazi.zip /tmp/yazi-x86_64-unknown-linux-gnu

# 4. Descargar e instalar JetBrains Mono Nerd Font
echo "Instalando JetBrains Mono Nerd Font..."
mkdir -p ~/.local/share/fonts
wget -qO /tmp/JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip -q /tmp/JetBrainsMono.zip -d ~/.local/share/fonts/
fc-cache -fv
rm /tmp/JetBrainsMono.zip

# 5. Instalar Oh My Zsh (Modo desatendido)
echo "Instalando Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 6. Instalar plugins de ZSH
echo "Instalando zsh-autosuggestions y zsh-syntax-highlighting..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# 7. Crear enlaces simbolicos (Symlinks)
echo "Creando enlaces simbolicos..."
mkdir -p ~/.config

# Borramos el .zshrc por defecto que acaba de crear Oh My Zsh
rm -f ~/.zshrc

ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.zshenv ~/.zshenv

ln -sfn ~/dotfiles/.config/alacritty ~/.config/alacritty
ln -sfn ~/dotfiles/.config/nvim ~/.config/nvim
ln -sfn ~/dotfiles/.config/yazi ~/.config/yazi

# Ghostty y DMS: se enlazan archivos sueltos para que los colores que
# genera DMS (themes/dankcolors, settings.json) no terminen en el repo
mkdir -p ~/.config/ghostty/themes ~/.config/DankMaterialShell/themes
ln -sf ~/dotfiles/.config/ghostty/config ~/.config/ghostty/config
ln -sf ~/dotfiles/.config/ghostty/themes/alacritty-fabian ~/.config/ghostty/themes/alacritty-fabian
ln -sf ~/dotfiles/.config/DankMaterialShell/themes/fabian-monokai-indigo.json ~/.config/DankMaterialShell/themes/fabian-monokai-indigo.json

mkdir -p ~/.oh-my-zsh/custom/themes
ln -sf ~/dotfiles/.oh-my-zsh/custom/themes/parrot.zsh-theme ~/.oh-my-zsh/custom/themes/parrot.zsh-theme

# 8. Cambiar la shell por defecto a ZSH
echo "Cambiando la shell por defecto a ZSH..."
chsh -s $(which zsh)

echo "Todo listo. Reinicia tu sesion para aplicar los cambios."
