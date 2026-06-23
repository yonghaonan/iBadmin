/**
 * VenueCard — 场馆卡片组件（v1.1.2 重构）
 *
 * 设计变化：
 * - 圆角 12 → 20（大圆角 + 轻边框）
 * - 双主题适配（暗色卡片自动切换）
 * - 状态徽章保留业务色
 *
 * 显示在社区页"附近场馆"Tab
 */

import { VenueItem, VenueStatus, VenueModel } from '../model/VenueModel';
import { DesignTokens } from '../common/DesignTokens';
import { IconVenue } from '../common/Icons';

@Component
export struct VenueCard {
  public item: VenueItem = new VenueModel();
  public onTap: (item: VenueItem) => void = (item: VenueItem): void => {};

  public build(): void {
    Column() {
      Row() {
        // 左侧 SVG 图标封面
        Row() {
          IconVenue({ iconSize: DesignTokens.ICON_BOX_SIZE })
        }
        .width(DesignTokens.ICON_BOX_SIZE)
        .height(DesignTokens.ICON_BOX_SIZE)
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)

        // 中间信息
        Column() {
          Row() {
            Text(this.item.name ?? '')
              .fontSize(DesignTokens.FONT_SUBTITLE)
              .fontWeight(DesignTokens.WEIGHT_HEAVY)
              .fontColor($r('app.color.text_primary'))
              .layoutWeight(1)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })

            // 状态徽章
            Text(this.statusText())
              .fontSize(DesignTokens.FONT_TINY)
              .fontWeight(DesignTokens.WEIGHT_HEAVY)
              .fontColor($r('app.color.text_on_primary'))
              .backgroundColor(this.statusColor())
              .padding({
                left: DesignTokens.SPACING_XS,
                right: DesignTokens.SPACING_XS,
                top: DesignTokens.SPACING_XXS,
                bottom: DesignTokens.SPACING_XXS
              })
              .borderRadius(DesignTokens.RADIUS_XS)
          }
          .width('100%')

          Text(this.item.address ?? '')
            .fontSize(DesignTokens.FONT_CAPTION)
            .fontColor($r('app.color.text_secondary'))
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .width('100%')
            .margin({ top: DesignTokens.SPACING_XXS })

          Row({ space: DesignTokens.SPACING_SM }) {
            Text(`⭐ ${this.item.rating?.toFixed(1) ?? '0.0'}`)
              .fontSize(DesignTokens.FONT_CAPTION)
              .fontColor($r('app.color.warning'))

            Text(`📍 ${this.item.distanceKm?.toFixed(1) ?? '0.0'} km`)
              .fontSize(DesignTokens.FONT_CAPTION)
              .fontColor($r('app.color.text_hint'))

            Text(`💰 ¥${this.item.pricePerHour ?? 0}/h`)
              .fontSize(DesignTokens.FONT_CAPTION)
              .fontColor($r('app.color.text_hint'))

            Blank()

            Text(`🏸 ${this.item.courtCount ?? 0} 片`)
              .fontSize(DesignTokens.FONT_CAPTION)
              .fontColor($r('app.color.text_hint'))
          }
          .width('100%')
          .margin({ top: DesignTokens.SPACING_XS })
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

  private statusText(): string {
    if (this.item.status === VenueStatus.AVAILABLE) {
      return '空闲';
    }
    if (this.item.status === VenueStatus.BUSY) {
      return '繁忙';
    }
    return '已满';
  }

  private statusColor(): ResourceColor {
    if (this.item.status === VenueStatus.AVAILABLE) {
      return $r('app.color.status_available');
    }
    if (this.item.status === VenueStatus.BUSY) {
      return $r('app.color.status_busy');
    }
    return $r('app.color.status_full');
  }
}
