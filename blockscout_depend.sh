#!/usr/bin/env bash

# Update & upgrade system
sudo apt -y update && sudo apt -y upgrade

# go to your home dir
cd ~

# download deb
wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb

# download key
wget https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc

# install repo
sudo dpkg -i erlang-solutions_2.0_all.deb

# install key
sudo apt-key add erlang_solutions.asc

# remove deb
rm erlang-solutions_2.0_all.deb

# remove key
rm erlang_solutions.asc

# Add NodeJS repo
sudo curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -

# Install Rust
sudo curl https://sh.rustup.rs -sSf | sh -s -- -y

# Install required version of Erlang
sudo apt -y install esl-erlang=1:24.*

# Install required version of Elixir
cd ~
mkdir /usr/local/elixir
wget https://github.com/elixir-lang/elixir/releases/download/v1.13.4/Precompiled.zip
sudo unzip -d /usr/local/elixir/ Precompiled.zip
rm Precompiled.zip
sudo ln -s /usr/local/elixir/bin/elixir /usr/local/bin/elixir
sudo ln -s /usr/local/elixir/bin/mix /usr/local/bin/mix
sudo ln -s /usr/local/elixir/bin/iex /usr/local/bin/iex
sudo ln -s /usr/local/elixir/bin/elixirc /usr/local/bin/elixirc
elixir -v

# Install NodeJS
sudo apt -y install nodejs

# Install Cargo
sudo apt -y install cargo

# Install other dependencies
sudo apt -y install automake libtool inotify-tools gcc libgmp-dev make g++ git

# Install PostgreSQL
sudo apt -y install postgresql postgresql-contrib
sudo systemctl start postgresql.service
sudo -u postgres psql -c "CREATE USER blockscout WITH PASSWORD 'Passw0Rd'"
sudo -u postgres psql -c "ALTER USER blockscout WITH SUPERUSER"
sudo -u blockscout psql -c "CREATEDB blockscout"
##sudo -u blockscout psql blockscout
export DATABASE_URL=postgresql://blockscout:Passw0Rd@localhost:5432/blockscout

# Clone and compile BlockScout
cd ~
git clone https://github.com/rishabhworking/blockscout
cd blockscout
mix deps.get -y
mix local.rebar --force
KEY=$(mix phx.gen.secret)
export SECRET_KEY_BASE="$KEY"
export SECRET_KEY_BASE="$KEY"
#OQr4tYJONhBKaZdpt0nHvdXrEGl9e6mWgfNcZBiU9DiHJO6mJyiGMWxvCvI+O3Kb
export MIX_ENV=prod
mix local.hex --force
mix do deps.get, local.rebar --force, deps.compile, compile
mix do ecto.drop, ecto.create, ecto.migrate
cd apps/block_scout_web/assets
sudo npm install
sudo node_modules/webpack/bin/webpack.js --mode production


npm install --save solc






		

