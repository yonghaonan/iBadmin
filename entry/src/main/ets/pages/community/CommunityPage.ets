/**
 * CommunityPage — 社区页（v1.1.2 重构 — 适配新设计语言）
 *
 * 设计变化：
 * - 标题字重 medium → heavy
 * - 3 子 Tab 选中态用主橙色 + 加粗
 * - 内部 Tab Bar 高度 +1vp（容纳加粗态）
 * - 双主题适配
 *
 * 职责保持：
 * - 纯 UI 展示
 * - 绑定 CommunityViewModel
 * - 3 子视图独立渲染 + 独立 3 态切换
 * - 下拉刷新全部数据
 */

import { DesignTokens } from '../../common/DesignTokens';
import { AppConstants } from '../../common/Constants';
import { AppLogger } from '../../common/AppLogger';
import { CommunityViewModel } from '../../viewmodel/CommunityViewModel';
import { LoadState } from '../../viewmodel/HomeViewModel';
import { IconRefresh } from '../../common/Icons';

import { VenueItem } from '../../model/VenueModel';
import { EquipmentItem } from '../../model/EquipmentModel';
import { PlayerItem } from '../../model/PlayerModel';

import { VenueCard } from '../../components/VenueCard';
import { EquipmentCategoryCard } from '../../components/EquipmentCategoryCard';
import { PlayerCard } from '../../components/PlayerCard';
import { EmptyState, EmptyStateType } from '../../components/EmptyState';

@Component
export struct CommunityPage {
  @State private vm: CommunityViewModel = new CommunityViewModel();
  @StorageProp(AppConstants.APPSTORAGE_COMMUNITY_REFRESH_COUNT) @Watch('onExternalRefresh') private refreshCount: number = 0;

  public aboutToAppear(): void {
    this.vm.loadAll();
  }

  public onExternalRefresh(): void {
    if (this.refreshCount > 0) {
      this.vm.onExternalRefresh();
    }
  }

  public build(): void {
    Column() {
      // 顶部标题栏
      Row() {
        Text($r('app.string.community_title'))
          .fontSize(DesignTokens.FONT_H1)
          .fontWeight(DesignTokens.WEIGHT_EXTRA_BOLD)
          .fontColor($r('app.color.text_primary'))
          .layoutWeight(1)

        IconRefresh({ iconSize: DesignTokens.FONT_EMOJI })
          .onClick((): void => {
            this.vm.refresh();
          })
      }
      .width('100%')
      .padding({
        left: DesignTokens.SPACING_MD,
        right: DesignTokens.SPACING_MD,
        top: DesignTokens.SPACING_MD,
        bottom: DesignTokens.SPACING_SM
      })

      // 内部 3 Tab 切换
      Tabs({ barPosition: BarPosition.Start, index: this.vm.activeTabIndex }) {
        TabContent() {
          this.VenueListView()
        }
        .tabBar(this.tabBarBuilder(AppConstants.COMMUNITY_TAB_VENUE, $r('app.string.community_tab_venues')))

        TabContent() {
          this.EquipmentGridView()
        }
        .tabBar(this.tabBarBuilder(AppConstants.COMMUNITY_TAB_EQUIPMENT, $r('app.string.community_tab_equipment')))

        TabContent() {
          this.PlayerListView()
        }
        .tabBar(this.tabBarBuilder(AppConstants.COMMUNITY_TAB_PLAYER, $r('app.string.community_tab_players')))
      }
      .barHeight(DesignTokens.COMMUNITY_TAB_BAR_HEIGHT)
      .barBackgroundColor($r('app.color.card_background'))
      .layoutWeight(1)
      .onChange((index: number): void => {
        this.vm.switchTab(index);
      })
    }
    .width('100%')
    .layoutWeight(1)
    .backgroundColor($r('app.color.background'))
  }

  @Builder
  private tabBarBuilder(tabIndex: number, label: ResourceStr): void {
    Text(label)
      .fontSize(DesignTokens.FONT_BODY)
      .fontColor(this.vm.activeTabIndex === tabIndex ? $r('app.color.ai_orange') : $r('app.color.text_secondary'))
      .fontWeight(this.vm.activeTabIndex === tabIndex ? DesignTokens.WEIGHT_HEAVY : DesignTokens.WEIGHT_REGULAR)
      .height('100%')
      .width('100%')
      .textAlign(TextAlign.Center)
  }

