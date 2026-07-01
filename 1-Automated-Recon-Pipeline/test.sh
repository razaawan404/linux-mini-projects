#!/usr/bin/env bash

SECONDS=0

mins=$(( SECONDS / 60 ))
secs=$(( SECONDS % 60 ))

echo "Duration  : ${mins}m ${secs}s"
whois 127.0.0.1
