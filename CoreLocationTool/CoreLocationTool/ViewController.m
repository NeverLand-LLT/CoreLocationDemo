//
//  ViewController.m
//  CoreLocationTool
//
//  Created by Melody on 2016/12/17.
//  Copyright © 2016年 Melody. All rights reserved.
//
#define kDeviceSysVersion  [[UIDevice currentDevice].systemVersion doubleValue]

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
         //定位成功
         NSLog(@"%@   ----   %@", currentLoc, placemark.name);
         NSLog(@"%f : %f",currentLoc.coordinate.latitude,currentLoc.coordinate.longitude);
         NSLog(@"%@ - %@",placemark.name,placemark.locality);    
     }else {
         //定位失败
         //情景一：一旦用户选择了“Don’t Allow”，意味着你的应用以后就无法使用定位功能，且当用户第一次选择了之后，以后就再也不会提醒进行设置。所以当第一次被拒绝事，可以通过代码跳转到设置界面。
         UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:error message:@"用户拒接定位，请在设置-私隐-中允许app授权定位" preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
             NSURL *url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
             if ([[UIApplication sharedApplication] canOpenURL:url]) { //打开设置的URL
                 if (kDeviceSysVersion < 10.0) {
                     [[UIApplication sharedApplication] openURL:url];
                 }else {
                     [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                 }
             }
         }];
         [alertVC addAction:cancelAction];
         [self.navigationController presentViewController:alertVC animated:YES completion:nil];

         
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