  @Builder
  private VenueListView(): void {
    if (this.vm.venueState === LoadState.LOADING) {
      EmptyState({
        type: EmptyStateType.LOADING,
        message: $r('app.string.venues_loading')
      })
    } else if (this.vm.venueState === LoadState.EMPTY) {
      EmptyState({
        type: EmptyStateType.EMPTY,
        message: $r('app.string.venues_empty')
      })
    } else if (this.vm.venueState === LoadState.ERROR) {
      EmptyState({
        type: EmptyStateType.ERROR,
        message: this.vm.venueError,
        retryText: $r('app.string.action_retry'),
        onRetry: (): void => {
          this.vm.loadVenues();
        }
      })
    } else {
      List({ space: DesignTokens.SPACING_SM }) {
        ForEach(this.vm.venueList, (item: VenueItem): void => {
          ListItem() {
            VenueCard({
              item: item,
              onTap: (v: VenueItem): void => {
                AppLogger.info('CommunityPage', `Venue tapped: ${v.id}`);
              }
            })
          }
        }, (item: VenueItem): string => item.id)
      }
      .width('100%')
      .layoutWeight(1)
      .padding({
        left: DesignTokens.SPACING_MD,
        right: DesignTokens.SPACING_MD,
        bottom: DesignTokens.SPACING_MD
      })
    }
  }

  @Builder
  private EquipmentGridView(): void {
    if (this.vm.equipmentState === LoadState.LOADING) {
      EmptyState({
        type: EmptyStateType.LOADING,
        message: $r('app.string.equipment_loading')
      })
    } else if (this.vm.equipmentState === LoadState.EMPTY) {
      EmptyState({
        type: EmptyStateType.EMPTY,
        message: $r('app.string.equipment_empty')
      })
    } else if (this.vm.equipmentState === LoadState.ERROR) {
      EmptyState({
        type: EmptyStateType.ERROR,
        message: this.vm.equipmentError,
        retryText: $r('app.string.action_retry'),
        onRetry: (): void => {
          this.vm.loadEquipments();
        }
      })
    } else {
      Grid() {
        ForEach(this.vm.equipmentList, (item: EquipmentItem): void => {
          GridItem() {
            EquipmentCategoryCard({
              item: item,
              onTap: (e: EquipmentItem): void => {
                AppLogger.info('CommunityPage', `Equipment tapped: ${e.id}`);
              }
            })
          }
        }, (item: EquipmentItem): string => item.id)
      }
      .columnsTemplate('1fr 1fr')
      .columnsGap(DesignTokens.SPACING_SM)
      .rowsGap(DesignTokens.SPACING_SM)
      .width('100%')
      .layoutWeight(1)
      .padding({
        left: DesignTokens.SPACING_MD,
        right: DesignTokens.SPACING_MD,
        top: DesignTokens.SPACING_MD,
        bottom: DesignTokens.SPACING_MD
      })
    }
  }

  @Builder
  private PlayerListView(): void {
    if (this.vm.playerState === LoadState.LOADING) {
      EmptyState({
        type: EmptyStateType.LOADING,
        message: $r('app.string.players_loading')
      })
    } else if (this.vm.playerState === LoadState.EMPTY) {
      EmptyState({
        type: EmptyStateType.EMPTY,
        message: $r('app.string.players_empty')
      })
    } else if (this.vm.playerState === LoadState.ERROR) {
      EmptyState({
        type: EmptyStateType.ERROR,
        message: this.vm.playerError,
        retryText: $r('app.string.action_retry'),
        onRetry: (): void => {
          this.vm.loadPlayers();
        }
      })
    } else {
      Scroll() {
        Row({ space: DesignTokens.SPACING_SM }) {
          ForEach(this.vm.playerList, (item: PlayerItem): void => {
            PlayerCard({
              item: item,
              onTap: (p: PlayerItem): void => {
                AppLogger.info('CommunityPage', `Player tapped: ${p.id}`);
              }
            })
          }, (item: PlayerItem): string => item.id)
        }
        .padding({
          left: DesignTokens.SPACING_MD,
          right: DesignTokens.SPACING_MD,
          top: DesignTokens.SPACING_MD,
          bottom: DesignTokens.SPACING_MD
        })
      }
      .width('100%')
      .layoutWeight(1)
      .scrollable(ScrollDirection.Horizontal)
    }
  }
}
