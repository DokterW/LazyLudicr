#!/bin/bash
# LazyLudicr v0.1
# Made by Dr. Waldijk
# Creat encrypted disk images with LUKS, the lazy way.
# Read the README.md for more info, but you will find more info here below.
# By running this script you agree to the license terms.
# Config ----------------------------------------------------------------------------
LALUVER="0.1"
LALUNAM="LazyLudicr"
# Function --------------------------------------------------------------------------
laluclear () {
    LALUVER=""
    LALUNAM=""
    LALUKEY=""
}
laluclr () {
    LALUKEY=""
}
# -----------------------------------------------------------------------------------
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
            echo "$LALUNAM v$LALUVER"
            echo ""
            read -s -p "Enter disk image size: " LALUIMS
            read -s -p "Enter disk image name: " LALUDSK
            read -s -p -n1 "(M)B or (T)B: " LALUMOT
            fallocate -l $LALUIMS$LALUMOT $LALUDSK.iso
            sudo cryptsetup -y luksFormat $LALUDSK.iso
            sudo cryptsetup luksOpen enc.iso LazyLudicr
            sudo mkfs.ext4 /dev/mapper/LazyLudicr
            sudo e2label /dev/mapper/LazyLudicr "$LALUDSK"
            sudo cryptsetup luksClose LazyLudicr
            echo ""
            echo "All done..."
            read -p "Press (the infamous) any key to continue... " -n1 -s
            laluclr
        ;;
        [qQ])
            clear
            laluclear
            break
        ;;
        *)
            clear
            echo "Wrong option!"
            read -p "Press (the infamous) any key to continue... " -n1 -s
            laluclr
        ;;
    esac
done
