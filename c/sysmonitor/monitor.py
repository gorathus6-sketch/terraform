import subprocess
import os

def get_memory_usage(pid):
    try:
        # caling the complied c binary
        result = subprocess.run(['./proc_reader', str(pid)], capture_output=True, text=True)
        return result.stdout.strip()
    except Exception as e:
        return f"Error: {e}"
    
if __name__ == "__main__":
    target_pid = input("Enter PID to monitor:")
    print(get_memory_usage(target_pid))
