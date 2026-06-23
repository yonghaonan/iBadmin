/**
 * MainTabs — 主 Tab 容器（v1.1.2 重构 — 药丸设计）
 *
 * 设计变化：
 * - 药丸（pill）选中态：橙色背景圆角胶囊 + 白色 emoji
 * - AI 状态点：选中时药丸右上角白色微动点
 * - 高度 60 → 72（容纳药丸）
 * - 双主题适配（浅色/暗色自动切换）
 *
 * v1.1.1 改进：
 * - TAB_ITEMS 改 readonly + TabItem 接口 readonly
 * - 用 AppConstants 常量统一 key 字符串
 * - 删除空的 @Watch 回调
 */

import { DesignTokens } from '../common/DesignTokens';
import { AppConstants } from '../common/Constants';
import { AppLogger } from '../common/AppLogger';
import { IconShuttlecock, IconVenue, IconPlayer } from '../common/Icons';

import { HomePage } from './home/HomePage';
import { CommunityPage } from './community/CommunityPage';
import { ProfilePage } from './profile/ProfilePage';

type TabIconType = 'home' | 'community' | 'profile';

interface TabItem {
  readonly index: number;
  readonly label: string;
  readonly iconType: TabIconType;
}

const TAB_ITEMS: readonly TabItem[] = [
  { index: 0, label: '首页', iconType: 'home' },
  { index: 1, label: '社区', iconType: 'community' },
  { index: 2, label: '我的', iconType: 'profile' }
];

@Component
export struct MainTabs {
  @StorageProp(AppConstants.APPSTORAGE_MAIN_TABS_ACTIVE_INDEX) activeIndex: number = 0;

  public aboutToAppear(): void {
    AppStorage.setOrCreate<number>(AppConstants.APPSTORAGE_MAIN_TABS_ACTIVE_INDEX, 0);
  }

  public build(): void {
    Tabs({ barPosition: BarPosition.End, index: this.activeIndex }) {
      TabContent() {
        HomePage()
      }
      .tabBar(this.tabBarBuilder(TAB_ITEMS[0]))

      TabContent() {
        CommunityPage()
      }
      .tabBar(this.tabBarBuilder(TAB_ITEMS[1]))

      TabContent() {
        ProfilePage()
      }
      .tabBar(this.tabBarBuilder(TAB_ITEMS[2]))
    }
    .barHeight(DesignTokens.TAB_BAR_HEIGHT)
    .barBackgroundColor($r('app.color.card_background'))
    .onChange((index: number): void => {
      AppStorage.setOrCreate<number>(AppConstants.APPSTORAGE_MAIN_TABS_ACTIVE_INDEX, index);
      AppLogger.debug('MainTabs', `onChange index=${index}`);
    })
  }

  @Builder
  private renderTabIcon(iconType: TabIconType, isActive: boolean): void {
    if (iconType === 'home') {
      IconShuttlecock({ iconSize: DesignTokens.ICON_SIZE })
    } else if (iconType === 'community') {
      IconVenue({ iconSize: DesignTokens.ICON_SIZE })
    } else {
      IconPlayer({ iconSize: DesignTokens.ICON_SIZE })
    }
  }

  @Builder
  private tabBarBuilder(item: TabItem): void {
    Column() {
      // 药丸 + SVG 图标（选中态：橙色背景）
      Stack({ alignContent: Alignment.Center }) {
        // 选中态的橙色药丸
        if (this.activeIndex === item.index) {
          Column()
            .width(DesignTokens.TAB_PILL_WIDTH)
            .height(DesignTokens.TAB_PILL_HEIGHT)
            .borderRadius(DesignTokens.RADIUS_PILL)
            .backgroundColor($r('app.color.tab_pill_active'))
            .hitTestBehavior(HitTestMode.Transparent)
        }

        // SVG 图标（选中态显示在橙色药丸上）
        this.renderTabIcon(item.iconType, this.activeIndex === item.index)
      }
      .width(DesignTokens.TAB_PILL_WIDTH)
      .height(DesignTokens.TAB_PILL_HEIGHT)

      // 标签
      Text(item.label)
        .fontSize(DesignTokens.FONT_CAPTION)
        .fontWeight(this.activeIndex === item.index ? DesignTokens.WEIGHT_HEAVY : DesignTokens.WEIGHT_REGULAR)
        .fontColor(this.activeIndex === item.index ? $r('app.color.tab_pill_active') : $r('app.color.tab_inactive'))
        .margin({ top: DesignTokens.SPACING_XXS })
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .layoutWeight(1)
  }
}
