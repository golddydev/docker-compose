# docker-compose

A collection of ready-to-run Docker Compose files for spinning up common
databases, message brokers, and infrastructure services during local
development. Each service lives in its own directory with a self-contained
`docker-compose.yml`, so you can start only what you need.

## Requirements

- [Docker](https://docs.docker.com/get-docker/)
- Docker Compose (bundled as `docker compose` with modern Docker installs)

## Usage

Start a service by pointing Compose at the directory of your choice:

```bash
# from a service directory
cd postgres
docker compose up -d

# or from the repo root
docker compose -f postgres/docker-compose.yml up -d
```

Stop and remove the containers with:

```bash
docker compose down
```

## Services

| Service | Directory | Image | Ports | Default credentials |
| --- | --- | --- | --- | --- |
| MongoDB | `mongo/` | `mongo` | `27017` | — |
| MySQL | `mysql/` | `mysql` | `3306` | root / `defaultPassword` |
| PostgreSQL | `postgres/` | `postgres` | `5432` | `default` / `defaultPassword` |
| Redis | `redis/` | `redis` | `6379` | `default` / `defaultPassword` |
| RabbitMQ | `rabbitmq/` | `rabbitmq:3-management` | `5672` (AMQP), `15672` (UI) | `admin` / `admin` |
| DynamoDB Local | `dynamodb/` | `amazon/dynamodb-local` | `8000` | — |
| Portainer | `portainer/` | `portainer/portainer-ce:lts` | `9443` (UI), `8000` (Edge) | set on first login |
| Cardano Node | `cardano-node/` | `ghcr.io/intersectmbo/cardano-node` | `3001` | — |

> **Note:** The credentials above are development defaults. Change them (and
> avoid committing real secrets) before using any of these services beyond
> local testing.

### DynamoDB Local

Runs with `-sharedDb` and persists data to `./mounted` (git-ignored). Point the
AWS SDK/CLI at `http://localhost:8000` to use it.

### Portainer

A web UI for managing Docker itself. It mounts the host Docker socket and
creates a dedicated `portainer_network`. Open `https://localhost:9443` and set
the admin password on first launch.

### Cardano Node

Runs a [Cardano](https://cardano.org/) node against the `preprod` network by
default (set via the `NETWORK` environment variable). Node configuration lives
in `cardano-node/environments/`, and blockchain data is stored under
`cardano-node/mounted/` (git-ignored).

- `docker-compose-1.yml` is an alternative setup that runs three nodes
  (`blinklabs-io/cardano-node`) on ports `3001`–`3003`.
- `restore.sh` bootstraps the node configuration and restores the chain
  database from a [Mithril](https://mithril.network/) snapshot to avoid a full
  sync from genesis.

## Notes

- `mounted/` directories and `.env` files are git-ignored (see `.gitignore`).
