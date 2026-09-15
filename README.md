# Slide Rebuild

**面向可编辑交付的 PPT 复刻 Skill。** 将参考图片、PDF 页面或图片版 PPT 重建为原生文字、表格、结构对象与独立视觉素材，并通过真实 PowerPoint 渲染和编辑检查验收。

Slide Rebuild is an agent skill for reconstructing visual slides into editable PowerPoint files. It emphasizes source accuracy, reusable tooling, and verification in Microsoft PowerPoint.

## 公开案例

![工业储热系统 PowerPoint 实际渲染](examples/thermal-storage-demo/preview.png)

[查看原图与复刻对照](examples/thermal-storage-demo/README.md) · [下载示例 PPTX](examples/thermal-storage-demo/rebuilt.pptx) · [首次使用](docs/getting-started.md) · [可编辑范围](docs/editability.md)

示例包含原生文字、表格和连接对象；科研曲线由 MATLAB 或 Python 生成并保留源文件。参数与设备均为虚构演示。

## 能力与定位

- 准确文稿和源数据优先，OCR 只补缺项和辅助定位。
- 文字、表格、流程保持原生可编辑；科研曲线通过 MATLAB / Python 数据和脚本修改，只有明确要求 PPT 内改数据的图表才做原生 chart。
- 复杂设备、插画和场景使用独立无字图片层。
- 优先复用已有构建器、脚本和素材，不为每页重写底层逻辑。
- 区分新页与局部修改，只重测受影响项。
- 检查模块移动、连接关系及公式表示方式，关注实际编辑体验。
- 对共用工具变更使用固定样例评价，避免以对象数量或流程长度证明质量。

## 当前边界

本项目提供执行流程、验收标准和模板，**不附带一键转换引擎、自动 OCR 服务或统一 PPTX 构建器**。没有承诺像素级一致，也没有公开新旧工具效果对测数据。

公式对象、可编辑文本和公式图片分别说明；可调整曲线顶点不等于能修改图表数据。复杂视觉的内部细节不保证原生可编辑。

## 环境要求

- 能加载 Skill、读取图片、操作文件并调用已有 PPTX 构建工具的 AI agent。
- 完整验收需要 Microsoft PowerPoint 的实际打开、渲染、编辑与保存重开能力。
- 复杂素材需要分层或去字时，需可用且获授权的图像编辑工具；已有合格素材可以复用。
- 不强制使用特定图片模型、OCR 服务或其他命名 Skill。没有 PowerPoint 时可准备草稿，但必须标记相关验收未完成。

## 安装

下载本仓库，将 `skills/slide-rebuild` 整个目录复制到当前 agent 支持的 Skills 目录。Codex 用户可放入用户级 `~/.codex/skills/slide-rebuild`，重新加载后使用 `$slide-rebuild`。

保留全部 `references/`、`roles/`、`templates/`、`acceptance.md` 和 `checklist.md`，不要只复制入口文件。

## 使用示例

```text
$slide-rebuild 将这张参考图复刻成可编辑 PPT。
标题、标签、表格和流程关系保持原生可编辑；复杂设备可以使用独立图片。
完成后提供真实 PowerPoint 预览和编辑检查结果。
```

```text
$slide-rebuild 只修改已验收页面的标题和两个参数。
保留现有对象与构建源，检查受影响区域，沿用仍有效的其他验证记录。
```

默认逐页串行推进。任务已授权连续制作时，保存页面 checkpoint 后继续；用户明确要求逐页确认时才暂停。

## 文件结构

```text
skills/slide-rebuild/
  SKILL.md                    入口与执行边界
  acceptance.md               验收标准
  checklist.md                当前页检查表
  agents/openai.yaml          显式调用策略
  references/                 测量复用、交接、对测与交付方法
  roles/                      制作与复核职责
  templates/                  对象计划与素材记录模板
```

## 验证与贡献

运行 `python scripts/validate_package.py` 检查包结构、名称、内部链接和 JSON 模板。该检查不会生成 PPT，也不证明视觉质量或 PowerPoint 编辑能力。

建议使用可公开的中文密集页、表格/图表页、流程页、公式页或设备页反馈问题，并注明期望、实际结果和可复现步骤。请勿上传私人项目资料、账户凭据或未获授权素材。

## 许可证

MIT。详见 [LICENSE](LICENSE)。
