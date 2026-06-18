// common/Utils.ets
// 通用工具类：ID 生成 / 日期格式化
export class AppUtils {
  /**
   * 生成简易唯一 ID（时间戳 + 随机数）
   */
  static generateId(): string {
    const timestamp: number = Date.now()
    const random: number = Math.floor(Math.random() * 10000)
    return `${timestamp}_${random}`
  }

  /**
   * 格式化日期为 YYYY-MM-DD
   */
  static formatDate(date: Date): string {
    const year: number = date.getFullYear()
    const month: string = AppUtils.padZero(date.getMonth() + 1)
    const day: string = AppUtils.padZero(date.getDate())
    return `${year}-${month}-${day}`
  }

  /**
   * 格式化时间为 HH:mm
   */
  static formatTime(date: Date): string {
    const hours: string = AppUtils.padZero(date.getHours())
    const minutes: string = AppUtils.padZero(date.getMinutes())
    return `${hours}:${minutes}`
  }

  /**
   * 格式化日期时间为 YYYY-MM-DD HH:mm
   */
  static formatDateTime(date: Date): string {
    return `${AppUtils.formatDate(date)} ${AppUtils.formatTime(date)}`
  }

  /**
   * 数字补零（<10 前置 0）
   */
  static padZero(num: number): string {
    return num < 10 ? `0${num}` : `${num}`
  }
}
