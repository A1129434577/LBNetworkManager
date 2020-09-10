//
//  NetworkManager+Configer.h
//  SunsharpPay
//
//  Created by 刘彬 on 2020/9/3.
//  Copyright © 2020 刘彬. All rights reserved.
//

#import "LBNetworkManager.h"

//#define NETWORK_HOST_NAME     @"http://192.168.1.44:8081"
#define NETWORK_HOST_NAME     @"http://testpay.iyaoho.com"

NS_ASSUME_NONNULL_BEGIN

@interface LBNetworkManager (Configer)
+(void)YCPOSTWithAPI:(NSString *)api
          parameters:(NSDictionary<NSString *, id> *_Nullable)parameters
             success:(nullable void (^)(NSDictionary* _Nullable result))success
             failure:(nullable void (^)(NSError *_Nullable error))failure;

+(void)YCGETWithAPI:(NSString *)api
         parameters:(NSDictionary<NSString *, id> *_Nullable)parameters
            success:(nullable void (^)(NSDictionary* _Nullable result))success
            failure:(nullable void (^)(NSError *_Nullable error))failure;

+(void)YCUploadWithAPI:(NSString *)api
                 files:(NSArray<NSData *> *)filesData
            parameters:(NSDictionary<NSString *, id> *_Nullable)parameters
              progress:(nullable void (^)(NSProgress *uploadProgress))progress
               success:(nullable void (^)(NSDictionary* _Nullable result))success
               failure:(nullable void (^)(NSError *_Nullable error))failure;
@end

NS_ASSUME_NONNULL_END
