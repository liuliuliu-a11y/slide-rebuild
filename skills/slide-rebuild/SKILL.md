---
name: slide-rebuild
description: >-
  Rebuild an explicitly requested image/PDF page as editable PowerPoint, or consume a generated-page brief after the user-authorized image-first workflow has frozen the full image deck. Reuse existing build tools, reconstruct one page at a time, and verify fidelity and practical editability in PowerPoint. Standalone invocation remains explicit-only.
---

# Slide Rebuild

将参考页重建为便于修改的 PPT。质量由内容准确、视觉还原和实际编辑表现证明，不由脚本数量、对象数量或检查轮次证明。优先复用工具、对象计划、素材和有效证据；每页只补本页不同的内容。

## 入口与范围

- 独立入口：用户明确要求 PPT 复刻或点名本 Skill。`external-reference` 接收图片、PDF、整页贴图 PPT；先复用原始文字/数据，否则核对读图与 OCR。
- 父流程入口：已授权的图像先行流程交接 `generated-page`。先读 [generated-page-handoff.md](references/generated-page-handoff.md)，整套图片检查和冻结通过后才复刻。准确任务书是内容权威，冻结图是视觉参考；OCR 不覆盖已确认文稿与数据。
- generated-page 继承上游的准确文稿、冻结图与真实生成/来源记录，不强制依赖特定提示词 Skill 或图片型号，不重做整页图。外部参考无需补做上游生图。
- 复刻阶段只允许一个 active page。完整制作已获授权时连续串行；用户要求逐页确认时才暂停。checkpoint 存档不增加批准环节。
- 已有可编辑 PPT 的局部修改优先保留原对象与原构建源，沿原生编辑路线执行，不重新识图复刻整页。

## 环境要求

宿主需能读图、读写本地文件并使用现有 PPTX 构建工具；本包不附带转换引擎或 OCR 服务。完整验收需要可实际打开、渲染和编辑文件的 Microsoft PowerPoint。缺少 PowerPoint 时可保留草稿并说明未能确认，不能用代码预览或其他渲染器冒称完整验收。需要复杂视觉分层时使用宿主可用且获授权的图像编辑工具；合格素材可直接复用。

## 资料分工

- [acceptance.md](acceptance.md)：对象、视觉、编辑与分级验收的唯一标准。
- [checklist.md](checklist.md)：当前页执行检查，不增加阈值。
- [reuse-and-measurement.md](references/reuse-and-measurement.md)：首次确定构建路线、文字测量、分组与局部修改时读取；复用已确定配置。
- [benchmark-evaluation.md](references/benchmark-evaluation.md)：用户要求工具对测，或实际修改共用构建/渲染工具时读取；日常单页制作不运行整组基准。
- [page-object-plan.md](templates/page-object-plan.md)：缺少页面对象计划时按需使用；已有上游 brief/manifest 可直接映射，不复制填表。

角色职责：[controller](roles/controller.md) 管理当前页与证据复用；[planner](roles/planner.md) 补对象映射；[builder](roles/builder.md) 制作修复；[reviewer](roles/reviewer.md) 只读复核。角色分工不要求为每个角色生成一套重复记录。

## 不可降低的对象边界

| 内容 | 最终对象 |
|---|---|
| 标题、正文、数字单位、标签、图例、脚注、署名日期 | 原生文本 |
| 表格 | PowerPoint table object |
| 需要数据编辑的图表 | 原生 chart 及可编辑数据，不能从生图猜值 |
| 流程框、容器、结构分区、主要连接线与箭头 | 原生形状/连接对象 |
| 公式 | 尽可能可编辑，区分公式对象、文本表达、图片；限制明示 |
| 设备、无字图标、复杂插画、场景 | 独立无字图片层 |
| Logo、指定真实素材 | 优先复用获授权原始资产 |

禁止整页贴图、带字底图叠重复文字、文字轮廓或 PNG 包 SVG 冒充可编辑。SVG 可作中间源，最终按 PPT 对象验收。原生形状用于结构，不手拼设备/图标替代选定的图像视觉。用户认可的主视觉必须保留，简化范围在任务书中明确。

## Frozen Page Brief

复用现有任务书，只补缺项：

- page_id、page_type、source_mode、参考版本与尺寸；generated-page 的父冻结记录。
- 准确文字/源数据/关系、必须可编辑对象、允许图片层、保真与接受简化。
- 构建路线、复用工具或构建源及其版本；文字测量依据、对象 ID/分组与布局风险。
- 输出/预览/工作资产目录、现有素材回执、page_control。
- 本轮变更对象及验收范围；复用证据的适用范围与失效条件。

常规细节合理判断后推进；只对改变事实、目标、成本或必要授权的缺项提问，独立工作继续。

## 单页执行闭环

1. **复用与选路**：检查本任务已有脚本/原生文件/资产；文字表格流程页优先现有原生构建能力，复杂视觉页使用混合分层。工具实际可用性未验证时标为候选，不声称已经接入统一构建器或 OCR。
2. **测量与映射**：按准确文稿建立稳定对象 ID，估计文字框、字号层级、间距和结构位置。已有源数据/文稿直接使用，读图与测量不改事实。
3. **制作**：复用构建器或原构建源，更新本页内容、坐标、样式和素材。保留可重复构建源；新增通用工具仅在当前任务确有必要时实施并验证，不因单页任务自动开发平台。
4. **实际验证**：最终 PPT 经 PowerPoint 渲染；按 acceptance.md 核验内容、视觉和对象，并完成适用的副本编辑保存重开。新页建立页面基线；后续小改只重测受影响项，既有证据的延续依据必须明确。
5. **只读复核**：按本 Skill 调用 reviewer 子代理（宿主允许时）；否则单独复核并标明 fallback，不能把自查虚称独立签收。Blocking 修复后复测；Polish 不触发无收益的循环重建。
6. **checkpoint**：保存当前 PPTX、真实预览、构建/资产索引、QA 与差距。连续授权时进入下一张已冻结页；合并只用验收页，保留原生对象/媒体/数据关系，再做整套实际打开渲染和关系核验。

## 资产与留痕

需要去字、分层、修图时先查看参考，再用宿主允许的图像编辑工具，保持构图、比例、视角和设备身份。已有合格独立资产及真实回执允许复用；不机械重复生图。局部裁切/清理服从宿主工具约束。

使用 [image_asset_manifest_template.json](templates/image_asset_manifest_template.json) 或等价已有记录，保留来源、回执、实际使用文件、尺寸/PPI、边缘/无字检查和 contact sheet。未返回实际模型时记录 null / 未能确认；严格型号要求缺证据不能通过。默认每项一次生成加至多两次定向修复，既有预算优先。

PPTX/交付预览放 output；构建源、计划、资产、回执与 QA 放对应项目/work。工具原图保留，使用素材有项目内副本。沿用已有目录，不复制大型材料；正式页面和备注不含内部路径、命令和制作记录。

## 交付

报告文件与预览位置、原生对象/公式及数据编辑边界、图片层、实际渲染与适用编辑测试、剩余差距及 checkpoint。区分本轮新验证和沿用的有效证据。按 [交付检查](references/delivery-checks.md) 核对文件与内容，并报告真实验证结果；不依赖另一套本机 Skill。

未满足项归为来源/材料/工具阻塞、已接受简化或尚未实现。规则修改、静态校验、基准方案或单页成功，均不能冒充新工具已部署、视觉质量提升或整套 PPT 验收完成。
