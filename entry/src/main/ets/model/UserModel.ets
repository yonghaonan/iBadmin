/**
 * 用户数据模型
 * 用于"我的"页登录态展示
 */

export interface UserInfo {
  id: string;
  nickname: string;
  avatar: string;
  phone: string;
  email: string;
  unionId: string;
  openId: string;
  loginAt: number;
}

export class UserModel implements UserInfo {
  public id: string = '';
  public nickname: string = '';
  public avatar: string = '';
  public phone: string = '';
  public email: string = '';
  public unionId: string = '';
  public openId: string = '';
  public loginAt: number = 0;

  constructor(item?: Partial<UserInfo>) {
    if (item) {
      this.id = item.id ?? '';
      this.nickname = item.nickname ?? '';
      this.avatar = item.avatar ?? '';
      this.phone = item.phone ?? '';
      this.email = item.email ?? '';
      this.unionId = item.unionId ?? '';
      this.openId = item.openId ?? '';
      this.loginAt = item.loginAt ?? 0;
    }
  }

  /**
   * 是否为空用户（未登录态）
   */
  public isEmpty(): boolean {
    return this.id === '' && this.unionId === '' && this.openId === '';
  }

  /**
   * 是否已登录
   */
  public isLoggedIn(): boolean {
    return this.id !== '' || this.unionId !== '' || this.openId !== '';
  }
}
