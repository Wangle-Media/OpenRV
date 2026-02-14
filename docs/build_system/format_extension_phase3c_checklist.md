# Format Extension Phase 3C Checklist (Runtime Validation + Release Gate)

This checklist is the go/no-go gate after Phase 3B dependency and OIIO wiring.

## Scope

- Validate runtime decode/open behavior for AVIF/HEIF/JXL.
- Confirm no regressions for existing still-image formats.
- Capture reproducible commands for build, smoke tests, and release notes.

---

## 1) Configure and build with HEIF/JXL enabled

Use both toggles explicitly:

- `RV_ENABLE_HEIF_JXL_DEPS=ON`
- `RV_OIIO_ENABLE_HEIF_JXL=ON`

### Windows (PowerShell)

Before building on Windows 10+, complete the platform setup in the official OpenRV docs:

- https://aswf-openrv.readthedocs.io/en/latest/build_system/config_windows.html

Important: On Windows, OpenRV is built with Microsoft Visual Studio (CMake `Visual Studio 17 2022` generator). MSYS2 MinGW64 is used to provide required Unix-style build tools.

```powershell
cmake -S C:\OpenRV -B C:\OpenRV\_build `
  -G "Visual Studio 17 2022" `
  -A x64 `
  -DRV_ENABLE_HEIF_JXL_DEPS=ON `
  -DRV_OIIO_ENABLE_HEIF_JXL=ON

cmake --build C:\OpenRV\_build --config Release --target rv
```

### Windows (MSYS2 MinGW64 shell)

Preflight in the same shell:

```bash
which cmake
which ninja
which sed
which git
```

Qt requirement:

- Use the Qt kit expected by the selected VFX/CY platform from the Windows setup guide (for CY2024/CY2025/CY2026 currently `msvc2019_64` in project docs).

If any command is missing, install prerequisites first (from MSYS2 MinGW64):

```bash
pacman -S --needed mingw-w64-x86_64-cmake mingw-w64-x86_64-ninja mingw-w64-x86_64-sed git
```

Install/verify tools in MSYS2 MinGW64 (tooling preflight):

```bash
pacman -S --needed \
  mingw-w64-x86_64-autotools \
  mingw-w64-x86_64-glew \
  mingw-w64-x86_64-libarchive \
  mingw-w64-x86_64-make \
  mingw-w64-x86_64-meson \
  mingw-w64-x86_64-toolchain \
  autoconf automake bison flex git libtool nasm p7zip patch unzip zip
```

Then run configure/build using the Visual Studio generator (PowerShell or Developer Command Prompt), not a MinGW compiler build.

### Linux/macOS (shell)

```bash
cmake -S . -B _build \
  -DRV_ENABLE_HEIF_JXL_DEPS=ON \
  -DRV_OIIO_ENABLE_HEIF_JXL=ON

cmake --build _build --config Release --target rv
```

---

## 2) Runtime smoke-test matrix

Run all three new formats and at least one baseline format.

### Required new-format checks

- AVIF sample opens and displays expected frame.
- HEIC/HEIF sample opens and displays expected frame.
- JXL sample opens and displays expected frame.

### Baseline regression checks

- EXR sample opens.
- PNG or JPEG sample opens.
- TIFF sample opens.

### Suggested sample naming convention

- `tests/media/avif/sample_avif_01.avif`
- `tests/media/heif/sample_heif_01.heic`
- `tests/media/jxl/sample_jxl_01.jxl`
- `tests/media/baseline/sample_exr_01.exr`

(Use your team’s actual sample path if different.)

---

## 3) Installer and Open With checks (Windows)

- Build installer:

```powershell
powershell -ExecutionPolicy Bypass -File .\installer\build-installer.ps1
```

- Install and confirm optional Open With registration includes:
  - `avif`
  - `heic`
  - `heif`
  - `jxl`

- Confirm task remains optional (unchecked by default).

---

## 4) Known environment blockers to clear first

If configure fails before format validation:

- Ensure `sed` is available in `PATH` for Windows build environment.
- Ensure git submodule helper tools resolve correctly in your shell.
- Re-run configure after fixing environment prerequisites.

---

## 5) Release-note template (Phase 3C validation pass)

Use this concise body once runtime validation succeeds:

- Enabled and validated HEIF/JXL decode path in OIIO-backed builds.
- Verified AVIF/HEIF/JXL open behavior and baseline still-format regressions.
- Includes rebuilt installer with optional Open With entries for AVIF/HEIC/HEIF/JXL.

---

## Exit criteria

All items below must be true:

- Build completes with both HEIF/JXL toggles ON on at least one primary platform.
- AVIF/HEIF/JXL smoke tests pass.
- Baseline EXR/PNG(JPEG)/TIFF checks pass.
- Installer path verified on Windows.
- Release notes updated with validation status and known platform limits.
