/**
 * EquipmentCategoryCard — 装备分类卡片组件（v1.1.2 重构）
 *
 * 设计变化：
 * - 圆角 12 → 20（大圆角 + 轻边框）
 * - 数量标签用主橙色 + 加粗
 * - 双主题适配
 *
 * 用于社区页"装备查询"Tab 的 2x2 网格
 */

import { EquipmentItem, EquipmentModel, EquipmentCategory } from '../model/EquipmentModel';
import { DesignTokens } from '../common/DesignTokens';
import { IconEquipment, IconRacket } from '../common/Icons';

@Component
export struct EquipmentCategoryCard {
  public item: EquipmentItem = new EquipmentModel();
  public onTap: (item: EquipmentItem) => void = (item: EquipmentItem): void => {};

  /**
   * 根据装备分类返回对应 SVG 图标
   */
  @Builder
  private renderCategoryIcon(): void {
    if (this.item.category === EquipmentCategory.RACKETS) {
      IconRacket({ size: DesignTokens.FONT_EMOJI_XL })
    } else if (this.item.category === EquipmentCategory.BAGS) {
      IconEquipment({ size: DesignTokens.FONT_EMOJI_XL })
    } else {
      IconEquipment({ size: DesignTokens.FONT_EMOJI_XL })
    }
  }

  public build(): void {
    Column() {
      this.renderCategoryIcon()
        .margin({ bottom: DesignTokens.SPACING_SM })

      Text(this.item.name ?? '')
        .fontSize(DesignTokens.FONT_SUBTITLE)
        .fontWeight(DesignTokens.WEIGHT_HEAVY)
        .fontColor($r('app.color.text_primary'))
        .margin({ bottom: DesignTokens.SPACING_XXS })

      Text(this.item.description ?? '')
        .fontSize(DesignTokens.FONT_CAPTION)
        .fontColor($r('app.color.text_secondary'))
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width('80%')
        .textAlign(TextAlign.Center)
        .margin({ bottom: DesignTokens.SPACING_XS })

      Text(`${this.item.count ?? 0} 件`)
        .fontSize(DesignTokens.FONT_CAPTION)
        .fontWeight(DesignTokens.WEIGHT_HEAVY)
        .fontColor($r('app.color.ai_orange'))
    }
    .width('100%')
    .height(DesignTokens.EQUIPMENT_CARD_HEIGHT)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .padding(DesignTokens.SPACING_MD)
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
