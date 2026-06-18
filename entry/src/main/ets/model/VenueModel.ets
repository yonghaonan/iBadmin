/**
 * 场馆数据模型
 * 用于社区附近场馆 Tab
 */

export enum VenueStatus {
  AVAILABLE = 'available',
  BUSY = 'busy',
  FULL = 'full'
}

export interface VenueItem {
  id: string;
  name: string;
  address: string;
  distanceKm: number;
  pricePerHour: number;
  status: VenueStatus;
  rating: number;
  courtCount: number;
  cover: string;
  phone: string;
}

export class VenueModel implements VenueItem {
  public id: string = '';
  public name: string = '';
  public address: string = '';
  public distanceKm: number = 0;
  public pricePerHour: number = 0;
  public status: VenueStatus = VenueStatus.AVAILABLE;
  public rating: number = 0;
  public courtCount: number = 0;
  public cover: string = '';
  public phone: string = '';

  constructor(item?: Partial<VenueItem>) {
    if (item) {
      this.id = item.id ?? '';
      this.name = item.name ?? '';
      this.address = item.address ?? '';
      this.distanceKm = item.distanceKm ?? 0;
      this.pricePerHour = item.pricePerHour ?? 0;
      this.status = item.status ?? VenueStatus.AVAILABLE;
      this.rating = item.rating ?? 0;
      this.courtCount = item.courtCount ?? 0;
      this.cover = item.cover ?? '';
      this.phone = item.phone ?? '';
    }
  }
}
