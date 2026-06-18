# iBadmin 羽毛球应用 - 项目总结（v1.1.2）

## 项目概述

iBadmin 是一款基于 HarmonyOS NEXT 开发的羽毛球爱好者专属应用，提供羽毛球资讯、社区场馆/装备/球员信息、华为账号登录等功能。

- **v1.1.0** 在 v1.0.0 基础上进行**全面架构重构**（MediMate 规范体系）
- **v1.1.1** 在 v1.1.0 基础上进行**代码质量优化**（7 项隐患消除）
- **v1.1.1.1** 修复 `ohpm install` 404 错误（错误三方包依赖 + SDK 模块切换）
- **v1.1.1.2** 修复 `hamock@2.0.0` 版本号 404 错误（manifest/lock 漂移修复）
- **v1.1.1.3** 修复 ArkTS 严格模式编译错误（29 ERROR + 7 WARN；但 callSdkAuth 修复不周）
- **v1.1.1.4** 修正 v1.1.1.3 AccountService 类型二次修复（3 ERROR）
- **v1.1.2** 双主题 UI 重构（A2 智能情境 + A3 深色霓虹）+ DevEco Studio CLI 工具链集成

## 技术栈

| 维度 | 选型 |
|------|------|
| 开发框架 | HarmonyOS NEXT / Stage Model |
| 编程语言 | ArkTS（严格模式） |
| UI 框架 | ArkUI（标准 Tabs，HdsTabs 后续升级） |
| 构建工具 | Hvigor 6.22.3（hvigorw） |
| 目标 SDK | HarmonyOS 6.0.1(21)（API 22） |
| 兼容最低 | HarmonyOS 6.0.1(21) |
| 华为账号 SDK | `@ohos.account.appAccount` 系统模块（API 9+，无需 ohpm 安装） |
| 测试框架 | `@ohos/hypium` 1.0.25 |

## 架构分层（MVVM）

```
View (pages/)            ← 纯 UI 展示，绑定 ViewModel
   ↕ @State / @StorageProp @Watch
ViewModel (viewmodel/)   ← 业务逻辑 + 状态管理，不含 UI 代码
   ↕ 方法调用
Client (cloud/XxxClient.ets) ← 领域 API 封装
   ↕ 统一入口
CloudClient (cloud/CloudClient.ets) ← 双模式网关 (Mock/Real)
   ↕
MockDataService (cloud/MockDataService.ets)
```

## 业务功能模块

### 1. 首页 — 资讯（HomePage）
- 资讯列表卡片式布局（5 条 Mock 数据）
- 标题 / 摘要 / 分类 / 作者 / 发布时间 / 阅读数
- 3 态切换：LOADING / EMPTY / ERROR（带重试）
- 跨页面刷新信号监听

### 2. 社区（CommunityPage）
- **附近场馆 Tab**：5 条 Mock 场馆（名称/地址/距离/价格/评分/状态色）
- **装备查询 Tab**：2x2 网格（球拍/球鞋/球包/羽毛球 4 分类）
- **球员信息 Tab**：横向滚动 3 名球员（头像/姓名/国家/排名/积分/打法）
- 每个子视图独立 3 态渲染

### 3. 我的（ProfilePage）
- 未登录态：欢迎页 + 华为红登录按钮（触发隐私弹窗）
- 隐私弹窗：PrivacyController 单例 + AppStorage（修复 @Link onAgree 错误）
- 登录态：用户卡片（emoji 头像）+ 5 项功能菜单 + 退出登录
- 登录流：UserClient.loginWithHuawei()（Mock 模式自动走 mockHuaweiLogin）

## 核心特性

