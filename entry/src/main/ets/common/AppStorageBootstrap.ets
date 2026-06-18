/**
 * AppStorageBootstrap — AppStorage 默认值集中初始化
 *
 * 职责：
 * - 在 EntryAbility.onCreate() 中统一初始化 7 个 AppStorage 共享 key
 * - 避免 Page 层 @StorageProp 在首次冷启动时拿到 undefined 与类型不一致
 *
 * 调用顺序：
 * 1. EntryAbility.onCreate() → AppStorageBootstrap.initDefaults()
 * 2. 各 Page 通过 @StorageProp(key) 同步读取（已具备默认值）
 */

import { AppConstants } from './Constants';
import { AppLogger } from './AppLogger';

export class AppStorageBootstrap {
  /**
   * 初始化所有 AppStorage 共享 key 的默认值
   * - 重复调用是安全的：setOrCreate 仅在 key 不存在时生效
   * - 必须先于首个 @StorageProp 读取
   */
  public static initDefaults(): void {
    AppStorage.setOrCreate<boolean>(AppConstants.APPSTORAGE_IS_LOGGED_IN, false);
    AppStorage.setOrCreate<string>(AppConstants.APPSTORAGE_USER_ID, '');
    AppStorage.setOrCreate<string>(AppConstants.APPSTORAGE_DISPLAY_NAME, '');
    AppStorage.setOrCreate<string>(AppConstants.APPSTORAGE_AVATAR_URI, '');
    AppStorage.setOrCreate<boolean>(AppConstants.APPSTORAGE_PRIVACY_AGREED, false);
    AppStorage.setOrCreate<number>(AppConstants.APPSTORAGE_NEWS_REFRESH_COUNT, 0);
    AppStorage.setOrCreate<number>(AppConstants.APPSTORAGE_COMMUNITY_REFRESH_COUNT, 0);
    // v1.1.2 主题模式默认跟随系统
    AppStorage.setOrCreate<string>(AppConstants.APPSTORAGE_THEME_MODE, AppConstants.THEME_AUTO);
    AppLogger.info('AppStorageBootstrap', '8 default keys initialized (with themeMode)');
  }
}
