#nohup ~/go-ethereum/build/bin/geth --datadir node1 --syncmode 'full' --port 40404 --http --http.addr 0.0.0.0 --http.port 5545 --http.api 'personal,db,clique,eth,net,web3,personal,admin,miner,txpool,debug' --bootnodes enode://f5ac23bafd813292d92a49d817703dfed6c33db593981e70b631bfd3db2798e0d6c7af1a6613afed872cb58c93aea3b908c7fa8922acbc872f79d76d7e138097@202.143.111.96:0?discport=40401 --networkid 6515 -unlock '0x18757d2ffd2dc8d4e139a18a7c47cb96932e3e76' --password password.txt --mine --ws --ws.api "personal,db,clique,eth,net,web3,personal,admin,miner,txpool,debug" --ws.port 5546 --ws.origins="*" --ws.addr 0.0.0.0 --allow-insecure-unlock 2>>chain.log &
nohup ./geth -snapshot=false --datadir mnnoderpc --syncmode 'full' --gcmode=archive --port 40605 --http.vhosts=* --http --http.corsdomain='*' --http.port 3545 --http.api 'personal,eth,net,web3,personal,admin,miner,txpool,debug,clique' --bootnodes enode://5374d7eaa5e2b5be591246773a4a96ea20b4f35d19ed05fcf53d9ec214b80deb0d68937b15f41b3f700e64921e864a47d8a17b6f728de44d9cd462d776a2de73@45.79.122.22:0?discport=40606 --networkid 50741 --ws --ws.api "personal,db,clique,eth,net,web3,personal,admin,miner,txpool,debug" --ws.port 3546 --ws.origins="*" --ws.addr 0.0.0.0 --allow-insecure-unlock 2>>chain.log &
# mix do ecto.drop, ecto.create, ecto.migrate
# lsof -t -i:3545
# lsof -t -i:4000