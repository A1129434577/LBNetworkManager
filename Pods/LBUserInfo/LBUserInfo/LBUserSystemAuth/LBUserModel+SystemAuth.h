//
//  LBUserModel+SystemAuth.h
//  LBUserInfoExample
//
//  Created by 刘彬 on 2020/7/7.
//  Copyright © 2020 刘彬. All rights reserved.
//

#import "LBUserModel.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LBUserModel (SystemAuth)<CLLocationManagerDelegate>

/// 相机、麦克风权限
/// @param authTypes 相机、麦克风
/// @param complete 完成
+ (void)checkAndRequestMediaAuthTypes:(NSArray<AVMediaType> *)authTypes complete:(void(^)(NSArray<AVMediaType> *notPassedAuthTypes))complete;

/// 相册权限
/// @param complete 完成
+ (void)checkAndRequestPhotoLibraryAuthComplete:(void(^)(BOOL photoLibraryAvailable, PHAuthorizationStatus authorizationStatus))complete;

/// 定位权限
/// @param complete 完成
+ (void)checkAndRequestLocationAlwaysAuth:(BOOL )always complete:(void(^)(BOOL locationServicesEnabled, CLAuthorizationStatus authorizationStatus))complete;
@end

NS_ASSUME_NONNULL_END
