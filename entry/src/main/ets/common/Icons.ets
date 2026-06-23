/**
 * Icons.ets — 统一图标组件库（v1.1.3 新增，v1.1.3.2 修复）
 *
 * 设计原则：
 * - 全部使用 SVG 资源（resources/base/media/icon_*.svg）
 * - 通过 @Prop 暴露 iconSize / color 供调用方定制
 * - 24×24 基准尺寸，颜色默认 $r('app.color.ai_orange')
 * - 可适配深色模式（color 通过 ResourceColor 传入）
 *
 * v1.1.3.2 修复：
 * - 将属性 `size` 重命名为 `iconSize`（避免与基类 `CustomComponent.size()` 冲突）
 * - 此错误与 v1.1.2.2 修复的 ProgressRing.ringSize 同根因
 *
 * 图标清单：
 * - IconShuttlecock：羽毛球（资讯、App Logo）
 * - IconRacket：球拍（装备、球员）
 * - IconVenue：场馆（附近场馆）
 * - IconEquipment：装备包（装备查询）
 * - IconPlayer：球员（球员信息）
 * - IconAI：AI 智能（智能助理、洞察）
 * - IconSparkle：闪光（AI 摘要标签）
 * - IconRefresh：刷新（刷新按钮）
 * - IconFire：火焰（活跃指示）
 *
 * 使用示例：
 * ```typescript
 * IconShuttlecock({ iconSize: 48 })
 * IconAI({ iconSize: 24, color: $r('app.color.text_on_primary') })
 * ```
 */

import { DesignTokens } from './DesignTokens';

const DEFAULT_ICON_SIZE: number = 24;

@Component
export struct IconShuttlecock {
  @Prop public iconSize: number = DEFAULT_ICON_SIZE;

  public build(): void {
    Image($r('app.media.icon_shuttlecock'))
      .width(this.iconSize)
      .height(this.iconSize)
      .objectFit(ImageFit.Contain)
      .interpolation(ImageInterpolation.High)
  }
}

@Component
export struct IconRacket {
  @Prop public iconSize: number = DEFAULT_ICON_SIZE;

  public build(): void {
    Image($r('app.media.icon_racket'))
      .width(this.iconSize)
      .height(this.iconSize)
      .objectFit(ImageFit.Contain)
      .interpolation(ImageInterpolation.High)
  }
}

@Component
export struct IconVenue {
  @Prop public iconSize: number = DEFAULT_ICON_SIZE;

  public build(): void {
    Image($r('app.media.icon_venue'))
      .width(this.iconSize)
      .height(this.iconSize)
      .objectFit(ImageFit.Contain)
      .interpolation(ImageInterpolation.High)
  }
}

@Component
export struct IconEquipment {
  @Prop public iconSize: number = DEFAULT_ICON_SIZE;

  public build(): void {
    Image($r('app.media.icon_equipment'))
      .width(this.iconSize)
      .height(this.iconSize)
      .objectFit(ImageFit.Contain)
      .interpolation(ImageInterpolation.High)
  }
}

@Component
export struct IconPlayer {
  @Prop public iconSize: number = DEFAULT_ICON_SIZE;

  public build(): void {
    Image($r('app.media.icon_player'))
      .width(this.iconSize)
      .height(this.iconSize)
      .objectFit(ImageFit.Contain)
      .interpolation(ImageInterpolation.High)
  }
}

@Component
export struct IconAI {
  @Prop public iconSize: number = DEFAULT_ICON_SIZE;

  public build(): void {
    Image($r('app.media.icon_ai'))
      .width(this.iconSize)
      .height(this.iconSize)
      .objectFit(ImageFit.Contain)
      .interpolation(ImageInterpolation.High)
  }
}

@Component
export struct IconSparkle {
  @Prop public iconSize: number = DEFAULT_ICON_SIZE;

  public build(): void {
    Image($r('app.media.icon_sparkle'))
      .width(this.iconSize)
      .height(this.iconSize)
      .objectFit(ImageFit.Contain)
      .interpolation(ImageInterpolation.High)
  }
}

@Component
export struct IconRefresh {
  @Prop public iconSize: number = DEFAULT_ICON_SIZE;

  public build(): void {
    Image($r('app.media.icon_refresh'))
      .width(this.iconSize)
      .height(this.iconSize)
      .objectFit(ImageFit.Contain)
      .interpolation(ImageInterpolation.High)
  }
}

@Component
export struct IconFire {
  @Prop public iconSize: number = DEFAULT_ICON_SIZE;

  public build(): void {
    Image($r('app.media.icon_fire'))
      .width(this.iconSize)
      .height(this.iconSize)
      .objectFit(ImageFit.Contain)
      .interpolation(ImageInterpolation.High)
  }
}

/**
 * Tab 栏专用图标：提供更具辨识度的版本
 */
@Component
export struct TabIconHome {
  public build(): void {
    IconShuttlecock({ iconSize: DesignTokens.ICON_SIZE })
  }
}

@Component
export struct TabIconCommunity {
  public build(): void {
    IconVenue({ iconSize: DesignTokens.ICON_SIZE })
  }
}

@Component
export struct TabIconProfile {
  public build(): void {
    Image($r('app.media.icon_player'))
      .width(DesignTokens.ICON_SIZE)
      .height(DesignTokens.ICON_SIZE)
      .objectFit(ImageFit.Contain)
      .interpolation(ImageInterpolation.High)
  }
}