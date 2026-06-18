/**
 * PlayerCard — 球员卡片组件（v1.1.2 重构）
 *
 * 设计变化：
 * - 圆角 12 → 20（大圆角 + 轻边框）
 * - 排名/积分用主橙色
 * - 双主题适配
 *
 * 用于社区页"球员信息"Tab（横向滚动列表）
 */

import { PlayerItem, PlayerModel } from '../model/PlayerModel';
import { DesignTokens } from '../common/DesignTokens';

@Component
export struct PlayerCard {
  public item: PlayerItem = new PlayerModel();
  public onTap: (item: PlayerItem) => void = (item: PlayerItem): void => {};

  public build(): void {
    Column() {
      // 头像（emoji）
      Text(this.item.avatar ?? '🏸')
        .fontSize(DesignTokens.FONT_EMOJI_XL)
        .margin({ bottom: DesignTokens.SPACING_SM })

      // 姓名
      Text(this.item.name ?? '')
        .fontSize(DesignTokens.FONT_SUBTITLE)
        .fontWeight(DesignTokens.WEIGHT_HEAVY)
        .fontColor($r('app.color.text_primary'))
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ bottom: DesignTokens.SPACING_XXS })

      // 国家 + 排名
      Row({ space: DesignTokens.SPACING_XS }) {
        Text(this.item.country ?? '')
          .fontSize(DesignTokens.FONT_CAPTION)
          .fontColor($r('app.color.text_hint'))

        Text(`🏆 #${this.item.ranking ?? 0}`)
          .fontSize(DesignTokens.FONT_CAPTION)
          .fontColor($r('app.color.warning'))
      }
      .margin({ bottom: DesignTokens.SPACING_XXS })

      // 积分
      Text(`${this.item.score ?? 0} 分`)
        .fontSize(DesignTokens.FONT_CAPTION)
        .fontWeight(DesignTokens.WEIGHT_HEAVY)
        .fontColor($r('app.color.ai_orange'))
        .margin({ bottom: DesignTokens.SPACING_XS })

      // 打法风格
      Text(this.item.playStyle ?? '')
        .fontSize(DesignTokens.FONT_CAPTION)
        .fontColor($r('app.color.text_secondary'))
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width('90%')
        .textAlign(TextAlign.Center)
    }
    .width(DesignTokens.PLAYER_CARD_WIDTH)
    .height(DesignTokens.PLAYER_CARD_HEIGHT)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .padding(DesignTokens.SPACING_SM)
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(DesignTokens.RADIUS_LG)
    .border({
      width: 1,
      color: $r('app.color.divider')
    })
    .onClick((): void => {
      this.onTap(this.item);
    })
  }
}
