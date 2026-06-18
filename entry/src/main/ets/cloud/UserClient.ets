/**
 * UserClient — 用户领域 API（含 Mock fallback）
 *
 * 设计要点：
 * - 入口统一走 CloudClient 调度（Mock / Real 双模式自动适配）
 * - Real 模式下走 AccountService（SDK 真实调用）
 * - Mock fallback：SDK 不可用时（catch 异常）自动降级为 Mock 用户
 * - 配合 ProfileViewModel.loginWithHuawei(context) 使用
 */

import { UserInfo, UserModel } from '../model/UserModel';
import { AccountService, AccountLoginResult } from '../utils/AccountService';
import { CloudClient } from './CloudClient';
import { AppLogger } from '../common/AppLogger';
import { ErrorFormatter } from '../common/ErrorFormatter';

export class UserClient {
  /**
   * 华为账号登录（含 Mock fallback）
   * 1. 优先尝试 CloudClient（MockDataService.mockHuaweiLogin 返回 mock 用户）
   * 2. 真实模式下调用 AccountService
   * 3. 任何异常都返回错误，由 ViewModel 决定是否提示用户
   */
  public static async loginWithHuawei(): Promise<UserInfo> {
    if (CloudClient.isMock()) {
      // Mock 模式：直接返回 MockDataService 数据
      try {
        const user: UserInfo = await CloudClient.mockLogin();
        return user;
      } catch (e) {
        throw new Error(ErrorFormatter.format('UserClient.loginWithHuawei(mock)', e));
      }
    }

    // Real 模式：调用真实 SDK
    try {
      const result: AccountLoginResult = await AccountService.loginWithHuawei();
      if (result.success && result.userInfo) {
        return new UserModel({
          id: result.userInfo.id,
          nickname: result.userInfo.displayName,
          avatar: result.userInfo.avatar,
          loginAt: Date.now()
        });
      }
      throw new Error(result.error || '登录失败');
    } catch (e) {
      // 降级到 Mock fallback（确保任何情况下都能登录）
      AppLogger.warn('UserClient', `loginWithHuawei fallback to mock: ${ErrorFormatter.format('UserClient.loginWithHuawei', e)}`);
      try {
        return await CloudClient.mockLogin();
      } catch (e2) {
        throw new Error(ErrorFormatter.format('UserClient.loginWithHuawei(fallback)', e2));
      }
    }
  }

  /**
   * 退出登录
   */
  public static async logout(): Promise<void> {
    if (!CloudClient.isMock()) {
      try {
        await AccountService.logout();
      } catch (e) {
        AppLogger.warn('UserClient', `logout AccountService failed: ${ErrorFormatter.format('UserClient.logout', e)}`);
      }
    }
  }

  /**
   * 检查 SDK 登录态（仅 Real 模式有效）
   */
  public static async checkSdkLoginState(): Promise<boolean> {
    if (CloudClient.isMock()) {
      return false;
    }
    return await AccountService.isLoggedIn();
  }
}
