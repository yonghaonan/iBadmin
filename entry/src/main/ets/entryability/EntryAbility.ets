/**
 * EntryAbility — 应用入口 Ability
 *
 * 职责：
 * 1. onCreate：初始化 CloudClient（Mock 模式）
 * 2. onWindowStageCreate：加载 pages/Index
 * 3. 清理日志使用统一 AppLogger
 */

import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';

import { CloudClient } from '../cloud/CloudClient';
import { AppLogger } from '../common/AppLogger';
import { AppStorageBootstrap } from '../common/AppStorageBootstrap';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      AppLogger.error('EntryAbility', `Failed to set colorMode: ${JSON.stringify(err)}`);
    }

    // 1. 初始化 AppStorage 默认值（必须先于 CloudClient 与 Page 读取）
    AppStorageBootstrap.initDefaults();

    // 2. 初始化 CloudClient（默认 Mock 模式）
    CloudClient.init(true);
    AppLogger.info('EntryAbility', 'Ability onCreate done');
  }

  onDestroy(): void {
    AppLogger.info('EntryAbility', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    AppLogger.info('EntryAbility', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        AppLogger.error('EntryAbility', `Failed to load content: ${JSON.stringify(err)}`);
        return;
      }
      AppLogger.info('EntryAbility', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    AppLogger.info('EntryAbility', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    AppLogger.info('EntryAbility', 'Ability onForeground');
  }

  onBackground(): void {
    AppLogger.info('EntryAbility', 'Ability onBackground');
  }
}
