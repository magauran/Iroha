#!/bin/bash

docker network create iroha-network

docker volume create blockstore

docker run --name postgres-iroha \
	-e POSTGRES_USER=postgres \
	-e POSTGRES_PASSWORD=mysecretpassword \
	-p 5432:5432 \
	--network=iroha-network \
	-d \
	postgres:9.5

docker run -it --name iroha \
	-p 50051:50051 \
	-v $(pwd)/ledger_config:/opt/iroha_data \
	-v blockstore:/tmp/block_store \
	--network=iroha-network \
	--entrypoint=/bin/bash \
	hyperledger/iroha:latest

