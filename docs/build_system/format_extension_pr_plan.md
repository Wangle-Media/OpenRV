# Format Support Extension PR Plan

This roadmap is structured as two small-to-medium PRs with clear blast radius.

## Goals

- Improve practical media compatibility without renderer architecture changes.
- Prioritize low-risk wins first (configuration and registration).
- Keep licensing/compliance review explicit per codec/library.

---

## Phase 1 (Low Risk): FFmpeg decoder opt-ins + extension registration

### Why first

OpenRV already builds FFmpeg and exposes knobs for disabled decoders/encoders. This is mostly configuration work and validation.

### Scope

1. Opt-in selected FFmpeg decoders in CI/build presets (decoder-only by default):
   - `prores`
   - `dnxhd`
   - `vp9`
2. Keep encoders disabled unless there is a clear requirement.
3. Extend Windows "Open with" extension registration to include modern container/file extensions already supported by decode stack:
   - `.mkv`, `.webm`, `.mxf` (and keep current list)

### File touchpoints

- `cmake/dependencies/ffmpeg.cmake`
  - Uses `RV_FFMPEG_NON_FREE_DECODERS_TO_ENABLE` and `RV_FFMPEG_NON_FREE_ENCODERS_TO_ENABLE`.
- Build preset/config entrypoint used by your team (if present in your branch/workflow).
- `packages/rv/openwith.reg`
- `installer/OpenRV.iss`

### Implementation notes

- Prefer passing decoder opt-ins from build config rather than hardcoding in `ffmpeg.cmake`.
- Keep codec toggles explicit in release notes/changelog.
- Update installer optional "Open with" task extension list to match `packages/rv/openwith.reg`.

### Validation

- Build completes on Windows/Linux/macOS with no new dependency failures.
- Smoke test opens representative files:
  - ProRes MOV
  - DNxHD/DNxHR MOV or MXF
  - VP9 WebM
- Installer Open with task remains optional and unchecked by default.

### Acceptance criteria

- No regressions for existing formats.
- New sample clips load/play in RV.
- Docs/changelog updated with the exact codec toggles.

---

## Phase 2 (Medium Risk): Add AVIF/HEIF + JPEG XL still-image support

### Why second

Requires dependency integration and OIIO wiring, which has broader build-system surface area.

### Scope

1. Integrate `libheif` (AVIF/HEIF decoding path via OIIO).
2. Integrate `libjxl` (JPEG XL decoding path via OIIO).
3. Enable corresponding OIIO options and dependency discovery in OpenRV dependency CMake.
4. Add Windows extension registration entries:
   - `.avif`, `.heic`, `.heif`, `.jxl`

### File touchpoints

- `cmake/dependencies/oiio.cmake`
- `cmake/dependencies/CMakeLists.txt`
- New dependency files (if added):
  - `cmake/dependencies/heif.cmake`
  - `cmake/dependencies/jxl.cmake`
- `packages/rv/openwith.reg`
- `installer/OpenRV.iss`

### Implementation notes

- Keep Linux/macOS/Windows dependency handling symmetrical where possible.
- Ensure transitive dependency pinning/hashes are explicit.
- If any platform cannot support one library initially, gate by platform and document it.

### Validation

- Build passes with OIIO + new deps enabled.
- Smoke test still-image decode:
  - AVIF
  - HEIC/HEIF
  - JXL
- Verify no regressions in EXR/DPX/TIFF/JPEG/PNG paths.

### Acceptance criteria

- New still formats open successfully on at least one primary platform first, then expand.
- Platform-specific limitations documented.
- Installer/Open-with extension list includes new formats.

---

## Recommended PR sequence

1. PR-1: FFmpeg decoder opt-ins + Open-with extension updates.
2. PR-2: Dependency scaffolding for `libheif`/`libjxl`.
3. PR-3: OIIO integration + format tests + docs.
4. PR-4: Runtime validation gate + release checklist (Phase 3C).

This split keeps review/rollback simple and isolates risk.

---

## Phase 3C (Validation Gate): Runtime verification + release readiness

### Why now

After dependency and OIIO wiring, runtime proof is required before treating HEIF/JXL support as stable.

### Scope

1. Build with `RV_ENABLE_HEIF_JXL_DEPS=ON` and `RV_OIIO_ENABLE_HEIF_JXL=ON`.
2. Smoke-test AVIF/HEIF/JXL decode/open behavior.
3. Verify baseline still-image regressions (EXR/PNG-or-JPEG/TIFF).
4. Confirm Windows installer/Open With behavior for `.avif/.heic/.heif/.jxl`.
5. Publish concise release notes only after validation is complete.

### Checklist

Use the operational checklist in:

- `docs/build_system/format_extension_phase3c_checklist.md`

---

## Minimal test matrix

- **Windows**: installer + sample playback/open checks.
- **Linux**: decode/playback and OIIO plugin load checks.
- **macOS**: decode/open checks and app launch sanity.

If bandwidth is limited, run full matrix for PR-1 and PR-3, reduced checks for PR-2.
