/**
 * Index.ets — 应用入口（纯容器，加载 MainTabs）
 *
 * 设计：
 * - @Entry 装饰器仅在此页面（被 EntryAbility.loadContent() 加载）
 * - 不包含业务逻辑，只承载 MainTabs
 */

import { MainTabs } from './MainTabs';

@Entry
@Component
struct Index {
  public build(): void {
    Stack() {
      MainTabs()
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background'))
  }
}