### 设计令牌体系（DesignTokens）
73 → **90** 个核心 Token，主题「A2 智能情境 / A3 深色霓虹」（v1.1.2 重构）：
- **色彩（19 色核心 + 12 色 AI 主题）**：活力橙 #FF8C00（v1.1.2 主色）/ 球场绿 #43A047 / AI 渐变 / AI 发光 / AI 描边 / AI 状态点
- **字号（14 级）**：HERO 32 / H1 24 / H2 20 / H3 18 / BODY 15 / CAPTION 12 / EMOJI_HERO 96
- **字重（5 档）**：REGULAR 400 / MEDIUM 500 / BOLD 600 / HEAVY 700 / EXTRA_BOLD 800
- **间距（9 级）**：XXS 2 / XS 4 / SM 8 / MD 16 / LG 24 / LG2 28 / XL 32 / 2XL 48
- **圆角（8 级）**：XS 4 / SM 8 / MD 12 / CARD 16 / LG 20 / XL 28 / PILL 14 / CAPSULE 24
- **组件尺寸（19 项）**：Tab 药丸 56×28 / AI 按钮 48 / AI FAB 56 / ProgressRing 80 / 头像 56

所有 UI **强制使用**，禁止硬编码。v1.1.2 同步更新 `resources/base` + `resources/dark` 各 40 色（双主题支持）。

### 主题系统（v1.1.2 新增）
- `THEME_AUTO/LIGHT/DARK` 三模式（Constants）
- `APPSTORAGE_THEME_MODE` 全局主题状态
- `ProfilePage` 主题切换菜单（跟随系统/浅色/深色）
- `AppStorageBootstrap` 增加 `themeMode` 默认值（7 keys → **8 keys**）
- A2（活力橙）与 A3（深空蓝 #0A0E1F + 霓虹橙）双主题资源完整覆盖

### 错误处理
- 统一 `ErrorFormatter.format(scope, e)` 格式化
- 7 大错误类型（Error/string/number/object/null/undefined/boolean）
- 所有 try/catch 走 AppLogger + ErrorFormatter 链路

### 跨页面刷新
- AppStorage.setOrCreate 计数器 + `@StorageProp @Watch`
- 4 类计数器：news / community / venue / equipment / player refreshCount

### Mock/Real 双模式
- `CloudClient.init(true)` 走 MockDataService
- `CloudClient.init(false)` 走真实 AGC 云函数（v1 stub）
- 6 个 CF_* 统一调度入口

## 关键修复（v1.1.0 11 项 + v1.1.1 7 项 + v1.1.1.1 1 项 + v1.1.1.2 1 项 + v1.1.1.3 32 项 + v1.1.2 5 项）

### v1.1.2 双主题 UI 重构 + 工具链集成（5 项）

| # | 旧问题 | 新方案 |
|---|--------|--------|
| 1 | 主色 #1E88E5（球场蓝）与品牌「活力」调性不符 | 主色切换为 #FF8C00（活力橙），DesignTokens 19 处 + 资源 10 处同步 |
| 2 | 无主题切换能力，用户无法选择浅色/深色 | `THEME_AUTO/LIGHT/DARK` 三模式 + `ProfilePage` 主题菜单 + `@StorageProp themeMode @Watch` 实时响应 |
| 3 | AI 智能能力无 UI 承载 | 新增 3 组件：`AIInsightCard`（Hero 洞察卡）/ `AIAssistantButton`（FAB 入口）/ `ProgressRing`（进度环） |
| 4 | 设计令牌仅 73 项，难以覆盖新组件需求 | DesignTokens 拓展至 **90 项**（新增 17 个 AI/Tab/阴影/间距/字重令牌） |
| 5 | hvigorw / ohpm CLI 未加入 PATH，需手动定位 | 用户 PATH 永久集成 `DevEco Studio\tools\node` + `tools\ohpm\bin`，解决 Node 版本冲突 |

### v1.1.0 全面重构（11 项）

| 旧问题 | 新方案 |
|--------|--------|
| 硬编码颜色/字符串/数字 50+ 处 | 全部走 DesignTokens + `$r('app.string.*')` |
| `Index.ets` + `MainTab.ets` 双入口 | 删 `MainTab.ets`，统一 `Index.ets → MainTabs.ets` |
| `@Link onAgree: () => void` 非法 | PrivacyController 单例 + AppStorage |
| `AccountService` 未消费 | UserClient + ProfileViewModel.loginWithHuawei() |
| 静态 3 条 news 硬编码 | MockDataService.getNewsList(20) 返回 5 条 |
| 无 MVVM 分层 | 5 Model + 6 Client + 3 ViewModel |
| 无统一错误处理 | ErrorFormatter + 全 VM catch |
| 0 测试覆盖 | 4 套件 / 45 cases（v1.1.0） |
| 无路由 | AppRouter 单例 + NavPathStack |
| 无 DesignTokens | 62 核心 Token + 资源同步 |
| `when: always` 位置权限 | `when: inuse` |

