# -*- mode: python ; coding: utf-8 -*-
# ═══════════════════════════════════════════════════════════
# LUNA GAME STORE — PyInstaller Spec
# Bundles src/main.py into a single Windows .exe
# ═══════════════════════════════════════════════════════════

import os
import sys
from pathlib import Path

# ─── Paths ────────────────────────────────────────────────
# SPECPATH is set by PyInstaller to the folder containing this spec file
SPEC_DIR = Path(SPECPATH).resolve()
ROOT_DIR = SPEC_DIR.parent          # repo root (one level up from build/)
SRC_DIR = ROOT_DIR / "src"
ASSETS_DIR = SRC_DIR / "assets"
VERSION_FILE = ROOT_DIR / "version.json"

# ─── Read version info ────────────────────────────────────
import json
try:
    with open(VERSION_FILE, "r", encoding="utf-8") as f:
        VERSION = json.load(f).get("version", "0.0.0")
except Exception:
    VERSION = "0.0.0"

# ─── Data files to bundle into the .exe ───────────────────
# Format: (source_path, destination_folder_inside_bundle)
datas = [
    # Assets (logo, icons, fonts)
    (str(ASSETS_DIR), "assets"),

    # Version metadata
    (str(VERSION_FILE), "."),
]

# ─── Hidden imports ───────────────────────────────────────
# PyInstaller sometimes misses dynamic imports. List them here.
hiddenimports = [
    "customtkinter",
    "PIL._tkinter_finder",
    "py7zr",
    "py7zr.callbacks",
]

# ─── Excluded modules (keep the .exe small) ───────────────
excludes = [
    # Testing
    "pytest",
    "coverage",
    "pytest_cov",

    # Dev tools
    "black",
    "ruff",
    "mypy",
    "pre_commit",
    "pip_tools",
    "dotenv",

    # Unused Python stdlib bloat
    "tkinter.test",
    "test",
    "unittest",
    "pydoc_data",
    "lib2to3",
    "distutils",
    "setuptools",
    "pip",

    # Scientific stack (not needed)
    "numpy",
    "scipy",
    "pandas",
    "matplotlib",

    # Heavy web frameworks (never used)
    "flask",
    "django",
    "fastapi",
    "starlette",
    "uvicorn",

    # Jupyter stuff
    "IPython",
    "jupyter",
    "notebook",
]

# ═══════════════════════════════════════════════════════════
# BUILD CONFIGURATION
# ═══════════════════════════════════════════════════════════

block_cipher = None

a = Analysis(
    # Entry point of the app
    [str(SRC_DIR / "main.py")],

    # Where PyInstaller looks for imports
    pathex=[str(SRC_DIR), str(ROOT_DIR)],

    binaries=[],
    datas=datas,
    hiddenimports=hiddenimports,
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=excludes,

    # Strip debug symbols for a smaller .exe
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,

    # Don't follow symlinks on Windows
    noarchive=False,
)

pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

# ─── Single-file EXE ──────────────────────────────────────
exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.zipfiles,
    a.datas,

    # ── Options ──
    [],
    name="LunaGameStore",
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,               # Compress with UPX if available
    upx_exclude=[
        "vcruntime140.dll",
        "python3.dll",
        "python311.dll",
    ],
    runtime_tmpdir=None,

    # ── Windows-specific ──
    console=False,          # No terminal window (GUI app)
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,

    # ── Icon ──
    icon=str(ASSETS_DIR / "logo.ico"),
)

# ═══════════════════════════════════════════════════════════
# ALTERNATIVE: Folder mode (faster startup, larger folder)
# Uncomment this block and comment the EXE block above if you
# prefer a folder with LunaGameStore.exe inside instead of a
# single bundled file.
# ═══════════════════════════════════════════════════════════

# exe = EXE(
#     pyz,
#     a.scripts,
#     [],
#     exclude_binaries=True,
#     name="LunaGameStore",
#     debug=False,
#     bootloader_ignore_signals=False,
#     strip=False,
#     upx=True,
#     console=False,
#     icon=str(ASSETS_DIR / "logo.ico"),
# )
#
# coll = COLLECT(
#     exe,
#     a.binaries,
#     a.zipfiles,
#     a.datas,
#     strip=False,
#     upx=True,
#     upx_exclude=[],
#     name="LunaGameStore",
# )
