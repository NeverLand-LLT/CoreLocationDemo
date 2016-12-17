//
//  ViewController.m
//  CoreLocationTool
//
//  Created by Melody on 2016/12/17.
//  Copyright © 2016年 Melody. All rights reserved.
//

#import "ViewController.h"
#import "SLLocationTool.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
 [[SLLocationTool sharedSLLocationTool] getCurrentLocation:^(CLLocation *currentLoc, CLPlacemark *placemark, NSString *error) {
    
     if ([error length] == 0) {
         NSLog(@"%@   ----   %@", currentLoc, placemark.name);
         NSLog(@"%f : %f",currentLoc.coordinate.latitude,currentLoc.coordinate.longitude);
         NSLog(@"%@ - %@",placemark.name,placemark.locality);
     }
 }];
 
}

//点击空白停止位置
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[SLLocationTool sharedSLLocationTool] stopUpdatingLocation];
    NSLog(@"停止定位");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
