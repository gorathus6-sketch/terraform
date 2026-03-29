#!/usr/bin/env bash

# Run FastAPI using the virtual env python interpreter in project dir
.venv/bin/python -m uvicorn app.main:app --reload