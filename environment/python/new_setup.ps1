# These are instructions & commands for setting up Python on a new system.

# Install Python
#     Download installer from www.python.org
#     Run Installer with the following options:
#         Add Python X.X to Path
#         Custom Installation
#         Advanced Options
#             Install for all users
#             Install Path: C:\Python\PythonXX

# Setup core Python environment. (I use a core environment for linters and other items I want accessible system wide)
python -m venv C:\Python\DevEnv

# Update new virtual environment (This requires my PowerShell profile to be loaded)
Update-VirtualEnv C:\Python\DevEnv

# Install required PIP packages (Requires my PowerShell repo)
pip install -r (Resolve-Path "~\Programming\powershell\environment\python\requirements.txt")
