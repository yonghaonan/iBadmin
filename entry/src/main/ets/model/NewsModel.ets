/**
 * 资讯数据模型
 * 用于首页资讯列表展示
 */

export interface NewsItem {
  id: string;
  title: string;
  summary: string;
  cover: string;
  category: string;
  author: string;
  publishedAt: number;
  viewCount: number;
  source: string;
}

export class NewsModel implements NewsItem {
  public id: string = '';
  public title: string = '';
  public summary: string = '';
  public cover: string = '';
  public category: string = '';
  public author: string = '';
  public publishedAt: number = 0;
  public viewCount: number = 0;
  public source: string = '';

  constructor(item?: Partial<NewsItem>) {
    if (item) {
      this.id = item.id ?? '';
      this.title = item.title ?? '';
      this.summary = item.summary ?? '';
      this.cover = item.cover ?? '';
      this.category = item.category ?? '';
      this.author = item.author ?? '';
      this.publishedAt = item.publishedAt ?? 0;
      this.viewCount = item.viewCount ?? 0;
      this.source = item.source ?? '';
    }
  }
}
