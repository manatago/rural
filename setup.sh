#!/bin/bash

# スクリプトが失敗した場合に中止
set -e

# 作業ディレクトリの作成
mkdir -p ~/local/src
cd ~/local/src

# libyamlのインストール
if [ ! -d "yaml-0.2.5" ]; then
    echo "Installing libyaml..."
    curl -LO https://github.com/yaml/libyaml/releases/download/0.2.5/yaml-0.2.5.tar.gz
    tar xzf yaml-0.2.5.tar.gz
    cd yaml-0.2.5
    ./configure --prefix=$HOME/local
    make
    make install
    cd ..
fi

# libxml2のインストール（nokogiri用）
if [ ! -d "libxml2-2.9.12" ]; then
    echo "Installing libxml2..."
    curl -LO https://download.gnome.org/sources/libxml2/2.9/libxml2-2.9.12.tar.gz
    tar xzf libxml2-2.9.12.tar.gz
    cd libxml2-2.9.12
    ./configure --prefix=$HOME/local --without-python
    make
    make install
    cd ..
fi

# libxsltのインストール（nokogiri用）
if [ ! -d "libxslt-1.1.34" ]; then
    echo "Installing libxslt..."
    curl -LO https://download.gnome.org/sources/libxslt/1.1/libxslt-1.1.34.tar.gz
    tar xzf libxslt-1.1.34.tar.gz
    cd libxslt-1.1.34
    ./configure --prefix=$HOME/local --without-python --with-libxml-prefix=$HOME/local
    make
    make install
    cd ..
fi

# 環境変数の設定
echo "Adding environment variables to ~/.bashrc..."
if ! grep -q "# Rural app environment variables" ~/.bashrc; then
    cat >> ~/.bashrc << 'EOL'

# Rural app environment variables
export LD_LIBRARY_PATH=$HOME/local/lib:$LD_LIBRARY_PATH
export LIBRARY_PATH=$HOME/local/lib:$LIBRARY_PATH
export C_INCLUDE_PATH=$HOME/local/include:$C_INCLUDE_PATH
export CPATH=$HOME/local/include:$CPATH
export PKG_CONFIG_PATH=$HOME/local/lib/pkgconfig:$PKG_CONFIG_PATH
EOL
fi

# 環境変数を現在のシェルに適用
export LD_LIBRARY_PATH=$HOME/local/lib:$LD_LIBRARY_PATH
export LIBRARY_PATH=$HOME/local/lib:$LIBRARY_PATH
export C_INCLUDE_PATH=$HOME/local/include:$C_INCLUDE_PATH
export CPATH=$HOME/local/include:$CPATH
export PKG_CONFIG_PATH=$HOME/local/lib/pkgconfig:$PKG_CONFIG_PATH

# bundlerの設定
echo "Configuring bundler..."
bundle config --global build.nokogiri --use-system-libraries \
    --with-xml2-include=$HOME/local/include/libxml2 \
    --with-xml2-lib=$HOME/local/lib \
    --with-xslt-include=$HOME/local/include \
    --with-xslt-lib=$HOME/local/lib

# gemのインストールパスを設定
bundle config --global path 'vendor/bundle'
bundle config --global build.psych --with-libyaml-dir=$HOME/local

echo "Setup completed successfully!"
echo "Please run:"
echo "1. source ~/.bashrc"
echo "2. bundle install"