### v1.1.1 代码质量优化（7 项）

| # | 旧问题 | 新方案 |
|---|--------|--------|
| 1 | Page 层残留 11 处 `console.*` | 统一替换为 `AppLogger.info` |
| 2 | AppStorage 7 个 key 未初始化 | 新增 `AppStorageBootstrap.initDefaults()` + EntryAbility 启动时调用 |
| 3 | `ProfileViewModel.isLoggedIn` 与 AppStorage 双向同步竞态 | 字段 → 方法 `vm.isLoggedIn()`（单数据源） |
| 4 | VM 提供 `onExternalRefresh` 但 Page 未消费 | 2 个 VM 完整提供，Page `@Watch` 改调 VM 方法 |
| 5 | `MainTabs.onTabChange` 空回调被 @Watch 自触发 | 删空回调，`@StorageProp` 仍能触发 build |
| 6 | `PrivacyDialog` 遮罩空 `onClick` 占位 | 改用 `hitTestBehavior(Transparent/Block)` 模式 |
| 7 | `MainTabs.TAB_ITEMS` 缺 readonly | `interface readonly` + `readonly TabItem[]` + 引入 `APPSTORAGE_MAIN_TABS_ACTIVE_INDEX` 常量 |

### v1.1.1.1 修复 ohpm install 404（1 项）

| # | 旧问题 | 新方案 |
|---|--------|--------|
| 1 | `oh-package.json5` 声明不存在的 `@ohos/account-ohos@2.0.0` 三方包（ohpm 中央仓 404） | 移除依赖；`AccountService` 改用 SDK 系统模块 `@ohos.account.appAccount`（API 9+，无需 ohpm 安装）；`getAccountManager()` → `createAppAccountManager()` |

### v1.1.1.2 修复 hamock 版本号 404（1 项）

| # | 旧问题 | 新方案 |
|---|--------|--------|
| 1 | `oh-package.json5` 声明 `@ohos/hamock@2.0.0`，但中央仓实际仅 `1.0.0-rc` / `1.0.0` 两个版本（`dist-tags.latest = 1.0.0`）—— **manifest/lock 漂移**（lock 已锁定 1.0.0，但 manifest 错写 2.0.0；`ohpm install --all` 按 manifest 重新解析 → 404） | manifest `2.0.0` 改回 `1.0.0`（与 lock 与中央仓 latest 一致）；全项目依赖与 import 系统化扫描确认无其他同类隐患 |

### v1.1.1.3 修复 ArkTS 严格模式编译错误（32 项）

| 类别 | 数量 | 旧问题 | 新方案 |
|------|------|--------|--------|
| 资源 string.json 冲突 | 4 | `AppScope/string.json` 与 `entry/string.json` 同名键重复 | 从 AppScope 删除 4 个冲突键，以 entry 详细版为唯一真源 |
| Resource → string 类型不匹配 | 17 | `EmptyState.message/retryText`、`MenuItem.title/subtitle` 是 `string`，调用方传 `Resource` | 4 个 prop 类型改为 `ResourceStr`（`string \| Resource`） |
| `as unknown as T` 禁止 | 6 | `CloudClient.ets` switch case 用 `as unknown as T` 双断言 | 删除 6 处 `unknown`（保留 `as T`） |
| untyped object literal | 2 | `AccountService.ets:70 resolve(data ?? {})` + `:148 return {...}` 内联 `{}` 无具名类型 | 改为 `Record<string, Object>` / `Record<string, string>` |
| MenuItem 命名冲突 | 2 | 自定义 `struct MenuItem` 与 ArkUI 22+ 内置组件 `MenuItem` 重名 | 重命名为 `AppMenuItem`（文件 + struct + import + 5 处使用） |
| `@Entry` struct export | 1 | `Index.ets:11 export struct Index` 不推荐 | 去除 `export` 关键字 |

