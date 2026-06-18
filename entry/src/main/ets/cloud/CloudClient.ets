/**
 * CloudClient — 双模式云端网关
 *
 * 设计要点：
 * 1. 静态单例化（无需实例化）
 * 2. setUseMock(true) 走 MockDataService，setUseMock(false) 走 AGC 云函数（v1 暂不实现，留 TODO）
 * 3. mockDispatch<T>() 统一 Mock 调度入口，6 个 CF_* 全部走此方法
 * 4. request() 统一远程调用入口，调用真实云函数（v1 stub）
 *
 * 设计原则（来自 CONSTITUTION.md）：
 * - 强制静态类型，所有方法签名必须显式标注返回类型
 * - 严格等号 ===
 * - throw 必须是 Error 实例
 */

import { AppConstants } from '../common/Constants';
import { AppLogger } from '../common/AppLogger';
import { ErrorFormatter } from '../common/ErrorFormatter';

import { NewsItem } from '../model/NewsModel';
import { VenueItem } from '../model/VenueModel';
import { EquipmentItem } from '../model/EquipmentModel';
import { PlayerItem } from '../model/PlayerModel';
import { UserInfo } from '../model/UserModel';

import { MockDataService } from './MockDataService';

export interface CloudRequestOptions {
  url: string;
  method?: 'POST' | 'GET';
  payload?: Object;
  timeoutMs?: number;
}

export class CloudClient {
  private static useMock: boolean = true;

  /**
   * 初始化网关（由 EntryAbility.onCreate 调用）
   */
  public static init(useMock: boolean = true): void {
    CloudClient.useMock = useMock;
    AppLogger.info('CloudClient', `Initialized. useMock=${useMock}`);
  }

  /**
   * 切换 Mock / Real 模式（运行时可调用）
   */
  public static setUseMock(useMock: boolean): void {
    CloudClient.useMock = useMock;
    AppLogger.info('CloudClient', `Switched. useMock=${useMock}`);
  }

  public static isMock(): boolean {
    return CloudClient.useMock;
  }

  /**
   * 统一 Mock 分发：6 个 CF_* 全部走此方法
   */
  public static async mockDispatch<T>(cfName: string, payload?: Object): Promise<T> {
    AppLogger.debug('CloudClient', `mockDispatch cf=${cfName}`);

    switch (cfName) {
      case AppConstants.CF_NEWS_LIST:
        return (await MockDataService.getNewsList(20)) as T;

      case AppConstants.CF_VENUE_NEARBY:
        return (await MockDataService.getVenueList(20)) as T;

      case AppConstants.CF_EQUIPMENT_CATEGORIES:
        return (await MockDataService.getEquipmentCategoryList()) as T;

      case AppConstants.CF_PLAYER_LIST:
        return (await MockDataService.getPlayerList(20)) as T;

      case AppConstants.CF_USER_LOGIN:
        return (await MockDataService.mockHuaweiLogin()) as T;

      case AppConstants.CF_USER_LOGOUT:
        return null as T;

      default:
        throw new Error(`[CloudClient] unknown cfName: ${cfName}`);
    }
  }

  /**
   * 统一远程请求（v1 stub，未对接 AGC）
   * 设计：返回 Promise<T>，调用方 await 时正常走通；切换为真实模式时只需替换此方法体
   */
  public static async request<T>(options: CloudRequestOptions): Promise<T> {
    if (CloudClient.useMock) {
      AppLogger.warn('CloudClient', `request() in mock mode, url=${options.url}`);
      throw new Error('[CloudClient] request() is unavailable in mock mode, use mockDispatch instead');
    }

    // TODO: 接入 AGC Cloud Functions SDK 后替换此处
    // 当前 stub：抛错提示
    throw new Error(`[CloudClient] request() not implemented yet, url=${options.url}`);
  }

  /**
   * 业务封装：资讯列表
   */
  public static async getNewsList(): Promise<NewsItem[]> {
    try {
      return await CloudClient.mockDispatch<NewsItem[]>(AppConstants.CF_NEWS_LIST);
    } catch (e) {
      throw new Error(ErrorFormatter.format('CloudClient.getNewsList', e));
    }
  }

  /**
   * 业务封装：附近场馆
   */
  public static async getVenueNearby(): Promise<VenueItem[]> {
    try {
      return await CloudClient.mockDispatch<VenueItem[]>(AppConstants.CF_VENUE_NEARBY);
    } catch (e) {
      throw new Error(ErrorFormatter.format('CloudClient.getVenueNearby', e));
    }
  }

  /**
   * 业务封装：装备分类
   */
  public static async getEquipmentCategories(): Promise<EquipmentItem[]> {
    try {
      return await CloudClient.mockDispatch<EquipmentItem[]>(AppConstants.CF_EQUIPMENT_CATEGORIES);
    } catch (e) {
      throw new Error(ErrorFormatter.format('CloudClient.getEquipmentCategories', e));
    }
  }

  /**
   * 业务封装：球员列表
   */
  public static async getPlayerList(): Promise<PlayerItem[]> {
    try {
      return await CloudClient.mockDispatch<PlayerItem[]>(AppConstants.CF_PLAYER_LIST);
    } catch (e) {
      throw new Error(ErrorFormatter.format('CloudClient.getPlayerList', e));
    }
  }

  /**
   * 业务封装：Mock 登录
   */
  public static async mockLogin(): Promise<UserInfo> {
    try {
      return await CloudClient.mockDispatch<UserInfo>(AppConstants.CF_USER_LOGIN);
    } catch (e) {
      throw new Error(ErrorFormatter.format('CloudClient.mockLogin', e));
    }
  }
}
