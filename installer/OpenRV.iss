; Minimal Inno Setup installer for OpenRV (Windows)
; Packages the already-staged app tree from ..\_build\stage\app

[Setup]
AppName=OpenRV
AppVersion=dev
DefaultDirName={autopf}\OpenRV
DefaultGroupName=OpenRV
OutputDir=..\dist
OutputBaseFilename=OpenRV-Setup
Compression=lzma2
SolidCompression=yes
ArchitecturesInstallIn64BitMode=x64
PrivilegesRequired=admin
DisableProgramGroupPage=yes

[Tasks]
Name: "desktopicon"; Description: "Create a desktop icon"; Flags: unchecked
Name: "openwith"; Description: "Register RV in 'Open with…' (does not force default associations)"; Flags: unchecked

[Files]
Source: "..\_build\stage\app\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\OpenRV"; Filename: "{app}\bin\rv.exe"; WorkingDir: "{app}\bin"
Name: "{autodesktop}\OpenRV"; Filename: "{app}\bin\rv.exe"; WorkingDir: "{app}\bin"; Tasks: desktopicon

[Registry]
; Allow `rv.exe` to be found via the Windows "App Paths" mechanism
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\rv.exe"; ValueType: string; ValueName: ""; ValueData: "{app}\bin\rv.exe"; Flags: uninsdeletekey
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\rv.exe"; ValueType: string; ValueName: "Path"; ValueData: "{app}\bin"

; Register `rvlink://` protocol handler
Root: HKCR; Subkey: "rvlink"; ValueType: string; ValueName: ""; ValueData: "URL:RV Protocol"; Flags: uninsdeletekey
Root: HKCR; Subkey: "rvlink"; ValueType: string; ValueName: "URL Protocol"; ValueData: ""
Root: HKCR; Subkey: "rvlink\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\bin\rv.exe,1"
Root: HKCR; Subkey: "rvlink\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\bin\rv.exe"" ""%1"""

; Optional: make RV show up in Windows "Open with..." for common types.
Root: HKCR; Subkey: "Applications\rv.exe\shell\open"; ValueType: string; ValueName: "FriendlyAppName"; ValueData: "RV"; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\bin\rv.exe"" ""%1"""; Tasks: openwith

Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "3gp"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "aces"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "aif"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "aifc"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "aiff"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "ari"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "au"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "avi"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "avif"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "bmp"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "bw"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "cin"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "cineon"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "cur"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "cut"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "dds"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "dpx"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "exr"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "gif"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "hdr"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "heic"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "heif"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "ico"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "iff"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "j2c"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "j2k"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "jp2"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "jpeg"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "jpg"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "jxl"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "jpt"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "lbm"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "lif"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "lmp"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "mdl"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "mkv"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "mov"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "movieproc"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "mp4"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "mxf"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "mraysubfile"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "openexr"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "pbm"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "pcd"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "pcx"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "pdf"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "pgm"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "pic"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "png"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "ppm"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "psd"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "qt"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "rgb"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "rgba"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "rgbe"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "rla"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "rpf"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "sgi"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "shd"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "sm"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "snd"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "stdinfb"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "sxr"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "targa"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "tdl"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "tex"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "tga"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "tif"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "tiff"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "tpic"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "tx"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "txr"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "txt"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "wal"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "wav"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "webm"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "yuv"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "z"; ValueData: ""; Tasks: openwith
Root: HKCR; Subkey: "Applications\rv.exe\SupportedTypes"; ValueType: string; ValueName: "zfile"; ValueData: ""; Tasks: openwith
