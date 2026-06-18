/**
 * VenueClient — 场馆领域 API
 * 入口统一走 CloudClient 调度
 */

import { VenueItem } from '../model/VenueModel';
import { CloudClient } from './CloudClient';
import { ErrorFormatter } from '../common/ErrorFormatter';

export class VenueClient {
  /**
   * 获取附近场馆列表
   * @param limit 最大数量（默认 20）
   */
  public static async getNearby(limit: number = 20): Promise<VenueItem[]> {
    try {
      const all: VenueItem[] = await CloudClient.getVenueNearby();
      return all.slice(0, limit);
    } catch (e) {
      throw new Error(ErrorFormatter.format('VenueClient.getNearby', e));
    }
  }

  /**
   * 根据 ID 查询单个场馆
   */
  public static async getById(id: string): Promise<VenueItem | null> {
    try {
      const all: VenueItem[] = await CloudClient.getVenueNearby();
      const found: VenueItem | undefined = all.find((item: VenueItem) => item.id === id);
      return found ?? null;
    } catch (e) {
      throw new Error(ErrorFormatter.format('VenueClient.getById', e));
    }
  }
}