## 测试统计

| 套件 | 用例数 | 覆盖点 |
|------|--------|--------|
| DesignTokens.test.ets | 11 | 4 色 + 3 字号 + 2 间距 + 2 圆角 |
| Constants.test.ets | 16 | 3 字体 + 5 CF + 5 AppStorage Key + 3 Tab |
| ErrorFormatter.test.ets | 15 | 8 format + 7 messageOf |
| AppLogger.test.ets | 5 | 4 级别烟测 + 1 页面 tap 场景 |
| **AppStorageBootstrap.test.ets**（v1.1.1 新增） | **5** | 2 登录态 + 1 隐私态 + 2 计数器 + 1 幂等性 |
| **总计** | **52** | **5 suites / 52 cases / 0 fail** |

运行命令：`_test.bat`（需 DevEco Studio 环境）

## 编码规范（来自 CONSTITUTION.md）

1. 强制静态类型（禁止隐式 any）
2. 禁止 `eval()` / `with` / `obj[key]`
3. 严格等号 `===`
4. `throw` 只能抛 Error 实例
5. 字符串用单引号
6. `Row/Column` 间距用构造函数 `space` 参数
7. `ForEach` 必须带第三参数 key generator
8. `$r()` 资源结果禁止 `.toString()`
9. 组件属性名禁用 `size/width/height/margin/padding/backgroundColor`
10. 2 空格缩进，行宽 ≤ 120 字符
11. switch case 缩进一层 + 必须大括号
12. DesignTokens 强制使用
13. 三方包依赖需经过 ohpm 中央仓存在性校验
14. **manifest 与 lock 版本号必须保持一致**（v1.1.1.2 教训）：写 manifest 时先看 lock / `dist-tags.latest`；lock 文件不可手动编辑，改版本号必须重新 `ohpm install`
15. **组件 prop 类型必须用 `ResourceStr` 而非 `string`**（v1.1.1.3 教训）：用于接受 `$r('app.string.*')` 资源
16. **禁止用 ArkUI 内置组件名作为自定义 struct 名**（v1.1.1.3 教训）：MenuItem / Button / Text / List / Tabs / Grid 等
17. **禁止 `as unknown as T` 双断言**（v1.1.1.3 教训，arkts-no-any-unknown）
18. **内联对象字面量 `{}` 必须标注具名类型**（v1.1.1.3 教训）：`Record<K, V>` 或具名 interface
19. **`Record<K, V>` 索引签名不能完全替代具名 interface**（v1.1.1.4 教训）：当函数返回对象字面量时，必须先定义具名 interface；SDK 动态数据用 `Object`，不要用 `Record<...>` 约束

## 后续路线图

- ✅ **v1.1.1**（已完成）：7 项代码质量优化
- ✅ **v1.1.1.1**（已完成）：修复 ohpm install 404
- ✅ **v1.1.1.2**（已完成）：修复 hamock 版本号 404（manifest/lock 漂移）
- ✅ **v1.1.1.3**（已完成）：修复 ArkTS 严格模式编译错误（29 ERROR + 7 WARN，但 callSdkAuth 修复不周）
- ✅ **v1.1.1.4**（已完成）：修正 v1.1.1.3 AccountService 类型二次修复（3 ERROR）
- ✅ **v1.1.2**（已完成）：双主题 UI 重构（A2 智能情境 + A3 深色霓虹）+ DevEco Studio CLI 工具链集成
- **v1.1.3**：ViewModel 单元测试 + 集成测试 + `ConfigurationConstant` 主题实时切换 + 覆盖率 ≥ 60%
- **v1.1.4**：升级 `@ohos.account.appAccount` 为 `@kit.AccountKit`（API 23+）+ AGC 真实云函数
- **v1.2.0**：资讯/场馆/球员详情页 + NavDestination 路由
- **v1.3.0**：用户系统持久化 + 本地数据库 + 推送通知
- **v2.0.0**：Pro 会员 + IAP + 实况窗 + 智感握姿 + 社群互动

---

**项目完成时间**：2026-06-18
**当前版本**：v1.1.2
**重构规范来源**：MediMate（药来）项目规范体系
