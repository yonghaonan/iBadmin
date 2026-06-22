/**
 * AIAssistantButton — 顶部 AI 助理按钮（A2/A3 通用）
 *
 * 特性：
 * - 圆形 48vp 按钮
 * - 浅色：橙色背景 + 极轻光晕
 * - 深色：橙色 + 强霓虹光晕 (8-12px)
 * - 含可选的 onTap 回调
 *
 * 设计：用作 HomePage 头部右侧的"AI 助理"入口
 */

import { DesignTokens } from '../common/DesignTokens';

@Component
export struct AIAssistantButton {
  public onTap: () => void = (): void => {};
  @Prop public icon: string = '🤖';

  public build(): void {
    Stack({ alignContent: Alignment.Center }) {
      // 外层光晕（深色下显示为霓虹）
      Column()
        .width(DesignTokens.AI_BUTTON_SIZE + 8)
        .height(DesignTokens.AI_BUTTON_SIZE + 8)
        .borderRadius((DesignTokens.AI_BUTTON_SIZE + 8) / 2)
        .backgroundColor($r('app.color.ai_glow_color'))
        .opacity(0.5)
        .hitTestBehavior(HitTestMode.Transparent)

      // 内层按钮
      Column() {
        Text(this.icon)
          .fontSize(24)
      }
      .width(DesignTokens.AI_BUTTON_SIZE)
      .height(DesignTokens.AI_BUTTON_SIZE)
      .borderRadius(DesignTokens.AI_BUTTON_SIZE / 2)
      .backgroundColor($r('app.color.ai_orange'))
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .shadow(ShadowStyle.OUTER_DEFAULT_XS)
    }
    .width(DesignTokens.AI_BUTTON_SIZE + 8)
    .height(DesignTokens.AI_BUTTON_SIZE + 8)
    .onClick((): void => {
      this.onTap();
    })
  }
}
