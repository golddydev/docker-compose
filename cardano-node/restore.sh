# Cardano network
export NETWORK=preview

# Aggregator API endpoint URL
export AGGREGATOR_ENDPOINT=https://aggregator.pre-release-preview.api.mithril.network/aggregator

# Genesis verification key
export GENESIS_VERIFICATION_KEY=$(curl -s https://raw.githubusercontent.com/input-output-hk/mithril/main/mithril-infra/configuration/pre-release-preview/genesis.vkey)

export ANCILLARY_VERIFICATION_KEY=$(curl -s https://raw.githubusercontent.com/input-output-hk/mithril/main/mithril-infra/configuration/pre-release-preview/ancillary.vkey)

# Digest of the latest produced snapshot for convenience of the demo
# You can also modify this variable and set it to the value of the digest of a snapshot that you can retrieve at step 2
export SNAPSHOT_DIGEST=latest

if ! [ -d configuration ]; then
  mkdir configuration
  cd configuration
  for file in alonzo-genesis.json byron-genesis.json config.json conway-genesis.json db-sync-config.json peer-snapshot.json shelley-genesis.json submit-api-config.json topology.json; do
    curl -O -L https://book.world.dev.cardano.org/environments/$NETWORK/$file
  done
  cd ..
fi

if ! [ -d db ]; then
  if ! [ -f mithril-client ]; then
    echo "Installing mithril-client"
    curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/input-output-hk/mithril/refs/heads/main/mithril-install.sh | sh -s -- -c mithril-client -d 2543.0 -p $(pwd)
  fi
  echo "Restoring DB from snapshot"

  mithril-client cardano-db download --genesis-verification-key $GENESIS_VERIFICATION_KEY --include-ancillary --ancillary-verification-key $ANCILLARY_VERIFICATION_KEY $SNAPSHOT_DIGEST  
fi

if ! [ -d db-2 ]; then
  mkdir db-2
  cp -r db/* db-2
fi

if ! [ -d db-3 ]; then
  mkdir db-3
  cp -r db/* db-3
fi