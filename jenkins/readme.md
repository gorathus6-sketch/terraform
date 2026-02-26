# Bitbucket + Jenkins CI/CD Lab

This project demonstrates a simple CI/CD workflow using both Bitbucket Pipelines and Jenkins.  
It includes:

- A sample application (`hello.sh`)
- A Bitbucket pipeline (`bitbucket-pipelines.yml`)
- A Jenkins declarative pipeline (`Jenkinsfile`)
- A clean, interview-ready CI/CD example

## Bitbucket Pipeline

Runs a lightweight Alpine container and executes the script.

## Jenkins Pipeline

Uses a declarative Jenkinsfile to check out the repo and run the same script.

## Purpose

This repo is part of my DevOps learning path and demonstrates:
- Pipeline-as-code
- Multi-platform CI/CD
- Git-based automation
