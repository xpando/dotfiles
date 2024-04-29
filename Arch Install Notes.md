## Remote Isntallation

Once the Arch installation ISO is booted installation can be done from another machine connected via SSH for easier copy paste and SCP of any keys etc.

```shell
# SSH required password so set a root password for the isntallation session
passwd

# Get IP address to use with SSH/SCP from another machine
ip a
```
## Disk Partitioning and File Systems

KVM/QEMU Example (for physical system the disk device names should be changed):

```shell
# Virtual machine
DISK=/dev/vda
EFI_PART=/dev/vda1
BTRFS_PART=/dev/vda2
SWAP_SIZE=2g
MOUNTOPTS=noatime,space_cache=v2,compress=zstd:3,discard=async

# My Desktop (CorsairOne)
DISK=/dev/nvme0n1
EFI_PART=/dev/nvme0n1p1
BTRFS_PART=/dev/nvme0n1p2
SWAP_SIZE=4g
MOUNTOPTS=noatime,ssd,space_cache=v2,compress=zstd:3,discard=async

# My Desktop (BeeLink)
DISK=/dev/nvme0n1
EFI_PART=/dev/nvme0n1p1
BTRFS_PART=/dev/nvme0n1p2
SWAP_SIZE=4g
MOUNTOPTS=noatime,ssd,space_cache=v2,compress=zstd:3,discard=async

# Partition system installation disk
parted -s $DISK \
  mklabel gpt \
  mkpart EFI fat32 2MiB 514MiB \
  set 1 esp on \
  mkpart BTRFS btrfs 514MiB 100% \
  align-check opt 1 \
  align-check opt 2 \
  print

# Create filesystems
mkfs.fat -F32 -n EFI $EFI_PART
mkfs.btrfs -f -L BTRFS $BTRFS_PART
lsblk -o NAME,FSTYPE,PARTUUID,PARTLABEL,LABEL,MOUNTPOINT,FSTYPE,FSUSE%

# Create BTRFS volumes:
# Mount the BTRFS partition and create subvolumes
mount $BTRFS_PART /mnt
btrfs subvolume create /mnt/{@,@var,@home,@swap}
umount /mnt
```

Mount BTRFS volumes to prepare file system structure for installation:
```shell
# Mount the root volume
mount -o "$MOUNTOPTS,subvol=@" $BTRFS_PART /mnt

# Create dirs in the root volume that we will mount the rest of the volumes to
mkdir -p /mnt/{boot,var,home,swap}

mount -o "$MOUNTOPTS,subvol=@var" $BTRFS_PART /mnt/var
mount -o "$MOUNTOPTS,subvol=@home" $BTRFS_PART /mnt/home
mount -o "$MOUNTOPTS,subvol=@swap" $BTRFS_PART /mnt/swap

# Create a swapfile
btrfs filesystem mkswapfile --size 4g --uuid clear /mnt/swap/swapfile
swapon /mnt/swap/swapfile

# Mount EFI boot partition
mount $EFI_PART /mnt/boot

# TODO: Create directories and mount any other drives/partitions you
# want mounted during boot. Ex:
# mkdir -p /mnt/data
# mount /dev/sda1 /mnt/data
```

Base Installation:
```shell
# Set timezone
timedatectl set-timezone America/Los_Angeles

# Verify that NTP service is enabled
timedatectl

# Rate and use the fastest mirrors
reflector --save /etc/pacman.d/mirrorlist --protocol https --country US --sort rate --age 6 --latest 10

# Update package DB
pacman -Sy

# minimal initial packages. More can be added after chroot for installation 
# specific packages
pkgs=(
  base 
  base-devel 
  linux 
  linux-firmware 
  linux-headers 
  lsb-release 
  amd-ucode 
  btrfs-progs 
  btrfsmaintenance
  pacman-contrib 
  networkmanager 
  openssh 
  rsync 
  acpi 
  acpi_call 
  tlp 
  acpid 
  grub 
  grub-btrfs 
  efibootmgr 
  reflector 
  man 
  vim 
  git 
  zsh
)
pacstrap -K /mnt ${pkgs[@]}

genfstab -U /mnt >> /mnt/etc/fstab

# Enter the newly initialized system for further configuration
arch-chroot /mnt

# Timezone and hardware clock
ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
hwclock --systohc 

# Generate locales
vim /etc/locale.gen # uncomment the desired locales
locale-gen
echo -e "LANG=en_US.UTF-8\nLC_ALL=en_US.UTF-8\n" > /etc/locale.conf
echo -e "KEYMAP=us" > /etc/vconsole.conf

# set host name
echo "beebox" >> /etc/hostname
echo -e "127.0.0.1\tlocalhost\n::1\t\tlocalhost\n127.0.0.1\t$(cat /etc/hostname).local,$(cat /etc/hostname)\n" > /etc/hosts

# Boot loader (GRUB)
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
# My Corsairone BIOS requires the --romovable flag :(
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --removable
grub-mkconfig -o /boot/grub/grub.cfg

# Enable networking
systemctl enable NetworkManager
systemctl enable sshd
systemctl enable tlp
systemctl enable acpid
systemctl enable reflector.timer
systemctl enable fstrim.timer     # For SSDs

# Set root password
passwd

# Create user
groupadd docker
useradd -mg users -G wheel,docker -s /usr/bin/zsh david

# Set user full name (optional)
usermod -c 'David Findley' david

# Set user's password
passwd david

# Enable sudo
echo "david ALL=(ALL) ALL" > /etc/sudoers.d/david

# or uncomment wheel group in main conf with
visudo

exit
swapoff /mnt/swap/swapfile

umount -R /mnt
reboot
```

