#!/bin/bash
ss -tulpn | grep LISTEN > open_ports.txt