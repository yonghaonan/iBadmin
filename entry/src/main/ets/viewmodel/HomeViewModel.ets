/**
 * HomeViewModel — 首页资讯 ViewModel
 *
 * 职责：
 * - 状态管理：loading / empty / error / loaded
 * - 数据加载：调用 NewsClient.getList()
 * - 跨页面刷新：通过 AppStorage.setOrCreate 增加 newsRefreshCount 计数器
 *
 * 边界：
 * - ViewModel 不持有 UI 引用
 * - ViewModel 不调用 console.* / prompt* 等 UI API
 * - 错误统一走 AppLogger + ErrorFormatter
 */

import { NewsItem } from '../model/NewsModel';
import { NewsClient } from '../cloud/NewsClient';
import { AppConstants } from '../common/Constants';
import { AppLogger } from '../common/AppLogger';
import { ErrorFormatter } from '../common/ErrorFormatter';
import { MockDataService } from '../cloud/MockDataService';
import { AIInsightEngine } from './AIInsightEngine';
import { AIInsightResult, UserActivity, WeatherInfo, VenueAvailability } from '../model/SportsDataModel';

export enum LoadState {
  IDLE = 'idle',
  LOADING = 'loading',
  EMPTY = 'empty',
  ERROR = 'error',
  LOADED = 'loaded'
}

@Observed
export class HomeViewModel {
  public state: LoadState = LoadState.IDLE;
  public newsList: NewsItem[] = [];
  public errorMessage: string = '';
  public aiInsight: AIInsightResult | null = null;

  /**
   * 加载资讯列表（首页入口）
   */
  public async loadNews(): Promise<void> {
    this.state = LoadState.LOADING;
    this.errorMessage = '';

    try {
      const data: NewsItem[] = await NewsClient.getList(AppConstants.DEFAULT_PAGE_SIZE);
      this.newsList = data;
      this.state = data.length === 0 ? LoadState.EMPTY : LoadState.LOADED;
      AppLogger.info('HomeViewModel', `Loaded ${data.length} news items`);
      // v1.1.3: 并行加载 AI 洞察
      this.loadAIInsight();
    } catch (e) {
      this.errorMessage = ErrorFormatter.format('HomeViewModel.loadNews', e);
      this.state = LoadState.ERROR;
      AppLogger.error('HomeViewModel', this.errorMessage);
    }
  }

  /**
   * v1.1.3: 加载 AI 洞察（基于规则引擎）
   */
  public async loadAIInsight(): Promise<void> {
    try {
      // v1.1.3.2 修复: ArkTS 不支持解构赋值，使用临时变量
      const result: Array<UserActivity | WeatherInfo | VenueAvailability> = await Promise.all([
        MockDataService.getUserActivity(),
        MockDataService.getWeather(),
        MockDataService.getVenueAvailability()
      ]);
      const user: UserActivity = result[0] as UserActivity;
      const weather: WeatherInfo = result[1] as WeatherInfo;
      const venue: VenueAvailability = result[2] as VenueAvailability;
      this.aiInsight = AIInsightEngine.generate({ user, weather, venue });
      AppLogger.info('HomeViewModel', `AI insight generated: ${this.aiInsight.insightContent}`);
    } catch (e) {
      AppLogger.error('HomeViewModel', `AI insight failed: ${ErrorFormatter.format('HomeViewModel.loadAIInsight', e)}`);
      // 失败时使用 null，UI 层显示静态 fallback
      this.aiInsight = null;
    }
  }

  /**
   * 刷新资讯（下拉刷新或跨页面触发）
   * 触发 AppStorage 计数器递增，使其他页面 @StorageProp @Watch 自动感知
   */
  public async refresh(): Promise<void> {
    AppLogger.debug('HomeViewModel', 'refresh triggered');
    await this.loadNews();
    HomeViewModel.bumpRefreshCount();
  }

  /**
   * 递增 AppStorage 计数器（跨页面刷新信号）
   */
  public static bumpRefreshCount(): void {
    const cur: number = (AppStorage.get<number>(AppConstants.APPSTORAGE_NEWS_REFRESH_COUNT) ?? 0) + 1;
    AppStorage.setOrCreate<number>(AppConstants.APPSTORAGE_NEWS_REFRESH_COUNT, cur);
  }

  /**
   * 监听其他页面的刷新信号（被 @StorageProp @Watch 调用）
   */
  public onExternalRefresh(): void {
    AppLogger.debug('HomeViewModel', 'onExternalRefresh received');
    this.loadNews();
  }
}
