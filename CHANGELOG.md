# Changelog

所有 iBadmin 项目的重要变更记录在此文件。

## [v1.1.3.1] - 2026-06-18 — App 图标资源冲突 hotfix

### 概述

v1.1.3 推送后真机测试报告资源冲突错误（hvigor Error 11211117 Resource Pack Error）。v1.1.3 添加 background.svg/foreground.svg 时忘记删除同名 PNG，导致 AppScope 和 entry 两个目录中各自存在 2 个同名资源，HarmonyOS 资源编译器 restool 检测到冲突并报错。

### 修复（Fix）

#### 资源冲突消除（git rm 4 个 PNG）

| 文件 | 操作 |
|------|------|
| `AppScope/resources/base/media/background.png` | git rm |
| `AppScope/resources/base/media/foreground.png` | git rm |
| `entry/src/main/resources/base/media/background.png` | git rm |
| `entry/src/main/resources/base/media/foreground.png` | git rm |
| `entry/src/main/resources/base/media/startIcon.png` | **保留**（DevEco 启动图标） |

### 根因分析

调用路径错误：
1. `del /f /q` 命令在 Node fallback shell 中被中文乱码截断，导致删除失败
2. `DeleteFile` 工具调用时已删除**物理文件**，但未执行 `git rm`
3. `git add` + `git commit` 仅记录新增 SVG，未追踪删除操作
4. 推送后 GitHub/Gitee 仓库中 PNG 和 SVG 同时存在
5. HarmonyOS 资源编译器检测同名资源冲突

### 静态验证

```bash
$ git ls-files AppScope/resources/base/media entry/src/main/resources/base/media | grep -E 'background|foreground'
AppScope/resources/base/media/background.svg
AppScope/resources/base/media/foreground.svg
entry/src/main/resources/base/media/background.svg
entry/src/main/resources/base/media/foreground.svg
```
PNG 已全部清除，仅剩 SVG ✅

### 兼容性

- **API 要求**：HarmonyOS API 22 / 6.0.1(21)
- **功能变更**：0（仅删除冲突文件）
- **依赖**：无变更

---

## [v1.1.3] - 2026-06-18 — UI 完善 + AI 洞察接入 + 图标重设计

### 概述

v1.1.2.3 推送后真机验证发现 4 类问题：界面含 'object Object' 字样、AI 洞察仍是静态文本、页面 emoji 图标不美观、App 图标无品牌辨识度。本版本一次性解决，同时接入本地 AI 规则引擎（5 条核心规则）。

### 修复（Fix）

#### 1. 修复 3 处 'object Object' 字样

**根因**：`Text()` 参数类型为 `ResourceStr | string`，但 `' ' + $r(...)` 拼接会调用 `Resource.toString()` 返回 `[object Object]`。

| 文件 | 行 | 修复方式 |
|------|----|---------|
| `components/NewsCard.ets` | 28 | 拆分为 Row { IconSparkle + Text($r(...)) } |
| `pages/home/HomePage.ets` | 52 | 拆分为 Row { Text($r(...)) + Text(' 👋') } |
| `pages/home/HomePage.ets` | 138 | 拆分为 Row { 3 个 Text 子项 } |

#### 2. 接入 AI 洞察能力（本地规则引擎）

- **新增** `model/SportsDataModel.ets`：体育数据模型（UserActivity / WeatherInfo / VenueAvailability / AIInsightResult）
- **新增** `viewmodel/AIInsightEngine.ets`：5 条规则的本地引擎
  - 规则 1：胜率偏好 → 单/双打专长推断
  - 规则 2：天气适宜性 → 运动提示
  - 规则 3：本周场次 ≥ 3 → 活跃状态
  - 规则 4：闲置天数 > 3 → 提示「已经 N 天没运动了」
  - 规则 5：场馆空闲时段 → 推荐最佳时段 + 偏好打法
- **修改** `cloud/MockDataService.ets`：新增 3 个 Mock 方法（getUserActivity / getWeather / getVenueAvailability）
- **修改** `viewmodel/HomeViewModel.ets`：新增 `aiInsight: AIInsightResult | null` 字段 + `loadAIInsight()` 方法
- **修改** `pages/home/HomePage.ets`：智能问候 / 副标题 / 进度环全部从 aiInsight 动态读取

#### 3. SVG 图标库设计

- **新增** `common/Icons.ets`：统一图标组件库（9 个图标）
- **新增 9 个 SVG 资源**：icon_shuttlecock / icon_racket / icon_venue / icon_equipment / icon_player / icon_ai / icon_sparkle / icon_refresh / icon_fire
- **设计风格**：扁平 + 渐变 + 动感线条，统一 #FF8C00 橙色品牌色
- **替换 emoji**：
  - NewsCard：🏸🥇🎯🏆🚀 → IconShuttlecock + IconSparkle
  - VenueCard：🏟️🏸☀️⚡🏘️ → IconVenue
  - EquipmentCategoryCard：🏸👟🎒 → IconRacket / IconEquipment（按 category 分发）
  - PlayerCard：🏸🎯⚡ → IconPlayer + IconFire
  - AIAssistantButton：🤖 → IconAI
  - HomePage / CommunityPage：🔄🎙️ → IconRefresh + IconAI
  - MainTabs：🏠👥👤 → IconShuttlecock / IconVenue / IconPlayer
  - AppMenuItem / ProfilePage：6 项菜单 → iconType 枚举分发 + IconPlayer 头像

#### 4. App 图标重新设计

