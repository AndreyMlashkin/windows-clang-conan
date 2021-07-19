# escape=`
FROM mcr.microsoft.com/windows/servercore:1909

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'Continue';"]

# Install chocolatey
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

RUN choco install llvm  -y
RUN choco install Ninja -y
RUN choco install conan -y

ADD profile C:\Users\ContainerAdministrator\.conan\profiles\default

# test code, should be deleted later
RUN conan install zlib/1.2.11@ --build "*"