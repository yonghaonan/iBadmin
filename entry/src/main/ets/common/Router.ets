// common/Router.ets
// NavPathStack 单例封装 — 路由统一入口
import { AppLogger } from './AppLogger'

const TAG: string = 'Router'

export class RouteNames {
  static readonly NEWS_DETAIL: string = 'news_detail'
  static readonly VENUE_DETAIL: string = 'venue_detail'
  static readonly EQUIPMENT_LIST: string = 'equipment_list'
  static readonly PLAYER_DETAIL: string = 'player_detail'
}

export class AppRouter {
  private static instance: AppRouter | null = null
  private navPathStack: NavPathStack = new NavPathStack()

  private constructor() {
  }

  static getInstance(): AppRouter {
    if (AppRouter.instance === null) {
      AppRouter.instance = new AppRouter()
    }
    return AppRouter.instance
  }

  getNavPathStack(): NavPathStack {
    return this.navPathStack
  }

  push(name: string, param?: Object): void {
    AppLogger.info(TAG, `push: ${name}`)
    this.navPathStack.pushPath({ name: name, param: param })
  }

  pop(): void {
    AppLogger.info(TAG, 'pop')
    this.navPathStack.pop()
  }

  popToRoot(): void {
    AppLogger.info(TAG, 'popToRoot')
    this.navPathStack.clear()
  }

  replace(name: string, param?: Object): void {
    AppLogger.info(TAG, `replace: ${name}`)
    this.navPathStack.replacePath({ name: name, param: param })
  }

  getSize(): number {
    return this.navPathStack.size()
  }
}
