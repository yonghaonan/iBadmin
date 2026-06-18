// common/DesignTokens.ets
// 设计令牌系统 — 主题「羽毛球场 Shuttle Court」
// 所有 UI 颜色/字号/间距/圆角必须使用本文件的静态常量，禁止硬编码
// 同步资源：resources/base/element/color.json
//
// v1.1.2 更新（UI 重构 — A2 智能情境 + A3 深色霓虹）：
// - 新增 RADIUS_XL / RADIUS_PILL（药丸 Tab / 大圆角卡片）
// - 新增 AI_BUTTON_SIZE / AI_FAB_SIZE / AI_INSIGHT_HEIGHT
// - 新增 PROGRESS_RING_SIZE / TAB_PILL_WIDTH / TAB_PILL_HEIGHT
// - 新增 SHADOW_SOFT_RADIUS / SHADOW_SOFT_OFFSET_Y（轻阴影）
// - 新增 SPACING_XS3 / SPACING_LG2（拓展间距）
// - 新增 WEIGHT_HEAVY / WEIGHT_EXTRA_BOLD（拓展字重）
export class DesignTokens {
  // ========== 色彩系统（19 色核心 + 8 辅助）==========

  // 活力橙（v1.1.2 主品牌色，替代原"蓝天蓝"）
  static readonly COLOR_PRIMARY: string = '#FF8C00'
  static readonly COLOR_PRIMARY_LIGHT: string = '#FFB74D'
  static readonly COLOR_PRIMARY_DARK: string = '#FF6F00'
  static readonly COLOR_PRIMARY_BG: string = '#FFF4E6'

  // 球场绿 — 标准羽毛球场地（保留业务色）
  static readonly COLOR_SECONDARY: string = '#43A047'
  static readonly COLOR_SECONDARY_BG: string = '#E8F5E9'

  // 球黄（v1.1.2 改用智能橙深）
  static readonly COLOR_ACCENT: string = '#FF6F00'
  static readonly COLOR_ACCENT_BG: string = '#FFF8E1'

  // 文本色（三级）
  static readonly COLOR_TEXT_PRIMARY: string = '#1A1A1A'
  static readonly COLOR_TEXT_SECONDARY: string = '#5D4037'
  static readonly COLOR_TEXT_HINT: string = '#9E9E9E'

  // 背景与表面
  static readonly COLOR_BACKGROUND: string = '#FFFFFF'
  static readonly COLOR_CARD_BG: string = '#FFFFFF'
  static readonly COLOR_DIVIDER: string = '#F5F5F5'

  // 场馆状态色（业务）
  static readonly COLOR_STATUS_AVAILABLE: string = '#43A047'
  static readonly COLOR_STATUS_BUSY: string = '#FB8C00'
  static readonly COLOR_STATUS_FULL: string = '#E53935'
  static readonly COLOR_STATUS_PRO: string = '#8E24AA'

  // 通用语义色
  static readonly COLOR_DANGER: string = '#E53935'
  static readonly COLOR_SUCCESS: string = '#43A047'
  static readonly COLOR_WARNING: string = '#FB8C00'
  static readonly COLOR_ERROR_TEXT: string = '#C62828'

  // 辅助色
  static readonly COLOR_TEXT_ON_PRIMARY: string = '#FFFFFF'
  static readonly COLOR_HUAWEI_RED: string = '#E60012'
  static readonly COLOR_HUAWEI_RED_BG: string = '#FFEBEE'
  static readonly COLOR_SHADOW: string = 'rgba(255,140,0,0.15)'
  static readonly COLOR_OVERLAY: string = 'rgba(255,255,255,0.85)'

  // ========== v1.1.2 新增 AI 智能主题色 ==========
  static readonly COLOR_AI_ORANGE: string = '#FF8C00'
  static readonly COLOR_AI_ORANGE_DARK: string = '#FF6F00'
  static readonly COLOR_AI_INSIGHT_BG_START: string = '#FFF4E6'
  static readonly COLOR_AI_INSIGHT_BG_END: string = '#FFE0B2'
  static readonly COLOR_AI_TAG_BG_START: string = '#FF8C00'
  static readonly COLOR_AI_TAG_BG_END: string = '#FF6F00'
  static readonly COLOR_AI_BORDER: string = '#FFF0DC'
  static readonly COLOR_AI_STATUS_DOT: string = '#43A047'
  static readonly COLOR_AI_GLOW: string = 'rgba(255,140,0,0.4)'
  static readonly COLOR_AI_GLOW_STRONG: string = 'rgba(255,140,0,0.7)'
  static readonly COLOR_SHADOW_SOFT: string = 'rgba(0,0,0,0.04)'
  static readonly COLOR_SHADOW_AI_BUTTON: string = 'rgba(255,140,0,0.5)'

