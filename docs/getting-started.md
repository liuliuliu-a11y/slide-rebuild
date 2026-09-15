# 第一次使用

## 1. 安装整个 Skill 目录

按仓库首页说明，将 `skills/slide-rebuild` 完整复制到 agent 的 Skills 目录。确认加载到的是 `$slide-rebuild`，而不是仅打开了一份 Markdown 文件。

## 2. 准备参考与内容

提供参考图片、PDF 页或图片版 PPT。若有准确文稿、表格数据、MATLAB / Python 绘图源，也一并提供；不必为了复刻先把正确文字转成 OCR。

## 3. 说明编辑范围

```text
$slide-rebuild 复刻这张参考页。
文字、参数表和流程关系在 PowerPoint 内可编辑。
科研曲线使用 MATLAB 或 Python 绘制，保留数据和脚本。
设备插画作为独立图片，保持原构图。
完成后提供 PPTX、真实 PowerPoint 预览及编辑边界说明。
```

需要逐页批准时加一句“每页完成后先给我确认”；否则按已授权范围连续串行推进。

## 4. 查看交付

- 打开 PPT，检查文字、表格和关系是否齐全。
- 对照真实 PowerPoint 预览与参考图，检查字体、换行和位置。
- 试改文字或表格、移动一个模块，检查标签和连接是否保持。
- 科研曲线通过随附数据与脚本重绘；不要期待图片自动拥有 PPT 数据编辑菜单。

缺少 PowerPoint 时可以得到构建结果，但真实打开、渲染及编辑验收必须注明尚未完成。

## 5. 用公开案例体验

下载[示例 PPT](../examples/thermal-storage-demo/rebuilt.pptx)，对照[原始参考](../examples/thermal-storage-demo/reference.png)和[实际渲染](../examples/thermal-storage-demo/preview.png)。重绘和构建命令见[示例说明](../examples/thermal-storage-demo/README.md)。

现有脚本只重建该固定示例，不是输入任意图片即可自动转换的引擎。
