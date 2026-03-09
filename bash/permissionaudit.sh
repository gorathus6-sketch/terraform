#!/bin/bash
find /etc -maxdepth 1 -type f -exec ls -l {} \; > etc_permissions.txt