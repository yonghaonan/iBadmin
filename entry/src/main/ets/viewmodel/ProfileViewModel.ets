/**
 * ProfileViewModel — 我的页 ViewModel（登录 / 退出 / 用户态）
 *
 * 职责：
 * - 登录态管理：isLoggedIn() / userInfo() 读 AppStorage（单数据源）
 * - 跨页面同步：通过 AppStorage.setOrCreate 写入 isLoggedIn / userId / displayName / avatarUri
 * - 退出登录：清空 AppStorage + 调用 UserClient.logout()
 *
 * 边界：
 * - 不持有 UI 引用
 * - 调用 UserClient（含 Mock fallback）
 * - 错误统一走 AppLogger + ErrorFormatter
 *
 * v1.1.1 状态单数据源重构：
 * - 旧实现：vm.isLoggedIn 字段 + @StorageProp 双向同步（死循环竞态）
 * - 新实现：vm.isLoggedIn() 方法直接读 AppStorage（单数据源，无竞态）
 */

import { UserInfo, UserModel } from '../model/UserModel';
import { UserClient } from '../cloud/UserClient';
import { AppConstants } from '../common/Constants';
import { AppLogger } from '../common/AppLogger';
import { ErrorFormatter } from '../common/ErrorFormatter';

@Observed
export class ProfileViewModel {
  public user: UserModel = new UserModel();
  public errorMessage: string = '';
  public isLoading: boolean = false;

  /**
   * 读取登录态（单数据源：AppStorage）
   * - 替代旧的 `vm.isLoggedIn` 字段
   * - 避免双向同步死循环
   */
  public isLoggedIn(): boolean {
    return AppStorage.get<boolean>(AppConstants.APPSTORAGE_IS_LOGGED_IN) ?? false;
  }

  /**
   * 同步用户信息字段（从 AppStorage 读取）
   * - 替代旧的 `init()`
   * - Page 在 aboutToAppear 中调用一次
   */
  public syncFromStorage(): void {
    if (this.isLoggedIn()) {
      this.user = new UserModel({
        id: AppStorage.get<string>(AppConstants.APPSTORAGE_USER_ID) ?? '',
        nickname: AppStorage.get<string>(AppConstants.APPSTORAGE_DISPLAY_NAME) ?? '',
        avatar: AppStorage.get<string>(AppConstants.APPSTORAGE_AVATAR_URI) ?? '',
        loginAt: Date.now()
      });
    } else {
      this.user = new UserModel();
    }
    AppLogger.debug('ProfileViewModel', `syncFromStorage loggedIn=${this.isLoggedIn()}`);
  }

  /**
   * 华为账号登录
   * 流程：UserClient.loginWithHuawei() -> 写入 AppStorage
   */
  public async loginWithHuawei(): Promise<boolean> {
    this.isLoading = true;
    this.errorMessage = '';

    try {
      const info: UserInfo = await UserClient.loginWithHuawei();
      this.user = new UserModel(info);
      this.persistLoginState();
      AppLogger.info('ProfileViewModel', `login success uid=${info.id}`);
      this.isLoading = false;
      return true;
    } catch (e) {
      this.errorMessage = ErrorFormatter.format('ProfileViewModel.loginWithHuawei', e);
      AppLogger.error('ProfileViewModel', this.errorMessage);
      this.isLoading = false;
      return false;
    }
  }

  /**
   * 退出登录
   */
  public async logout(): Promise<void> {
    this.isLoading = true;
    try {
      await UserClient.logout();
    } catch (e) {
      AppLogger.warn('ProfileViewModel', `logout client failed: ${ErrorFormatter.format('ProfileViewModel.logout', e)}`);
    }
    this.user = new UserModel();
    this.clearLoginState();
    this.isLoading = false;
    AppLogger.info('ProfileViewModel', 'logout done');
  }

  /**
   * 持久化登录态到 AppStorage（跨页面同步）
   * - 唯一写 isLoggedIn / userId / displayName / avatarUri 的入口
   */
  private persistLoginState(): void {
    AppStorage.setOrCreate<boolean>(AppConstants.APPSTORAGE_IS_LOGGED_IN, true);
    AppStorage.setOrCreate<string>(AppConstants.APPSTORAGE_USER_ID, this.user.id);
    AppStorage.setOrCreate<string>(AppConstants.APPSTORAGE_DISPLAY_NAME, this.user.nickname);
    AppStorage.setOrCreate<string>(AppConstants.APPSTORAGE_AVATAR_URI, this.user.avatar);
  }

  /**
   * 清空登录态
   */
  private clearLoginState(): void {
    AppStorage.setOrCreate<boolean>(AppConstants.APPSTORAGE_IS_LOGGED_IN, false);
    AppStorage.setOrCreate<string>(AppConstants.APPSTORAGE_USER_ID, '');
    AppStorage.setOrCreate<string>(AppConstants.APPSTORAGE_DISPLAY_NAME, '');
    AppStorage.setOrCreate<string>(AppConstants.APPSTORAGE_AVATAR_URI, '');
  }
}
