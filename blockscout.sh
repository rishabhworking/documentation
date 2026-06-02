#!/bin/sh

list tables  \l

sudo -i -u postgres

sudo -u postgres psql
sudo -u blockscout psql

sudo -u postgres createuser --interactive

sudo -u postgres createdb blockscout

# postgresql connection example:  DATABASE_URL=postgresql://blockscout:Passw0Rd@db.instance.local:5432/blockscout
#export DATABASE_URL=postgresql://<db_user>:<db_pass>@<db_host>:<db_port>/<db_name> # db_name does not have to be existing database
export DATABASE_URL=postgresql://postgres:Passw0Rd@127.0.0.1:5432/blockscout

# we set these env vars to test the db connection with psql
export PGPASSWORD=Passw0Rd
export PGUSER=postgres
export PGHOST=127.0.0.1
export PGDATABASE=blockscout

export SECRET_KEY_BASE="Kb+uH05FMVtCKQHHMrSU/U7FXO+LZ01L7lNbKsqdo8CWJpjXlfqAn3F4yireSwlu"

Success. You can now start the database server using:

pg_ctlcluster 12 main start

CREATE DATABASE blockscout;

CREATE USER blockscout WITH PASSWORD 'Passw0Rd';

GRANT ALL PRIVILEGES ON DATABASE blockscout to blockscout;









sudo apt-get --purge remove postgresql 
sudo apt-get --purge remove postgresql-contrib 
sudo apt-get --purge remove postgresql-client

psql -c "alter user postgres with password 'Passw0Rd'"


JGvyKR1yfITtTREq+gR5Nve1EeS3re5SwrseiV4M7+F7yDLFArxVP4s+szWalEu4

xKFVAamIi3Psh0n7fFRtGxJECUBpVJrEOq9B+UbZdn+QOXgvSVWPVFr2v4/eGE+E



[Unit]
Description=BlockScout Server
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
Restart=always
RestartSec=1
User=root
StandardOutput=syslog
StandardError=syslog
WorkingDirectory=/root/blockscout
ExecStart=/usr/local/bin/mix phx.server
EnvironmentFile=/root/blockscout/env_vars.env

[Install]
WantedBy=multi-user.target






#blockscoutbegins

export DATABASE_URL=postgresql://blockscout:Passw0Rd@localhost:5432/blockscout
export LANG=en_US.UTF-8
export LANGUAGE=en_US
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export ETHEREUM_JSONRPC_HTTP_URL=http://localhost:8545
export ETHEREUM_JSONRPC_WS_URL=ws://localhost:8546
export ETHEREUM_JSONRPC_VARIANT=geth
export BLOCKSCOUT_PROTOCOL=https
export PORT=4000
export MIX_ENV=prod
export COIN="KNC Coin"
export COIN_NAME="KNC"
export SECRET_KEY_BASE=O6280rMHnoSzfXYRNQup0tcj3mC6B2yQWqKI+mm533/NFZBpI0n/lsOYY76oAoFU
export ECTO_USE_SSL=false
export NETWORK="KNC Coin"
export SUBNETWORK="Testnet"
export DISABLE_EXCHANGE_RATES="true"
export LINK_TO_OTHER_EXPLORERS="false"
export BLOCK_TRANSFORMER=clique
export INDEXER_DISABLE_BLOCK_REWARD_FETCHER="true"
export INDEXER_DISABLE_PENDING_TRANSACTIONS_FETCHER="true"
export INDEXER_DISABLE_INTERNAL_TRANSACTIONS_FETCHER="true"
export CHAIN_ID=2235
export POOL_SIZE=10
export POOL_SIZE_API=10
export LOGO=/images/logo.png
#export BLOCKSCOUT_HOST=testnet.kedarneuralchains.in
export INDEXER_HIDE_INDEXING_PROGRESS_ALERT="true"
export NEXT_PUBLIC_NETWORK_TOKEN_STANDARD_NAME=SRC
export SHOW_TESTNET_LABEL=true
export DISABLE_WEBAPP=false



The guard passes the moment that migration's row in migrations_status reads completed. Since your config has:

INDEXER_DISABLE_INTERNAL_TRANSACTIONS_FETCHER="true"

your internal_transactions table isn't being populated, so the heavy PK rewrite has no real work to do — marking it complete is safe for your setup. Run this once against your DB (your DATABASE_URL is already
exported, so in your shell you can do):

psql "$DATABASE_URL" -c "INSERT INTO migrations_status (migration_name, status, inserted_at, updated_at) VALUES ('heavy_indexes_create_internal_transactions_pkey', 'completed', NOW(), NOW()) ON CONFLICT 
(migration_name) DO UPDATE SET status = 'completed', updated_at = NOW();"

Then mix phx.server boots normally, every time, with your indexed data intact and the open-source code untouched. (In this session you can run it by typing ! psql ....)

One honest caveat: this records the migration as done without performing the PK rewrite. That's fine while the internal-transactions fetcher is disabled. If you ever set
INDEXER_DISABLE_INTERNAL_TRANSACTIONS_FETCHER="false", first DELETE FROM migrations_status WHERE migration_name = 'heavy_indexes_create_internal_transactions_pkey'; and let it run for real (keep
MIGRATION_HEAVY_INDEX_OPERATIONS_CHECK_INTERVAL short so it finishes before you restart).


psql "$DATABASE_URL" -c "INSERT INTO migrations_status (migration_name, status, inserted_at, updated_at) VALUES ('heavy_indexes_create_internal_transactions_pkey', 'completed', NOW(), NOW()) ON CONFLICT 
(migration_name) DO UPDATE SET status = 'completed', updated_at = NOW();"






















