#!/bin/bash
echo "CPU:"; top -bn1 | grep "Cpu(s)"
echo "Memory:"; free -h
echo "Disks:"; df -h
echo "Top Processes:"; ps aux --sort=-%cpu | head