/**
 * NewsClient — 资讯领域 API
 * 入口统一走 CloudClient 调度（Mock / Real 双模式自动适配）
 */

import { NewsItem } from '../model/NewsModel';
import { CloudClient } from './CloudClient';
import { ErrorFormatter } from '../common/ErrorFormatter';

export class NewsClient {
  /**
   * 获取资讯列表
   * @param limit 最大数量（默认 20）
   */
  public static async getList(limit: number = 20): Promise<NewsItem[]> {
    try {
      const all: NewsItem[] = await CloudClient.getNewsList();
      return all.slice(0, limit);
    } catch (e) {
      throw new Error(ErrorFormatter.format('NewsClient.getList', e));
    }
  }

  /**
   * 根据 ID 查询单条资讯（v1 不分页，按 id 直接过滤）
   */
  public static async getById(id: string): Promise<NewsItem | null> {
    try {
      const all: NewsItem[] = await CloudClient.getNewsList();
      const found: NewsItem | undefined = all.find((item: NewsItem) => item.id === id);
      return found ?? null;
    } catch (e) {
      throw new Error(ErrorFormatter.format('NewsClient.getById', e));
    }
  }
}
