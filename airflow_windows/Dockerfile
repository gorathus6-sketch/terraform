FROM apache/airflow:3.1.8

USER airflow
# install FAB stack
RUN pip install --no-cache-dir \
    apache-airflow-providers-fab \
    flask-appbuilder \
    flask-babel \
    marshmallow \
    marshmallow-sqlalchemy


# switch to root for OS-level Install
USER root
# Install PowerShell Core
RUN apt-get update && \
     apt-get install -y wget apt-transport-https software-properties-common && \
     wget -q https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb && \
     dpkg -i packages-microsoft-prod.deb && \
     apt-get update && \
     apt-get install -y powershell && \
     apt-get clean

# Return to airflow user
USER airflow