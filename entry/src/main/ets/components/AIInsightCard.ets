/**
 * AIInsightCard — 智能洞察 Hero 卡片（A2 智能情境核心组件）
 *
 * 特性：
 * - 浅色模式：浅橙渐变背景 + 极轻橙边 + 状态点（绿）
 * - 深色模式：深色半透明渐变 + 橙色描边 + 霓虹光晕
 * - 展示"今日 AI 洞察" + 智能推荐文案
 *
 * 配合 HomePage 使用，位于头部智能问候下方、智能资讯列表上方
 */

import { DesignTokens } from '../common/DesignTokens';

@Component
export struct AIInsightCard {
  @Prop public insightLabel: ResourceStr = $r('app.string.ai_insight_label');
  @Prop public insightContent: ResourceStr = $r('app.string.ai_insight_content');
  @Prop public suggestionLabel: ResourceStr = $r('app.string.ai_insight_suggestion_label');
  @Prop public suggestionText: ResourceStr = $r('app.string.ai_insight_suggestion_text');

  public build(): void {
    Column() {
      // 顶部：状态点 + 洞察标签
      Row() {
        // 状态点（绿色 = AI 在线）
        Row()
          .width(10)
          .height(10)
          .borderRadius(5)
          .backgroundColor($r('app.color.ai_status_dot'))
          .margin({ right: DesignTokens.SPACING_XS })

        Text(this.insightLabel)
          .fontSize(DesignTokens.FONT_BODY)
          .fontWeight(DesignTokens.WEIGHT_HEAVY)
          .fontColor($r('app.color.ai_orange_dark'))
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .margin({ bottom: DesignTokens.SPACING_XS })

      // 洞察内容
      Text(this.insightContent)
        .fontSize(DesignTokens.FONT_SMALL)
        .fontColor($r('app.color.text_secondary'))
        .lineHeight(DesignTokens.LINE_HEIGHT_INSIGHT)
        .width('100%')
        .margin({ bottom: DesignTokens.SPACING_SM })

      // 建议
      Row() {
        Text(this.suggestionLabel)
          .fontSize(DesignTokens.FONT_SMALL)
          .fontWeight(DesignTokens.WEIGHT_HEAVY)
          .fontColor($r('app.color.ai_orange_dark'))
          .margin({ right: DesignTokens.SPACING_XS })

        Text(this.suggestionText)
          .fontSize(DesignTokens.FONT_SMALL)
          .fontColor($r('app.color.text_primary'))
          .layoutWeight(1)
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .padding(DesignTokens.SPACING_LG)
    .borderRadius(DesignTokens.RADIUS_LG)
    .backgroundColor($r('app.color.primary_bg'))
    .border({
      width: 1,
      color: $r('app.color.ai_border')
    })
    .alignItems(HorizontalAlign.Start)
  }
}
