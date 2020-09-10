//
//  AppDelegate+Positioning.h
//  MBP_MAPP
//
//  Created by 刘彬 on 16/5/6.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import "LBUserModel.h"
#import <MapKit/MapKit.h>

@interface LBUserModel (Location)
@property (nonatomic,strong,readonly,nullable)CLPlacemark * placemark;//用户位置
@property (nonatomic,copy,nullable)void(^getLocationInfoBlock)(CLPlacemark * _Nullable placemark,NSError * _Nullable error);
@end
