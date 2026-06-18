/**
 * PlayerClient — 球员领域 API
 * 入口统一走 CloudClient 调度
 */

import { PlayerItem } from '../model/PlayerModel';
import { CloudClient } from './CloudClient';
import { ErrorFormatter } from '../common/ErrorFormatter';

export class PlayerClient {
  /**
   * 获取热门球员列表
   * @param limit 最大数量（默认 20）
   */
  public static async getList(limit: number = 20): Promise<PlayerItem[]> {
    try {
      const all: PlayerItem[] = await CloudClient.getPlayerList();
      return all.slice(0, limit);
    } catch (e) {
      throw new Error(ErrorFormatter.format('PlayerClient.getList', e));
    }
  }

  /**
   * 根据 ID 查询单个球员
   */
  public static async getById(id: string): Promise<PlayerItem | null> {
    try {
      const all: PlayerItem[] = await CloudClient.getPlayerList();
      const found: PlayerItem | undefined = all.find((item: PlayerItem) => item.id === id);
      return found ?? null;
    } catch (e) {
      throw new Error(ErrorFormatter.format('PlayerClient.getById', e));
    }
  }
}
