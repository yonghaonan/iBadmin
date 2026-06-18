// common/RouteParams.ets
// 路由参数类型定义 — 所有 NavPathStack 跳转必须使用 interface
export interface NewsDetailParams {
  newsId: string
}

export interface VenueDetailParams {
  venueId: string
}

export interface EquipmentListParams {
  category: string
}

export interface PlayerDetailParams {
  playerId: string
}
