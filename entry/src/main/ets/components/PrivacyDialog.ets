/**
 * PrivacyDialog — 隐私弹窗组件（v1.1.2 重构 — 双主题适配）
 *
 * 设计变化：
 * - 圆角 16 → 20
 * - 同意按钮背景色改用主橙色（品牌统一）
 * - 双主题适配
 *
 * 通过 PrivacyController 单例 + AppStorage 实现"同意/拒绝"通信
 */

import { AppConstants } from '../common/Constants';
import { DesignTokens } from '../common/DesignTokens';
import { AppLogger } from '../common/AppLogger';

type AgreeCallback = () => void;
type DisagreeCallback = () => void;

@Observed
export class PrivacyController {
  private static instance: PrivacyController | null = null;
  private onAgreeCallback: AgreeCallback | null = null;
  private onDisagreeCallback: DisagreeCallback | null = null;

  public static getInstance(): PrivacyController {
    if (PrivacyController.instance === null) {
      PrivacyController.instance = new PrivacyController();
    }
    return PrivacyController.instance;
  }

  public setOnAgreeCallback(cb: AgreeCallback): void {
    this.onAgreeCallback = cb;
  }

  public setOnDisagreeCallback(cb: DisagreeCallback): void {
    this.onDisagreeCallback = cb;
  }

  public show(onAgree: AgreeCallback, onDisagree?: DisagreeCallback): void {
    this.onAgreeCallback = onAgree;
    this.onDisagreeCallback = onDisagree ?? null;
    AppStorage.setOrCreate<boolean>(AppConstants.APPSTORAGE_PRIVACY_AGREED, false);
    AppStorage.setOrCreate<boolean>('privacyDialogVisible', true);
    AppLogger.debug('PrivacyController', 'show');
  }

  public hide(): void {
    AppStorage.setOrCreate<boolean>('privacyDialogVisible', false);
  }

  public agree(): void {
    AppStorage.setOrCreate<boolean>(AppConstants.APPSTORAGE_PRIVACY_AGREED, true);
    this.hide();
    if (this.onAgreeCallback !== null) {
      this.onAgreeCallback();
    }
    AppLogger.info('PrivacyController', 'agreed');
  }

  public disagree(): void {
    AppStorage.setOrCreate<boolean>(AppConstants.APPSTORAGE_PRIVACY_AGREED, false);
    this.hide();
    if (this.onDisagreeCallback !== null) {
      this.onDisagreeCallback();
    }
    AppLogger.info('PrivacyController', 'disagreed');
  }
}

@Component
export struct PrivacyDialog {
  @StorageProp('privacyDialogVisible') @Watch('onVisibleChange') visible: boolean = false;
  @StorageProp(AppConstants.APPSTORAGE_PRIVACY_AGREED) privacyAgreed: boolean = false;

  public aboutToAppear(): void {
    AppLogger.debug('PrivacyDialog', 'aboutToAppear');
  }

  public onVisibleChange(): void {
    AppLogger.debug('PrivacyDialog', `visible changed: ${this.visible}`);
  }

  public build(): void {
    Stack() {
      // 半透明遮罩（hitTestBehavior.Transparent：让事件穿透，背景色仍可见）
      Column() {
        if (this.visible) {
          Column() {
            // 标题
            Text($r('app.string.privacy_title'))
              .fontSize(DesignTokens.FONT_H2)
              .fontWeight(DesignTokens.WEIGHT_HEAVY)
              .fontColor($r('app.color.text_primary'))
              .margin({ bottom: DesignTokens.SPACING_LG })
              .width('100%')
              .textAlign(TextAlign.Center)

            // 内容
            Text($r('app.string.privacy_content'))
              .fontSize(DesignTokens.FONT_BODY)
              .fontColor($r('app.color.text_secondary'))
              .lineHeight(DesignTokens.LINE_HEIGHT_BODY)
              .margin({ bottom: DesignTokens.SPACING_XL })
              .width('100%')

            // 按钮行
            Row({ space: DesignTokens.SPACING_MD }) {
              Button($r('app.string.privacy_disagree'))
                .fontSize(DesignTokens.FONT_BODY)
                .fontColor($r('app.color.text_secondary'))
                .backgroundColor($r('app.color.background'))
                .height(DesignTokens.INPUT_HEIGHT)
                .borderRadius(DesignTokens.RADIUS_LG)
                .layoutWeight(1)
                .onClick((): void => {
                  PrivacyController.getInstance().disagree();
                })

              Button($r('app.string.privacy_agree'))
                .fontSize(DesignTokens.FONT_BODY)
                .fontColor($r('app.color.text_on_primary'))
                .backgroundColor($r('app.color.ai_orange'))
                .height(DesignTokens.INPUT_HEIGHT)
                .borderRadius(DesignTokens.RADIUS_LG)
                .layoutWeight(1)
                .onClick((): void => {
                  PrivacyController.getInstance().agree();
                })
            }
            .width('100%')
          }
          .width('80%')
          .padding(DesignTokens.SPACING_XL)
          .backgroundColor($r('app.color.card_background'))
          .borderRadius(DesignTokens.RADIUS_LG)
          .hitTestBehavior(HitTestMode.Block)
        }
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .backgroundColor(this.visible ? 'rgba(0, 0, 0, 0.5)' : 'rgba(0, 0, 0, 0)')
      .hitTestBehavior(HitTestMode.Transparent)
    }
    .width('100%')
    .height('100%')
  }
}
