[Setup]
SetupIconFile=pcinfo.ico
AppName=PC Info by Nooba7
AppVersion=1.0
DefaultDirName={pf}\PCInfo
DefaultGroupName=PC Info
UninstallDisplayIcon={app}\pcinfo.exe
OutputDir={src}\..\dist
OutputBaseFilename=PCInfo_Installer
Compression=lzma2
SolidCompression=yes

[Files]
Source: "pcinfo.exe"; DestDir: "{app}"

[Icons]
Name: "{group}\PC Info"; Filename: "{app}\pcinfo.exe"; IconFilename: "{app}\pcinfo.exe"
Name: "{commondesktop}\PC Info"; Filename: "{app}\pcinfo.exe"; IconFilename: "{app}\pcinfo.exe"

[Registry]
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"; \
ValueType: expandsz; ValueName: "Path"; ValueData: "{olddata};{app}"; Flags: preservestringtype

[Run]
Filename: "{app}\pcinfo.exe"; Description: "Execute PC Info"; Flags: postinstall nowait
