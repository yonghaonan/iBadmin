/**
 * EmptyState — 空状态/加载中/错误通用占位组件（v1.1.2 重构）
 *
 * 设计变化：
 * - LOADING 图标用主色（活力橙）
 * - 大圆角 LOADING 旋转器
 * - 双主题适配
 *
 * 支持 3 种场景：
 * - LOADING：加载中（旋转图标 + 文案）
 * - EMPTY：空数据（图标 + 文案）
 * - ERROR：加载失败（错误图标 + 文案 + 重试按钮）
 */

import { DesignTokens } from '../common/DesignTokens';

export enum EmptyStateType {
  LOADING = 'loading',
  EMPTY = 'empty',
  ERROR = 'error'
}

@Component
export struct EmptyState {
  public type: EmptyStateType = EmptyStateType.EMPTY;
  public message: ResourceStr = '';
  public retryText: ResourceStr = '';
  public onRetry: () => void = (): void => {};

  public build(): void {
    Column() {
      // 图标
      if (this.type === EmptyStateType.LOADING) {
        LoadingProgress()
          .width(DesignTokens.FONT_EMOJI_LG)
          .height(DesignTokens.FONT_EMOJI_LG)
          .color($r('app.color.ai_orange'))
      } else {
        Text(this.type === EmptyStateType.ERROR ? '⚠️' : '📭')
          .fontSize(DesignTokens.FONT_EMOJI_XL)
      }

      // 文案
      if (this.message !== '') {
        Text(this.message)
          .fontSize(DesignTokens.FONT_BODY)
          .fontColor($r('app.color.text_secondary'))
          .margin({ top: DesignTokens.SPACING_LG })
          .textAlign(TextAlign.Center)
      }

      // 重试按钮（仅 ERROR 状态）
      if (this.type === EmptyStateType.ERROR && this.retryText !== '') {
        Button(this.retryText)
          .fontSize(DesignTokens.FONT_BODY)
          .fontColor($r('app.color.text_on_primary'))
          .backgroundColor($r('app.color.ai_orange'))
          .height(DesignTokens.INPUT_HEIGHT)
          .width('50%')
          .borderRadius(DesignTokens.RADIUS_LG)
          .margin({ top: DesignTokens.SPACING_LG })
          .onClick((): void => {
            this.onRetry();
          })
      }
    }
    .width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .padding(DesignTokens.SPACING_XL)
  }
}
