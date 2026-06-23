/**
 * ProfilePage — 我的页（v1.1.2 重构）
 *
 * 设计变化：
 * - 标题字重 bold → extra-bold
 * - 5 项菜单 + 1 项主题切换（共 6 项）
 * - 主题切换弹出半模态选择器（跟随系统 / 浅色 / 深色）
 * - 双主题适配
 *
 * 职责保持：
 * - 未登录态：欢迎页 + 华为账号登录按钮
 * - 登录态：用户卡片 + 菜单项 + 退出登录
 * - 隐私弹窗：PrivacyDialog 全局组件
 */

import { DesignTokens } from '../../common/DesignTokens';
import { AppConstants } from '../../common/Constants';
import { ProfileViewModel } from '../../viewmodel/ProfileViewModel';
import { PrivacyDialog, PrivacyController } from '../../components/PrivacyDialog';
import { AppMenuItem } from '../../components/AppMenuItem';
import { AppLogger } from '../../common/AppLogger';
import { IconPlayer } from '../../common/Icons';

import { ConfigurationConstant } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Component
export struct ProfilePage {
  @State private vm: ProfileViewModel = new ProfileViewModel();
  @StorageProp(AppConstants.APPSTORAGE_IS_LOGGED_IN) private isLoggedInApp: boolean = false;
  @StorageProp('privacyDialogVisible') private privacyVisible: boolean = false;
  @StorageProp(AppConstants.APPSTORAGE_THEME_MODE) @Watch('onThemeModeChange') private themeMode: string = AppConstants.THEME_AUTO;

  public aboutToAppear(): void {
    this.vm.syncFromStorage();
  }

  public onThemeModeChange(): void {
    // 主题模式变化时，同步到系统 ColorMode
    this.applyThemeMode(this.themeMode);
  }

  private applyThemeMode(mode: string): void {
    try {
      const ctx = this.getUIContext().getHostContext();
      if (!ctx) {
        AppLogger.warn('ProfilePage', 'HostContext is undefined, skip applyThemeMode');
        return;
      }
      let colorMode: ConfigurationConstant.ColorMode = ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET;
      if (mode === AppConstants.THEME_DARK) {
        colorMode = ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
      } else if (mode === AppConstants.THEME_LIGHT) {
        colorMode = ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT;
      }
      ctx.getApplicationContext().setColorMode(colorMode);
      AppLogger.info('ProfilePage', `Theme mode applied: ${mode}`);
    } catch (err) {
      AppLogger.error('ProfilePage', `Failed to apply theme: ${JSON.stringify(err)}`);
    }
  }

