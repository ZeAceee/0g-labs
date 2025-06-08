sudo apt-get update && sudo apt-get install clang cmake build-essential openssl pkg-config libssl-dev jq git bc cargo

cd $HOME &&
ver="1.22.0" &&
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" &&
sudo rm -rf /usr/local/go &&
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" &&
rm "go$ver.linux-amd64.tar.gz" &&
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile &&
source ~/.bash_profile &&
go version

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

git clone -b v1.0.0 https://github.com/0glabs/0g-storage-node.git && cd $HOME/0g-storage-node && git stash && git fetch --all --tags && git checkout 347cd3e && git submodule update --init && cargo build --release

rm -rf $HOME/0g-storage-node/run/config.toml && curl -o $HOME/0g-storage-node/run/config.toml https://docs.ze-ace.com/0g-labs/config.toml && nano $HOME/0g-storage-node/run/config.toml

sudo tee /etc/systemd/system/zgs.service > /dev/null <<EOF
[Unit]
Description=ZGS Node
After=network.target

[Service]
User=$USER
WorkingDirectory=$HOME/0g-storage-node/run
ExecStart=$HOME/0g-storage-node/target/release/zgs_node --config $HOME/0g-storage-node/run/config.toml
Restart=on-failure
RestartSec=10
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload && sudo systemctl enable zgs && sudo systemctl start zgs && tail -f ~/0g-storage-node/run/log/zgs.log.$(TZ=UTC date +%Y-%m-%d)
