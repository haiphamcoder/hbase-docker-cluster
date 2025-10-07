# Makefile for HBase
# Author: Hai Pham Ngoc <ngochai285nd@gmail.com>

.PHONY: help up down restart logs status clean

help:
	@echo "Usage: make <target>"
	@echo "Targets:"
	@echo "  up - Start the services"
	@echo "  down - Stop the services"
	@echo "  restart - Restart the services"
	@echo "  logs - Show the logs"
	@echo "  status - Show the status"
	@echo "  clean - Clean the services"

up:
	@echo "Starting the services..."
	@docker compose up -d

down:
	@echo "Stopping the services..."
	@docker compose down

restart:
	@echo "Restarting the services..."
	@docker compose restart

logs:
	@echo "Showing the logs..."
	@docker compose logs -f

status:
	@echo "Showing the status..."
	@docker compose ps

clean:
	@echo "Cleaning the services..."
	@docker compose down --volumes --rmi all
	