/**
 * CommunityViewModel — 社区页 ViewModel（3 Tab：场馆 / 装备 / 球员）
 *
 * 职责：
 * - 并行加载 3 个数据源（Promise.all）
 * - 每个数据源独立维护 loading/error 状态
 * - 跨页面刷新：通过 AppStorage 计数器
 */

import { VenueItem } from '../model/VenueModel';
import { EquipmentItem } from '../model/EquipmentModel';
import { PlayerItem } from '../model/PlayerModel';

import { VenueClient } from '../cloud/VenueClient';
import { EquipmentClient } from '../cloud/EquipmentClient';
import { PlayerClient } from '../cloud/PlayerClient';

import { AppConstants } from '../common/Constants';
import { AppLogger } from '../common/AppLogger';
import { ErrorFormatter } from '../common/ErrorFormatter';
import { LoadState } from './HomeViewModel';

@Observed
export class CommunityViewModel {
  public venueState: LoadState = LoadState.IDLE;
  public equipmentState: LoadState = LoadState.IDLE;
  public playerState: LoadState = LoadState.IDLE;

  public venueList: VenueItem[] = [];
  public equipmentList: EquipmentItem[] = [];
  public playerList: PlayerItem[] = [];

  public venueError: string = '';
  public equipmentError: string = '';
  public playerError: string = '';

  public activeTabIndex: number = AppConstants.COMMUNITY_TAB_VENUE;

  /**
   * 并行加载 3 个数据源
   */
  public async loadAll(): Promise<void> {
    this.venueState = LoadState.LOADING;
    this.equipmentState = LoadState.LOADING;
    this.playerState = LoadState.LOADING;
    this.venueError = '';
    this.equipmentError = '';
    this.playerError = '';

    const venueP: Promise<void> = this.loadVenues();
    const equipmentP: Promise<void> = this.loadEquipments();
    const playerP: Promise<void> = this.loadPlayers();

    await Promise.all([venueP, equipmentP, playerP]);
    AppLogger.info('CommunityViewModel', 'loadAll finished');
  }

  public async loadVenues(): Promise<void> {
    try {
      const data: VenueItem[] = await VenueClient.getNearby(20);
      this.venueList = data;
      this.venueState = data.length === 0 ? LoadState.EMPTY : LoadState.LOADED;
    } catch (e) {
      this.venueError = ErrorFormatter.format('CommunityViewModel.loadVenues', e);
      this.venueState = LoadState.ERROR;
      AppLogger.error('CommunityViewModel', this.venueError);
    }
  }

  public async loadEquipments(): Promise<void> {
    try {
      const data: EquipmentItem[] = await EquipmentClient.getCategories();
      this.equipmentList = data;
      this.equipmentState = data.length === 0 ? LoadState.EMPTY : LoadState.LOADED;
    } catch (e) {
      this.equipmentError = ErrorFormatter.format('CommunityViewModel.loadEquipments', e);
      this.equipmentState = LoadState.ERROR;
      AppLogger.error('CommunityViewModel', this.equipmentError);
    }
  }

  public async loadPlayers(): Promise<void> {
    try {
      const data: PlayerItem[] = await PlayerClient.getList(20);
      this.playerList = data;
      this.playerState = data.length === 0 ? LoadState.EMPTY : LoadState.LOADED;
    } catch (e) {
      this.playerError = ErrorFormatter.format('CommunityViewModel.loadPlayers', e);
      this.playerState = LoadState.ERROR;
      AppLogger.error('CommunityViewModel', this.playerError);
    }
  }

  /**
   * 切换 Tab（仅前端切换，不重新加载数据）
   */
  public switchTab(index: number): void {
    this.activeTabIndex = index;
    AppLogger.debug('CommunityViewModel', `switchTab index=${index}`);
  }

  /**
   * 跨页面刷新
   */
  public async refresh(): Promise<void> {
    await this.loadAll();
    CommunityViewModel.bumpRefreshCount();
  }

  /**
   * 监听其他页面的刷新信号（被 @StorageProp @Watch 调用）
   */
  public onExternalRefresh(): void {
    AppLogger.debug('CommunityViewModel', 'onExternalRefresh received');
    this.loadAll();
  }

  public static bumpRefreshCount(): void {
    const cur: number = (AppStorage.get<number>(AppConstants.APPSTORAGE_COMMUNITY_REFRESH_COUNT) ?? 0) + 1;
    AppStorage.setOrCreate<number>(AppConstants.APPSTORAGE_COMMUNITY_REFRESH_COUNT, cur);
  }
}
