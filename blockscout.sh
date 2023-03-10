#!/bin/sh

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

export SECRET_KEY_BASE="xKFVAamIi3Psh0n7fFRtGxJECUBpVJrEOq9B+UbZdn+QOXgvSVWPVFr2v4/eGE+E/"

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






# env_vars.env file should hold these values ( adjusted for your environment )
ETHEREUM_JSONRPC_HTTP_URL="localhost:28998"  # json-rpc API of the chain
ETHEREUM_JSONRPC_TRACE_URL="localhost:28998" # same as json-rpc API 
DATABASE_URL='postgresql://postgres:Passw0Rd@127.0.0.1:5432/blockscout' # database connection from Step 2
SECRET_KEY_BASE="xKFVAamIi3Psh0n7fFRtGxJECUBpVJrEOq9B+UbZdn+QOXgvSVWPVFr2v4/eGE+E/" # secret key base 
ETHEREUM_JSONRPC_WS_URL="ws://localhost:28998/ws" # websocket API of the chain
CHAIN_ID=11997 # chain id
HEART_COMMAND="systemctl restart explorer" # command used by blockscout to restart it self in case of failure
SUBNETWORK="Supertestnet PoA" # this will be in html title
LOGO="/images/polygon_edge_logo.svg" # logo location
LOGO_FOOTER="/images/polygon_edge_logo.svg" # footer logo location
COIN="AETA" # coin
COIN_NAME="Arietta" # name of the coin
INDEXER_DISABLE_BLOCK_REWARD_FETCHER="true" # disable block reward indexer as Polygon Edge doesn't support tracing
INDEXER_DISABLE_PENDING_TRANSACTIONS_FETCHER="true" # disable pending transactions indexer as Polygon Edge doesn't support tracing
INDEXER_DISABLE_INTERNAL_TRANSACTIONS_FETCHER="true" # disable internal transactions indexer as Polygon Edge doesn't support tracing
MIX_ENV="prod" # run in production mode
BLOCKSCOUT_PROTOCOL="http" # protocol to run blockscout web service on
PORT=4000 # port to run blockscout service on
DISABLE_EXCHANGE_RATES="true" # disable fetching of exchange rates
POOL_SIZE=200 # the number of database connections
POOL_SIZE_API=50 # the number of read-only database connections
ECTO_USE_SSL="false" # if protocol is set to http this should be false 
HEART_BEAT_TIMEOUT=60 # run HEARTH_COMMAND if heartbeat missing for this amount of seconds
INDEXER_MEMORY_LIMIT="10Gb" # soft memory limit for indexer - depending on the size of the chain and the amount of RAM the server has
FETCH_REWARDS_WAY="manual" # disable trace_block query 
INDEXER_EMPTY_BLOCKS_SANITIZER_BATCH_SIZE=100 # sanitize empty block in this batch size






















