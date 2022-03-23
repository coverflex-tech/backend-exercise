#!/bin/bash
sleep 5
echo "Dropping database..."
mix ecto.drop
echo "Setting up database..."
mix ecto.setup
echo "Spinning up server..."
mix phx.server
