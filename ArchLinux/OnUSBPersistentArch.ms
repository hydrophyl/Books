.de BL
.IP \(bu 2
..

.TL
Install Arch Linux on USB Stick with persistent storage
.AU
Duy Nguyen
.AB
Smatest way to live is always learning.
.AE

.SH
You needs
.IP
A USB: min 8GB-...500GB formatted in FAT32/NTFS (not ExtF or Ext4)
.IP
A USB: min 2GB with Arch Linux installed
(with Rufus or LiveLinux)
.IP
A Ethernet/ Wifi connection
.SH
Main process (als Stichworte)
.PP
Boot in Arch on Arch installed USB

.BL
wifi-menu 			//connect to WiFi
.BL
lsblk				//list the disks , find the USB drive (sdc/sdb..)
.BL
cfdisk /dev/sdc		//Format disk
.RS
.IP
> Delete partition
.IP
> Create new partions
.IP
> sdc1 = 500M -> 2G (bootable)
.IP
> sdc2 = Rest (128G-20G)
.IP
> Write disk
.RE
.BL
mkfs.ext4 /dev/sdc1 && mkfs.ext4 /dev/sdc2
.BL
lsblk	 				//Check disks
.BL
mount /dev/sdc2 /mnt		//MOUNT sdc2 to /mnt (Mount drive to work on)
.BL
mkdir /mnt/boot
.BL
mount /dev/sdc1 /mnt/boot
.BL
pacstrap /mnt base base-devel vim
.IP
// Install base applications to /mnt bzw. our sdc2 (USB Drive to initiate new system)
.IP
// Any apps can installed here (vim, NetworkManager, sudo, grub)
.BL
genfstab -U -p /mnt >> /mnt/etc/fstab
.BL
cat /mnt/etc/fstab
.BL
arch-chroot /mnt
.BL
nano(or vim) /etc/pacman.d/mirrorlist
.IP
// Ctrl K to cut
.IP
// Ctrl U to paste
.IP
// Take the "Germany" links on top
.BL
ln -sf /usr/share/zoneinfo/Iceland /etc/localtime  	//(or zoneinfo/Europe/Berlin)
.BL
hwclock --systohc --> hwclock 			// to check the time
.BL
nano /etc/locale.gen
.IP
// Uncomment this line "EN_US.UTF-8 UTF-8"
.BL
locale-gen							// to generate the Keys
.BL
nano /etc/mkinitcpio.conf
.IP
// Change this line to
.IP
HOOKS=(base udev block autodetect modconf filesystems keyboard fsck)
.BL
mkinitcpio -p linux
.BL
nano /etc/pacman.conf
.IP
// Uncomment these lines
.RS
.IP
[multilib]
.IP
Include = /etc/pacman.d/mirrorlist
.RE
.BL
pacman -Sy
.BL
passwd								//type in password for root users
.BL
nano /etc/hostname					//"archer" - Name of root user
.BL
Create a new user:
.RS
.IP
useradd -m -g users -G wheel,storage,power -s /bin/bash shiki
.IP
passwd shiki							//set password for "shiki"
.BL
pacman -S sudo (if not installed)
.BL
nano /etc/sudoers
.IP
// Uncomment these lines to allow members of group WHEEL to execute any commands
.IP
%wheel ALL = (ALL)ALL
.BL
pacman -S grub (if not installed)
.BL
grub-install --boot-directory=/boot --recheck --debug --target=i386-pc /dev/sdc
.IP
// no Errors -> Good to go
.BL
grub-mkconfig -o /boot/grub/grub.cfg
.BL
pacman -S networkmanager (if not installed)
.BL
exit to root
.BL
umount -R /mnt
.BL
lslbk to double check
.BL
NOTE: muss install when no cable zu Verfugung gestellt.
.RS
.IP
pacman -S dialog **before umount**
.IP
systemctl disable NetworkManager (if enabled) here isn't
.IP
systemctl enable dhcpcd
.IP
systemctl enable netctl-auto@wlp2s0.service
.IP
// wlp2s0/wlp4s0 is from Laptop/Computer Hardware
.IP
// Check WLAN-Adapter bei typing "ip link"
.RE
.BL
Unmount everything and reboot to USB -> "exit" then "umount -R /mnt"

.NH
After fresh install Arch
.BL
Boot in -> login with accounts
.RS
.IP
root -> passwd of root (zB. "root" :)
shiki -> passwd of shiki
.RE
.BL
sudo su 							//to execute administrator commands
.BL
wifi-menu 							//to connect with Wifi
.BL
Install LARBS (credit of Luke Smith)
.RS
.IP
curl -LO larbs.xyz/larbs.sh
.IP
bash larbs.sh
.RE
.BL
After that, ...
.BL
disable dhcpcd, netctl-auto (just the upper command lines "enable" -> "disable")
.BL
enable NetworkManager *systemctl enable NetworkManager

.SH
REBOOT in to USB -> LOGIN -> "startx"

.SH
Done with fresh install Arch!



.SH
p/s: When you in troubles sich befindest, bitte nimm Kontakt mit mir auf duynguyenhnde@outlook.com
