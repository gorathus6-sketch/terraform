# This assumed you have installed python. You will need the Jira python
# plugin installed using Gitbash, WSL, or bash (if native Linux user), 
# use the following command to install the plugin:
# pip install jira

from jira import JIRA
from datetime import datetime

# 1) config
# _________
JIRA_URL = "https://company.atlassian.net"
USERNAME = "email@company.com"
API_TOKEN = "YOUR_API_TOKEN" # Must generate a token manually on jira website
PROJECT_KEY = "Operations" # use your team's business function here

# 2) jira connection
# __________________
jira = JIRA(
    server=JIRA_URL,
    basic_auth=(USERNAME, API_TOKEN)
)

# 3) your input (dynamic)
# _______________________
your_name = "Your Name Here"
shift = "US"    # Use EMEA or APAC if on other shifts
task_name = "Daily Operations Checklist" # can use specific task performed
time_worked_hours = 8

# example checklist itenerary
checklist_items = [
    "Dynamics 365 Incidents Triaged or Resolved"
    "Investiage CloudWatch Alerts"
    "Monitor Control-M or Airflow tasks"
    "Monitor system health in host and Grafana"
    "Weekly wildfly, servicemix, and ActiveMQ recycles"
    "DEV, UAT, or QA Deployments"
]

# 4) create parent task
# _____________________
timestamp = datetime.now().strftime("%Y-%m-%d %H:%M")

parent_summary = f"{your_name} - {task_name} - {shift} Shift"
parent_description = (
    f"Automated task submission.\n"
    f"Name: {your_name}\n"
    f"Time Worked: {time_worked_hours} hours\n"
    f"Submitted: {timestamp}"
)

parent_issue = jira.create_issue(fields={
    "project": {"key": PROJECT_KEY},
    "summary": parent_summary,
    "description": parent_description,
    "issuetype": {"name": "Task"}
})

print("Created parent task:", parent_issue.key)

# 5. create subtask (checklist)
# _____________________________
for item in checklist_items:
    subtask = jira.create_issue(fields={
        "project": {"key": PROJECT_KEY},
        "summary": item,
        "issuetype": {"name": "Sub-tasks"},
        "parent": {"key": parent_issue.key}
    })

print("Created parent tasks:", parent_issue.key)

#
# 5. create subtasks (chk list items)
# ___________________________________
for item in checklist_items:
    subtask = jira.create_issue(fields={
        "project": {"key": PROJECT_KEY},
        "summary": item,
        "issuetype": {"name": "Sub-task"},
        "parent": {"key": parent_issue.key}
    })
    print("  Added subtask:", subtask.key)

print("All tasks submitted successfully.")