```shell
# AUR Helpers
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# Paru, AUR helper like Yay but written in Rust
yay -S paru-bin

# Additional commonly installed packages

# CLI
pkgs=(
  atuin
  bandwhich
  bat
  ctop
  direnv
  dmidecode
  docker
  dog
  duf
  dust
  eza
  fasd
  fd
  fzf
  git-delta
  go-swagger
  gum
  htop
  hwinfo
  inxi
  jless
  jq
  just
  lazygit
  less
  lnav
  lua
  mise-bin
  neofetch
  neovim
  nvtop
  onefetch
  ripgrep
  starship
  stow
  tmux
  tokei
  unarchiver
  unzip
  zellij
  zip
  zoxide
)
paru -S --needed ${pkgs[@]}

# Audio
pkgs=(
  alsa-utils
  pipewire
  wireplumber
)
paru -S --needed ${pkgs[@]}

# Video drivers/utils
# Uncomment [multilib] in /etc/pacman.conf for 32bit libs
# needed for Steam games

# AMD GPU
pkgs=(
  mesa
  xf86-video-amdgpu
  vulkan-radeon
  libva-mesa-driver
  lib32-libva-mesa-driver
  lib32-vulkan-radeon
)
paru -S --needed ${pkgs[@]}

# NVIDIA GPU
pkgs=(
  mesa
  nvidia-dkms
  nvidia-settings
  nvidia-utils
  lib32-nvidia-utils
)
paru -S --needed ${pkgs[@]}

# DE - Gnome
pkgs=(
  xorg-server
  xorg-xinit
  gdm
  gnome
  folderpreview
  webp-pixbuf-loader
)
paru -S --needed ${pkgs[@]}

# Fonts
pkgs=(
  ttf-iosevka
  ttf-iosevka-nerd
  ttf-iosevkaterm-nerd
)
paru -S --needed ${pkgs[@]}

# GUI Apps
pkgs=(
  1password
  1password-cli
  alacritty
  brave-bin
  discord
  firefox
  jetbrains-toolbox
  neovide
  steam
  vlc
)
paru -S --needed ${pkgs[@]}

# Virtualization host QEMU/KVM
pkgs=(
  dnsmasq
  libvirt
  qemu-full
  virt-manager
)
paru -S --needed ${pkgs[@]}
```

## NVIDIA Setup 

Install drivers

```shell
sudo pacman -S --needed nvidia nvidia-settings nvidia-utils lib32-nvidia-utils
```

Based on: https://github.com/korvahannu/arch-nvidia-drivers-installation-guide

```shell
# Add kernal parameters to GRUB
sudo vim /etc/default/grub

# Append nvidia-drm.modeset=1 to GRUB_CMDLINE_LINUX_DEFAULT

sudo vim /etc/mkinitcpio.conf

# MODULES=(nvidia nvidia_uvm nvidia_drm)
# Remove the word "kms" from HOOKS()

sudo mkinitcpio -p linux
```

Auto build a new boot image with NVIDIA kernel modules when either the Linux kernel is updated or the NVIDIA drivers are updated. 

```shell
sudo vim /etc/pacman.d/hooks/nvidia.hook
```

Add this content:
```
[Trigger]
Operation=Install
Operation=Upgrade
Operation=Remove
Type=Package
Target=nvidia
Target=linux

# Adjust line(6) above to match your driver, e.g. Target=nvidia-dkms
# Change line(7) above, if you are not using the regular kernel For example, Target=linux-lts

[Action]
Description=Update Nvidia module in initcpio
Depends=mkinitcpio
When=PostTransaction
NeedsTargets
Exec=/bin/sh -c 'while read -r trg; do case $trg in linux) exit 0; esac; done; /usr/bin/mkinitcpio -P'
```

```
cat /etc/modprobe.d/nvidia.conf

blacklist nouveau
options nvidia_drm modeset=1 fbdev=1 NVreg_PreserveVideoMemoryAllocations=1
```

## Timeshift and Timeshift-Autosnap
```shell
paru -S timeshift-bin timeshift-autosnap
timeshift --list-devices
timeshift --snapshot-device /dev/vda2
```

## Tips

List Disks
```shell
lsblk -o NAME,FSTYPE,PARTUUID,PARTLABEL,LABEL,MOUNTPOINT,FSTYPE,FSUSE%
```

Find the UUID of a partition:
```
# Get uuid of partition
blkid -s UUID -o value /dev/vda2
```

Connect to WiFi using network manager text UI
```shell
nmtui
```

Enable Parallel Package Downloads
```shell
# uncomment ParallelDownloads = 5 line in pacman.conf
sudo vim /etc/pacman.conf
```

Better TTY Fonts
```shell
paru -S powerline-fonts-git
sudo vim /etc/vconsole.conf

# Add this line:
FONT=ter-powerline-v20n
```

Gnome Files Thumbnails
```shell
sudo pacman -S --needed tumbler poppler-glib ffmpegthumbnailer freetype2 libgsf raw-thumbnailer totem evince
```

Wayland w/NVIDIA
```shell
sudo pacman -S --needed xorg-xwayland xorg-xlsclients glfw-wayland
```

