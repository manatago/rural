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

echo "Setup completed successfully!"
echo "Please run 'source ~/.bashrc' to apply the changes to your current shell"