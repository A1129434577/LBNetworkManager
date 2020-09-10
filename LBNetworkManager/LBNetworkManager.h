//
//  NetworkManager.h
//
//  Created by 刘彬 on 16/4/18.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN


extern NSString *const NETWORK_API_KEY;
extern NSString *const NETWORK_URL_KEY;

extern NSString *const NetworkResponseSuccessedNotificationName;
extern NSString *const NetworkResponseFailedNotificationName;
extern NSString *const NetworkUploadFileNameKey;

@interface LBNetworkManager : NSObject
@property (nonatomic, strong) NSString *baseUrlString;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@property (nonatomic, copy  ) void(^sessionManagerCustomConfigHandler)(AFHTTPSessionManager *sessionManager);

@property (nonatomic, copy  ) void(^postCustomConfigHandler)(NSMutableDictionary<NSString *,id> *parameters, NSMutableDictionary <NSString *, NSString *> *headers);
@property (nonatomic, copy  ) void(^getCustomConfigHandler)(NSMutableDictionary<NSString *,id> *parameters, NSMutableDictionary <NSString *, NSString *> *headers);
@property (nonatomic, copy  ) void(^uploadCustomConfigHandler)(NSMutableDictionary<NSString *,id> *parameters, NSMutableDictionary <NSString *, NSString *> *headers);
@property (nonatomic, copy  ) void(^putCustomConfigHandler)(NSMutableDictionary<NSString *,id> *parameters, NSMutableDictionary <NSString *, NSString *> *headers);
@property (nonatomic, copy  ) void(^patchCustomConfigHandler)(NSMutableDictionary<NSString *,id> *parameters, NSMutableDictionary <NSString *, NSString *> *headers);
@property (nonatomic, copy  ) void(^deleteCustomConfigHandler)(NSMutableDictionary<NSString *,id> *parameters, NSMutableDictionary <NSString *, NSString *> *headers);

+(LBNetworkManager *)manager;

+(void)POSTWithParameters:(NSDictionary<NSString *, id> *)parameters
                  headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                  success:(nullable void (^)(id _Nullable result))success
                  failure:(nullable void (^)(NSError *_Nullable error))failure;

+(void)GETWithParameters:(NSDictionary<NSString *, id> *)parameters
                 headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                 success:(nullable void (^)(id _Nullable result))success
                 failure:(nullable void (^)(NSError *_Nullable error))failure;

+(void)uploadFiles:(NSArray<NSData *> *)filesData
        parameters:(NSDictionary<NSString *, id> *)parameters
           headers:(nullable NSDictionary <NSString *, NSString *> *)headers
          progress:(nullable void (^)(NSProgress *uploadProgress))progress
           success:(nullable void (^)(id _Nullable result))success
           failure:(nullable void (^)(NSError *_Nullable error))failure;

+(void)PUTWithParameters:(NSDictionary<NSString *, id> *)parameters
                 headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                 success:(nullable void (^)(id _Nullable result))success
                 failure:(nullable void (^)(NSError *_Nullable error))failure;

+(void)PATCHWithParameters:(NSDictionary<NSString *, id> *)parameters
                   headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                   success:(nullable void (^)(id _Nullable result))success
                   failure:(nullable void (^)(NSError *_Nullable error))failure;

+(void)DELETEWithParameters:(NSDictionary<NSString *, id> *)parameters
                    headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                    success:(nullable void (^)(id _Nullable result))success
                    failure:(nullable void (^)(NSError *_Nullable error))failure;
@end
NS_ASSUME_NONNULL_END
