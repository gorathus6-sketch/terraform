#!/bin/bash
docker logs $1 2>&1 | grep -i error | tee container_errors.txt