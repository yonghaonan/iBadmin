/**
 * EquipmentClient — 装备领域 API
 * 入口统一走 CloudClient 调度
 */

import { EquipmentItem } from '../model/EquipmentModel';
import { CloudClient } from './CloudClient';
import { ErrorFormatter } from '../common/ErrorFormatter';

export class EquipmentClient {
  /**
   * 获取装备分类列表
   */
  public static async getCategories(): Promise<EquipmentItem[]> {
    try {
      return await CloudClient.getEquipmentCategories();
    } catch (e) {
      throw new Error(ErrorFormatter.format('EquipmentClient.getCategories', e));
    }
  }

  /**
   * 根据 ID 查询单个装备分类
   */
  public static async getById(id: string): Promise<EquipmentItem | null> {
    try {
      const all: EquipmentItem[] = await CloudClient.getEquipmentCategories();
      const found: EquipmentItem | undefined = all.find((item: EquipmentItem) => item.id === id);
      return found ?? null;
    } catch (e) {
      throw new Error(ErrorFormatter.format('EquipmentClient.getById', e));
    }
  }
}
