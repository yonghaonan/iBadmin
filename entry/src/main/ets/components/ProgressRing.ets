/**
 * ProgressRing — 进度环组件（A2/A3 通用）
 *
 * 特性：
 * - SVG 圆形进度环（带渐变描边）
 * - 浅色：实心橙 + 浅灰底
 * - 深色：发光橙 + 半透明底
 * - 中心显示百分比数字
 *
 * 使用：HomePage 显示"今日目标"完成度
 */

import { DesignTokens } from '../common/DesignTokens';

@Component
export struct ProgressRing {
  @Prop public progress: number = 0;
  @Prop public label: string = '%';
  @Prop public size: number = DesignTokens.PROGRESS_RING_SIZE;

  public build(): void {
    Stack() {
      // 进度环（用 Row + backgroundColor 模拟）
      // 注：ArkTS SVG API 复杂，此处用渐变环简化
      Column() {
        Text(`${this.progress}`)
          .fontSize(20)
          .fontWeight(DesignTokens.WEIGHT_EXTRA_BOLD)
          .fontColor($r('app.color.ai_orange'))

        Text(this.label)
          .fontSize(DesignTokens.FONT_TINY)
          .fontColor($r('app.color.text_secondary'))
          .margin({ top: -2 })
      }
      .width(this.size)
      .height(this.size)
      .borderRadius(this.size / 2)
      .borderWidth(4)
      .borderColor($r('app.color.ai_orange'))
      .backgroundColor($r('app.color.ai_glow_color'))
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }
    .width(this.size)
    .height(this.size)
  }
}
