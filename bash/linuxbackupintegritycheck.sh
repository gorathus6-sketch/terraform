#!/bin/bash
tar -czf backup.tar.gz /etc
sha256sum backup.tar.gz > backup.sha256
# requires sudo or root access