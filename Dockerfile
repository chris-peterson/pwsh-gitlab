FROM mcr.microsoft.com/powershell:lts-debian-12

RUN apt-get update && apt-get install -y git

ADD ./src/GitlabCli /opt/microsoft/powershell/7-lts/Modules/GitlabCli

RUN mkdir root/.config && mkdir root/.config/powershell
RUN echo '$ErrorActionPreference="Stop"' >> /root/.config/powershell/Microsoft.PowerShell_profile.ps1
RUN echo "Import-Module GitlabCli" >> /root/.config/powershell/Microsoft.PowerShell_profile.ps1
