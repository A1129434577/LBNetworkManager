//
//  LBUserModel+SystemAuth.m
//  LBUserInfoExample
//
//  Created by 刘彬 on 2020/7/7.
//  Copyright © 2020 刘彬. All rights reserved.
//

#import "LBUserModel+SystemAuth.h"

static void (^locationComplete)(BOOL, CLAuthorizationStatus);
static CLLocationManager *locationManager;

@implementation LBUserModel (SystemAuth)
#pragma mark 相机、麦克风权限
+ (void)checkAndRequestMediaAuthTypes:(NSArray<AVMediaType> *)authTypes complete:(void(^)(NSArray<AVMediaType> *notPassedAuthTypes))complete{
    NSMutableArray<AVMediaType> *notPassedAuthTypes = [NSMutableArray array];
    [self requestMediaAuthTypes:authTypes atCheckIndex:0 allRequestComplete:^{
        [authTypes enumerateObjectsUsingBlock:^(AVMediaType  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([AVCaptureDevice authorizationStatusForMediaType:obj] != AVAuthorizationStatusAuthorized) {
                [notPassedAuthTypes addObject:obj];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            complete?
            complete(notPassedAuthTypes):NULL;
        });
    }];
}

+ (void)requestMediaAuthTypes:(NSArray<AVMediaType> *)authTypes atCheckIndex:(NSUInteger )index allRequestComplete:(void(^)(void))complete{
    __block NSUInteger theIndex = index;
    
    AVMediaType currentCheckType = authTypes[theIndex];
    __block AVAuthorizationStatus auth = [AVCaptureDevice authorizationStatusForMediaType:currentCheckType];
    
    if (auth == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:currentCheckType completionHandler:^(BOOL granted) {
            theIndex ++;
            
            if (theIndex == authTypes.count) {
                complete?
                complete():NULL;
            }else{
                [self requestMediaAuthTypes:authTypes atCheckIndex:theIndex allRequestComplete:complete];
            }
        }];
    }else{
        theIndex ++;
        if (theIndex == authTypes.count) {
            complete?
            complete():NULL;
        }else{
            [self requestMediaAuthTypes:authTypes atCheckIndex:theIndex allRequestComplete:complete];
        }
    }
}
#pragma mark 相册权限
+ (void)checkAndRequestPhotoLibraryAuthComplete:(void (^)(BOOL, PHAuthorizationStatus))complete{
    __block BOOL photoLibraryAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    
    __block PHAuthorizationStatus auth = [PHPhotoLibrary authorizationStatus];
    
    if (auth == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complete?
                complete(photoLibraryAvailable,status):NULL;
            });
        }];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            complete?
            complete(photoLibraryAvailable,auth):NULL;
        });
    }
}
#pragma mark 位置权限
+ (void)checkAndRequestLocationAlwaysAuth:(BOOL )always complete:(void (^)(BOOL, CLAuthorizationStatus))complete{
    locationComplete = complete;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = [self shareInstanse];
    
    if (always) {
        [locationManager requestAlwaysAuthorization];
    }else{
        [locationManager requestWhenInUseAuthorization];
    }
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (locationComplete) {
        dispatch_async(dispatch_get_main_queue(), ^{
            locationComplete([CLLocationManager locationServicesEnabled],status);
        });
    }
}
@end
