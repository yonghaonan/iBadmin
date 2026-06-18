// ohosTest/ets/test/common/ErrorFormatter.test.ets
// ErrorFormatter 单元测试 — 15 cases
// 覆盖 format() 与 messageOf() 全部边界场景
import { describe, it, expect } from '@ohos/hypium'
import { ErrorFormatter } from '../../../../main/ets/common/ErrorFormatter'

class CircularNode {
  self: CircularNode | null = null
}

interface BusinessError {
  code: number
  message: string
}

export default function ErrorFormatterTest() {
  describe('ErrorFormatter_format', () => {
    it('format_001_error_instance', 0, () => {
      const r: string = ErrorFormatter.format('auth', new Error('invalid token'))
      expect(r).assertEqual('ERR:auth: invalid token')
    })
    it('format_002_string_input', 1, () => {
      const r: string = ErrorFormatter.format('login', 'network down')
      expect(r).assertEqual('ERR:login: network down')
    })
    it('format_003_number_input', 2, () => {
      const r: string = ErrorFormatter.format('db', 500)
      expect(r).assertEqual('ERR:db: 500')
    })
    it('format_004_object_json', 3, () => {
      const o: BusinessError = { code: 1001860001, message: 'fail' }
      const r: string = ErrorFormatter.format('iap', o)
      expect(r).assertContain('ERR:iap:')
      expect(r).assertContain('"message":"fail"')
    })
    it('format_005_null', 4, () => {
      expect(ErrorFormatter.format('x', null)).assertEqual('ERR:x: unknown')
    })
    it('format_006_undefined', 5, () => {
      expect(ErrorFormatter.format('x', undefined)).assertEqual('ERR:x: unknown')
    })
    it('format_007_empty_scope', 6, () => {
      expect(ErrorFormatter.format('', new Error('e'))).assertEqual('ERR:: e')
    })
    it('format_008_boolean', 7, () => {
      expect(ErrorFormatter.format('b', false)).assertEqual('ERR:b: false')
    })
  })

  describe('ErrorFormatter_messageOf', () => {
    it('messageOf_001_error', 0, () => {
      expect(ErrorFormatter.messageOf(new Error('timeout'))).assertEqual('timeout')
    })
    it('messageOf_002_string', 1, () => {
      expect(ErrorFormatter.messageOf('foo')).assertEqual('foo')
    })
    it('messageOf_003_number', 2, () => {
      expect(ErrorFormatter.messageOf(42)).assertEqual('42')
    })
    it('messageOf_004_null_fallback', 3, () => {
      expect(ErrorFormatter.messageOf(null, 'fb')).assertEqual('fb')
    })
    it('messageOf_005_undefined_fallback', 4, () => {
      expect(ErrorFormatter.messageOf(undefined, 'fb')).assertEqual('fb')
    })
    it('messageOf_006_boolean', 5, () => {
      expect(ErrorFormatter.messageOf(true)).assertEqual('true')
    })
    it('messageOf_007_circular_fallback', 6, () => {
      const c: CircularNode = new CircularNode()
      c.self = c
      const r: string = ErrorFormatter.messageOf(c, 'fallback')
      expect(r).assertEqual('fallback')
    })
  })
}
