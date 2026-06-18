/**
 * AccountService — 华为账号 SDK 封装层
 *
 * 设计要点：
 * - 静态类，无需实例化
 * - 所有方法均通过 try/catch 走 AppLogger + ErrorFormatter
 * - 不抛出 Error 给上层（上层使用 UserClient 时会拿到 try/catch 结果）
 * - SDK 调用走系统模块 @ohos.account.appAccount（API 9+ 通用，无需 ohpm 安装）
 *
 * 与 UserClient 的边界：
 * - 本层只负责 SDK 交互 + 返回原始结果 {success, userInfo, error}
 * - 上层 UserClient 决定是否走 Mock fallback（SDK 不可用时）
 *
 * 兼容性说明：
 * - v1 默认 Mock 模式（CloudClient.init(true)），本层代码不会被执行
 * - Real 模式下 SDK 类型在编译期较宽松，运行时遇到 API 变化由 try/catch 兜底
 * - v1.1.3 计划升级到 @kit.AccountKit（API 23+）
 *
 * v1.1.1.1 修复：
 * - 旧实现：从 ohpm 安装不存在的 @ohos/account-ohos@2.0.0（导致 ohpm install 404）
 * - 新实现：使用 SDK 系统模块 @ohos.account.appAccount（无需 ohpm 安装）
 * - API 适配：getAccountManager() → createAppAccountManager()
 */

import account from '@ohos.account.appAccount';

import { AppLogger } from '../common/AppLogger';
import { ErrorFormatter } from '../common/ErrorFormatter';

export interface AccountLoginResult {
  success: boolean;
  userInfo: AccountUserInfo | null;
  error: string;
}

export interface AccountUserInfo {
  id: string;
  displayName: string;
  avatar: string;
}

/**
 * 调用 SDK auth() 的通用 Promise 包装
 * - API 9+ 标准签名：auth(name, owner, authType, callback)
 * - 失败抛错 → UserClient 走 Mock fallback
 */

/**
 * 空对象常量：替代 {} 空字面量，避免 arkts-no-untyped-obj-literals
 */
const EMPTY_OBJECT: Object = new Object();

function callSdkAuth(): Promise<Object> {
  return new Promise<Object>((resolve: (v: Object) => void, reject: (e: Error) => void) => {
    try {
      const accountManager = account.createAppAccountManager() as Object;
      const authFn = (accountManager as Record<string, Object>)['auth'];
      if (typeof authFn !== 'function') {
        reject(new Error('SDK auth method not found'));
        return;
      }
      (authFn as (
        name: string,
        owner: string,
        authType: string,
        callback: (err: Error | null, data: Object | null) => void
      ) => void)(
        'iBadmin',
        'iBadmin_owner',
        'serviceAuthProvider',
        (err: Error | null, data: Object | null) => {
          if (err !== null) {
            reject(err);
            return;
          }
          resolve(data ?? EMPTY_OBJECT);
        }
      );
    } catch (e) {
      reject(e as Error);
    }
  });
}

/**
 * 调用 SDK getAccounts() 获取应用账号列表（静默检查登录态）
 */
function callSdkGetAccountList(): Promise<Object[]> {
  return new Promise<Object[]>((resolve: (v: Object[]) => void, reject: (e: Error) => void) => {
    try {
      const accountManager = account.createAppAccountManager() as Object;
      const listFn = (accountManager as Record<string, Object>)['getAccounts'];
      if (typeof listFn !== 'function') {
        // SDK 不可用：返回空数组（视为未登录）
        resolve([]);
        return;
      }
      (listFn as (
        owner: string,
        callback: (err: Error | null, data: Object[]) => void
      ) => void)(
        'iBadmin_owner',
        (err: Error | null, data: Object[]) => {
          if (err !== null) {
            // 静默失败（视为未登录）
            resolve([]);
            return;
          }
          resolve(data ?? []);
        }
      );
    } catch (e) {
      // 静默失败
      resolve([]);
    }
  });
}

/**
 * 调用 SDK deleteAccount() 退出登录
 */
function callSdkDeleteAccount(): Promise<boolean> {
  return new Promise<boolean>((resolve: (v: boolean) => void, reject: (e: Error) => void) => {
    try {
      const accountManager = account.createAppAccountManager() as Object;
      const delFn = (accountManager as Record<string, Object>)['deleteAccount'];
      if (typeof delFn !== 'function') {
        // SDK 不可用：返回 true（视为已退出）
        resolve(true);
        return;
      }
      (delFn as (
        name: string,
        callback: (err: Error | null) => void
      ) => void)(
        'iBadmin',
        (err: Error | null) => {
          if (err !== null) {
            reject(err);
            return;
          }
          resolve(true);
        }
      );
    } catch (e) {
      reject(e as Error);
    }
  });
}

/**
 * 构造 AuthInfo（兼容多 SDK 版本的字段命名）
 *
 * v1.1.1.4 修正：
 * - v1.1.1.3 误用 `Record<string, string>` 作为返回类型
 * - ArkTS 严格模式下 Record 索引签名不是“具名 interface”，return 的对象字面量仍报 untyped-obj-literals
 * - 修正为具名 interface AuthInfo（name/owner/authType 三个必填字段）
 */
export interface AuthInfo {
  name: string;
  owner: string;
  authType: string;
}

function buildAuthInfo(): AuthInfo {
  return {
    name: 'iBadmin',
    owner: 'iBadmin_owner',
    authType: 'serviceAuthProvider'
  };
}

export class AccountService {
  /**
   * 华为账号一键登录（SDK 内部拉起 UI）
   */
  public static async loginWithHuawei(): Promise<AccountLoginResult> {
    try {
      const authInfo: Object = buildAuthInfo();
      const rawResult: Object = await callSdkAuth();
      // 兼容多种 SDK 字段命名
      const state: number = (rawResult as Record<string, number>)['state'] ?? -1;
      const openId: string = String((rawResult as Record<string, string>)['openID'] ?? '');
      const authId: string = String((rawResult as Record<string, string>)['accountName'] ?? openId);
      if (state === 0 && authId !== '') {
        const userInfo: AccountUserInfo = {
          id: authId,
          displayName: '华为用户',
          avatar: String((rawResult as Record<string, string>)['avatar'] ?? '')
        };
        return { success: true, userInfo, error: '' };
      }
      return { success: false, userInfo: null, error: '华为账号登录失败' };
    } catch (e) {
      const msg: string = ErrorFormatter.format('AccountService.loginWithHuawei', e);
      AppLogger.error('AccountService', msg);
      return { success: false, userInfo: null, error: msg };
    }
  }

  /**
   * 检查是否已登录华为账号（静默查询）
   */
  public static async isLoggedIn(): Promise<boolean> {
    try {
      const accounts: Object[] = await callSdkGetAccountList();
      return accounts.length > 0;
    } catch (e) {
      AppLogger.warn('AccountService', `isLoggedIn failed: ${ErrorFormatter.format('AccountService.isLoggedIn', e)}`);
      return false;
    }
  }

  /**
   * 退出登录（仅清空 SDK 侧会话，应用态由 UserClient 处理）
   */
  public static async logout(): Promise<boolean> {
    try {
      return await callSdkDeleteAccount();
    } catch (e) {
      AppLogger.warn('AccountService', `logout failed: ${ErrorFormatter.format('AccountService.logout', e)}`);
      return false;
    }
  }
}
