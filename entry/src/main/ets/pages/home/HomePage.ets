/**
 * HomePage — 首页（v1.1.2 重构 — A2 智能情境 + A3 深色霓虹）
 *
 * 设计变化：
 * - 顶部：智能问候 + AI 助理按钮（带光晕）
 * - 智能洞察 Hero 卡（带状态点 + AI 建议）
 * - 今日目标进度环（双主题：浅色实心 / 深色发光）
 * - 智能资讯列表（每张卡含 AI 摘要标签）
 * - 右下角 AI 语音输入浮动按钮
 *
 * 职责保持：
 * - 纯 UI 展示
 * - 绑定 HomeViewModel
 * - 3 状态渲染：LOADING / EMPTY / ERROR / LOADED
 * - 下拉刷新
 * - 监听跨页面刷新信号
 */

import { DesignTokens } from '../../common/DesignTokens';
import { AppConstants } from '../../common/Constants';
import { AppLogger } from '../../common/AppLogger';
import { HomeViewModel, LoadState } from '../../viewmodel/HomeViewModel';
import { NewsItem } from '../../model/NewsModel';
import { NewsCard } from '../../components/NewsCard';
import { EmptyState, EmptyStateType } from '../../components/EmptyState';
import { AIInsightCard } from '../../components/AIInsightCard';
import { AIAssistantButton } from '../../components/AIAssistantButton';
import { ProgressRing } from '../../components/ProgressRing';
import { IconAI, IconRefresh } from '../../common/Icons';


@Component
export struct HomePage {
  @State private vm: HomeViewModel = new HomeViewModel();
  @StorageProp(AppConstants.APPSTORAGE_NEWS_REFRESH_COUNT) @Watch('onExternalRefreshTrigger') private refreshCount: number = 0;

  public aboutToAppear(): void {
    this.vm.loadNews();
  }

  public onExternalRefreshTrigger(): void {
    if (this.refreshCount > 0) {
      this.vm.onExternalRefresh();
    }
  }

