#!/bin/bash
# LazyLudicr v0.2
# Made by Dr. Waldijk
# Create encrypted disk images with LUKS, the lazy way.
# Read the README.md for more info, but you will find more info here below.
# By running this script you agree to the license terms.
# Config ----------------------------------------------------------------------------
LALUVER="0.2"
LALUNAM="LazyLudicr"
LALULOC=""
if [ ! -e $HOME/.dokter ]; then
    mkdir $HOME/.dokter
fi
if [ ! -e $HOME/.dokter/LazyLudicr ]; then
    mkdir $HOME/.dokter/LazyLudicr
fi
if [ ! -e $HOME/.dokter/LazyLudicr/laluloc ]; then
    touch $HOME/.dokter/LazyLudicr/laluloc
    read -s -p "Enter disk image location: " LALULOC
    echo "$LALULOC" > $HOME/.dokter/LazyLudicr/laluloc
    LALUFLS=$(ls $LALULOC)
else
    LALULOC=$(cat $HOME/.dokter/LazyLudicr/laluloc)
    LALUFLS=$(ls $LALULOC)
fi
# Function --------------------------------------------------------------------------
laluclear () {
    LALUVER=""
    LALUNAM=""
    LALULOC=""
    LALUFLS=""
    LALUKEY=""
    LALUIMS=""
    LALUDSK=""
    LALUMOT=""
}
laluclr () {
    LALUKEY=""
    LALUIMS=""
    LALUDSK=""
    LALUMOT=""
}
# -----------------------------------------------------------------------------------
while :; do
    clear
    echo "$LALUNAM v$LALUVER"
    echo ""
    echo "1. Create Encrypted Disk Image"
    echo "2. Mount Encrypted Disk Image  |  3. Unmount Encrypted Disk Image"
    echo ""
    echo "Q. Quit"
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
            sudo cryptsetup luksOpen $LALUDSK.iso LazyLudicr
            sudo mkfs.ext4 /dev/mapper/LazyLudicr
#            sudo e2label /dev/mapper/LazyLudicr "$LALUDSK"
            sync
            sudo cryptsetup luksClose LazyLudicr
            echo ""
            echo "All done..."
            read -p "Press (the infamous) any key to continue... " -n1 -s
            laluclr
        ;;
        2)
            clear
            echo "$LALUNAM v$LALUVER"
            echo ""
            echo "Disk image(s): $LALUFLS"
            echo ""
            read -s -p "Enter disk image name: " LALUDSK
            sudo cryptsetup luksOpen $LALUDSK.iso LazyLudicr
            sudo mkdir /media/$LALUDSK
            sudo mount /dev/mapper/LazyLudicr /media/$LALUDSK
            sudo chown -R $USER:$USER /media/$LALUDSK
            echo ""
            echo "$LALUDSK.iso mounted"
            read -p "Press (the infamous) any key to continue... " -n1 -s
            laluclr
        ;;
        3)
            clear
            echo "$LALUNAM v$LALUVER"
            echo ""
            echo "Disk image(s): $LALUFLS"
            echo ""
            read -s -p "Enter disk image name: " LALUDSK
            sync
            sudo unmount /dev/mapper/LazyLudicr /media/$LALUDSK
            sync
            sudo cryptsetup luksClose LazyLudicr
            sudo rmdir /media/$LALUDSK
            echo ""
            echo "$LALUDSK.iso unmounted"
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
