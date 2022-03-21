#!/bin/bash
sleep 5
echo "Setting up database..."
mix ecto.setup
mix phx.server
