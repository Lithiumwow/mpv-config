## MPV config (English fork)

Fork of [dyphire/mpv-config](https://github.com/dyphire/mpv-config) (`eng` branch), with Windows display/HDR extras and English documentation.

### What this fork adds

| Change | Details |
| --- | --- |
| **mpv-display-plugin 1.1.0** | `scripts/display-info.dll` — exposes monitor HDR/luminance properties and can toggle Windows HDR ([upstream](https://github.com/dyphire/mpv-display-plugin/tree/1.1.0)) |
| **hdr-mode.lua** | Companion script that can auto-switch SDR/HDR using the plugin ([upstream](https://github.com/dyphire/mpv-scripts/blob/main/hdr-mode.lua)) |
| **HDR key bindings** | `SHIFT+h` toggle Windows HDR · `CTRL+ALT+h` enable · `CTRL+ALT+H` disable |
| **hdr-mode options** | `script-opts/hdr-mode.conf` (default `hdr_mode=noth`; set `switch` or `pass` to enable automation) |
| **English docs** | README rewritten in English with a clear changelog for this fork |

Requires **mpv ≥ 0.37.0** with **cplugins** enabled (standard Windows builds such as shinchiro / chocolatey `mpvio` usually include this).

### Install on this machine (chocolatey mpv)

This install uses portable config next to the binary:

`C:\ProgramData\chocolatey\lib\mpvio.install\tools\portable_config\`

That overrides `%APPDATA%\mpv`. After a chocolatey mpv upgrade, re-copy this folder if the package replaces the tools directory.

### Project introduction

Windows configuration for [mpv](https://github.com/mpv-player/mpv). Place it in the `portable_config` folder next to `mpv.exe`, **or** under `%APPDATA%\mpv\` for a global config.

`portable_config` overrides the global config.

When editing files yourself, use **UTF-8** encoding and **Unix (LF)** line endings, or mpv may fail to read them.

**Upstream integration package**: [dyphire Releases](https://github.com/dyphire/mpv-config/releases)

### mpv clients

- There is no official Windows binary; see [mpv installation](https://mpv.io/installation)
- Recommended Windows builds: [shinchiro_mpv](https://github.com/shinchiro/mpv-winbuild-cmake/releases)
- Daily builds: [zhongfly_mpv](https://github.com/zhongfly/mpv-winbuild)
- dyphire patched builds: [dyphire_mpv](https://github.com/dyphire/mpv-winbuild) — [notes](https://github.com/dyphire/mpv-config/discussions/7)
- Frontend: [mpv.net](https://github.com/mpvnet-player/mpv.net) — [dyphire mpv.net config](https://github.com/dyphire/mpv-config/tree/mpvnet)
- Browser → mpv: [mpv-handler](https://github.com/akiirui/mpv-handler) + [play-with-mpv](https://greasyfork.org/en/scripts/416271-play-with-mpv), or [Play-With-MPV](https://github.com/LuckyPuppy514/Play-With-MPV)
- Single-instance helper: [umpv](https://github.com/zhongfly/umpv-go)

### Scripts and shaders

Upstream script overview (Chinese wiki; use a translator if needed): [Script description wiki](https://github.com/dyphire/mpv-config/wiki/脚本说明)

Shader lists and profiles live in `mpv.conf`.

### Display plugin quick reference

After install, mpv exposes properties such as:

- `user-data/display-info/hdr-supported`
- `user-data/display-info/hdr-status` (`on` / `off` / `unsupported`)
- `user-data/display-info/max-luminance`, `min-luminance`, `refresh-rate`, …

Script message (also bound in `input.conf`):

```text
script-message toggle-hdr-display
script-message toggle-hdr-display on
script-message toggle-hdr-display off
```

### Preview

![image-20231103224421000](https://cdn.jsdelivr.net/gh/dyphire/PicGo/img/2023/11/03/image-20231103224421000.png)

![image-20231103224540075](https://cdn.jsdelivr.net/gh/dyphire/PicGo/img/2023/11/03/image-20231103224540075.png)

![image-20231103224557019](https://cdn.jsdelivr.net/gh/dyphire/PicGo/img/2023/11/03/image-20231103224557019.png)

| Pinyin search (supports initials) | Subtitle download |
| --- | --- |
| ![image](https://cdn.jsdelivr.net/gh/dyphire/PicGo/img/2023/11/03/image-20231103224614449.png) | ![image](https://cdn.jsdelivr.net/gh/dyphire/PicGo/img/2023/11/03/image-20231103224721066.png) |

### References

* [hooke007 configuration manual](https://hooke007.github.io/mpv-lazy/mpv.html)
* [mpv manual (English)](https://mpv.io/manual/master/)
* [Chinese mpv docs (hooke007)](https://github.com/hooke007/mpv_doc-CN)
* [mpv-display-plugin](https://github.com/dyphire/mpv-display-plugin)
