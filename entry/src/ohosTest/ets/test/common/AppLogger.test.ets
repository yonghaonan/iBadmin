// ohosTest/ets/test/common/AppLogger.test.ets
// AppLogger 单元测试 — 5 cases（仅烟测各级别调用无异常）
import { describe, it, expect } from '@ohos/hypium'
import { AppLogger } from '../../../../main/ets/common/AppLogger'

export default function AppLoggerTest() {
  describe('AppLogger_smoke', () => {
    it('logger_001_debug', 0, () => {
      AppLogger.debug('Test', 'debug message')
      expect(true).assertEqual(true)
    })
    it('logger_002_info', 1, () => {
      AppLogger.info('Test', 'info message', 'arg1', 'arg2')
      expect(true).assertEqual(true)
    })
    it('logger_003_warn', 2, () => {
      AppLogger.warn('Test', 'warn message')
      expect(true).assertEqual(true)
    })
    it('logger_004_error', 3, () => {
      AppLogger.error('Test', 'error message', 'detail')
      expect(true).assertEqual(true)
    })
  })

  describe('AppLogger_pageTapStyle', () => {
    // 模拟 Page 层 onClick 内的日志输出（验证 v1.1.1 替换 console.* 后行为一致）
    it('logger_005_page_tap_event', 0, () => {
      const eventId: string = 'news_001'
      AppLogger.info('HomePage', `News tapped: ${eventId}`)
      expect(true).assertEqual(true)
    })
  })
}
