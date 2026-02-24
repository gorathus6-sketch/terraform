# System Health Check – PowerShell Automation Script

A production‑ready PowerShell script designed to perform common operational health checks on Windows systems.  
This script demonstrates clean automation practices, parameterized execution, structured logging, and error handling — ideal for cloud, DevOps, and systems administration environments.

## 🚀 Features

- Disk usage monitoring for any drive  
- Service status validation and auto‑restart attempts  
- Network connectivity testing  
- Recent system error log inspection  
- Timestamped log file output  
- Clean, readable PowerShell with functions and parameters  
- Exit codes suitable for CI/CD, Airflow, Jenkins, or monitoring tools  

## 📂 Repository Structure

/SystemHealthCheck │ ├── SystemHealthCheck.ps1 ├── README.md └── examples/ └── sample-log-output.txt

## 🛠️ Requirements

- PowerShell 5.1 or PowerShell 7+
- Windows OS (for CIM and Event Log queries)
- Execution policy allowing script execution:
  ```powershell
  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
