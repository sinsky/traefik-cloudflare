#!/bin/bash
docker network create --subnet 172.100.0.0/16 --gateway 172.100.0.1 traefik-network
