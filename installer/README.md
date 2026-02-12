# OpenRV Windows packaging

This repo’s build produces a self-contained staged app tree in:

- `OpenRV/_build/stage/app/`

## Option A: Portable ZIP

From PowerShell at the repo root:

```powershell
.\installer\make-portable-zip.ps1
```

Output:
- `OpenRV/dist/OpenRV-portable.zip`

## Option B: Windows installer (Inno Setup)

1. Install **Inno Setup 6**.
2. Build OpenRV (so `_build/stage/app` exists).
3. From PowerShell at the repo root:

```powershell
.\installer\build-installer.ps1
```

Output:
- `OpenRV/dist/OpenRV-Setup.exe`

The installer:
- Installs the staged tree under `Program Files`.
- Creates a Start Menu shortcut (and optional Desktop icon).
- Registers `rvlink://` and adds an `App Paths` entry for `rv.exe`.

During install there is also an optional (unchecked) task to register RV in Windows **"Open with…"** for common media types. This does not force RV as the default app for those extensions.
