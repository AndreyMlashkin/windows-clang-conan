# escape=`
FROM mcr.microsoft.com/windows/servercore:1909

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'Continue';"]

# Install chocolatey
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

RUN choco install windows-sdk-10.0 -y
RUN choco install llvm  -y
RUN choco install Ninja -y
RUN choco install cmake -y --installargs 'ADD_CMAKE_TO_PATH=System'
RUN choco install conan -y

SHELL ["cmd", "/wait", "/S", "/C"]
RUN setx /M PATH "%PATH%;C:\Program Files\LLVM\bin"
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

ADD profile C:\Users\ContainerAdministrator\.conan\profiles\default

# test code, should be deleted later
RUN conan new hello/0.1 -m v2_cmake
RUN conan create . hello/0.1@ -m v2_cmake -c tools.env.virtualenv:auto_use=True