  public build(): void {
    Stack() {
      Column() {
        // 顶部标题栏
        Row() {
          Text($r('app.string.tab_profile'))
            .fontSize(DesignTokens.FONT_H1)
            .fontWeight(DesignTokens.WEIGHT_EXTRA_BOLD)
            .fontColor($r('app.color.text_primary'))
            .layoutWeight(1)
        }
        .width('100%')
        .padding({
          left: DesignTokens.SPACING_MD,
          right: DesignTokens.SPACING_MD,
          top: DesignTokens.SPACING_MD,
          bottom: DesignTokens.SPACING_SM
        })

        if (this.isLoggedInApp) {
          // 已登录态
          this.LoggedInView()
        } else {
          // 未登录态
          this.LoggedOutView()
        }
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor($r('app.color.background'))

      // 隐私弹窗（全局栈）
      if (this.privacyVisible) {
        PrivacyDialog()
      }
    }
    .width('100%')
    .layoutWeight(1)
  }

  @Builder
  private LoggedOutView(): void {
    Column() {
      Blank().layoutWeight(1)

      // 欢迎图标
      IconPlayer({ iconSize: DesignTokens.FONT_EMOJI_HERO })
        .margin({ bottom: DesignTokens.SPACING_LG })

      Text($r('app.string.profile_login_title'))
        .fontSize(DesignTokens.FONT_H1)
        .fontWeight(DesignTokens.WEIGHT_EXTRA_BOLD)
        .fontColor($r('app.color.text_primary'))
        .margin({ bottom: DesignTokens.SPACING_SM })

      Text($r('app.string.profile_login_subtitle'))
        .fontSize(DesignTokens.FONT_BODY)
        .fontColor($r('app.color.text_secondary'))
        .margin({ bottom: DesignTokens.SPACING_2XL })

      // 华为账号登录按钮（保留品牌色）
      Button($r('app.string.profile_login_button'))
        .fontSize(DesignTokens.FONT_BODY)
        .fontColor($r('app.color.text_on_primary'))
        .backgroundColor($r('app.color.huawei_red'))
        .height(DesignTokens.LOGIN_BUTTON_HEIGHT)
        .width('80%')
        .borderRadius(DesignTokens.RADIUS_LG)
        .margin({ bottom: DesignTokens.SPACING_MD })
        .onClick((): void => {
          this.triggerPrivacyDialog();
        })

      Blank().layoutWeight(1)
    }
    .width('100%')
    .layoutWeight(1)
    .padding(DesignTokens.SPACING_XL)
  }

  @Builder
  private LoggedInView(): void {
    Column() {
      // 用户卡片
      Row() {
        Row() {
          IconPlayer({ iconSize: DesignTokens.FONT_EMOJI_XL })
        }
        .width(DesignTokens.AVATAR_SIZE)
        .height(DesignTokens.AVATAR_SIZE)
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .backgroundColor($r('app.color.primary_bg'))
        .borderRadius(DesignTokens.RADIUS_CAPSULE)

        Column() {
          Text(this.vm.user.nickname !== '' ? this.vm.user.nickname : $r('app.string.profile_user_default_name'))
            .fontSize(DesignTokens.FONT_H3)
            .fontWeight(DesignTokens.WEIGHT_HEAVY)
            .fontColor($r('app.color.text_primary'))
            .width('100%')

          if (this.vm.user.id !== '') {
            Text(`ID: ${this.vm.user.id}`)
              .fontSize(DesignTokens.FONT_CAPTION)
              .fontColor($r('app.color.text_hint'))
              .width('100%')
              .margin({ top: DesignTokens.SPACING_XXS })
          }
        }
        .layoutWeight(1)
        .margin({ left: DesignTokens.SPACING_MD })
        .alignItems(HorizontalAlign.Start)
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

      // 6 项菜单
      AppMenuItem({
        iconType: 'venue',
        title: $r('app.string.profile_menu_venues'),
        subtitle: '',
        onTap: (): void => {
          AppLogger.info('ProfilePage', 'tap 我的场馆');
        }
      })

      AppMenuItem({
        iconType: 'equipment',
        title: $r('app.string.profile_menu_equipment'),
        subtitle: '',
        onTap: (): void => {
          AppLogger.info('ProfilePage', 'tap 我的装备');
        }
      })

      AppMenuItem({
        iconType: 'history',
        title: $r('app.string.profile_menu_history'),
        subtitle: '',
        onTap: (): void => {
          AppLogger.info('ProfilePage', 'tap 对战记录');
        }
      })

      // 主题外观菜单（v1.1.2 新增）
      AppMenuItem({
        iconType: 'theme',
        title: $r('app.string.profile_menu_theme'),
        subtitle: this.themeLabel(),
        onTap: (): void => {
          this.showThemePicker();
        }
      })

      AppMenuItem({
        iconType: 'settings',
        title: $r('app.string.profile_menu_settings'),
        subtitle: '',
        onTap: (): void => {
          AppLogger.info('ProfilePage', 'tap 设置');
        }
      })

      AppMenuItem({
        iconType: 'about',
        title: $r('app.string.profile_menu_about'),
        subtitle: '',
        onTap: (): void => {
          AppLogger.info('ProfilePage', 'tap 关于');
        }
      })

      Blank().layoutWeight(1)

      // 退出登录按钮
      Button($r('app.string.profile_logout_button'))
        .fontSize(DesignTokens.FONT_BODY)
        .fontColor($r('app.color.danger'))
        .backgroundColor($r('app.color.background'))
        .height(DesignTokens.INPUT_HEIGHT)
        .width('100%')
        .borderRadius(DesignTokens.RADIUS_LG)
        .margin({ bottom: DesignTokens.SPACING_MD })
        .onClick((): void => {
          this.vm.logout();
        })
    }
    .width('100%')
    .layoutWeight(1)
    .padding({
      left: DesignTokens.SPACING_MD,
      right: DesignTokens.SPACING_MD,
      top: DesignTokens.SPACING_MD,
      bottom: DesignTokens.SPACING_MD
    })
  }

  /**
   * 主题标签（副标题）
   */
  private themeLabel(): ResourceStr {
    if (this.themeMode === AppConstants.THEME_DARK) {
      return $r('app.string.profile_theme_dark');
    }
    if (this.themeMode === AppConstants.THEME_LIGHT) {
      return $r('app.string.profile_theme_light');
    }
    return $r('app.string.profile_theme_auto');
  }

  /**
   * 显示主题选择器（半模态）
   */
  private showThemePicker(): void {
    const that = this;
    this.getUIContext().getPromptAction().showActionMenu({
      title: $r('app.string.profile_theme_picker_title'),
      buttons: [
        { text: $r('app.string.profile_theme_auto'), color: $r('app.color.text_primary') },
        { text: $r('app.string.profile_theme_light'), color: $r('app.color.text_primary') },
        { text: $r('app.string.profile_theme_dark'), color: $r('app.color.text_primary') }
      ]
    }, (err: BusinessError, data): void => {
      if (err) {
        AppLogger.error('ProfilePage', `Theme picker canceled: ${err.message}`);
        return;
      }
      const index: number = data.index;
      let newMode: string = AppConstants.THEME_AUTO;
      if (index === 1) {
        newMode = AppConstants.THEME_LIGHT;
      } else if (index === 2) {
        newMode = AppConstants.THEME_DARK;
      }
      AppStorage.setOrCreate<string>(AppConstants.APPSTORAGE_THEME_MODE, newMode);
      that.applyThemeMode(newMode);
      that.getUIContext().getPromptAction().showToast({ message: $r('app.string.theme_switch_success'), duration: 1000 });
    });
  }

  /**
   * 触发隐私弹窗：同意后调用登录
   */
  private triggerPrivacyDialog(): void {
    PrivacyController.getInstance().show(
      (): void => {
        AppLogger.info('ProfilePage', 'Privacy agreed -> loginWithHuawei');
        this.vm.loginWithHuawei();
      },
      (): void => {
        AppLogger.info('ProfilePage', 'Privacy rejected');
        this.getUIContext().getPromptAction().showToast({ message: $r('app.string.privacy_reject_toast'), duration: 2000 });
      }
    );
  }
}
