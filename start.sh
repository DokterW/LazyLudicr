#!/bin/bash
# LazyLudicr v0.1
# Made by Dr. Waldijk
# Creat encrypted disk images with LUKS, the lazy way.
# Read the README.md for more info, but you will find more info here below.
# By running this script you agree to the license terms.
# -----------------------------------------------------------------------------------
LALUVER="0.1"
LALUNAM="LazyLudicr"
while :; do
    clear
    echo "$LALUNAM v$LALUVER"
    echo ""
    echo "1. Create Encrypted Disk Image  |  2. Mount Encrypted Disk Image"
    echo ""
    echo "Q. Quit"
    echo ""
    echo ""
    read -p "Enter option: " -s -n1 LALUKEY
    case "$LALUKEY" in
        1)
            clear
            fallocate -l 512M enc.iso
            sudo cryptsetup -y luksFormat enc.iso
            sudo cryptsetup luksOpen enc.iso encVolume
            sudo mkfs.ext4 /dev/mapper/encVolume
            sudo e2label /dev/mapper/encVolume "diskname"
            sudo cryptsetup luksClose encVolume
            echo ""
            echo "All done..."
            read -p "Press (the infamous) any key to continue... " -n1 -s
        ;;
        [qQ])
            clear
            break
        ;;
        *)
            clear
            echo "Wrong option!"
            read -p "Press (the infamous) any key to continue... " -n1 -s
        ;;
    esac
done
