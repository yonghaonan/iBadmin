/**
 * NewsCard — 资讯卡片组件（v1.1.2 重构）
 *
 * 设计变化：
 * - 圆角 12 → 20（大圆角，A2 智能情境风格）
 * - 新增 AI 摘要标签（右上角）
 * - 轻阴影（替代原无边风格）
 * - 暗色模式自动适配（霓虹橙边框 + 标题白色）
 *
 * 显示在首页"智能资讯"列表
 */

import { NewsItem, NewsModel } from '../model/NewsModel';
import { DesignTokens } from '../common/DesignTokens';
import { AppUtils } from '../common/Utils';

@Component
export struct NewsCard {
  public item: NewsItem = new NewsModel();
  public onTap: (item: NewsItem) => void = (item: NewsItem): void => {};
  @Prop public showAiTag: boolean = true;

  public build(): void {
    Column() {
      // AI 摘要标签（右上角）
      if (this.showAiTag) {
        Row() {
          Text('✨ ' + $r('app.string.ai_summary_tag'))
            .fontSize(DesignTokens.FONT_TINY)
            .fontWeight(DesignTokens.WEIGHT_HEAVY)
            .fontColor($r('app.color.text_on_primary'))
        }
        .padding({
          left: DesignTokens.SPACING_XS,
          right: DesignTokens.SPACING_XS,
          top: DesignTokens.SPACING_XXS,
          bottom: DesignTokens.SPACING_XXS
        })
        .backgroundColor($r('app.color.ai_orange'))
        .borderRadius(DesignTokens.RADIUS_XS)
        .position({ x: '100%', y: 0 })
        .markAnchor({ x: '100%', y: 0 })
        .offset({ x: -12, y: 12 })
      }

      Row() {
        // 左侧 emoji 封面
        Text(this.item.cover ?? '🏸')
          .fontSize(DesignTokens.FONT_EMOJI_LG)
          .width(DesignTokens.ICON_BOX_SIZE)
          .height(DesignTokens.ICON_BOX_SIZE)
          .textAlign(TextAlign.Center)

        // 右侧内容
        Column() {
          Text(this.item.title ?? '')
            .fontSize(DesignTokens.FONT_SUBTITLE)
            .fontWeight(DesignTokens.WEIGHT_HEAVY)
            .fontColor($r('app.color.text_primary'))
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .width('100%')
            .margin({ bottom: DesignTokens.SPACING_XS })

          Text(this.item.summary ?? '')
            .fontSize(DesignTokens.FONT_SMALL)
            .fontColor($r('app.color.text_secondary'))
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .width('100%')
            .margin({ bottom: DesignTokens.SPACING_SM })

          Row({ space: DesignTokens.SPACING_SM }) {
            Text(this.item.category ?? '')
              .fontSize(DesignTokens.FONT_CAPTION)
              .fontColor($r('app.color.ai_orange'))
              .fontWeight(DesignTokens.WEIGHT_BOLD)
              .padding({ left: DesignTokens.SPACING_XS, right: DesignTokens.SPACING_XS })

            Text(this.item.author ?? '')
              .fontSize(DesignTokens.FONT_CAPTION)
              .fontColor($r('app.color.text_hint'))

            Blank()

            Text(AppUtils.formatDate(new Date(this.item.publishedAt)))
              .fontSize(DesignTokens.FONT_CAPTION)
              .fontColor($r('app.color.text_hint'))
          }
          .width('100%')
        }
        .layoutWeight(1)
        .margin({ left: DesignTokens.SPACING_MD })
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
    }
    .width('100%')
    .padding(DesignTokens.SPACING_MD)
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(DesignTokens.RADIUS_LG)
    .border({
      width: 1,
      color: $r('app.color.divider')
    })
    .margin({ bottom: DesignTokens.SPACING_SM })
    .onClick((): void => {
      this.onTap(this.item);
    })
  }
}
