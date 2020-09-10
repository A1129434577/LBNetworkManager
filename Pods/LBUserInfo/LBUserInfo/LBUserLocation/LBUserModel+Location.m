//
//  AppDelegate+Positioning.m
//  MBP_MAPP
//
//  Created by 刘彬 on 16/5/6.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import "LBUserModel+Location.h"
#import <objc/runtime.h>

static NSString *LB_PlacemarkKey = @"LB_PlacemarkKey";
static NSString *LB_GetLocationInfoBlockKey = @"LB_GetLocationInfoBlockKey";

static CLLocationManager *_locationManager;
@interface LBUserModel ()<CLLocationManagerDelegate>

@end

@implementation LBUserModel (Location)

-(CLPlacemark *)placemark{
    return objc_getAssociatedObject(self, &LB_PlacemarkKey);
}
-(void)setPlacemark:(CLPlacemark *)placemark{
    objc_setAssociatedObject(self, &LB_PlacemarkKey, placemark, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void (^)(CLPlacemark * _Nullable, NSError * _Nullable))getLocationInfoBlock{
    return objc_getAssociatedObject(self, &LB_GetLocationInfoBlockKey);
}

-(void)setGetLocationInfoBlock:(void (^)(CLPlacemark * _Nullable, NSError * _Nullable))getLocationInfoBlock{
    objc_setAssociatedObject(self, &LB_GetLocationInfoBlockKey, getLocationInfoBlock, OBJC_ASSOCIATION_COPY);
    
    if (_locationManager) {
        [_locationManager startUpdatingLocation];
    }else{
        _locationManager = [[CLLocationManager alloc]init];//初始化一个定位管理对象
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];//申请定位服务权限
        }
        _locationManager.delegate = self;//设置代理
        [_locationManager startUpdatingLocation];//开启定位服务
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    [manager stopUpdatingLocation];
    
    typeof(self) __weak weakSelf = self;
    CLLocation *location = [locations firstObject];
    //开始检索定位到的地址
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> *placemarks,NSError *error){
        weakSelf.placemark = placemarks.firstObject;
        weakSelf.getLocationInfoBlock?
        weakSelf.getLocationInfoBlock(weakSelf.placemark,error):NULL;
    }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    self.getLocationInfoBlock?
    self.getLocationInfoBlock(self.placemark,error):NULL;
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"系统定位服务未开启");
    }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        NSLog(@"APP定位服务未授权");
    }
}


@end
