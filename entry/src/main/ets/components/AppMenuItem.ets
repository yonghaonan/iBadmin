/**
 * AppMenuItem — 通用菜单项组件（v1.1.2 重构）
 *
 * 设计变化：
 * - 圆角 12 → 20（大圆角 + 轻边框）
 * - 标题字重 medium → heavy
 * - 双主题适配（暗色模式自动切换）
 *
 * 用于"我的"页菜单项
 */

import { DesignTokens } from '../common/DesignTokens';
import { IconVenue, IconEquipment, IconFire, IconAI, IconShuttlecock, IconPlayer } from '../common/Icons';

export type MenuIconType = 'venue' | 'equipment' | 'history' | 'theme' | 'settings' | 'about';

@Component
export struct AppMenuItem {
  public iconType: MenuIconType = 'venue';
  public iconFallback: string = '';
  public title: ResourceStr = '';
  public subtitle: ResourceStr = '';
  public onTap: () => void = (): void => {};

  @Builder
  private renderMenuIcon(): void {
    if (this.iconType === 'venue') {
      IconVenue({ iconSize: DesignTokens.ICON_ROW_SIZE })
    } else if (this.iconType === 'equipment') {
      IconEquipment({ iconSize: DesignTokens.ICON_ROW_SIZE })
    } else if (this.iconType === 'history') {
      IconFire({ iconSize: DesignTokens.ICON_ROW_SIZE })
    } else if (this.iconType === 'theme') {
      IconAI({ iconSize: DesignTokens.ICON_ROW_SIZE })
    } else if (this.iconType === 'settings') {
      IconShuttlecock({ iconSize: DesignTokens.ICON_ROW_SIZE })
    } else {
      IconPlayer({ iconSize: DesignTokens.ICON_ROW_SIZE })
    }
  }

  public build(): void {
    Row() {
      this.renderMenuIcon()

      Column() {
        Text(this.title)
          .fontSize(DesignTokens.FONT_BODY)
          .fontWeight(DesignTokens.WEIGHT_HEAVY)
          .fontColor($r('app.color.text_primary'))
          .width('100%')

        if (this.subtitle !== '') {
          Text(this.subtitle)
            .fontSize(DesignTokens.FONT_CAPTION)
            .fontColor($r('app.color.text_hint'))
            .width('100%')
            .margin({ top: DesignTokens.SPACING_XXS })
        }
      }
      .layoutWeight(1)
      .margin({ left: DesignTokens.SPACING_MD })
      .alignItems(HorizontalAlign.Start)

      Text('›')
        .fontSize(DesignTokens.FONT_H2)
        .fontColor($r('app.color.text_hint'))
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
      this.onTap();
    })
  }
}
