# Phase 10 社区与扩展技术设计

## 1. 目标
建立开放协作基础：贡献指南、Issue/PR 模板、后续功能路线图；降低外部贡献门槛并保持一致性。

## 2. 范围
- CONTRIBUTING 文档与行为准则引用
- ISSUE_TEMPLATE / PULL_REQUEST_TEMPLATE
- 标签体系：`feature`, `bug`, `good-first-issue`, `docs`, `performance`
- 路线图列出潜在扩展（照片、里程碑事件、自定义单位、提醒通知）

## 3. 路线图示例
| 功能 | 描述 | 优先级 |
|------|------|--------|
| 事件里程碑记录 | 翻身/走路等发展事件 | 中 |
| 照片附件与时间轴 | 记录伴随照片 | 中 |
| 自定义单位 | 英制/公制切换 | 低 |
| 提醒录入 | 定期推送未更新提示 | 中 |
| 数据分析报告 | 自动生成周/月总结 | 低 |

## 4. 模板结构
Issue 模板字段：
- 描述
- 预期行为
- 当前行为 / 截图
- 复现步骤
- 环境（版本/设备）

PR 模板字段：
- 变更概述
- 关联 Issue
- 测试说明
- 截图（UI 变更）
- Checklist（格式化通过 / 测试通过 / 无新警告）

## 5. 任务拆分
- [ ] 添加 CONTRIBUTING.md
- [ ] 创建 `.github/ISSUE_TEMPLATE/feature.md` 等
- [ ] 创建 `.github/PULL_REQUEST_TEMPLATE.md`
- [ ] 更新 README 链接路线图
- [ ] 添加标签建议（文档中说明）

## 6. 测试与验证
| 测试 | 内容 |
|------|------|
| reviewContributingClarity | 文档是否明确安装/运行步骤 |
| issueTemplateFields | 模板字段完整性 |
| prChecklistCompleteness | PR 模板包含质量校验项 |

## 7. 风险与缓解
| 风险 | 影响 | 缓解 |
|------|------|------|
| 模板过长劝退贡献者 | 降低参与 | 简洁分级，必填与可选分开 |
| 路线与当前实现偏离 | 期望冲突 | 定期（每发布一次）复审路线图 |

## 8. 可选扩展
- 自动生成变更日志脚本
- GitHub Actions：标签自动分配

## 9. 完成标准
- 模板文件存在且语义清晰
- README 引用路线图与贡献文档
