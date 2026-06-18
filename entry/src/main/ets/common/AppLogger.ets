// common/AppLogger.ets
// 统一日志器 — 基于 hilog 封装（DOMAIN 集中管理）
// 使用方式：AppLogger.info(TAG, 'message', 'arg1', 'arg2')
import { hilog } from '@kit.PerformanceAnalysisKit'

const DOMAIN: number = 0x0001

export class AppLogger {
  static debug(tag: string, message: string, ...args: string[]): void {
    hilog.debug(DOMAIN, tag, '%{public}s %{public}s', message, args.join(' '))
  }

  static info(tag: string, message: string, ...args: string[]): void {
    hilog.info(DOMAIN, tag, '%{public}s %{public}s', message, args.join(' '))
  }

  static warn(tag: string, message: string, ...args: string[]): void {
    hilog.warn(DOMAIN, tag, '%{public}s %{public}s', message, args.join(' '))
  }

  static error(tag: string, message: string, ...args: string[]): void {
    hilog.error(DOMAIN, tag, '%{public}s %{public}s', message, args.join(' '))
  }
}
