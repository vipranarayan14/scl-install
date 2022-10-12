#!/bin/bash

# Installation location

MAIN_DIR="$HOME/scl"
ZEN_MAIN_DIR="$MAIN_DIR/SKT/zen"
SCL_MAIN_DIR="$MAIN_DIR/scl"


echo -e "\n=== Updating system packages ===\n"


# Update system package repositories and packages:
sudo apt update && sudo apt upgrade


echo -e "\n=== Installing prerequisites ===\n"


# Install prerequisite system packages:
sudo apt install \
apache2 \
bash \
bison \
flex \
graphviz \
gcc \
lttoolbox \
make \
perl \
python \
python3-pip \
xsltproc \
default-jdk \
g++ ocaml \
ocamlbuild \
camlp4

# Install prerequisite python packages:
sudo pip3 install pandas openpyxl anytree devtrans


echo -e "\n=== Downloading SCL & Dependencies ===\n"


# Creating main installation dir
mkdir $MAIN_DIR

# Download Zen
git clone --depth 1 https://gitlab.inria.fr/huet/Zen.git "$ZEN_MAIN_DIR"

echo -e "\n"

# Download SCL
git clone --depth 1 https://github.com/samsaadhanii/scl.git "$SCL_MAIN_DIR"

cat "$SCL_MAIN_DIR/SPEC/spec_users.txt" \
| sed -E \
    -e "s|^(ZENDIR=).*$|\1$ZEN_MAIN_DIR/ML|" \
    -e "s|^(SCLINSTALLDIR=).*$|\1$SCL_MAIN_DIR|" \
> "$SCL_MAIN_DIR/spec.txt"


# Setup Zen
echo -e "\n=== Installing SCL ===\n"

if [ ! -d "$ZEN_MAIN_DIR/ML" ] || [ ! -d "$SCL_MAIN_DIR" ]; then 
    echo "Missing dependencies. Installation failed."
    exit 1
fi

cd "$ZEN_MAIN_DIR/ML"

make

sudo a2enmod cgid
sudo systemctl restart apache2

# Install SCL

cd "$SCL_MAIN_DIR"

./configure

make

sudo make install

echo -e "\nInstalled SCL Successfully."
echo -e "\nOpen http://localhost/scl/ in your browser.\n"
