#!/usr/bin/env bash

#!/bin/bash

SECONDS=0

sleep 125

minutes=$((SECONDS / 60))
seconds=$((SECONDS % 60))

echo "Duration: ${minutes}m ${seconds}s"
