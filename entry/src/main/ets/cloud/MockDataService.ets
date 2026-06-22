/**
 * Mock 数据服务
 * 为 iBadmin 业务提供静态 Mock 数据（5+5+4+3），可由 CloudClient 统一调度
 *
 * 设计原则：
 * - 静态方法、单例化（无需实例化）
 * - 每个方法延迟 200-400ms 模拟网络
 * - 数据来源：内部硬编码（避免对外部资源依赖）
 */

import { NewsItem } from '../model/NewsModel';
import { VenueItem, VenueStatus } from '../model/VenueModel';
import { EquipmentItem, EquipmentCategory } from '../model/EquipmentModel';
import { PlayerItem } from '../model/PlayerModel';
import { UserInfo } from '../model/UserModel';
import {
  UserActivity,
  WeatherInfo,
  VenueAvailability
} from '../model/SportsDataModel';

const MOCK_LATENCY_MS: number = 300;

function delay<T>(value: T, ms: number = MOCK_LATENCY_MS): Promise<T> {
  return new Promise<T>((resolve: (v: T) => void) => {
    setTimeout(() => {
      resolve(value);
    }, ms);
  });
}

export class MockDataService {
  /**
   * 获取资讯列表（5 条）
   */
  public static async getNewsList(limit: number = 20): Promise<NewsItem[]> {
    const data: NewsItem[] = [
      {
        id: 'news_001',
        title: '2026 全英羽毛球公开赛中国队斩获 2 金 1 银',
        summary: '北京时间 3 月 15 日,2026 年全英羽毛球公开赛在伯明翰落幕,中国队在男单、女单两个项目上夺得金牌。',
        cover: '🥇',
        category: '赛事',
        author: '羽毛球资讯',
        publishedAt: Date.now() - 3600_000,
        viewCount: 12800,
        source: 'BWF 官方'
      },
      {
        id: 'news_002',
        title: '石宇奇排名回升至世界第二,逼近榜首',
        summary: '凭借近三站公开赛的稳定发挥,石宇奇的世界排名连升两位,仅落后于丹麦名将安东森。',
        cover: '🏸',
        category: '排名',
        author: '羽坛观察',
        publishedAt: Date.now() - 7200_000,
        viewCount: 8420,
        source: '世界羽联'
      },
      {
        id: 'news_003',
        title: '新手必读:羽毛球拍磅数怎么选?',
        summary: '从 20 磅到 30 磅,不同水平、不同打法的球友应该如何选择适合自己的拍线磅数?本文详细解读。',
        cover: '🎯',
        category: '教学',
        author: '教练老李',
        publishedAt: Date.now() - 86400_000,
        viewCount: 24500,
        source: 'iBadmin 教学'
      },
      {
        id: 'news_004',
        title: '春季羽毛球爱好者活动报名启动',
        summary: '全国 32 个城市同步开启"春日挥拍"羽毛球爱好者巡回赛,报名通道现已开启,前 1000 名享早鸟优惠。',
        cover: '🏆',
        category: '活动',
        author: '活动君',
        publishedAt: Date.now() - 172800_000,
        viewCount: 6320,
        source: 'iBadmin 活动'
      },
      {
        id: 'news_005',
        title: '李宁 2026 春季新品发布会:雷霆 90 球拍亮相',
        summary: '李宁推出全新雷霆 90 系列球拍,主打"超轻高弹"概念,首发 8 款配色,售价 1680 元起。',
        cover: '🚀',
        category: '装备',
        author: '装备评测',
        publishedAt: Date.now() - 259200_000,
        viewCount: 15780,
        source: '装备频道'
      }
    ];
    return delay(data.slice(0, limit));
  }

  /**
   * 获取附近场馆列表（5 条）
   */
  public static async getVenueList(limit: number = 20): Promise<VenueItem[]> {
    const data: VenueItem[] = [
      {
        id: 'venue_001',
        name: '星河羽毛球馆',
        address: '上海市浦东新区张江高科技园区科苑路 88 号',
        distanceKm: 1.2,
        pricePerHour: 60,
        status: VenueStatus.AVAILABLE,
        rating: 4.8,
        courtCount: 12,
        cover: '🏟️',
        phone: '021-58880001'
      },
      {
        id: 'venue_002',
        name: '飞扬羽毛球俱乐部',
        address: '上海市浦东新区花木路 2000 号',
        distanceKm: 2.5,
        pricePerHour: 80,
        status: VenueStatus.BUSY,
        rating: 4.6,
        courtCount: 8,
        cover: '🏸',
        phone: '021-58880002'
      },
      {
        id: 'venue_003',
        name: '阳光羽毛球中心',
        address: '上海市浦东新区龙阳路 200 号',
        distanceKm: 3.8,
        pricePerHour: 50,
        status: VenueStatus.AVAILABLE,
        rating: 4.5,
        courtCount: 16,
        cover: '☀️',
        phone: '021-58880003'
      },
      {
        id: 'venue_004',
        name: '极速羽毛球馆',
        address: '上海市浦东新区金桥路 199 号',
        distanceKm: 5.0,
        pricePerHour: 100,
        status: VenueStatus.FULL,
        rating: 4.9,
        courtCount: 6,
        cover: '⚡',
        phone: '021-58880004'
      },
      {
        id: 'venue_005',
        name: '社区羽毛球场',
        address: '上海市浦东新区张江路 100 号',
        distanceKm: 0.8,
        pricePerHour: 40,
        status: VenueStatus.AVAILABLE,
        rating: 4.2,
        courtCount: 4,
        cover: '🏘️',
        phone: '021-58880005'
      }
    ];
    return delay(data.slice(0, limit));
  }

