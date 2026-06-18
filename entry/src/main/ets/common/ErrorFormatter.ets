// common/ErrorFormatter.ets
// 统一错误格式化器 — 所有 catch 块的标准输出
// 使用方式：catch (e) { AppLogger.error(TAG, ErrorFormatter.format('scope', e)) }
export type ErrorLike = Error | Object | string | number | boolean | null | undefined

export class ErrorFormatter {
  /**
   * 格式化错误为 ERR:<scope>: <msg> 形式
   */
  public static format(scope: string, e: ErrorLike): string {
    const msg: string = ErrorFormatter.extractMessage(e)
    return `ERR:${scope}: ${msg}`
  }

  /**
   * 仅提取错误消息，可指定 fallback
   */
  public static messageOf(e: ErrorLike, fallback: string = 'unknown'): string {
    return ErrorFormatter.extractMessage(e, fallback)
  }

  /**
   * 提取任意类型的可读消息
   * 优先级：Error.message > string > number/boolean > JSON.stringify > fallback
   */
  private static extractMessage(e: ErrorLike, fallback: string = 'unknown'): string {
    if (e instanceof Error) {
      return e.message
    }
    if (typeof e === 'string') {
      return e
    }
    if (typeof e === 'number' || typeof e === 'boolean') {
      return String(e)
    }
    if (e === null || e === undefined) {
      return fallback
    }
    try {
      const json: string = JSON.stringify(e)
      return json !== '' ? json : fallback
    } catch (jsonErr) {
      // JSON.stringify 抛错（循环引用等）→ 返回 fallback
      return fallback
    }
  }
}
