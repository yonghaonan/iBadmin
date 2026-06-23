// ohosTest/ets/test/common/DesignTokens.test.ets
// DesignTokens 单元测试 — 11 cases
// 验证色彩、字体、间距、圆角 Token 值稳定（防手抖改动）
// v1.1.4 修复：主色从球场蓝(#1E88E5)改为活力橙(#FF8C00)，同步更新断言
import { describe, it, expect } from '@ohos/hypium'
import { DesignTokens } from '../../../../main/ets/common/DesignTokens'

export default function DesignTokensTest() {
  describe('DesignTokens_Color', () => {
    it('color_001_primary_vibrant_orange', 0, () => {
      expect(DesignTokens.COLOR_PRIMARY).assertEqual('#FF8C00')
    })
    it('color_002_secondary_court_green', 1, () => {
      expect(DesignTokens.COLOR_SECONDARY).assertEqual('#43A047')
    })
    it('color_003_accent_deep_orange', 2, () => {
      expect(DesignTokens.COLOR_ACCENT).assertEqual('#FF6F00')
    })
    it('color_004_text_primary', 3, () => {
      expect(DesignTokens.COLOR_TEXT_PRIMARY).assertEqual('#1A1A1A')
    })
  })

  describe('DesignTokens_FontSize', () => {
    it('font_001_h1', 0, () => {
      expect(DesignTokens.FONT_H1).assertEqual(24)
    })
    it('font_002_body', 1, () => {
      expect(DesignTokens.FONT_BODY).assertEqual(15)
    })
    it('font_003_emoji_hero', 2, () => {
      expect(DesignTokens.FONT_EMOJI_HERO).assertEqual(96)
    })
  })

  describe('DesignTokens_Spacing', () => {
    it('spacing_001_xs', 0, () => {
      expect(DesignTokens.SPACING_XS).assertEqual(4)
    })
    it('spacing_002_md', 1, () => {
      expect(DesignTokens.SPACING_MD).assertEqual(16)
    })
  })

  describe('DesignTokens_Radius', () => {
    it('radius_001_md', 0, () => {
      expect(DesignTokens.RADIUS_MD).assertEqual(12)
    })
    it('radius_002_card', 1, () => {
      expect(DesignTokens.RADIUS_CARD).assertEqual(16)
    })
  })
}
