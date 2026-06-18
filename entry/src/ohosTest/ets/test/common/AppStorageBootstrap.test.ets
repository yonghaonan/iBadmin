// ohosTest/ets/test/common/AppStorageBootstrap.test.ets
// AppStorageBootstrap 单元测试 — 5 cases
// 验证 7 个 AppStorage 共享 key 的默认值初始化
import { describe, it, expect, beforeAll } from '@ohos/hypium'
import { AppStorageBootstrap } from '../../../../main/ets/common/AppStorageBootstrap'
import { AppConstants } from '../../../../main/ets/common/Constants'

export default function AppStorageBootstrapTest() {
  beforeAll((): void => {
    // 清理可能存在的脏数据（test fixture 隔离）
    AppStorage.delete(AppConstants.APPSTORAGE_IS_LOGGED_IN);
    AppStorage.delete(AppConstants.APPSTORAGE_USER_ID);
    AppStorage.delete(AppConstants.APPSTORAGE_DISPLAY_NAME);
    AppStorage.delete(AppConstants.APPSTORAGE_AVATAR_URI);
    AppStorage.delete(AppConstants.APPSTORAGE_PRIVACY_AGREED);
    AppStorage.delete(AppConstants.APPSTORAGE_NEWS_REFRESH_COUNT);
    AppStorage.delete(AppConstants.APPSTORAGE_COMMUNITY_REFRESH_COUNT);
    // 显式调用
    AppStorageBootstrap.initDefaults();
  });

  describe('AppStorageBootstrap_loginState', () => {
    it('login_001_isLoggedIn_false', 0, () => {
      expect(AppStorage.get<boolean>(AppConstants.APPSTORAGE_IS_LOGGED_IN)).assertEqual(false);
    });
    it('login_002_userFields_empty', 1, () => {
      expect(AppStorage.get<string>(AppConstants.APPSTORAGE_USER_ID)).assertEqual('');
      expect(AppStorage.get<string>(AppConstants.APPSTORAGE_DISPLAY_NAME)).assertEqual('');
      expect(AppStorage.get<string>(AppConstants.APPSTORAGE_AVATAR_URI)).assertEqual('');
    });
  });

  describe('AppStorageBootstrap_privacyState', () => {
    it('privacy_001_agreed_false', 0, () => {
      expect(AppStorage.get<boolean>(AppConstants.APPSTORAGE_PRIVACY_AGREED)).assertEqual(false);
    });
  });

  describe('AppStorageBootstrap_refreshCounters', () => {
    it('refresh_001_news_count_zero', 0, () => {
      expect(AppStorage.get<number>(AppConstants.APPSTORAGE_NEWS_REFRESH_COUNT)).assertEqual(0);
    });
    it('refresh_002_community_count_zero', 1, () => {
      expect(AppStorage.get<number>(AppConstants.APPSTORAGE_COMMUNITY_REFRESH_COUNT)).assertEqual(0);
    });
  });

  describe('AppStorageBootstrap_idempotent', () => {
    it('idempotent_001_keeps_existing_value', 0, () => {
      // 修改后再调用 initDefaults，setOrCreate 应保留已有值
      AppStorage.setOrCreate<boolean>(AppConstants.APPSTORAGE_IS_LOGGED_IN, true);
      AppStorageBootstrap.initDefaults();
      expect(AppStorage.get<boolean>(AppConstants.APPSTORAGE_IS_LOGGED_IN)).assertEqual(true);
    });
  });
}
