/**
 * AIInsightEngine — AI 洞察规则引擎（v1.1.3 新增）
 *
 * 职责：
 * - 基于本地规则生成动态 AI 洞察文案
 * - 输入：UserActivity + WeatherInfo + VenueAvailability
 * - 输出：AIInsightResult（智能问候 / 副标题 / 今日洞察 / 智能建议 / 进度）
 *
 * 设计原则：
 * - 完全本地运行，无云端依赖
 * - 5 条核心规则覆盖常见场景（天气 / 胜率 / 活跃度 / 闲置时长 / 场馆空闲）
 * - 文案拼接在引擎内完成，UI 层只负责显示
 * - 未来可平滑升级到 HarmonyOS Agent Framework Kit / 云函数 LLM
 */

import {
  AIInsightInput,
  AIInsightResult,
  PlayStyle,
  WeatherCondition,
  WeatherInfo,
  UserActivity,
  VenueAvailability
} from '../model/SportsDataModel';

const HOUR_MS: number = 60 * 60 * 1000;
const DAY_MS: number = 24 * HOUR_MS;
const ACTIVE_THRESHOLD_MATCH: number = 3;
const INACTIVE_THRESHOLD_DAYS: number = 3;
const WIN_RATE_DIFF_THRESHOLD: number = 0.1;

export class AIInsightEngine {

  /**
   * 生成 AI 洞察文案（主入口）
   */
  public static generate(input: AIInsightInput): AIInsightResult {
    const user: UserActivity = input.user;
    const weather: WeatherInfo = input.weather;
    const venue: VenueAvailability = input.venue;

    return {
      greeting: AIInsightEngine.computeGreeting(),
      subtitle: AIInsightEngine.computeSubtitle(user),
      insightLabel: $r('app.string.ai_insight_label'),
      insightContent: AIInsightEngine.computeInsight(user, weather, venue),
      suggestionLabel: $r('app.string.ai_insight_suggestion_label'),
      suggestionText: AIInsightEngine.computeSuggestion(user, weather, venue),
      progressLabel: $r('app.string.ai_progress_today'),
      progressSub: AIInsightEngine.computeProgress(user),
      progressPercent: AIInsightEngine.computeProgressPercent(user)
    };
  }

  /**
   * 智能问候（按时段）
   */
  private static computeGreeting(): ResourceStr {
    const hour: number = new Date().getHours();
    if (hour >= 5 && hour < 11) {
      return $r('app.string.ai_greeting_morning');
    }
    if (hour >= 11 && hour < 13) {
      return $r('app.string.ai_greeting_afternoon');
    }
    if (hour >= 13 && hour < 18) {
      return $r('app.string.ai_greeting_afternoon');
    }
    if (hour >= 18 && hour < 22) {
      return $r('app.string.ai_greeting_evening');
    }
    return $r('app.string.ai_greeting_night');
  }

  /**
   * 副标题（基于活跃度）
   */
  private static computeSubtitle(user: UserActivity): ResourceStr {
    const isActive: boolean = user.weeklyMatchCount >= ACTIVE_THRESHOLD_MATCH;
    return isActive ? $r('app.string.ai_subtitle_active') : $r('app.string.ai_subtitle_inactive');
  }

  /**
   * 今日洞察（核心：拼接天气 + 胜率 + 场馆）
   */
  private static computeInsight(
    user: UserActivity,
    weather: WeatherInfo,
    venue: VenueAvailability
  ): string {
    const parts: string[] = [];

    // 规则1：天气
    const weatherText: string = weather.isSuitable
      ? `${weather.conditionText}天气适宜`
      : `${weather.conditionText}天气不佳`;
    parts.push(weatherText);

    // 规则2：胜率偏好
    const isSinglesSpecialist: boolean =
      user.singlesWinRate > user.doublesWinRate + WIN_RATE_DIFF_THRESHOLD;
    const isDoublesSpecialist: boolean =
      user.doublesWinRate > user.singlesWinRate + WIN_RATE_DIFF_THRESHOLD;
    if (isSinglesSpecialist) {
      parts.push('你的胜率偏单打');
    } else if (isDoublesSpecialist) {
      parts.push('你的胜率偏双打');
    } else {
      parts.push('单双打胜率均衡');
    }

    // 规则3：场馆空闲时段
    const bestSlot: string = AIInsightEngine.findBestTimeSlot(venue);
    parts.push(`${bestSlot}场馆空闲率最低`);

    return parts.join('、');
  }

  /**
   * 智能建议（基于闲置时长 + 偏好打法）
   */
  private static computeSuggestion(
    user: UserActivity,
    weather: WeatherInfo,
    venue: VenueAvailability
  ): string {
    const parts: string[] = [];

    // 规则4：闲置时长提示
    const daysSinceLastMatch: number =
      (Date.now() - user.lastMatchAt) / DAY_MS;
    if (daysSinceLastMatch > INACTIVE_THRESHOLD_DAYS) {
      const days: number = Math.floor(daysSinceLastMatch);
      parts.push(`已经 ${days} 天没运动了`);
    }

    // 规则5：推荐最佳时段 + 偏好打法
    const bestSlot: string = AIInsightEngine.findBestTimeSlot(venue);
    const styleText: string = AIInsightEngine.formatStyle(user.preferredStyle);
    const weatherHint: string = weather.isSuitable ? '别错过好天气' : '建议室内活动';
    parts.push(`选择 ${bestSlot} ${styleText}（${weatherHint}）`);

    return parts.join('，');
  }

  /**
   * 今日目标进度（已读 / 目标）
   */
  private static computeProgress(user: UserActivity): string {
    return `已读 ${user.todayReadNews}/${user.todayTargetNews} 资讯`;
  }

  /**
   * 今日目标百分比（用于 ProgressRing）
   */
  private static computeProgressPercent(user: UserActivity): number {
    if (user.todayTargetNews <= 0) {
      return 0;
    }
    const ratio: number = user.todayReadNews / user.todayTargetNews;
    return Math.max(0, Math.min(100, Math.round(ratio * 100)));
  }

  /**
   * 找出空闲率最低的时段
   */
  private static findBestTimeSlot(venue: VenueAvailability): string {
    if (venue.afternoonFreeRate <= venue.morningFreeRate &&
        venue.afternoonFreeRate <= venue.eveningFreeRate) {
      return '下午';
    }
    if (venue.morningFreeRate <= venue.eveningFreeRate) {
      return '上午';
    }
    return '晚间';
  }

  /**
   * 格式化偏好打法的中文名
   */
  private static formatStyle(style: PlayStyle): string {
    switch (style) {
      case 'attacking':
        return '拉吊突击';
      case 'defensive':
        return '防守反击';
      case 'speed':
        return '快速拉吊';
      default:
        return '均衡打法';
    }
  }

  /**
   * 格式化天气状况（备用：使用 conditionText 已含中文，无需额外转换）
   */
  private static formatWeather(condition: WeatherCondition): string {
    switch (condition) {
      case 'sunny':
        return '晴';
      case 'cloudy':
        return '阴';
      case 'rainy':
        return '雨';
      case 'snowy':
        return '雪';
      default:
        return '';
    }
  }
}