  /**
   * 获取装备分类列表（4 条）
   */
  public static async getEquipmentCategoryList(): Promise<EquipmentItem[]> {
    const data: EquipmentItem[] = [
      {
        id: 'equip_001',
        category: EquipmentCategory.RACKETS,
        name: '球拍',
        description: '进攻型 / 平衡型 / 速度型',
        icon: '🏸',
        count: 128,
        brandOptions: ['李宁', '尤尼克斯', '胜利', '川崎']
      },
      {
        id: 'equip_002',
        category: EquipmentCategory.SHOES,
        name: '球鞋',
        description: '防滑 / 减震 / 透气',
        icon: '👟',
        count: 86,
        brandOptions: ['李宁', '尤尼克斯', '胜利', '美津浓']
      },
      {
        id: 'equip_003',
        category: EquipmentCategory.BAGS,
        name: '球包',
        description: '双肩 / 手提 / 多功能',
        icon: '🎒',
        count: 42,
        brandOptions: ['李宁', '尤尼克斯', '胜利']
      },
      {
        id: 'equip_004',
        category: EquipmentCategory.SHUTTLECOCKS,
        name: '羽毛球',
        description: '鹅毛 / 鸭毛 / 训练 / 比赛',
        icon: '🏸',
        count: 56,
        brandOptions: ['亚狮龙', '尤尼克斯', '胜利', '李宁']
      }
    ];
    return delay(data);
  }

  /**
   * 获取热门球员信息（3 条）
   */
  public static async getPlayerList(limit: number = 20): Promise<PlayerItem[]> {
    const data: PlayerItem[] = [
      {
        id: 'player_001',
        name: '石宇奇',
        avatar: '🏸',
        ranking: 2,
        score: 92850,
        country: '中国',
        playStyle: '拉吊突击',
        achievements: ['全英赛冠军', '世锦赛亚军', '汤姆斯杯冠军成员']
      },
      {
        id: 'player_002',
        name: '昆拉武特',
        avatar: '🎯',
        ranking: 1,
        score: 102340,
        country: '泰国',
        playStyle: '防守反击',
        achievements: ['世锦赛冠军', '全英赛冠军', '世界排名第一']
      },
      {
        id: 'player_003',
        name: '奈良冈功大',
        avatar: '⚡',
        ranking: 4,
        score: 85120,
        country: '日本',
        playStyle: '快速拉吊',
        achievements: ['全英赛冠军', '世锦赛四强', '日本国家队主力']
      }
    ];
    return delay(data.slice(0, limit));
  }

  /**
   * Mock 登录：返回一个虚拟华为账号用户
   */
  public static async mockHuaweiLogin(): Promise<UserInfo> {
    const user: UserInfo = {
      id: 'mock_user_001',
      nickname: '羽毛球爱好者',
      avatar: '🏸',
      phone: '',
      email: '',
      unionId: 'mock_union_' + Date.now().toString(),
      openId: 'mock_open_' + Date.now().toString(),
      loginAt: Date.now()
    };
    return delay(user, 500);
  }

  /**
   * v1.1.3 新增：用户运动活动数据
   */
  public static async getUserActivity(): Promise<UserActivity> {
    const data: UserActivity = {
      weeklyMatchCount: 3,
      singlesWinRate: 0.65,
      doublesWinRate: 0.52,
      lastMatchAt: Date.now() - 86400_000 * 2,
      preferredStyle: 'attacking',
      todayReadNews: 3,
      todayTargetNews: 5
    };
    return delay(data);
  }

  /**
   * v1.1.3 新增：天气信息
   */
  public static async getWeather(): Promise<WeatherInfo> {
    const data: WeatherInfo = {
      isSuitable: true,
      condition: 'sunny',
      conditionText: '晴',
      temperatureC: 22,
      humidity: 55
    };
    return delay(data);
  }

  /**
   * v1.1.3 新增：场馆空闲率
   */
  public static async getVenueAvailability(): Promise<VenueAvailability> {
    const data: VenueAvailability = {
      morningFreeRate: 0.45,
      afternoonFreeRate: 0.30,
      eveningFreeRate: 0.60
    };
    return delay(data);
  }
}
