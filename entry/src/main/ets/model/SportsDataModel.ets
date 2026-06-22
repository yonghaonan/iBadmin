/**
 * SportsDataModel — 体育数据模型（v1.1.3 新增）
 *
 * 用于 AI 洞察引擎输入：
 * - UserActivity：用户运动活动数据
 * - WeatherInfo：天气信息
 * - VenueAvailability：场馆空闲率
 * - AIInsightResult：规则引擎输出
 *
 * 设计原则：
 * - 全部使用具名 interface（符合 ArkTS 严格模式）
 * - 字符串枚举使用 union literal 类型（防止枚举值越界）
 * - AIInsightResult 中的文案最终由 AIInsightEngine 拼接，不在此处拼接
 */

export type PlayStyle = 'attacking' | 'defensive' | 'speed';
export type WeatherCondition = 'sunny' | 'cloudy' | 'rainy' | 'snowy';

/**
 * 用户活动数据
 */
export interface UserActivity {
  weeklyMatchCount: number;
  singlesWinRate: number;
  doublesWinRate: number;
  lastMatchAt: number;
  preferredStyle: PlayStyle;
  todayReadNews: number;
  todayTargetNews: number;
}

/**
 * 天气信息
 */
export interface WeatherInfo {
  isSuitable: boolean;
  condition: WeatherCondition;
  conditionText: string;
  temperatureC: number;
  humidity: number;
}

/**
 * 场馆空闲率（按时段）
 */
export interface VenueAvailability {
  morningFreeRate: number;
  afternoonFreeRate: number;
  eveningFreeRate: number;
}

/**
 * AI 洞察引擎输出
 */
export interface AIInsightResult {
  greeting: ResourceStr;
  subtitle: ResourceStr;
  insightLabel: ResourceStr;
  insightContent: string;
  suggestionLabel: ResourceStr;
  suggestionText: string;
  progressLabel: ResourceStr;
  progressSub: string;
  progressPercent: number;
}

/**
 * AI Insight 引擎的输入合集
 */
export interface AIInsightInput {
  user: UserActivity;
  weather: WeatherInfo;
  venue: VenueAvailability;
}