  public build(): void {
    Stack() {
      Column() {
        // 顶部智能问候 + AI 助理按钮
        Row() {
          Column() {
            Row() {
              Text(this.vm.aiInsight?.greeting ?? $r('app.string.ai_greeting_afternoon'))
                .fontSize(DesignTokens.FONT_H1)
                .fontWeight(DesignTokens.WEIGHT_EXTRA_BOLD)
                .fontColor($r('app.color.text_primary'))
              Text(' 👋')
                .fontSize(DesignTokens.FONT_H1)
                .fontWeight(DesignTokens.WEIGHT_EXTRA_BOLD)
                .fontColor($r('app.color.text_primary'))
            }

            Text(this.vm.aiInsight?.subtitle ?? $r('app.string.ai_subtitle_winrate'))
              .fontSize(DesignTokens.FONT_SMALL)
              .fontColor($r('app.color.text_hint'))
              .margin({ top: DesignTokens.SPACING_XXS })
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Start)

          AIAssistantButton({
            onTap: (): void => {
              AppLogger.info('HomePage', 'AI Assistant tapped');
              this.getUIContext().getPromptAction().showToast({ message: $r('app.string.toast_ai_assistant_coming_soon'), duration: 1500 });
            }
          })
        }
        .width('100%')
        .padding({
          left: DesignTokens.SPACING_MD,
          right: DesignTokens.SPACING_MD,
          top: DesignTokens.SPACING_MD,
          bottom: DesignTokens.SPACING_SM
        })

        // 内容区
        if (this.vm.state === LoadState.LOADING) {
          EmptyState({
            type: EmptyStateType.LOADING,
            message: $r('app.string.home_loading')
          })
        } else if (this.vm.state === LoadState.EMPTY) {
          EmptyState({
            type: EmptyStateType.EMPTY,
            message: $r('app.string.home_empty')
          })
        } else if (this.vm.state === LoadState.ERROR) {
          EmptyState({
            type: EmptyStateType.ERROR,
            message: $r('app.string.home_error'),
            retryText: $r('app.string.home_retry'),
            onRetry: (): void => {
              this.vm.loadNews();
            }
          })
        } else {
          // 已加载：AI 洞察 + 今日目标 + 智能资讯
          Scroll() {
            Column() {
              // AI 洞察 Hero 卡（动态文案）
              AIInsightCard({
                insightContent: this.vm.aiInsight?.insightContent ?? $r('app.string.ai_insight_content'),
                suggestionText: this.vm.aiInsight?.suggestionText ?? $r('app.string.ai_insight_suggestion_text')
              })
                .margin({ bottom: DesignTokens.SPACING_MD })

              // 今日目标进度环 + 智能资讯标题（并排）
              Row() {
                Column() {
                  Text(this.vm.aiInsight?.progressLabel ?? $r('app.string.ai_progress_today'))
                    .fontSize(DesignTokens.FONT_BODY)
                    .fontWeight(DesignTokens.WEIGHT_HEAVY)
                    .fontColor($r('app.color.text_primary'))
                    .margin({ bottom: DesignTokens.SPACING_XXS })

                  Text(this.vm.aiInsight?.progressSub ?? $r('app.string.ai_progress_sub'))
                    .fontSize(DesignTokens.FONT_CAPTION)
                    .fontColor($r('app.color.text_hint'))
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)

                ProgressRing({ progress: this.vm.aiInsight?.progressPercent ?? 0, label: '%' })
              }
              .width('100%')
              .padding(DesignTokens.SPACING_MD)
              .backgroundColor($r('app.color.card_background'))
              .borderRadius(DesignTokens.RADIUS_LG)
              .border({
                width: 1,
                color: $r('app.color.divider')
              })
              .margin({ bottom: DesignTokens.SPACING_MD })

              // 智能资讯标题
              Row() {
                Row() {
                  Text($r('app.string.ai_smart_news_title'))
                    .fontSize(DesignTokens.FONT_H3)
                    .fontWeight(DesignTokens.WEIGHT_HEAVY)
                    .fontColor($r('app.color.text_primary'))
                  Text(` (${this.vm.newsList.length.toString()})`)
                    .fontSize(DesignTokens.FONT_H3)
                    .fontWeight(DesignTokens.WEIGHT_HEAVY)
                    .fontColor($r('app.color.text_primary'))
                  Text($r('app.string.ai_smart_news_count_suffix'))
                    .fontSize(DesignTokens.FONT_H3)
                    .fontWeight(DesignTokens.WEIGHT_HEAVY)
                    .fontColor($r('app.color.text_primary'))
                }
                .layoutWeight(1)

                IconRefresh({ iconSize: DesignTokens.FONT_EMOJI })
                  .onClick((): void => {
                    this.vm.refresh();
                  })
              }
              .width('100%')
              .padding({
                left: DesignTokens.SPACING_XS,
                right: DesignTokens.SPACING_XS,
                top: DesignTokens.SPACING_SM,
                bottom: DesignTokens.SPACING_SM
              })
              .margin({ bottom: DesignTokens.SPACING_XS })

              // 资讯列表（避免 Scroll 嵌套 List 的反模式）
              ForEach(this.vm.newsList, (item: NewsItem): void => {
                NewsCard({
                  item: item,
                  showAiTag: true,
                  onTap: (n: NewsItem): void => {
                    AppLogger.info('HomePage', `News tapped: ${n.id}`);
                  }
                })
              }, (item: NewsItem): string => item.id)
            }
            .width('100%')
            .padding({
              left: DesignTokens.SPACING_MD,
              right: DesignTokens.SPACING_MD,
              bottom: DesignTokens.SPACING_2XL
            })
          }
          .layoutWeight(1)
          .scrollBar(BarState.Off)
          .edgeEffect(EdgeEffect.Spring)
        }
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor($r('app.color.background'))

      // AI 语音输入浮动按钮（右下角）
      if (this.vm.state === LoadState.LOADED) {
        Column() {
          IconAI({ iconSize: DesignTokens.FONT_EMOJI_LG })
        }
        .width(DesignTokens.AI_FAB_SIZE)
        .height(DesignTokens.AI_FAB_SIZE)
        .borderRadius(DesignTokens.AI_FAB_SIZE / 2)
        .backgroundColor($r('app.color.ai_orange'))
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .shadow(ShadowStyle.OUTER_DEFAULT_LG)
        .position({ x: '100%', y: '100%' })
        .markAnchor({ x: '100%', y: '100%' })
        .offset({ x: -DesignTokens.FAB_OFFSET, y: -(DesignTokens.TAB_BAR_HEIGHT + DesignTokens.FAB_OFFSET) })
        .onClick((): void => {
          AppLogger.info('HomePage', 'AI Voice FAB tapped');
          this.getUIContext().getPromptAction().showToast({ message: $r('app.string.toast_ai_voice_coming_soon'), duration: 1500 });
        })
      }
    }
    .width('100%')
    .height('100%')
  }
}
