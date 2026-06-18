// ohosTest/ets/test/common/Constants.test.ets
// Constants 单元测试 — 14 cases
// 锁定 AppStorage Key / 云函数名 / 路由名等字符串字面量
import { describe, it, expect } from '@ohos/hypium'
import { AppConstants } from '../../../../main/ets/common/Constants'

export default function ConstantsTest() {
  describe('Constants_Font', () => {
    it('font_001_family', 0, () => {
      expect(AppConstants.FONT_FAMILY).assertEqual('HarmonyOS Sans')
    })
    it('font_002_family_medium', 1, () => {
      expect(AppConstants.FONT_FAMILY_MEDIUM).assertEqual('HarmonyOS Sans Medium')
    })
    it('font_003_family_bold', 2, () => {
      expect(AppConstants.FONT_FAMILY_BOLD).assertEqual('HarmonyOS Sans Bold')
    })
  })

  describe('Constants_CloudFunction', () => {
    it('cf_001_news_list', 0, () => {
      expect(AppConstants.CF_NEWS_LIST).assertEqual('news-list')
    })
    it('cf_002_venue_nearby', 1, () => {
      expect(AppConstants.CF_VENUE_NEARBY).assertEqual('venue-nearby')
    })
    it('cf_003_equipment', 2, () => {
      expect(AppConstants.CF_EQUIPMENT_CATEGORIES).assertEqual('equipment-categories')
    })
    it('cf_004_player_list', 3, () => {
      expect(AppConstants.CF_PLAYER_LIST).assertEqual('player-list')
    })
    it('cf_005_user_login', 4, () => {
      expect(AppConstants.CF_USER_LOGIN).assertEqual('user-login')
    })
  })

  describe('Constants_AppStorageKey', () => {
    it('key_001_is_logged_in', 0, () => {
      expect(AppConstants.APPSTORAGE_IS_LOGGED_IN).assertEqual('isLoggedIn')
    })
    it('key_002_display_name', 1, () => {
      expect(AppConstants.APPSTORAGE_DISPLAY_NAME).assertEqual('displayName')
    })
    it('key_003_news_refresh', 2, () => {
      expect(AppConstants.APPSTORAGE_NEWS_REFRESH_COUNT).assertEqual('newsRefreshCount')
    })
    it('key_004_privacy_agreed', 3, () => {
      expect(AppConstants.APPSTORAGE_PRIVACY_AGREED).assertEqual('privacyAgreed')
    })
    it('key_005_main_tabs_index', 4, () => {
      expect(AppConstants.APPSTORAGE_MAIN_TABS_ACTIVE_INDEX).assertEqual('mainTabsActiveIndex')
    })
  })

  describe('Constants_CommunityTab', () => {
    it('tab_001_venue', 0, () => {
      expect(AppConstants.COMMUNITY_TAB_VENUE).assertEqual(0)
    })
    it('tab_002_equipment', 1, () => {
      expect(AppConstants.COMMUNITY_TAB_EQUIPMENT).assertEqual(1)
    })
    it('tab_003_player', 2, () => {
      expect(AppConstants.COMMUNITY_TAB_PLAYER).assertEqual(2)
    })
  })
}
