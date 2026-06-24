# CS2 Demo POV 录制工具

使用 [HLAE](https://www.advancedfx.org/) + FFmpeg 录制 CS2 Demo 回放的高画质 POV 视角视频。支持 CPU/GPU 多编码器预设，一键切换录制模式。

> FFmpeg 录制预设由 [Purp1e 紫](https://space.bilibili.com/73115492) 制作 (v2.6e)

## 📁 文件结构

```
├── pov.vpk          # POV 视角模型/材质包
├── hlae.cfg         # HLAE 录制配置（运镜、通道、按键绑定）
├── ffmpeg.cfg       # FFmpeg 编码预设（CPU / NVIDIA / AMD / Intel）
├── merge.bat        # 合并 raw.mp4 + audio.wav → output.mp4
└── README.md
```

## 🛠 环境准备

| 依赖 | 说明 |
|------|------|
| [HLAE](https://www.advancedfx.org/download/) | Half-Life Advanced Effects，安装后需在其目录下安装 FFmpeg |
| FFmpeg | 通过 HLAE 安装包自带的一键安装即可 |
| CS2 游戏本体 | 需要能正常播放 Demo |

## 🚀 安装步骤

### 1. 安装 HLAE 与 FFmpeg

下载并安装 HLAE，使用 HLAE 安装包内的工具一键安装 FFmpeg 到 HLAE 目录下（路径应为 `<HLAE目录>\ffmpeg\bin\ffmpeg.exe`）。

### 2. 放置 CFG 文件

将 `hlae.cfg` 和 `ffmpeg.cfg` 复制到 CS2 的 cfg 目录：

```
<CS2安装目录>\game\csgo\cfg\
```

### 3. 放置 VPK 文件

将 `pov.vpk` 放到 cfg 的上一级目录：

```
<CS2安装目录>\game\csgo\pov.vpk
```

### 4. 修改 gameinfo.gi

编辑 `<CS2安装目录>\game\csgo\gameinfo.gi`，在 `SearchPaths` 中添加 `csgo/pov.vpk` 挂载行：

```
FileSystem
{
    SearchPaths
    {
        Game_LowViolence   csgo_lv // Perfect World content override

        Game    csgo/pov.vpk        // ← 添加这一行
        Game    csgo
        Game    csgo_imported
        Game    csgo_core
        Game    core

        Mod     csgo
        Mod     csgo_imported
        Mod     csgo_core

        AddonRoot           csgo_addons
        OfficialAddonRoot   csgo_community_addons

        LayeredGameRoot     "../game_otherplatforms/etc" [$MOBILE || $ETC_TEXTURES]
        LayeredGameRoot     "../game_otherplatforms/low_bitrate" [$MOBILE]
    }

    "UserSettingsPathID"   "USRLOCAL"
    "UserSettingsFileEx"   "cs2_"
}
```

> ⚠️ 只需添加 `Game    csgo/pov.vpk` 一行，不要改动其他内容。

## 🎬 使用方法

### 录制流程

1. **启动 CS2**，在控制台中 `playdemo <demo名称>` 播放回放
2. **加载配置**：依次执行
   ```
   exec hlae
   exec ffmpeg
   ```
3. **选择编码模式**：输入对应指令切换预设（如 `c1`、`n1`，详见下方预设表）
4. **控制录制**：
   - 按 **↑（上箭头）** → 开始录制 + 恢复播放
   - 按 **↓（下箭头）** → 暂停 Demo + 结束录制

### 合并音视频

录制完成后，将生成的 `raw.mp4`（视频）和 `audio.wav`（音频）放到 `merge.bat` 同级目录下，双击运行即可合并为 `output.mp4`。

> 如果 FFmpeg 路径不是 `C:\Program Files (x86)\HLAE FFMPEG\ffmpeg\bin\ffmpeg.exe`，请编辑 `merge.bat` 修改 `FFMPEG` 变量。

## 🎞 编码预设速查

### 通用说明

| 后缀 | 含义 |
|------|------|
| 无后缀 | 默认 YUV 4:2:0 |
| `p` | YUV 4:4:4（更高色彩保真度） |
| `s` | 拉伸至 16:9 |

### ProRes（Apple ProRes，CPU 编码）

| 指令 | 说明 |
|------|------|
| `p0` | ProRes 4444（最高质量） |
| `p0a` | ProRes 4444 + 8bit Alpha 通道 |
| `phq` | ProRes 422 HQ |
| `p1` / `p1s` | ProRes 422 |
| `p2` / `p2s` | ProRes LT |
| `p3` / `p3s` | ProRes Proxy（最低码率） |

### CPU 编码（libx264 / libx265）

| 指令 | 编码器 | 画质 |
|------|--------|------|
| `c0` / `c0p` | x264 无损 | 无损 |
| `c1` / `c1p` / `c1s` | x264 高画质 | 高 **(推荐)** |
| `c2` / `c2p` | x264 中画质 | 中 |
| `he0` / `he0p` | x265 无损 | 无损 |
| `he1` / `he1p` / `he1s` | x265 高画质 | 高 |
| `he2` / `he2p` | x265 中画质 | 中 |

### NVIDIA GPU 加速

| 指令 | 编码器 | 画质 |
|------|--------|------|
| `n0` / `n0p` | HEVC NVENC 无损 | 无损 |
| `n1` / `n1p` / `n1s` | HEVC NVENC 高画质 | 高 **(推荐)** |
| `n2` / `n2p` | HEVC NVENC 中画质 | 中 |
| `nav1` / `nav1s` | AV1 NVENC 高画质 | 高 (RTX 40 系) |

### AMD GPU 加速

| 指令 | 编码器 | 画质 |
|------|--------|------|
| `a0` | HEVC AMF 无损 | 无损 |
| `a1` / `a1s` | HEVC AMF 高画质 | 高 **(推荐)** |
| `a2` | HEVC AMF 中画质 | 中 |

### Intel GPU 加速

| 指令 | 编码器 | 画质 |
|------|--------|------|
| `i0` | HEVC QSV 无损 | 无损 |
| `i1` / `i1s` | HEVC QSV 高画质 | 高 **(推荐)** |
| `i2` | HEVC QSV 中画质 | 中 |

### 无损图片序列

| 指令 | 说明 |
|------|------|
| `tga` | .tga 无损图片序列 |

> 💡 切换预设只需在控制台输入指令即可，如 `c1`、`n1`。默认预设为 `c1`（x264 高画质）。

## ⌨ 按键绑定（hlae.cfg）

| 按键 | 功能 |
|------|------|
| **↑**（上箭头） | 开始 HLAE 录制 + 恢复 Demo 播放，打印通道与帧率 |
| **↓**（下箭头） | 暂停 Demo + 结束 HLAE 录制 |

## 🔧 HLAE 录制参数（hlae.cfg）

| 参数 | 值 | 说明 |
|------|-----|------|
| 录制 FPS | 240 | 可在 `mirv_streams record fps` 修改 |
| 录制路径 | `D:\record` | 修改 `mirv_streams record name` 的值 |
| 默认 FOV | 90 | `mirv_input fov` |
| 运动镜头 | 开启 | `mirv_campath enabled 1` |
| ReShade | 开启 | `mirv_reshade enabled 1` |
| 录制通道 | raw + depth | 原始层 + 深度层 |

## ⚠️ 注意事项

1. **显卡编码**：使用 GPU 加速编码时，显卡驱动版本需与 FFmpeg 版本匹配。如出现录制错误，请更新驱动或回退 FFmpeg 版本。
2. **后台不掉帧**：`ffmpeg.cfg` 中已设置 `engine_no_focus_sleep 0`，窗口失焦时游戏不会降帧。
3. **完美世界服**：`gameinfo.gi` 中需保留 `Game_LowViolence csgo_lv` 行（国服特供内容覆盖）。

## 📜 致谢

- FFmpeg 录制预设 (v2.6e) by [Purp1e 紫](https://space.bilibili.com/73115492)
- [HLAE (Half-Life Advanced Effects)](https://www.advancedfx.org/)
