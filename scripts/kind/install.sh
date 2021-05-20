#!/bin/bash
CONFIG=$1

if [ -z "$CONFIG" ]
then
    echo "No configuration was supplied. Default configuration will be used."
    CONFIG="./config.yaml"
fi

kind create cluster --config $CONFIG