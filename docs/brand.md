# Oi brand guide

Oi 的品牌应该像一句在终端里轻轻喊出的招呼：短、直接、有一点疲惫，但仍然可靠。

本页描述仓库门面使用的原创视觉系统。它服务于 Oi 语言与 Oi plugin，不是对任何现有动画角色的再创作。

## License and brand boundary

除非文件或目录另有说明，仓库源代码、文档和视觉资产采用根目录的 [MIT License](../LICENSE)。该许可证不授予 `Oi` 名称、logo 或吉祥物的商标/品牌使用权，也不表示与 Google、Go 项目或其他第三方存在关联。

## Core assets

| Asset | Use |
| --- | --- |
| [`oi-mascot.png`](../assets/brand/oi-mascot.png) | 定稿的 1:1 Oi 吉祥物；GitHub 组织/仓库头像的首选位图 |
| [`oi-wordmark.svg`](../assets/brand/oi-wordmark.svg) | README、文档封面和较宽的品牌入口 |
| [`oi-readme-hero.png`](../assets/brand/oi-readme-hero.png) | README 顶部的宽幅吉祥物工作场景 |
| [`oi-social-preview.png`](../assets/brand/oi-social-preview.png) | GitHub social preview 或需要位图的分享卡片 |

`oi-wordmark.svg` 是字标的可审阅矢量源；三项 PNG 按各自列出的固定场景使用，不应互相放大、裁切或替代。

## Identity

Oi 的吉祥物是一个原创的“执行胶囊/小终端”：它代表 Agent 完成又一个任务后的平静疲惫。定稿形象是 1:1、矮宽、圆钝的橙色胶囊，内部用一个圆形 aperture 和一个竖向 slot 暗示 `oi`，配以黄色状态面板和薄荷色侧板；不再使用头顶光标。

它不需要在每个页面出现。正式文档、命令参考和代码示例优先使用 `oi-wordmark.svg` 或纯文字 `Oi`；GitHub 头像使用 `oi-mascot.png`，README hero 和社交卡片分别使用各自的定稿位图。

## Palette

| Name | Hex | Recommended use |
| --- | --- | --- |
| Ink | `#17191F` | 正文、轮廓、深色背景 |
| Coral | `#F26B4F` | 吉祥物主色、主要强调 |
| Warm yellow | `#FFC857` | 状态条、次要强调 |
| Paper | `#F7F2EA` | 背景、留白、浅色卡片 |
| Mint accent | `#7ED8C7` | 少量状态、链接或执行提示 |

字标不依赖渐变才能成立。渐变、纸张纹理和投影只允许出现在 hero 或 social preview 的氛围层，不应加入仓库头像。

## Sizing and usage

- `oi-wordmark.svg` 在横向空间至少保留 220px 宽；更窄时使用纯文字 `Oi`。
- `oi-mascot.png` 保持 1:1 比例，不裁掉胶囊轮廓或状态面板。
- `oi-readme-hero.png` 保持原始宽高比，不从中裁切头像或图标。
- `oi-social-preview.png` 只用于分享卡片，不替代仓库头像或 README hero。

## Copy and naming

- 正式名称写作 `Oi`，不要默认写成 `OI`。
- 工程命名使用 `oi` 或 `oi-lang`，例如 `.oi`、`plugins/oi/` 和 `github.com/oi-language/oi`。
- 品牌句为 `Oi oi oi.`；感叹号可以出现在宣传语中，但不是名称的一部分。
- 推荐定位句：`An agent-native language for writing and running Agent Skills.`

## Originality rules

“疲惫、呆滞、荒诞”的情绪可以延续，但形体必须原创。任何新插画、表情或贴纸都必须遵守：

- 不描绘或临摹用户提供的原角色。
- 不复用其虫形身体、横向条纹、三根触角、身体比例或具体五官关系。
- 不让第三方角色、商标、随机文字或水印进入 Oi 资产。
- 不把 AI 生成的位图当作 logo 的唯一源文件；新的正式标志必须回写为可审阅的 SVG。

如果一个新版本在缩小后仍然能被认作某个已知角色，应退回到“执行胶囊/终端”这一抽象层重新设计。

## Examples

推荐：

```markdown
<img src="assets/brand/oi-wordmark.svg" alt="Oi" width="380">
```

不推荐：

- 把 3D 或带纹理的 social preview 用作仓库头像。
- 直接从 meme 截图裁剪出头像，或以相似身体比例重绘原角色。