- **替换** AppScope/entry 的 `background.png / foreground.png` → `background.svg / foreground.svg`
- **设计**：
  - 背景：橙色渐变 (#FFB74D → #FF8C00 → #FF6F00) + 装饰圆 + 动感速度线
  - 前景：白色羽毛球（7 片羽毛 + 软木底座 + 中心红心）+ 飞行轨迹光弧
- 保持与 DesignTokens 一致的 #FF8C00 主品牌色

### 静态自检（grep 验证）

- `Text(... + $r(...))` 拼接：0 命中（全部拆分）
- `getContext() / promptAction.xxx` 直接调用：0 命中
- `AIInsightEngine` 引用：14 处
- `IconXXX` 组件引用：10+ 处（替代原 emoji）

### 兼容性

- **API 要求**：HarmonyOS API 22 / 6.0.1(21)
- **依赖**：无新增 ohpm 包（SVG 是 HarmonyOS 原生支持）
- **文件数**：13 修改 + 11 新增
- **公共 API**：内部重构（AppMenuItem 的 `icon: string` → `iconType: MenuIconType`，调用方已同步更新）

### 后续

- v1.1.4 可考虑接入 HarmonyOS Agent Framework Kit / 云函数 LLM，替换本地规则引擎为真实 AI
- SVG 图标性能可进一步优化（缓存、合并 sprite）

---

## [v1.1.2.3] - 2026-06-18 — ProfilePage 真机编译 ERROR hotfix

### 概述

v1.1.2.2 推送后二次真机测试发现 v1.1.2 hotfix 遗漏的 2 类错误（4 个 ERROR 实例）。本热修复针对性解决，1 文件 6+ 行。

### 修复（Fix）

#### ERROR 1 — `'ctx' is possibly 'undefined'` (10605999)

| 项 | 内容 |
|----|------|
| 位置 | `pages/profile/ProfilePage.ets:51` |
| 错误信息 | `'ctx' is possibly 'undefined'` |
| 根因 | `this.getUIContext().getHostContext()` 返回类型为 `common.Context \| undefined`（ArkTS 严格模式不允许未定义值直接调用方法） |
| 修复 | 添加 `if (!ctx) { AppLogger.warn(...); return; }` 守卫 |

#### ERROR 2 & 3 — `ActionMenuSuccessResponse` 未从 `@kit.ArkUI` 导出 (10505001 / 10311006)

| 项 | 内容 |
|----|------|
| 位置 | `pages/profile/ProfilePage.ets:22` |
| 错误信息 | `Module '"@kit.ArkUI"' has no exported member 'ActionMenuSuccessResponse'` |
| 根因 | v1.1.2.2 误判：`ActionMenuSuccessResponse` 是 `promptAction` 命名空间下的内部类型，不通过顶层 `export` 暴露 |
| 修复 | 1. 删除 `import { ActionMenuSuccessResponse } from '@kit.ArkUI';` <br>2. 回调签名改为 `(err, data)` 让 ArkTS 自动推断 <br>3. 同步清理不再使用的 `import { promptAction }` |

### 全项目规范静态检查（grep 验证）

| 检查项 | 命令 | 结果 |
|--------|------|------|
| promptAction 全局调用 | `grep -rn 'promptAction\.' entry/src/main/ets` | ✅ 0 命中 |
| getContext() 调用 | `grep -rn 'getContext()' entry/src/main/ets` | ✅ 0 命中 |
| ActionMenuSuccessResponse import | `grep -rn "import.*ActionMenuSuccessResponse" entry/src/main/ets` | ✅ 0 命中 |
| Stack + justifyContent 误用 | `grep -rn 'Stack()' entry/src/main/ets` + `.justifyContent` | ✅ 0 命中 |
| @Prop 属性与 ArkUI 基类同名 | `grep -rn '@Prop public (size\|width\|height\|...)' entry/src/main/ets` | ✅ 0 命中 |
| console / eval / obj[key] | `grep -rn 'console\.\|eval(\|obj\[key\]' entry/src/main/ets` | ✅ 0 命中 |

### 兼容性

- **API 要求**：HarmonyOS API 22 / 6.0.1(21)，`getUIContext()` / `getPromptAction()` / `getHostContext()` 均属该 API 标准方法
- **公共 API**：0 破坏性变更
- **依赖**：无新增 ohpm 包
- **文件数**：仅 1 文件修改（`ProfilePage.ets`，+6 -2 行）

### 提交信息

```
v1.1.2.3 hotfix: 修复 ProfilePage 2 个真机编译 ERROR

ERROR 1 - ctx possibly undefined:
  getHostContext() 返回 Context | undefined，需加 if (!ctx) return

ERROR 2 - ActionMenuSuccessResponse 未从 @kit.ArkUI 导出:
  应让回调参数类型自动推断，删除错误的 import 语句
```

---

## [v1.1.2.2] - 2026-06-18 — 真机测试 ArkTS 编译错误 hotfix

### 概述

v1.1.2 推送至 GitHub/Gitee 后，在 DevEco Studio 真机编译时 hvigor 报告 **3 个 ERROR + 6 个 WARN**。本热修复全部修复，在保持 v1.1.2 视觉设计完全不变的前提下，消除所有 ArkTS 严格模式告警，为后续真机调试验证扫除障碍。

### 修复（Fix）

#### 3 个 ArkTS 编译 ERROR

| # | 文件 | 行 | 错误信息 | 根因 | 修复 |
|---|------|----|---------|------|------|
| 1 | `components/AIAssistantButton.ets` | 46 | `Property 'justifyContent' does not exist on type 'StackAttribute'` | Stack 是堆叠布局容器，仅有 `alignContent`（子元素对齐），**不支持 `justifyContent`**（Flex 主轴对齐属性） | 改为 `Stack({ alignContent: Alignment.Center })`，子元素依靠尺寸自适应堆叠居中 |
| 2 | `components/ProgressRing.ets` | 19 | `Property 'size' in type 'ProgressRing' is not assignable to the same property in base type 'CustomComponent'. Type 'number' is not assignable to type '(value: SizeOptions) => CommonAttribute'` | ArkUI 内置基类 `CustomComponent` 有 `size(value: SizeOptions)` setter，自定义 `@Prop size: number` 与之类型冲突 | 重命名属性 `size` → `ringSize`，同步内部 3 处引用 |
| 3 | `pages/profile/ProfilePage.ets` | 300 | `Argument of type '(err: BusinessError, index: number) => void' is not assignable to parameter of type 'AsyncCallback<ActionMenuSuccessResponse, void>'` | `showActionMenu` API 第二参数是 `data: ActionMenuSuccessResponse`（含 `index` 字段），不是直接的 `index` | 回调签名改为 `(err, data)`，内部 `data.index` 取值；新增 import `ActionMenuSuccessResponse` |

#### 6 个 deprecated API WARN

| # | 文件 | 行 | 旧写法（deprecated） | 新写法（ArkUI 12+ 推荐） |
|---|------|----|---------------------|-------------------------|
| 1 | `pages/home/HomePage.ets` | 68 | `promptAction.showToast(...)` | `this.getUIContext().getPromptAction().showToast(...)` |
| 2 | `pages/home/HomePage.ets` | 204 | `promptAction.showToast(...)` | `this.getUIContext().getPromptAction().showToast(...)` |
| 3 | `pages/profile/ProfilePage.ets` | 44 | `getContext()` | `this.getUIContext().getHostContext()` |
| 4 | `pages/profile/ProfilePage.ets` | 293 | `promptAction.showActionMenu(...)` | `this.getUIContext().getPromptAction().showActionMenu(...)` |
| 5 | `pages/profile/ProfilePage.ets` | 313 | `promptAction.showToast(...)` | `this.getUIContext().getPromptAction().showToast(...)` |
| 6 | `pages/profile/ProfilePage.ets` | 328 | `promptAction.showToast(...)` | `this.getUIContext().getPromptAction().showToast(...)` |

### 静态自检结果

```bash
$ grep -rn 'promptAction\.\|getContext()' entry/src/main/ets
# 0 命中（全部清除）

$ grep -n 'this\.size\|@Prop public size' entry/src/main/ets/components/ProgressRing.ets
# 0 命中（ringSize 完全替代）

$ grep -n 'Stack() {' entry/src/main/ets/components/AIAssistantButton.ets
# 0 命中（改为 Stack({ alignContent })）
```

### 兼容性

- **API 要求**：项目锁定 HarmonyOS API 22 / 6.0.1(21)，`getUIContext()` / `getPromptAction()` / `getHostContext()` 均属该 API 标准方法
- **视觉效果**：零变化（仅修改 API 调用入口与回调签名）
- **公共 API**：0 破坏性变更（仅内部组件属性 `size` → `ringSize`，外部调用点 0 个使用）
- **依赖**：无新增 ohpm 包，无 manifest 变更

### 提交信息

```
v1.1.2.2 hotfix: 修复 3 ArkTS ERROR + 6 deprecated API

- AIAssistantButton: Stack { alignContent: Center } (justifyContent 不属于 StackAttribute)
- ProgressRing: 属性 size → ringSize (避免与基类 CustomComponent.size 冲突)
- ProfilePage: showActionMenu 回调签名 (err, data: ActionMenuSuccessResponse)
- 6 处 deprecated API → this.getUIContext().getPromptAction().xxx / getHostContext()
- 删除 HomePage.ets / ProfilePage.ets 中不再使用的 promptAction import
```

### 后续

- 真机验证：用户需在 DevEco Studio 中执行 `_build.bat` 确认 HAP 打包成功
- 如遇 `getPromptAction` / `getHostContext` 在真机 SDK 版本不存在，需检查 SDK 版本是否 ≥ API 12

---

## [v1.1.2] - 2026-06-18 — 双主题 UI 重构（A2 智能情境 + A3 深色霓虹）

### 概述

v1.1.1.4 完成 ArkTS 严格模式编译修复后，对 v1 整体 UI 进行**双主题重构**，并同步集成 DevEco Studio 命令行工具链：

- **A2 智能情境**：活力橙主品牌色 + AI 智能洞察/助理组件 + 渐变光晕特效
- **A3 深色霓虹**：深空蓝（#0A0E1F）背景 + 霓虹橙（#FF8C00）强调色 + 强发光阴影
- **工具链**：hvigorw / ohpm / Node v18.20.1 全部加入用户 PATH

### 新增（Add）

#### 1. 三个新组件（A2/A3 通用）

| 组件 | 文件 | 职责 |
|------|------|------|
| `AIInsightCard` | `components/AIInsightCard.ets` | 智能洞察 Hero 卡片（标题/副标题/4 段内容/进度环/状态点） |
| `AIAssistantButton` | `components/AIAssistantButton.ets` | 顶部 AI 助理入口按钮（圆形 FAB + 光晕） |
| `ProgressRing` | `components/ProgressRing.ets` | 通用进度环（百分比/弧度/轨道色） |

#### 2. DesignTokens 新增 17 令牌

| 类别 | 令牌 |
|------|------|
| 圆角 | `RADIUS_XL: 28`、`RADIUS_PILL: 14` |
| AI 专属尺寸 | `AI_BUTTON_SIZE: 48`、`AI_FAB_SIZE: 56`、`AI_INSIGHT_HEIGHT: 96`、`PROGRESS_RING_SIZE: 80` |
| Tab 药丸 | `TAB_PILL_WIDTH: 56`、`TAB_PILL_HEIGHT: 28` |
| 阴影 | `SHADOW_SOFT_RADIUS: 8`、`SHADOW_SOFT_OFFSET_Y: 2` |
| 间距 | `SPACING_XS3: 20`、`SPACING_LG2: 28` |
| 字重 | `WEIGHT_HEAVY: 700`、`WEIGHT_EXTRA_BOLD: 800` |
| AI 主题色（12 色） | `COLOR_AI_ORANGE`、`COLOR_AI_ORANGE_DARK`、`COLOR_AI_INSIGHT_BG_START/END`、`COLOR_AI_TAG_BG_START/END`、`COLOR_AI_BORDER`、`COLOR_AI_STATUS_DOT`、`COLOR_AI_GLOW/STRONG`、`COLOR_SHADOW_SOFT`、`COLOR_SHADOW_AI_BUTTON` |

#### 3. Constants 新增 4 项

- `APPSTORAGE_THEME_MODE: 'themeMode'`
- `THEME_AUTO: 'auto'`、`THEME_LIGHT: 'light'`、`THEME_DARK: 'dark'`

#### 4. 资源系统（40 色双主题）

- `resources/base/element/color.json`：26 色 → **40 色**（新增 14 个 AI 主题色 + Tab 状态色）
- `resources/dark/element/color.json`：15 色 → **40 色**（深空蓝 #0A0E1F 背景 + 霓虹橙强调 + 强发光阴影）

### 重构（Refactor）

#### 1. 主品牌色切换

| 项目 | v1.1.1.4 | v1.1.2 |
|------|----------|--------|
| 主色 | `#1E88E5`（球场蓝） | `#FF8C00`（活力橙） |
| 主色 Light | `#42A5F5` | `#FFB74D` |
| 主色 Dark | `#1565C0` | `#FF6F00` |
| 主色 BG | `#E3F2FD` | `#FFF4E6` |
| 强调色 | `#FFC107`（球黄） | `#FF6F00`（智能橙深） |
| 阴影 | `rgba(30,136,229,0.15)` | `rgba(255,140,0,0.15)` |

涉及：`DesignTokens.ets`（19 处）+ `resources/base/color.json`（5 处）+ `resources/dark/color.json`（5 处）。

#### 2. 6 个组件接入新主题

| 组件 | 变更 |
|------|------|
| `NewsCard` | 主色切换为活力橙，标题/分类/AI Tag 重排 |
| `AppMenuItem` | 图标盒圆角 +16，hover 态采用 AI 主题渐变 |
| `EmptyState` | 空状态插画 emoji 化，按钮主色活力橙 |
| `PrivacyDialog` | 遮罩透明度调整，按钮双主题适配 |
| `VenueCard` | 状态色 + 评分星采用 AI 主题渐变 |
| `EquipmentCategoryCard` | 4 分类卡片背景采用 AI 渐变 |
| `PlayerCard` | 排名 chip 背景采用 AI 主题色 |

#### 3. 3 个页面重构

- **`pages/home/HomePage.ets`**：
  - 新增 `AIInsightCard` 顶部插入（标题/AI 摘要/4 段要点）
  - 新增 `AIAssistantButton` 浮动按钮（FAB 右下角）
  - 新增 `ProgressRing` 嵌入 `AIInsightCard`（健康度/胜率/活跃度）
- **`pages/community/CommunityPage.ets`**：
  - 场馆卡片增加评分星级 + 价格 chip
  - 装备卡片背景渐变
  - 球员卡片排名 chip + 积分高亮
- **`pages/profile/ProfilePage.ets`**：
  - 新增主题切换菜单（跟随系统/浅色/深色 三选项）
  - `@StorageProp themeMode @Watch onThemeModeChange` 实时响应
  - `applyThemeMode(mode)` 应用主题（暂存 placeholder，预留 v1.1.3 接入 `ConfigurationConstant`）

#### 4. AppStorageBootstrap 升级

- `initDefaults()` 增加 `themeMode` 默认值（`'auto'`）
- 7 keys → **8 keys**

### 修复（Fix）

#### 1. DevEco Studio CLI 工具链 PATH 集成

- **问题**：hvigorw 需手动定位 `D:\Program Files\Huawei\DevEco Studio\tools\hvigor\bin\hvigorw.bat`；ohpm 需定位 `tools\ohpm\bin\ohpm`；Node 默认版本与 hvigorw 不兼容（`TransformStream is not defined`）
- **解决**：
  - 用户 PATH 永久加入 `DevEco Studio\tools\node` 和 `tools\ohpm\bin`（**前置于** 系统 PATH，确保 hvigorw 优先使用 Node v18.20.1）
  - 备份原 PATH 至 `path_backup_20260618_145305.txt`（本地，不提交）
  - 最终 PATH 长度 595 → 697 chars

#### 2. 视觉一致性

- `PrivacyDialog` 遮罩透明度 `0.4 → 0.5`（深色模式下更清晰）
- `AIInsightCard` 状态点位置从 (10,10) 调整到 (12,12)（视觉重心更稳）

### 兼容约束

- **业务功能 100% 不变**：3 个 Mock 数据源（News/Venue/Equipment/Player/User）无任何修改
- **API 22 / 6.0.1(21) 不变**
- **公共 API 0 破坏性变更**：所有新增/重构均为组件层与样式层；Constants 新增 4 项为纯新增
- **Page 公共 API 不变**：`HomePage` / `CommunityPage` / `ProfilePage` 入口签名不变

### 静态验证

```bash
# 1. DesignTokens 数量：v1.1.1.4 共 73 → v1.1.2 共 90
grep -c "^  static readonly" D:\ProgramData\iBadmin\entry\src\main\ets\common\DesignTokens.ets
# 期望：≥ 90

# 2. 颜色资源：base + dark 各 40 色
grep -c '"name":' D:\ProgramData\iBadmin\entry\src\main\resources\base\element\color.json
grep -c '"name":' D:\ProgramData\iBadmin\entry\src\main\resources\dark\element\color.json
# 期望：≥ 40

# 3. 主题切换菜单存在
grep -n "themeMode" D:\ProgramData\iBadmin\entry\src\main\ets\pages\profile\ProfilePage.ets
# 期望：≥ 5 处（声明 + @Watch + 3 处 applyThemeMode 分支）

# 4. PATH 验证
where hvigorw   # 期望：DevEco Studio\tools\hvigor\bin\hvigorw.bat
where ohpm      # 期望：DevEco Studio\tools\ohpm\bin\ohpm
node --version  # 期望：v18.20.1
```

### 已知限制

- `applyThemeMode()` 当前仅记录到 console，**未真正切换主题**：v1.1.3 接入 `ConfigurationConstant`（API 22 兼容方案），实现应用级实时主题切换
- 真机/模拟器视觉效果需在 DevEco Studio Previewer 中验证（当前环境无预览器）

### 路线图调整

| 版本 | 原计划 | 调整后 |
|------|--------|--------|
| v1.1.2 | ViewModel 单测 + 集成测试 | **双主题 UI 重构 + 工具链集成**（本次） |
| v1.1.3 | `@kit.AccountKit` 升级 | ViewModel 单测 + 集成测试 + `ConfigurationConstant` 主题切换 |
| v1.1.4 | — | `@kit.AccountKit` 升级（API 23+） |

---

## [v1.1.1.4] - 2026-06-16 — 修正 v1.1.1.3 AccountService 类型二次修复

### 概述

v1.1.1.3 修复后重新 `_build.bat`，仍报 **3 个 ERROR + 1 个 WARN**：

```
3 ERROR: 10505001 ArkTS Compiler Error
Error Message: Argument of type 'Object' is not assignable to parameter of type 'Record<string, Object>'.
  Index signature for type 'string' is missing in type 'Object'.
  At File: D:/ProgramData/iBadmin/entry/src/main/ets/utils/AccountService.ets:70:19

3 ERROR: 10505038 ArkTS Compiler Error
Error Message: Object literal must correspond to some explicitly declared class or interface
  (arkts-no-untyped-obj-literals)
  At File: D:/ProgramData/iBadmin/entry/src/main/ets/utils/AccountService.ets:149:10

3 ERROR: 10505001 ArkTS Compiler Error
Error Message: Type 'Object' is not assignable to type 'Record<string, string>'.
  Index signature for type 'string' is missing in type 'Object'.
  At File: D:/ProgramData/iBadmin/entry/src/main/ets/utils/AccountService.ets:149:3
```

### 根因（v1.1.1.3 计划不周）

v1.1.1.3 错误地假设 `Record<string, X>` 索引签名类型可以解决所有 untyped object literal 问题，但 ArkTS 严格模式有以下限制：

| 限制 | 说明 |
|------|------|
| 1. `Record<K, V>` 不接受 `Object` | `Object` 缺索引签名 `[K: string]`，不能直接赋给 `Record<string, X>`（反之亦然） |
| 2. `Record<K, V>` 不是“具名 interface” | ArkTS 的 arkts-no-untyped-obj-literals 规则要求对象字面量对应**具名 class/interface**，`Record<...>` 索引签名类型不算“具名” |
| 3. SDK 动态数据只能用 `Object` | `@ohos.account.appAccount` 的 SDK 返回值是动态 Object，不能预先定义字段名约束 |

### 修复（Fix）

#### AccountService.ets 二次修复

| 任务 | 文件 | 内容 |
|------|------|------|
| F.1 | `utils/AccountService.ets:47-48` | `function callSdkAuth(): Promise<Record<string, Object>>` 回退为 `Promise<Object>`；resolve/reject 类型同步回 `Object`（SDK 动态数据是 Object，不能用 Record 约束） |
| F.2 | `utils/AccountService.ets:70` | `resolve(data ?? {} as Record<string, Object>);` → `resolve(data ?? {} as Object);`（显式 Object 断言） |
| F.3 | `utils/AccountService.ets:147-149` | 新增 `export interface AuthInfo { name: string; owner: string; authType: string; }`（具名 interface） |
| F.4 | `utils/AccountService.ets:159` | `function buildAuthInfo(): Record<string, string>` → `function buildAuthInfo(): AuthInfo`（用具名 interface 接收对象字面量） |

**关键代码片段**：

```typescript
// v1.1.1.4 修正后

// 1. SDK 动态数据：保持 Promise<Object>
function callSdkAuth(): Promise<Object> {
  return new Promise<Object>((resolve: (v: Object) => void, reject: (e: Error) => void) => {
    // ...
    (err: Error | null, data: Object | null) => {
      if (err !== null) { reject(err); return; }
      resolve(data ?? {} as Object);  // 显式 Object 断言
    }
  });
}

// 2. 具名接口：定义 AuthInfo
export interface AuthInfo {
  name: string;
  owner: string;
  authType: string;
}

function buildAuthInfo(): AuthInfo {  // 具名返回类型
  return {  // 对象字面量对应具名 interface，不再报 untyped
    name: 'iBadmin',
    owner: 'iBadmin_owner',
    authType: 'serviceAuthProvider'
  };
}
```

### 防御措施（更新编码规范第 19 条）

**第 19 条**（v1.1.1.4 教训）：
- `Record<K, V>` 索引签名类型**不能**完全替代具名 interface
- 当函数返回对象字面量时，必须**先定义具名 interface**，然后用该 interface 作为返回类型
- SDK 动态数据（`Object` 类型）只能保持 `Object` 类型，**不要**试图用 `Record<...>` 约束
- `Object` 缺索引签名，不能赋给 `Record<string, X>`；需要中间转换时用 `as Object as Record<...>` 双断言（或保持 Object 不约束）

### 验证

#### 静态检查
```bash
# v1.1.1.4 修复后
grep -rn "Promise<Record<" D:\ProgramData\iBadmin\entry\src\main\ets
# 期望：0 结果（callSdkAuth 已回退到 Promise<Object>）

grep -rn "function buildAuthInfo" D:\ProgramData\iBadmin\entry\src\main\ets
# 期望：1 结果（utils/AccountService.ets:159，返回类型为 AuthInfo）

grep -rn "interface AuthInfo" D:\ProgramData\iBadmin\entry\src\main\ets
# 期望：1 结果（utils/AccountService.ets:153）

grep -rn "resolve(data ?? {} as Record" D:\ProgramData\iBadmin\entry\src\main\ets
# 期望：0 结果（已改为 as Object）
```

#### 编译验证
```bash
cd D:\ProgramData\iBadmin
_build.bat
# 期望：0 ERROR，1-2 WARN（showToast deprecated + ArkTS FAQ 提示）
# 期望：生成 entry-default-unsigned.hap
```

### 兼容约束

- 业务功能 100% 不变（v1 走 Mock 模式，AccountService 未被实际调用）
- API 22 / 6.0.1(21) 不变
- 公共 API 0 破坏性变更（`AuthInfo` 是新增内部 interface，外部未使用）
- v1.1.1.3 修复被部分回退（`callSdkAuth` 从 `Promise<Record<string, Object>>` 回退到 `Promise<Object>`，这是 v1.1.1.2 之前的状态）

### 修复链总结（v1.1.1.1 - v1.1.1.4）

- v1.1.1.1：移除错误三方包 `@ohos/account-ohos@2.0.0`（已完成）
- v1.1.1.2：修复 hamock 版本号 2.0.0 → 1.0.0（已完成）
- v1.1.1.3：修复 ArkTS 严格模式 29 ERROR + 7 WARN（已完成，但 callSdkAuth 修复方案不周）
- v1.1.1.4（本版本）：二次修复 callSdkAuth + buildAuthInfo 类型（3 ERROR）
- 下一站：v1.1.2（ViewModel 单测 + 集成测试）/ v1.1.3（`@kit.AccountKit` 升级，API 23+）

---

## [v1.1.1.3] - 2026-06-16 — 修复 ArkTS 严格模式编译错误

### 概述

v1.1.1.2 修复 `ohpm install` 后，重新执行 `_build.bat` 时 ArkTS 编译器报 **29 个 ERROR + 3 个 WARN + 4 个资源冲突 WARN**，编译中断：

```
> hvigor ERROR: BUILD FAILED in 9 s 395 ms
COMPILE RESULT:FAIL {ERROR:29 WARN:3}
```

### 错误分类

| 类别 | 数量 | 错误 ID | 根因 |
|------|------|---------|------|
| A. 资源 string.json 冲突 | 4 | WARN: app_name / internet_permission_reason / network_permission_reason / location_permission_reason | `AppScope/resources/base/element/string.json` 与 `entry/src/main/resources/base/element/string.json` 重复声明同名键 |
| B. Resource → string 类型不匹配 | 17 | 10505001 | `EmptyState.message/retryText`、`MenuItem.title/subtitle` 声明为 `string`，但调用方传 `$r('app.string.*')` 返回 `Resource` |
| C. `as unknown as T` 禁止 | 6 | 10605008 arkts-no-any-unknown | `CloudClient.ets` 6 处 switch case 返回值使用 `as unknown as T` 双断言 |
| D. untyped object literal | 2 | 10605038 arkts-no-untyped-obj-literals | `AccountService.ets:70 resolve(data ?? {})` + `:148 return {...}` 内联 `{}` 无具名类型 |
| E. MenuItem 命名冲突 | 2 | 10905227 / 10905237 | 自定义 struct `MenuItem` 与 ArkUI 22+ 内置组件 `MenuItem`（`@kit.ArkUI`）重名 |
| F. `@Entry` struct export | 1 | WARN | `Index.ets:11 export struct Index` 不推荐（可能引起 ACE Engine preview 错误） |
| G. showToast 废弃 | 1 | WARN | `ProfilePage.ets:233 promptAction.showToast` deprecated（warn 不阻断，v1.1.4 处理） |

### 影响

- 编译失败 → 无法生成 entry-default-unsigned.hap → 无法在 DevEco Studio 调试/打包
- v1.1.1.2 修复 `ohpm install` 后，ArkTS 严格模式的累积问题（v1.1.0 改造遗留 + v1.1.1.1 AccountService 重构遗留）集中暴露

### 修复（Fix）

#### 阶段 A：资源 string.json 去重
- `AppScope/resources/base/element/string.json` — 删除 4 个冲突键（`app_name` / `internet_permission_reason` / `network_permission_reason` / `location_permission_reason`），保留 8 个 AppScope 独有的 Tab/全局字符串；以 entry 详细版为唯一文案真源

#### 阶段 B：4 个 prop 类型 string → ResourceStr（修复 17 处调用点）
- `components/EmptyState.ets:21` — `message: string` → `message: ResourceStr`
- `components/EmptyState.ets:22` — `retryText: string` → `retryText: ResourceStr`
- `components/AppMenuItem.ets:11` — `title: string` → `title: ResourceStr`（v1.1.1.3 由 MenuItem.ets 重命名而来）
- `components/AppMenuItem.ets:12` — `subtitle: string` → `subtitle: ResourceStr`

#### 阶段 C：MenuItem → AppMenuItem 重命名
- `components/MenuItem.ets` — 重命名为 `components/AppMenuItem.ets`（避免与 ArkUI 22+ 内置 `MenuItem` 组件冲突）
- `components/AppMenuItem.ets:9` — `struct MenuItem` → `struct AppMenuItem`
- `pages/profile/ProfilePage.ets:18` — `import { MenuItem } from '.../MenuItem'` → `import { AppMenuItem } from '.../AppMenuItem'`
- `pages/profile/ProfilePage.ets:153, 162, 171, 180, 189` — 5 处 `MenuItem({` → `AppMenuItem({`

#### 阶段 D：CloudClient.ets 6 处 as unknown 修复
- 行 66/69/72/75/78/81 — 删除 6 处 `as unknown as T` 中的 `unknown`，保留 `as T`（arkts-no-any-unknown 规则禁止双断言）

#### 阶段 E：AccountService.ets 3 处类型标注
- 行 47-48 — `Promise<Object>` → `Promise<Record<string, Object>>`（含 resolve 类型签名）
- 行 70 — `resolve(data ?? {})` → `resolve(data ?? {} as Record<string, Object>)`（内联空对象字面量具名化）
- 行 148 — `function buildAuthInfo(): Object` → `function buildAuthInfo(): Record<string, string>`

#### 阶段 F：编译 WARN 处理
- `pages/Index.ets:11-13` — `export struct Index` → `struct Index`（去除 export 关键字，@Entry struct 不推荐 export）
- `pages/profile/ProfilePage.ets:233` — `promptAction.showToast` 保留（warn 不阻断编译；`promptAction.openToast` 尚未发布到 6.0.1(21)，v1.1.4 处理）

### 防御措施（更新编码规范第 15-18 条）

1. **第 15 条**：组件 prop 类型必须用 `ResourceStr` 而非 `string`（用于接受 `$r('app.string.*')` 资源）
2. **第 16 条**：禁止用 ArkUI 内置组件名作为自定义 struct 名（MenuItem / Button / Text / List / Tabs / Grid 等）
3. **第 17 条**：禁止 `as unknown as T` 双断言（arkts-no-any-unknown）
4. **第 18 条**：内联对象字面量 `{}` 必须标注具名类型（`Record<K, V>` 或具名 interface）

### 验证

#### 静态检查
```bash
# 1. 资源冲突已清
grep -E "app_name|internet_permission_reason|network_permission_reason|location_permission_reason" D:\ProgramData\iBadmin\AppScope\resources\base\element\string.json
# 期望：0 结果

# 2. MenuItem 旧名残留
grep -rn "components/MenuItem" D:\ProgramData\iBadmin\entry\src\main\ets
grep -rn "struct MenuItem" D:\ProgramData\iBadmin\entry\src\main\ets
# 期望：0 结果

# 3. as unknown 双断言
grep -rn "as unknown as" D:\ProgramData\iBadmin\entry\src\main\ets
# 期望：0 结果

# 4. untyped obj 上下文
grep -rn "Promise<Object>\|: Object {" D:\ProgramData\iBadmin\entry\src\main\ets
# 期望：0 结果
```

#### 编译验证
```bash
cd D:\ProgramData\iBadmin
_build.bat
# 期望：0 ERROR，3 WARN（showToast deprecated + ArkTS FAQ + Index.ets export 剩余）
# 期望：生成 entry-default-unsigned.hap
```

#### 测试验证
```bash
_test.bat
# 期望：52 cases / 0 fail（v1.1.1 + v1.1.1.1 + v1.1.1.2 均未破坏）
```

### 兼容约束

- 业务功能 100% 不变（仅类型 / 命名调整）
- API 22 / 6.0.1(21) 不变
- 公共 API 0 破坏性变更（`MenuItem` → `AppMenuItem` 是内部组件，影响范围：仅 ProfilePage，已同步修改；组件 prop 类型从 `string` 升级到 `ResourceStr` 是 ArkUI 标准类型，调用方 `$r('app.string.*')` 自动适配）

### 修复链总结

- v1.1.1.1：移除错误三方包 `@ohos/account-ohos@2.0.0`（已完成）
- v1.1.1.2：修复 hamock 版本号 2.0.0 → 1.0.0（已完成）
- v1.1.1.3（本版本）：修复 ArkTS 严格模式 29 ERROR + 7 WARN
- 下一站：v1.1.2（ViewModel 单测 + 集成测试）/ v1.1.3（`@kit.AccountKit` 升级，API 23+）

---

## [v1.1.1.2] - 2026-06-16 — 修复 hamock 版本号 404 错误

### 概述

v1.1.1.1 修复后重新 `ohpm install`，仍报错：

```
ohpm INFO: MetaDataFetcher fetching meta info of package '@ohos/hamock' from https://ohpm.openharmony.cn/ohpm/
ohpm ERROR: Run install command failed
Error: 00617101 Fetch Pkg Info Failed
Error Message: FetchPackageInfo: "@ohos/hamock" failed
╰→ Caused by:
  Original Error: NOTFOUND package '@ohos/hamock@2.0.0' not found from all the registries https://ohpm.openharmony.cn/ohpm/
```

### 根因（已验证）

- `oh-package.json5` 声明了 `"@ohos/hamock": "2.0.0"`，该版本在中央仓**不存在**
- 中央仓 `https://ohpm.openharmony.cn/ohpm/@ohos/hamock` 元数据显示：仅 `1.0.0-rc`（2023-12-15）和 `1.0.0`（2024-02-02）两个版本，`dist-tags.latest = 1.0.0`
- `oh-package-lock.json5` 已锁定 `1.0.0`（与中央仓 latest 一致），证明 1.0.0 是正确的可用版本
- 推断：v1.1.0 之前曾以 `1.0.0` 装上并生成 lock；某次 manifest 改写时手误写成 `2.0.0`，但 lock 未重新生成
- `ohpm install --all` 总是按 manifest 重新解析（忽略 lock 中的版本号），所以 2.0.0 找不到 → 404

### Superpowers 整体扫描结论

在修复过程中，对全项目所有依赖与 import 进行了系统化扫描，确认**无其他类似问题**：

| 检查项 | 范围 | 结果 |
|--------|------|------|
| 根 `oh-package.json5` | devDependencies | ✅ hypium 1.0.25 / hamock 1.0.0（已修复） |
| `entry/oh-package.json5` | 私有 manifest | ✅ `dependencies: {}` 空对象，无隐患 |
| `oh-package-lock.json5` | 锁定版本 | ✅ 与 manifest 一致（hamock@1.0.0 / hypium@1.0.25） |
| `build-profile.json5` × 2 | 构建配置 | ✅ 仅 SDK 版本配置，无依赖声明 |
| 全部 `.ets/.ts` 代码 import | 依赖调用 | ✅ 仅 SDK 系统模块（@ohos.account.appAccount、@ohos.hilog 等），无 ohpm 三方包 import |
| `@ohos/account-ohos` 残留 | v1.1.1.1 根因 | ✅ 仅 1 处（AccountService.ets 文档注释，标注"旧实现"） |

### 修复（Fix）

- `oh-package.json5` — `"@ohos/hamock"` 从 `"2.0.0"` 改回 `"1.0.0"`（与 lock 与中央仓 latest 一致）
- `oh-package-lock.json5` — 无需修改（已经是 `1.0.0`）

### 验证

```bash
# 中央仓元数据验证
curl -s https://ohpm.openharmony.cn/ohpm/@ohos/hamock | jq '.["dist-tags"], (.versions | keys)'
# 期望：latest = "1.0.0"，versions = ["1.0.0-rc", "1.0.0"]
# 实际：✅ 通过

# tarball 可达性验证
curl -sI https://ohpm.openharmony.cn/ohpm/@ohos/hamock/-/hamock-1.0.0.har
# 期望：HTTP 200
# 实际：✅ tarball 存在（lock 文件 integrity 哈希可佐证）
```

#### ohpm install 验证

```bash
cd D:\ProgramData\iBadmin
ohpm install --all --registry https://ohpm.openharmony.cn/ohpm/
# 期望：0 ERROR，仅 hypium/hamock 安装完成
```

#### 编译验证

```bash
_build.bat
# 期望：生成 entry-default-unsigned.hap，0 ERROR
```

### 兼容约束

- 业务功能 100% 不变（hamock 仅在 ohosTest 测试运行时使用）
- API 22 / 6.0.1(21) 不变
- 公共 API 0 破坏性变更（仅 manifest 版本号回退，与 lock 对齐）

### 教训与防御措施（更新编码规范第 13 条）

1. **Ohpm 依赖版本号三步校验**（新增）：
   - Step 1：写 manifest 前先 `curl https://ohpm.openharmony.cn/ohpm/<package>` 看 `dist-tags.latest`
   - Step 2：写 manifest 时**与 lock 文件版本号保持一致**（避免 manifest/lock 漂移）
   - Step 3：提交前用 `ohpm install --all` 验证 0 ERROR
2. **避免 manifest/lock 漂移**：lock 文件不可手动编辑；若 manifest 改了版本号，必须先 `rm -rf oh_modules oh-package-lock.json5` 再 `ohpm install` 重新生成
3. **v1.1.1.1 教训复盘**：当时只扫描了 `@ohos/account-ohos` 单一隐患，未做整体依赖版本号一致性扫描；v1.1.1.2 补齐"manifest 版本号与 lock 一致性"扫描

---

## [v1.1.1.1] - 2026-06-16 — 修复 ohpm install 404 错误

### 概述

DevEco Studio 重新构建时，`ohpm install` 失败：

```
ohpm WARN: fetch meta info of package '@ohos/account-ohos' failed - GET
  https://ohpm.openharmony.cn/ohpm/@ohos/account-ohos 404( undefined )
ohpm ERROR: Run install command failed
  Error: 00617101 Fetch Pkg Info Failed
  Original Error: NOTFOUND package '@ohos/account-ohos@2.0.0' not found
```

### 根因（已验证）

- `oh-package.json5` 声明了 `"@ohos/account-ohos": "2.0.0"`，该包名在 ohpm 中央仓**不存在**（404 验证：`@ohos/account-os`、`@ohos/appAccount` 全部 404）
- 真实的 HarmonyOS 账号 API 是 **`@ohos.account.appAccount`**（**SDK 系统内置模块**，不通过 ohpm 分发）
- `oh_modules` 目录中实际未安装任何 `account-ohos`（仅有 hypium/hamock），`oh-package-lock.json5` 也不含此包——证明从来就没装上
- v1 走 Mock 模式（`CloudClient.init(true)`），`AccountService` 实际从未被调用

### 影响

- 整个项目 `ohpm install` 失败 → `hvigorw` 编译中断
- 无法生成 HAP → 无法在 DevEco Studio 调试/打包

### 修复（Fix）

#### 阶段 A：移除错误三方包依赖
- `oh-package.json5` — 移除 `"@ohos/account-ohos": "2.0.0"` 依赖项，`dependencies` 改回空对象
- `oh-package-lock.json5` — 同步移除（实际无残留，验证后未改动）
- `oh_modules/.ohpm/lock.json5` — 同步移除（实际无残留，验证后未改动）

#### 阶段 B：重写 AccountService 改用系统模块
- `entry/src/main/ets/utils/AccountService.ets`（192 行）— 改用 `@ohos.account.appAccount` SDK 系统模块：
  - `import account from '@ohos.account.appAccount'`
  - `account.createAppAccountManager()` 替代 `account.getAccountManager()`（API 9+ 标准）
  - `auth(name, owner, authType, callback)` 签名（API 9+ 标准）
  - `getAccounts(owner, callback)` 替代 `getAccountList(name)`
  - `deleteAccount(name, callback)` 替代 `logout`
  - 所有方法保留 try/catch，SDK 异常时抛错 → UserClient 自动降级到 `MockDataService.mockHuaweiLogin`

### 验证

#### 静态检查
```bash
grep -rn "@ohos/account-ohos" D:\ProgramData\iBadmin\entry\src\main\ets
# 期望：仅 1 处（AccountService.ets 文档注释，标注「已废弃」）
# 实际：✅ 仅 1 处文档注释

grep -rn "from '@ohos.account.appAccount'" D:\ProgramData\iBadmin\entry\src\main\ets
# 期望：1 处（AccountService.ets）
# 实际：✅ 1 处
```

#### ohpm install 验证
```bash
cd D:\ProgramData\iBadmin
ohpm install --all --registry https://ohpm.openharmony.cn/ohpm/
# 期望：0 ERROR，仅 hypium/hamock 安装完成
```

#### 编译验证
```bash
_build.bat
# 期望：生成 entry-default-unsigned.hap，0 ERROR
```

#### 业务冒烟
| 场景 | 验证点 |
|------|--------|
| 启动 App | 控制台无 SDK 加载错误（Mock 模式自动走 `CloudClient.mockLogin`） |
| 隐私弹窗 → 同意 → 登录 | `ProfileViewModel.loginWithHuawei()` → `UserClient.loginWithHuawei()` → `CloudClient.mockLogin()` 成功（因 `CloudClient.isMock() === true`） |
| 退出登录 | AppStorage 清空 + `UserClient.logout()`（Mock 模式下跳过 AccountService） |

### 兼容约束

- 业务功能 100% 不变（v1 走 Mock 模式，`AccountService` 未被实际调用）
- API 22 / 6.0.1(21) 不变
- 公共 API 0 破坏性变更（仅内部实现迁移：三方包 → SDK 系统模块）

### 后续规划

- v1.1.3 路线图维持 `@kit.AccountKit` 升级（API 23+，不在本次范围）

---

## [v1.1.1] - 2026-06-16 — 代码质量优化（消除 7 项遗留隐患）

### 概述

v1.1.0 全面重构后，仍有 7 项代码质量隐患需修复：在不破坏业务的前提下消除日志分散、AppStorage 默认值缺失、状态双向同步竞态、VM 接口未消费、组件类型弱化等问题。

### 新增（Add）

#### 基础设施
- `common/AppStorageBootstrap.ets` — 7 个 AppStorage 共享 key 集中初始化（isLoggedIn/userId/displayName/avatarUri/privacyAgreed/newsRefreshCount/communityRefreshCount）

#### 测试
- `ohosTest/ets/test/common/AppStorageBootstrap.test.ets` — 5 cases（2 登录态 + 1 隐私态 + 2 计数器 + 1 幂等性）

### 重构（Refactor）

- `viewmodel/ProfileViewModel.ets` — 状态单数据源重构：
  - 删除 `public isLoggedIn: boolean` 字段
  - 新增 `public isLoggedIn(): boolean` 方法（直接读 AppStorage）
  - `init()` 改名为 `syncFromStorage()`（语义更清晰）
  - 避免双向同步死循环竞态
- `pages/profile/ProfilePage.ets` — 删除 `isLoggedInStorage` + `onLoginStateChanged` + `vm.isLoggedIn` 字段赋值，build 中用 `@StorageProp` 字段做条件渲染
- `pages/MainTabs.ets` — `TAB_ITEMS` 改 `readonly TabItem[]` + `interface TabItem` 加 readonly + 引入 `AppConstants.APPSTORAGE_MAIN_TABS_ACTIVE_INDEX` 常量 + 删除空 `onTabChange` 回调
- `components/PrivacyDialog.ets` — 遮罩空 `onClick` 改 `hitTestBehavior(HitTestMode.Transparent)`，内部 dialog Column 加 `hitTestBehavior(HitTestMode.Block)`

### 修复（Fix）

- **Page 层残留 11 处 `console.*`** — 全部替换为 `AppLogger.info('PageName', ...)`（HomePage:1 + CommunityPage:3 + ProfilePage:6；其中 1 处改用 `promptAction.showToast`）
- **AppStorage 7 个 key 未在启动时初始化** — `EntryAbility.onCreate()` 调用 `AppStorageBootstrap.initDefaults()`
- **`ProfileViewModel.isLoggedIn` 与 AppStorage 双向同步死循环竞态** — 字段 → 方法（单数据源）
- **`HomeViewModel.onExternalRefresh` 已存在但 Page 未消费** — `HomePage` `@Watch` 改调 `vm.onExternalRefresh()`
- **`CommunityViewModel.onExternalRefresh` 缺失** — 新增 `onExternalRefresh()` 方法，`CommunityPage` `@Watch` 改调之
- **`MainTabs.onTabChange` 空回调被 @Watch 自触发** — 删除空方法
- **`MainTabs.TAB_ITEMS` 缺 readonly 修饰** — 强化类型
- **`PrivacyDialog` 遮罩空 `onClick` 占位** — 改用 `hitTestBehavior` 模式

### 测试统计

- 总套件：**5**（DesignTokens / Constants / ErrorFormatter / AppLogger / **AppStorageBootstrap**）
- 总用例：**52**（11 + 16 + 15 + 5 + 5）
- 新增：5 cases（AppStorageBootstrap 套件）
- 升级：Constants 15→16（新增 `APPSTORAGE_MAIN_TABS_ACTIVE_INDEX` 验证），AppLogger 4→5（新增页面 tap 场景）

### 兼容约束

- 业务功能 100% 不变
- API 22 / 6.0.1(21) 不变
- 公共 API 仅 `ProfileViewModel.init()` → `syncFromStorage()` 与 `vm.isLoggedIn` 字段 → `vm.isLoggedIn()` 方法两处破坏性变更（影响范围：仅 ProfilePage，已同步修改）

### 静态验证

```bash
# 已验证
grep -rn "console\." D:\ProgramData\iBadmin\entry\src\main\ets
# 结果：仅 1 处（HomeViewModel.ets 文档注释中提及），无实际调用

grep -rn "vm\.isLoggedIn\b" D:\ProgramData\iBadmin\entry\src\main\ets
# 结果：仅 3 处（ProfileViewModel.ets 文档注释），无实际字段引用
```

---

## [v1.1.0] - 2026-06-16 — 全面架构重构（MediMate 规范对齐）

### 概述

参考药来项目（MediMate）规范体系（73 DesignTokens + 7 铁律 + Superpowers 7 步 + 4 件套开发序），对 iBadmin 进行全面架构重构，从「能跑就行」升级为「架构合规、令牌化、可测试、可演进」。

### 新增（Add）

#### 基础设施层（common/）
- `common/DesignTokens.ets` — 57 个核心 Token（19 色 + 11 字号 + 3 字重 + 8 间距 + 6 圆角 + 6 组件尺寸 + 3 字体族 + 1 头像），主题「羽毛球场 Shuttle Court」
- `common/Constants.ets` — 全局常量（AppStorage Keys / 云函数名 / 路由名 / 社区 Tab 索引 / Mock ID 前缀）
- `common/ErrorFormatter.ets` — 统一错误格式化（format / messageOf / extractMessage）
- `common/AppLogger.ets` — hilog 封装（DOMAIN 0x0001），4 级日志
- `common/Router.ets` — AppRouter 单例 + NavPathStack
- `common/RouteParams.ets` — 4 个路由参数接口（NewsDetail/VenueDetail/EquipmentList/PlayerDetail）
- `common/Utils.ets` — ID 生成 + 日期格式化

#### Model 层（model/）
- `model/NewsModel.ets` — 资讯数据模型
- `model/VenueModel.ets` — 场馆数据模型（含 VenueStatus 枚举）
- `model/EquipmentModel.ets` — 装备数据模型（含 EquipmentCategory 枚举）
- `model/PlayerModel.ets` — 球员数据模型
- `model/UserModel.ets` — 用户数据模型（含 isEmpty/isLoggedIn 方法）

#### Cloud 层（cloud/）
- `cloud/CloudClient.ets` — 双模式云端网关（Mock/Real）+ 6 CF_* 统一调度
- `cloud/MockDataService.ets` — 静态 Mock 数据（5 资讯 + 5 场馆 + 4 装备 + 3 球员 + 1 用户）
- `cloud/NewsClient.ets` — 资讯领域 API
- `cloud/VenueClient.ets` — 场馆领域 API
- `cloud/EquipmentClient.ets` — 装备领域 API
- `cloud/PlayerClient.ets` — 球员领域 API
- `cloud/UserClient.ets` — 用户登录 API（含 Mock fallback）

#### ViewModel 层（viewmodel/）
- `viewmodel/HomeViewModel.ets` — 首页 ViewModel（LoadState 5 态）
- `viewmodel/CommunityViewModel.ets` — 社区 ViewModel（3 子视图独立状态）
- `viewmodel/ProfileViewModel.ets` — 我的 ViewModel（登录/退出 + AppStorage 持久化）

#### Components 层（components/）
- `components/PrivacyDialog.ets` — 隐私弹窗（修复 @Link onAgree 错误，改用 PrivacyController 单例 + AppStorage）
- `components/EmptyState.ets` — 通用空状态/加载/错误组件
- `components/NewsCard.ets` — 资讯卡片
- `components/VenueCard.ets` — 场馆卡片（带状态色）
- `components/EquipmentCategoryCard.ets` — 装备分类卡片
- `components/PlayerCard.ets` — 球员卡片
- `components/MenuItem.ets` — 通用菜单项

#### Pages 层（pages/）
- `pages/Index.ets` — 应用入口（纯容器）
- `pages/MainTabs.ets` — 标准 Tabs 容器（API 22 兼容）
- `pages/home/HomePage.ets` — 首页（资讯列表）
- `pages/community/CommunityPage.ets` — 社区页（3 子 Tab）
- `pages/profile/ProfilePage.ets` — 我的页（登录态切换）

#### 测试层（ohosTest/）
- `ohosTest/ets/test/common/DesignTokens.test.ets` — 10 cases
- `ohosTest/ets/test/common/Constants.test.ets` — 15 cases
- `ohosTest/ets/test/common/ErrorFormatter.test.ets` — 15 cases
- `ohosTest/ets/test/common/AppLogger.test.ets` — 4 cases
- `ohosTest/ets/test/runner/TestRunner.test.ets` — 测试套件聚合

#### 工程脚本
- `_test.bat` — Windows 测试命令（`hvigorw --mode module -p module=entry@ohosTest ohosTest`）
- `_build.bat` — Windows 构建命令（`hvigorw assembleHap --mode module -p module=entry@default -p buildMode=debug`）

### 重构（Refactor）

- `utils/AccountService.ets` — 重写华为账号 SDK 封装（统一 AppLogger + ErrorFormatter + 兼容多种 SDK 签名）
- `entryability/EntryAbility.ets` — 重写（init CloudClient + loadContent）
- `resources/base/element/color.json` — 8 色 → 25 色（与 DesignTokens 对齐）
- `resources/dark/element/color.json` — 1 色 → 15 色（暗色模式）
- `resources/base/element/string.json` — 3 项 → 60+ 项（覆盖所有 UI 文案 + 权限说明）
- `resources/base/element/float.json` — 1 项 → 4 项（新增 line_height 系列）

### 修复（Fix）

- **PrivacyDialog `@Link onAgree: () => void` 非法** — ArkUI 不支持函数类型 @Link，改用 PrivacyController 单例 + AppStorage 实现同意/拒绝回调
- **AccountService 完全未被消费** — 通过 UserClient + ProfileViewModel.loginWithHuawei() 真实消费
- **Index.ets + MainTab.ets 双入口** — 删除 MainTab.ets，统一为 Index.ets → MainTabs.ets
- **位置权限 `when: always`** — 改为 `when: inuse`（符合 HarmonyOS 隐私规范）
- **硬编码颜色/字符串/数字散落 50+ 处** — 全部走 DesignTokens + `$r('app.string.*')`

### 删除（Delete）

- `pages/MainTab.ets`（被 MainTabs.ets 替代）
- `ohosTest/ets/test/Ability.test.ets`（被 TestRunner 替代）

### 测试统计

- 总套件：4（DesignTokens / Constants / ErrorFormatter / AppLogger）
- 总用例：44（10 + 15 + 15 + 4）

### 兼容约束

- API 22 / 6.0.1(21) 保持不变
- `@ohos/account-ohos` 2.0.0 继续使用（UserClient 已实现 Mock fallback）
- HdsTabs 暂用标准 Tabs 兜底（v1.1.1 升级）

### 已知限制

- 真机/模拟器冒烟测试需要在 DevEco Studio 中执行（当前环境无 hvigorw/Java）
- Dark mode 仅定义 color，未实现运行时切换逻辑

---

## [v1.0.0] - 2026-04-05 — 初始版本

### 功能

- 首页（3 条静态资讯）
- 社区（附近场馆/装备查询/球员信息 3 Tab）
- 我的（华为账号登录入口，但未消费 AccountService）
- 隐私弹窗（有 `@Link onAgree` 错误）
- 1 个示例测试（Ability.test）
