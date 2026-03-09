#!/bin/bash
echo "Top CPU:"; ps aux --sort=-%cpu | head
echo "Top Memory:"; ps aux --sort=-%mem | head