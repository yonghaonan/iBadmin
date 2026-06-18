// common/Constants.ets
// 全局常量：AppStorage Key / 云函数名 / 业务枚举 / 路由名
// 注意：ArkTS 装饰器不接受 const 变量，所以 @StorageProp 装饰必须用字面量字符串
// 此处的常量供业务代码运行时引用
export class AppConstants {
  // ========== 字体族（与 DesignTokens 同步）==========
  static readonly FONT_FAMILY: string = 'HarmonyOS Sans'
  static readonly FONT_FAMILY_MEDIUM: string = 'HarmonyOS Sans Medium'
  static readonly FONT_FAMILY_BOLD: string = 'HarmonyOS Sans Bold'

  // ========== AppStorage Keys（运行时调用，非装饰器）==========
  static readonly APPSTORAGE_IS_LOGGED_IN: string = 'isLoggedIn'
  static readonly APPSTORAGE_USER_ID: string = 'userId'
  static readonly APPSTORAGE_DISPLAY_NAME: string = 'displayName'
  static readonly APPSTORAGE_AVATAR_URI: string = 'avatarUri'
  static readonly APPSTORAGE_LOGIN_ERROR: string = 'loginError'
  static readonly APPSTORAGE_PRIVACY_AGREED: string = 'privacyAgreed'
  static readonly APPSTORAGE_NEWS_REFRESH_COUNT: string = 'newsRefreshCount'
  static readonly APPSTORAGE_COMMUNITY_REFRESH_COUNT: string = 'communityRefreshCount'
  static readonly APPSTORAGE_PROFILE_REFRESH_COUNT: string = 'profileRefreshCount'
  static readonly APPSTORAGE_VENUE_REFRESH_COUNT: string = 'venueRefreshCount'
  static readonly APPSTORAGE_EQUIPMENT_REFRESH_COUNT: string = 'equipmentRefreshCount'
  static readonly APPSTORAGE_PLAYER_REFRESH_COUNT: string = 'playerRefreshCount'
  static readonly APPSTORAGE_MAIN_TABS_ACTIVE_INDEX: string = 'mainTabsActiveIndex'

  // v1.1.2 主题模式（auto/light/dark）
  static readonly APPSTORAGE_THEME_MODE: string = 'themeMode'

  // ========== 主题模式枚举（v1.1.2）==========
  static readonly THEME_AUTO: string = 'auto'
  static readonly THEME_LIGHT: string = 'light'
  static readonly THEME_DARK: string = 'dark'

  // ========== Preferences 键名（持久化）==========
  static readonly KEY_PRIVACY_AGREED: string = 'privacy_agreed'
  static readonly KEY_USER_ID: string = 'user_id'
  static readonly KEY_DISPLAY_NAME: string = 'display_name'
  static readonly KEY_AVATAR_URI: string = 'avatar_uri'
  static readonly KEY_IS_LOGGED_IN: string = 'is_logged_in'
  static readonly PREF_STORE_NAME: string = 'ibadmin_prefs'

  // ========== 云函数名（Mock dispatch key）==========
  static readonly CF_NEWS_LIST: string = 'news-list'
  static readonly CF_VENUE_NEARBY: string = 'venue-nearby'
  static readonly CF_EQUIPMENT_CATEGORIES: string = 'equipment-categories'
  static readonly CF_PLAYER_LIST: string = 'player-list'
  static readonly CF_USER_LOGIN: string = 'user-login'
  static readonly CF_USER_LOGOUT: string = 'user-logout'

  // ========== 路由名（NavPathStack 路由 key）==========
  static readonly ROUTE_HOME: string = 'pages/home/HomePage'
  static readonly ROUTE_COMMUNITY: string = 'pages/community/CommunityPage'
  static readonly ROUTE_PROFILE: string = 'pages/profile/ProfilePage'

  // ========== 社区 Tab 索引 ==========
  static readonly COMMUNITY_TAB_VENUE: number = 0
  static readonly COMMUNITY_TAB_EQUIPMENT: number = 1
  static readonly COMMUNITY_TAB_PLAYER: number = 2

  // ========== 场馆状态枚举 ==========
  static readonly VENUE_AVAILABLE: string = 'available'
  static readonly VENUE_BUSY: string = 'busy'
  static readonly VENUE_FULL: string = 'full'

  // ========== 球馆类型枚举 ==========
  static readonly VENUE_TYPE_INDOOR: string = 'indoor'
  static readonly VENUE_TYPE_OUTDOOR: string = 'outdoor'

  // ========== 装备分类枚举 ==========
  static readonly EQUIPMENT_RACKET: string = 'racket'
  static readonly EQUIPMENT_SHOES: string = 'shoes'
  static readonly EQUIPMENT_CLOTHES: string = 'clothes'
  static readonly EQUIPMENT_ACCESSORY: string = 'accessory'

  // ========== Mock 数据 ID 前缀 ==========
  static readonly MOCK_ID_PREFIX_NEWS: string = 'news_'
  static readonly MOCK_ID_PREFIX_VENUE: string = 'venue_'
  static readonly MOCK_ID_PREFIX_EQUIPMENT: string = 'equip_'
  static readonly MOCK_ID_PREFIX_PLAYER: string = 'player_'
  static readonly MOCK_ID_PREFIX_USER: string = 'user_'

  // ========== 业务固定 emoji ==========
  static readonly DEFAULT_AVATAR_EMOJI: string = '🏸'
}
