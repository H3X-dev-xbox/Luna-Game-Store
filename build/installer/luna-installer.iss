; ═══════════════════════════════════════════════════════════
; LUNA GAME STORE — Inno Setup Installer Script
; Compiles into LunaGameStore-Setup.exe
; Requires: Inno Setup 6+ (https://jrsoftware.org/isdl.php)
; ═══════════════════════════════════════════════════════════

#define MyAppName "Luna Game Store"
#define MyAppShortName "Luna"
#define MyAppVersion "0.1.0"
#define MyAppPublisher "H3X-dev-xbox"
#define MyAppURL "https://h3x-dev-xbox.github.io/luna-website/"
#define MyAppExeName "LunaGameStore.exe"
#define MyAppDescription "A modern, galaxy-themed PC game launcher powered by FitGirl Repacks."
#define MyAppCopyright "© 2026 H3X-dev-xbox. All Rights Reserved."

[Setup]
; ─── App Identity ────────────────────────────────────────
AppId={{8F4C7D2A-9B3E-4F1A-A6D5-C7E9B2F3A1D8}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}

; ─── Installation Directory ──────────────────────────────
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
AllowNoIcons=yes

; ─── Output ──────────────────────────────────────────────
OutputDir=..\..\dist
OutputBaseFilename=LunaGameStore-Setup-{#MyAppVersion}
Compression=lzma2/ultra64
SolidCompression=yes
LZMANumBlockThreads=4

; ─── Icon ────────────────────────────────────────────────
SetupIconFile=..\..\src\assets\logo.ico
UninstallDisplayIcon={app}\{#MyAppExeName}

; ─── Windows Version Requirements ────────────────────────
MinVersion=10.0.17763
ArchitecturesInstallIn64BitMode=x64compatible
ArchitecturesAllowed=x64compatible

; ─── Privileges ──────────────────────────────────────────
; "lowest" lets users install without admin rights, into their user folder
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog

; ─── Visual Style ────────────────────────────────────────
WizardStyle=modern
WizardSizePercent=120
DisableWelcomePage=no
DisableDirPage=no
DisableReadyPage=no

; ─── License & Info ──────────────────────────────────────
; Uncomment if you have a license text file users must accept
; LicenseFile=..\..\LICENSE
InfoBeforeFile=..\..\README.md

; ─── Uninstaller ─────────────────────────────────────────
UninstallDisplayName={#MyAppName}
CreateUninstallRegKey=yes
Uninstallable=yes

; ─── Version Info Metadata ───────────────────────────────
VersionInfoVersion={#MyAppVersion}
VersionInfoCompany={#MyAppPublisher}
VersionInfoDescription={#MyAppDescription}
VersionInfoCopyright={#MyAppCopyright}
VersionInfoProductName={#MyAppName}
VersionInfoProductVersion={#MyAppVersion}

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
; Desktop shortcut (optional — user can uncheck)
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 6.1; Check: not IsAdminInstallMode

[Files]
; ─── Main Executable ─────────────────────────────────────
Source: "..\..\dist\LunaGameStore.exe"; DestDir: "{app}"; Flags: ignoreversion

; ─── Optional: bundled assets if you ship them separately ─
; (PyInstaller's single-file mode bundles everything, so this
; section is usually just the .exe. If you use folder mode,
; uncomment the line below and add the files.)
; Source: "..\..\dist\LunaGameStore\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
; ─── Start Menu ──────────────────────────────────────────
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"

; ─── Desktop Shortcut (if task checked) ──────────────────
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

; ─── Quick Launch (legacy) ───────────────────────────────
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: quicklaunchicon

[Run]
; ─── Launch after install ────────────────────────────────
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
; ─── Clean up leftover files on uninstall ────────────────
Type: filesandordirs; Name: "{app}\assets"
Type: files; Name: "{app}\version.json"
Type: filesandordirs; Name: "{localappdata}\{#MyAppName}"

[Registry]
; ─── File Association (optional) ─────────────────────────
; Registers a custom URI scheme like "luna://" so the website
; can trigger the launcher later. Uncomment to enable.
;
; Root: HKA; Subkey: "Software\Classes\luna"; ValueType: string; ValueName: ""; ValueData: "URL:Luna Protocol"; Flags: uninsdeletekey
; Root: HKA; Subkey: "Software\Classes\luna"; ValueType: string; ValueName: "URL Protocol"; ValueData: ""
; Root: HKA; Subkey: "Software\Classes\luna\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName},0"
; Root: HKA; Subkey: "Software\Classes\luna\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""

[Code]
// ═══════════════════════════════════════════════════════════
// PASCAL SCRIPT — Custom installer logic
// ═══════════════════════════════════════════════════════════

// ─── Check if app is already running ──────────────────────
function InitializeSetup(): Boolean;
begin
  Result := True;
end;

// ─── Detect existing installation ─────────────────────────
function GetUninstallString(): String;
var
  sUnInstPath: String;
  sUnInstallString: String;
begin
  sUnInstPath := ExpandConstant('Software\Microsoft\Windows\CurrentVersion\Uninstall\{#emit SetupSetting("AppId")}_is1');
  sUnInstallString := '';
  if not RegQueryStringValue(HKLM, sUnInstPath, 'UninstallString', sUnInstallString) then
    RegQueryStringValue(HKCU, sUnInstPath, 'UninstallString', sUnInstallString);
  Result := sUnInstallString;
end;

// ─── Uninstall previous version if present ────────────────
function IsUpgrade(): Boolean;
begin
  Result := (GetUninstallString() <> '');
end;

// ─── Custom welcome message ───────────────────────────────
procedure InitializeWizard();
begin
  WizardForm.WelcomeLabel2.Caption :=
    'Welcome to the Luna Game Store installer!' + #13#10 + #13#10 +
    'Luna is a modern, galaxy-themed PC game launcher ' +
    'powered by FitGirl Repacks.' + #13#10 + #13#10 +
    'This wizard will install Luna on your computer.' + #13#10 + #13#10 +
    'Click Next to continue.';
end;

// ─── Prevent running while Luna is open ───────────────────
function PrepareToInstall(var NeedsRestart: Boolean): String;
var
  ResultCode: Integer;
begin
  Result := '';
  // If Luna is running, ask user to close it first
  // (Custom check — Inno Setup can't easily detect running processes natively)
end;
