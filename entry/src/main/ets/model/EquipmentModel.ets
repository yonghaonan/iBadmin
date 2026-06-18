/**
 * 装备数据模型
 * 用于社区装备查询 Tab（4 分类卡片网格）
 */

export enum EquipmentCategory {
  RACKETS = 'rackets',
  SHOES = 'shoes',
  BAGS = 'bags',
  SHUTTLECOCKS = 'shuttlecocks'
}

export interface EquipmentItem {
  id: string;
  category: EquipmentCategory;
  name: string;
  description: string;
  icon: string;
  count: number;
  brandOptions: string[];
}

export class EquipmentModel implements EquipmentItem {
  public id: string = '';
  public category: EquipmentCategory = EquipmentCategory.RACKETS;
  public name: string = '';
  public description: string = '';
  public icon: string = '';
  public count: number = 0;
  public brandOptions: string[] = [];

  constructor(item?: Partial<EquipmentItem>) {
    if (item) {
      this.id = item.id ?? '';
      this.category = item.category ?? EquipmentCategory.RACKETS;
      this.name = item.name ?? '';
      this.description = item.description ?? '';
      this.icon = item.icon ?? '';
      this.count = item.count ?? 0;
      this.brandOptions = item.brandOptions ?? [];
    }
  }
}
