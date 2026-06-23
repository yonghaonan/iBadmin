/**
 * EquipmentCategoryCard — 装备分类卡片组件（v1.1.2 重构）
 *
 * 设计变化：
 * - 圆角 12 → 20（大圆角 + 轻边框）
 * - 数量标签用主橙色 + 加粗
 * - 双主题适配
 *
 * 用于社区页"装备查询"Tab 的 2x2 网格
 *
 * v1.1.3.2 修复记录（多次迭代）：
 * - v1 误判：移除 @Builder → 10905204 ERROR（普通方法返回 void，不满足 Column 子组件语法）
 * - v2 正确：保留 @Builder 装饰，margin 加到 Icon 组件链式调用上
 *   - IconRacket / IconEquipment 是组件，链式 .margin() 是合法的
 *   - @Builder 装饰的方法返回类型实际是 void，但 ArkTS 编译器会把它视为 UI 组件语法
 * - IconRacket/IconEquipment 的 size → iconSize（避免与基类 CustomComponent.size() 冲突）
 */

import { EquipmentItem, EquipmentModel, EquipmentCategory } from '../model/EquipmentModel';
import { DesignTokens } from '../common/DesignTokens';
import { IconEquipment, IconRacket } from '../common/Icons';

@Component
export struct EquipmentCategoryCard {
  public item: EquipmentItem = new EquipmentModel();
  public onTap: (item: EquipmentItem) => void = (item: EquipmentItem): void => {};

  /**
   * 根据装备分类返回对应 SVG 图标（@Builder 装饰，margin 加在 Icon 上）
   */
  @Builder
  private renderCategoryIcon(): void {
    if (this.item.category === EquipmentCategory.RACKETS) {
      IconRacket({ iconSize: DesignTokens.FONT_EMOJI_XL })
        .margin({ bottom: DesignTokens.SPACING_SM })
    } else if (this.item.category === EquipmentCategory.BAGS) {
      IconEquipment({ iconSize: DesignTokens.FONT_EMOJI_XL })
        .margin({ bottom: DesignTokens.SPACING_SM })
    } else {
      IconEquipment({ iconSize: DesignTokens.FONT_EMOJI_XL })
        .margin({ bottom: DesignTokens.SPACING_SM })
    }
  }

  public build(): void {
    Column() {
      this.renderCategoryIcon()

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
}/**
 * EquipmentCategoryCard — 装备分类卡片组件（v1.1.2 重构）
 *
 * 设计变化：
 * - 圆角 12 → 20（大圆角 + 轻边框）
 * - 数量标签用主橙色 + 加粗
 * - 双主题适配
 *
 * 用于社区页"装备查询"Tab 的 2x2 网格
 *
 * v1.1.3.2 修复：
 * - 删除 @Builder 装饰（@Builder 装饰的方法返回类型是 void，
 *   导致链式 .margin() 报错：Property 'margin' does not exist on type 'void'）
 * - renderCategoryIcon 改为普通方法，margin 移到下一个 Text 上
 * - IconRacket/IconEquipment 的 size → iconSize（避免与基类 CustomComponent.size() 冲突）
 */

import { EquipmentItem, EquipmentModel, EquipmentCategory } from '../model/EquipmentModel';
import { DesignTokens } from '../common/DesignTokens';
import { IconEquipment, IconRacket } from '../common/Icons';

@Component
export struct EquipmentCategoryCard {
  public item: EquipmentItem = new EquipmentModel();
  public onTap: (item: EquipmentItem) => void = (item: EquipmentItem): void => {};

  /**
   * 根据装备分类返回对应 SVG 图标（普通方法，不再用 @Builder）
   */
  private renderCategoryIcon(): void {
    if (this.item.category === EquipmentCategory.RACKETS) {
      IconRacket({ iconSize: DesignTokens.FONT_EMOJI_XL })
    } else if (this.item.category === EquipmentCategory.BAGS) {
      IconEquipment({ iconSize: DesignTokens.FONT_EMOJI_XL })
    } else {
      IconEquipment({ iconSize: DesignTokens.FONT_EMOJI_XL })
    }
  }

  public build(): void {
    Column() {
      this.renderCategoryIcon()
      // 注：renderCategoryIcon 是普通方法，返回 void，不能链式 .margin()
      // margin 加在下一个 Text 上

      Text(this.item.name ?? '')
        .fontSize(DesignTokens.FONT_SUBTITLE)
        .fontWeight(DesignTokens.WEIGHT_HEAVY)
        .fontColor($r('app.color.text_primary'))
        .margin({ top: DesignTokens.SPACING_SM })
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