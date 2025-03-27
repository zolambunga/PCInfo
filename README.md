# PCInfo

PCInfo is a lightweight tool designed to collect and display detailed system information directly from the terminal. The output is automatically copied to the clipboard, allowing you to easily share your specs with friends.

## Features
- Displays key system information such as CPU, GPU, RAM, storage, motherboard, and more.
- Runs directly in the terminal for quick access.
- Installer adds `pcinfo` as a native command, making execution as simple as typing `pcinfo`.
- Copies output to the clipboard so you can paste it anywhere.

## Installation
1. Download the latest version Releases.
2. After installation, open a terminal (PowerShell or Command Prompt) and simply type:
   ```powershell
   pcinfo
   ```
3. Press **Ctrl + V** to paste the collected system information wherever you want.

## Usage
- Open the terminal and run:
  ```powershell
  pcinfo
  ```
- The system summary will be copied to the clipboard.
- Paste it anywhere (Ctrl + V) to flex your PC specs.

## Compilation
If you want to build from source:
1. Edit `pcinfo.ps1` as needed.
2. Convert `pcinfo.ps1` into `pcinfo.exe` using PS2EXE.

a)If you dont havE PS2EXE installed you an install it with
  ```powershell
  Install-Module PS2EXE -Scope CurrentUser
  ```
b) To convert `pcinfo.ps1` into `pcinfo.exe` use
  ```powershell
  Invoke-PS2EXE .\pcinfo.ps1 .\pcinfo.exe
  ```
3. Use Inno Setup to compile `pcinfo_setup.iss` into an installer.
4. The compiled installer will register `pcinfo` as a command.

## License
This project is open-source under the MIT License.

## Contributing
Feel free to fork this project, submit issues, or suggest improvements!

