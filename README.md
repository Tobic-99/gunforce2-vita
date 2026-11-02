# Gunforce 2 for the PS Vita

A static recompilation of Gunforce 2 (Irem, 1994, M92 arcade board) to native ARM code. The game's V33 main program is translated
to C++ and linked with a native runtime that replaces the board: memory map, interrupt controller, DMA, a software video renderer,
and the sound board (V35 with Irem's opcode encryption, YM2151 and GA20). The sound CPU runs in an interpreter.

The repository contains no game code, data or artwork. You need your own copy of the MAME ROM set `gunforc2`.

This port is intended only for owners of the game. Do not ask how to get the ROMs: piracy is not supported.

The VPK holds the translated code and nothing of the ROMs: graphics, sound and the programs' data are read from your ROM files.

How the port runs on the PS Vita: [docs/optimizations.md](docs/optimizations.md).

## Installing on the PS Vita

You need a PS Vita with HENkaku/Ensō, [VitaShell](https://github.com/TheOfficialFloW/VitaShell/releases) and `libshacccg.suprx`
(vitaGL compiles its shaders with it).

1. Install `gunforce2.vpk` from the [releases](../../releases) with VitaShell.
2. Copy your ROM files to `ux0:data/gunforce2/rom/`:
   ```
   a2-l0-a.8h  a2-h0-a.6h  a2-l1-a.8f  a2-h1-a.6f     (main program)
   a2_sl0.5l   a2_sh0.3l                               (sound program)
   a2_c0.1a    a2_c1.1b    a2_c2.3a    a2_c3.3b        (tiles)
   a2_000.8a   a2_010.8b   a2_020.8c   a2_030.8d       (sprites)
   a2_da.1l                                            (samples)
   ```
3. Start Gunforce 2.

[Controls and saves](docs/vita-controls.md).

## Building

Tested on x86-64 Linux. Every target needs Python 3, CMake 3.16+ and Ninja.

- PS Vita: [VitaSDK](https://vitasdk.org) (`VITASDK`) with the vitaGL, vitaShaRK, SceShaccCgExt and math-neon packages (`vdpm`).
- Linux: clang.

### 1. Translate

Copy the ROM files listed above to `rom/`, then:

```sh
scripts/translate.sh
```

This writes `gen/v33/`. `rom/` and `gen/` are not part of the repository.

### 2. Build

PS Vita (`build/vita/gunforce2.vpk`):

```sh
scripts/build-vita.sh
```

LiveArea images are optional and not part of the repository: `vita/sce_sys/icon0.png` (128x128),
`vita/sce_sys/livearea/contents/bg.png` (840x500) and `startup.png` (280x158) are packed when present; the PNGs must be 8-bit indexed.

Linux (`build/desktop/gf2_desktop`):

```sh
scripts/build-desktop.sh
GF2_ROOT=$PWD GF2_PNG=/some/folder GF2_PNG_EVERY=300 build/desktop/gf2_desktop 3000     # 3000 frames, a PNG every 300
```

## Credits

Licences of the linked libraries and the tools used: [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md).

- [VitaSDK](https://vitasdk.org)
- [vitaGL](https://github.com/Rinnegatamante/vitaGL), [vitaShaRK](https://github.com/Rinnegatamante/vitaShaRK) — Rinnegatamante (LGPL-3.0)
- [SceShaccCgExt](https://github.com/bythos14/SceShaccCgExt) — bythos14 (LGPL-2.1)
- [math-neon](https://github.com/Rinnegatamante/math-neon) — Lachlan Tychsen-Smith (MIT)
- [ymfm](https://github.com/aaronsgiles/ymfm) — Aaron Giles (BSD-3-Clause): YM2151 synthesis
- [MAME](https://github.com/mamedev/mame) (BSD-3-Clause drivers): hardware reference for the M92 board; the sound CPU opcode table
  (`host/gf2_v35_key.inc`) and the M92 video, DMA, GA20 and V35 interrupt behaviour (Bryan McPhail, Alex W. Jackson, Acho A. Tang,
  R. Belmont, Valley Bell; [LICENSE-MAME.txt](LICENSE-MAME.txt)). MAME was also the reference for checking pictures and sound.
- [psp2-tooling](https://github.com/Grarak/psp2-tooling) — Grarak (GPL-3.0): testing and measuring on a PS Vita
- [Vita3K](https://github.com/Vita3K/Vita3K) (GPL-2.0): desktop tests of the PS Vita build

## License

The code in this repository is licensed under the GNU General Public License v3.0 (`LICENSE`), copyright Tobic-99, except the MAME
opcode table and the hardware behaviour taken from MAME's drivers (BSD-3-Clause, `LICENSE-MAME.txt`) and ymfm (BSD-3-Clause,
`third_party/ymfm/LICENSE`). Third-party components keep their own licences. Gunforce 2, its name and its artwork are the property of
their rights holders; no ROM data is included.
