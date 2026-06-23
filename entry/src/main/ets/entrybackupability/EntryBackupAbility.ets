import { BackupExtensionAbility, BundleVersion } from '@kit.CoreFileKit';
import { AppLogger } from '../common/AppLogger';

export default class EntryBackupAbility extends BackupExtensionAbility {
  async onBackup(): Promise<void> {
    AppLogger.info('EntryBackupAbility', 'onBackup ok');
    await Promise.resolve();
  }

  async onRestore(bundleVersion: BundleVersion): Promise<void> {
    AppLogger.info('EntryBackupAbility', `onRestore ok: ${JSON.stringify(bundleVersion)}`);
    await Promise.resolve();
  }
}
