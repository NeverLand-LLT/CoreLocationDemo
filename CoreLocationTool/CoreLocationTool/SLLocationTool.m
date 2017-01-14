//
//  SLLocationTool.m
//  CoreLoationMapViewDemo
//
//  Created by Melody on 2016/12/2.
//  Copyright © 2016年 admin. All rights reserved.
//

#define kDeviceSysVersion  [[UIDevice currentDevice].systemVersion doubleValue]

#import "SLLocationTool.h"

@interface SLLocationTool()<CLLocationManagerDelegate>

/** CLLocationManager */
@property (nonatomic,strong) CLLocationManager * locaManager;

/** Geo编码 */
@property (nonatomic,strong) CLGeocoder * geoCoder;

/** 反馈Block */
@property (nonatomic,strong) ResultBlock resultBlock ;

@end

@implementation SLLocationTool

static SLLocationTool *_instance;

+ (SLLocationTool *)sharedSLLocationTool {
    if (_instance == nil) {
        _instance = [[self alloc] init];
    }
    return _instance;
    
}
+ (id)allocWithZone:(NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}


#pragma mark - LazyLoad

- (CLLocationManager *)locaManager {
    
    if (!_locaManager) {
        _locaManager = [[CLLocationManager alloc] init];
        _locaManager.delegate = self;
        _locaManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self startUpdateLocation];
    }
    return _locaManager;
}

- (CLGeocoder *)geoCoder {
    
    if (!_geoCoder) {
        _geoCoder = [[CLGeocoder alloc] init];
    }
    return _geoCoder;
}

- (void)startUpdateLocation {
    
    //1.获取授权
    NSDictionary *infoDict =  [[NSBundle mainBundle] infoDictionary];
    NSString *WhenStr = infoDict[@"NSLocationWhenInUseUsageDescription"];
    NSString *alwaysStr= infoDict[@"NSLocationAlwaysUsageDescription"];
    //判断定位权限模式：
    //如果两个都存在，请求 权限比较高的一个(Always)，如果只有某一个，就请求对应的授权，如果两个都没有就提示开发者
    if (kDeviceSysVersion >= 8.0) {
        if (alwaysStr != nil) {
            NSLog(@"请求 Always 权限");
            [self.locaManager requestAlwaysAuthorization];    // 永久授权(前后台模式)
        }else if (WhenStr!= nil) {
            NSLog(@"请求 WhenUserIn 权限");
            [self.locaManager requestWhenInUseAuthorization]; // 使用时授权(前台模式)
        }else {
            NSLog(@"ERROR===iOS8 以后需要 主动请求授权 ！请在info.Plist 文件添加 授权名单 NSLocationAlwaysUsageDescription 或者 requestWhenInUseAuthorization");
        }
        NSArray *backModes = [infoDict valueForKey:@"UIBackgroundModes"]; // 获取后台参数数组
        if ([backModes containsObject:@"location"]) {
            self.locaManager.allowsBackgroundLocationUpdates = YES;       // 判断后台模式中是否包含位置更新服务
        }
    }
    //2.开启定位
    [self.locaManager startUpdatingLocation];
}

#pragma privaty Method

//获取当前位置
- (void)getCurrentLocation:(ResultBlock)block {
    
    self.resultBlock = block;
    
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locaManager startUpdatingLocation];    // 开始更新用户位置
    }
    else {
        self.resultBlock(nil, nil, @"定位服务未开启");
    }
    
}

- (void)stopUpdatingLocation {
    
    [self.locaManager stopUpdatingLocation];
    
}

#pragma mark - CLLocationManagerDelegate
/**
 *  获取到用户位置之后调用
 *
 *  @param manager   位置管理者
 *  @param locations 位置信息数组
 */

-(void)locationManager:(CLLocationManager *)manager
    didUpdateLocations:(NSArray *)locations
{
    
    // 获取到位置信息后,再进行地理编码
    [self.geoCoder reverseGeocodeLocation:[locations lastObject] completionHandler:^(NSArray *placemarks, NSError *error) {
        if (self.resultBlock) {
            self.resultBlock([locations lastObject], [placemarks firstObject], nil);
        }
    }];
    
}

- (void)updateUserLocation {
    [self.locaManager startUpdatingLocation];
}

/**
 *  当用户授权状态发生变化时调用
 */
-(void)locationManager:(nonnull CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            NSLog(@"用户选择中");    // 用户选择中
            break;
        }
            // 访问受限
        case kCLAuthorizationStatusRestricted: {
            NSLog(@"访问受限"); 
            self.resultBlock(nil, nil, @"访问受限");
            break;
        }
            // 定位关闭时和对此APP授权为never时调用
        case kCLAuthorizationStatusDenied:
        {
            // 定位是否可用（是否支持定位或者定位是否开启）
            if([CLLocationManager locationServicesEnabled]) {
                NSLog(@"定位开启，但被拒");
                self.resultBlock(nil, nil, @"被拒绝");
            }else {
                NSLog(@"定位关闭，不可用");
            }
            break;
        }
            // 获取前后台定位授权
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            NSLog(@"获取前后台定位授权");
            break;
        }
            // 获得前台定位授权
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            NSLog(@"获得前台定位授权");
            break;
        }
        default:
            break;
    }
    
}

@end