  // ========== 字体尺寸（fp）==========
  static readonly FONT_HERO: number = 32
  static readonly FONT_H1: number = 24
  static readonly FONT_H2: number = 20
  static readonly FONT_H3: number = 18
  static readonly FONT_SUBTITLE: number = 16
  static readonly FONT_BODY: number = 15
  static readonly FONT_SMALL: number = 13
  static readonly FONT_CAPTION: number = 12
  static readonly FONT_TINY: number = 10
  static readonly FONT_EMOJI: number = 24
  static readonly FONT_EMOJI_LG: number = 32
  static readonly FONT_EMOJI_XL: number = 48
  static readonly FONT_EMOJI_HERO: number = 96

  // ========== 字重 ==========
  static readonly WEIGHT_REGULAR: number = 400
  static readonly WEIGHT_MEDIUM: number = 500
  static readonly WEIGHT_BOLD: number = 600
  static readonly WEIGHT_HEAVY: number = 700
  static readonly WEIGHT_EXTRA_BOLD: number = 800

  // ========== 间距（vp）==========
  static readonly SPACING_XXS: number = 2
  static readonly SPACING_XS: number = 4
  static readonly SPACING_XS2: number = 12
  static readonly SPACING_XS3: number = 20
  static readonly SPACING_SM: number = 8
  static readonly SPACING_MD: number = 16
  static readonly SPACING_LG: number = 24
  static readonly SPACING_LG2: number = 28
  static readonly SPACING_XL: number = 32
  static readonly SPACING_2XL: number = 48

  // ========== 圆角（vp）==========
  static readonly RADIUS_XS: number = 4
  static readonly RADIUS_SM: number = 8
  static readonly RADIUS_MD: number = 12
  static readonly RADIUS_CARD: number = 16
  static readonly RADIUS_LG: number = 20
  static readonly RADIUS_CAPSULE: number = 24
  static readonly RADIUS_XL: number = 28
  static readonly RADIUS_PILL: number = 14

  // ========== 组件特定尺寸 ==========
  static readonly TAB_BAR_HEIGHT: number = 72
  static readonly TAB_PILL_WIDTH: number = 56
  static readonly TAB_PILL_HEIGHT: number = 28
  static readonly AVATAR_SIZE: number = 56
  static readonly ICON_SIZE: number = 24
  static readonly ICON_BOX_SIZE: number = 48
  static readonly ICON_ROW_SIZE: number = 32
  static readonly INPUT_HEIGHT: number = 40
  static readonly CARD_HEIGHT: number = 80
  static readonly SEARCH_BAR_HEIGHT: number = 40
  static readonly BANNER_HEIGHT: number = 56
  static readonly EQUIPMENT_CARD_HEIGHT: number = 120
  static readonly PLAYER_CARD_WIDTH: number = 120
  static readonly PLAYER_CARD_HEIGHT: number = 180

  // AI 专属尺寸
  static readonly AI_BUTTON_SIZE: number = 48
  static readonly AI_FAB_SIZE: number = 56
  static readonly AI_INSIGHT_HEIGHT: number = 96
  static readonly PROGRESS_RING_SIZE: number = 80

  // ========== 行高 ==========
  static readonly LINE_HEIGHT_BODY: number = 22
  static readonly LINE_HEIGHT_HEADING: number = 28
  static readonly LINE_HEIGHT_INSIGHT: number = 22

  // ========== 透明度 ==========
  static readonly OPACITY_DISABLED: number = 0.4
  static readonly OPACITY_SECONDARY: number = 0.7
  static readonly OPACITY_FULL: number = 1.0

  // ========== 阴影 ==========
  static readonly SHADOW_RADIUS: number = 12
  static readonly SHADOW_OFFSET_Y: number = 4
  static readonly SHADOW_SOFT_RADIUS: number = 8
  static readonly SHADOW_SOFT_OFFSET_Y: number = 2

  // ========== 字体族（仅系统字体）==========
  static readonly FONT_FAMILY: string = 'HarmonyOS Sans'
  static readonly FONT_FAMILY_MEDIUM: string = 'HarmonyOS Sans Medium'
  static readonly FONT_FAMILY_BOLD: string = 'HarmonyOS Sans Bold'

  // ========== 默认头像 emoji ==========
  static readonly DEFAULT_AVATAR_EMOJI: string = '🏸'
}
