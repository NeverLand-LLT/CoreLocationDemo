//
//  SLLocationTool.h
//  CoreLoationMapViewDemo
//
//  Created by Melody on 2016/12/2.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "Singleton.h"

typedef void(^ResultBlock) (CLLocation *currentLoc,CLPlacemark *placemark,NSString *error);

@interface SLLocationTool : NSObject

single_interface(SLLocationTool);

/**
 获取当前位置

 @param block 获取当前位置后处理的block
 */
- (void)getCurrentLocation:(ResultBlock)block;


/**
 更新用户定位（starUpdatingLocation 只有用户在规定距离位置的改变才会更新定位信息）
 */
- (void)updateUserLocation;

/**
 停止定位
 */
- (void)stopUpdatingLocation;

@end
