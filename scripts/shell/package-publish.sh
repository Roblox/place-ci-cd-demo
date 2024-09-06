#!/bin/sh

set -e

$HOME/.foreman/bin/rojo build $1 --output dist.rbxl
python3 scripts/python/upload_and_run_task.py dist.rbxl $2
rm dist.rbxl