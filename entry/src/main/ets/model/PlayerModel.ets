/**
 * 球员数据模型
 * 用于社区球员信息 Tab（横向滚动卡片）
 */

export interface PlayerItem {
  id: string;
  name: string;
  avatar: string;
  ranking: number;
  score: number;
  country: string;
  playStyle: string;
  achievements: string[];
}

export class PlayerModel implements PlayerItem {
  public id: string = '';
  public name: string = '';
  public avatar: string = '';
  public ranking: number = 0;
  public score: number = 0;
  public country: string = '';
  public playStyle: string = '';
  public achievements: string[] = [];

  constructor(item?: Partial<PlayerItem>) {
    if (item) {
      this.id = item.id ?? '';
      this.name = item.name ?? '';
      this.avatar = item.avatar ?? '';
      this.ranking = item.ranking ?? 0;
      this.score = item.score ?? 0;
      this.country = item.country ?? '';
      this.playStyle = item.playStyle ?? '';
      this.achievements = item.achievements ?? [];
    }
  }
}
