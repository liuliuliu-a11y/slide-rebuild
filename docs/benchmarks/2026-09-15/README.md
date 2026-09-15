# 同页复刻测试结果

2026-09-15，使用同一张工业储热参考页、准确文稿、独立素材和 Skill 快照，两组分别从头重建，未读取既有布局脚本和成品。

| 测试项 | GPT-6 Astra · 中 | GPT-5.6 Sol · 高 |
|---|---|---|
| 派发至收到报告 | 约 5 分 46 秒 | 约 16 分 10 秒，含中断 |
| 模型自报起止间隔 | 4 分 32 秒 | 14 分 51 秒，含中断 |
| 构建次数 | 2 | 2 |
| 定向修复次数 | 1 | 1 |
| PowerPoint 预览导出 | 4 张 | 4 张 |
| 必需内容读回 | 无缺项 | 无缺项 |
| 统一改字、改单元格、移动及保存重开 | 通过 | 通过 |
| 最终主预览 | 更接近参考，未发现阻断问题 | 控制箭头指向设备上方留白，存在阻断问题 |
| 整段换字后的字体保持 | 出现字体回退，未通过 | 出现字体回退，未通过 |
| 完整视觉与编辑质量验收 | 未完全通过 | 未完全通过 |
| Token / 费用 | 未能确认 | 未能确认 |
| 测试文件 | [PPTX](astra-medium/rebuilt.pptx) · [预览](astra-medium/preview.png) · [首轮](astra-medium/first-preview.png) | [PPTX](sol-high/rebuilt.pptx) · [预览](sol-high/preview.png) · [首轮](sol-high/first-preview.png) |
| 统一编辑证据 | [演示](astra-medium/edit-demo.png) · [检查](astra-medium/edit-checks.json) | [演示](sol-high/edit-demo.png) · [检查](sol-high/edit-checks.json) |

口径：每组仅测一页、一次运行；复用设备和科研曲线，不计生图耗时。派发时间包含启动、工具操作、自检和报告；后续统一复核不计入。Sol 曾被外部中断并续做，暂停时长未知，不能据此作严格速度排名。两组字体回退均发生于共同 COM 整段换字操作，尚不能单独归因于模型或断言手工逐字编辑也会发生。功能检查通过不代表完整视觉验收通过。

[参考页与素材](../../../examples/thermal-storage-demo/README.md) · [测试记录](results.json)
