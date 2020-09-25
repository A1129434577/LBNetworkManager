//
//  NetworkManager.m
//
//  Created by 刘彬 on 16/4/18.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import "LBNetworkManager.h"

NSString *const NETWORK_API_KEY = @"NETWORK_API_KEY";
NSString *const NETWORK_URL_KEY = @"NETWORK_URL_KEY";

NSString *const NetworkResponseSuccessedNotificationName = @"NetworkResponseSuccessedNotificationName";
NSString *const NetworkResponseFailedNotificationName = @"NetworkResponseFailedNotificationName";
NSString *const NetworkUploadFileNameKey = @"NetworkUploadFileNameKey";

@implementation LBNetworkManager
+ (LBNetworkManager *)manager{
    static LBNetworkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LBNetworkManager alloc] init];
        manager.sessionManager = [AFHTTPSessionManager manager];
        manager.sessionManager.requestSerializer.timeoutInterval = 20;
        manager.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/javascript",@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    });
    if (manager.sessionManagerCustomConfigHandler) {
        manager.sessionManagerCustomConfigHandler(manager.sessionManager);
    }
    return manager;
}

+(void)POSTWithParameters:(NSDictionary<NSString *,id> *)parameters
                  headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                  success:(void (^)(id _Nullable))success
                  failure:(nullable void (^)(NSError * _Nullable))failure{
    //url处理
    NSString *postUrl = parameters[NETWORK_URL_KEY];
    if (postUrl == nil) {
        postUrl = [[LBNetworkManager manager].baseUrlString stringByAppendingPathComponent:parameters[NETWORK_API_KEY]];
    }
    
    //参数处理
    NSMutableDictionary *newParams = [NSMutableDictionary dictionary];
    [newParams addEntriesFromDictionary:parameters];
    [newParams removeObjectForKey:NETWORK_API_KEY];
    [newParams removeObjectForKey:NETWORK_URL_KEY];
    
    NSMutableDictionary *newHeaders = [NSMutableDictionary dictionary];
    [newHeaders addEntriesFromDictionary:headers];
    
    if ([LBNetworkManager manager].POSTCustomConfigHandler) {
        [LBNetworkManager manager].POSTCustomConfigHandler(newParams,newHeaders);
    }
    
    [[LBNetworkManager manager].sessionManager POST:postUrl parameters:newParams headers:newHeaders progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success?success(responseObject):NULL;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NetworkResponseSuccessedNotificationName object:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure?failure(error):NULL;
        [[NSNotificationCenter defaultCenter] postNotificationName:NetworkResponseFailedNotificationName object:error];
    }];
}

+(void)GETWithParameters:(NSDictionary<NSString *,id> *)parameters
                 headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                 success:(void (^)(id _Nullable))success
                 failure:(void (^)(NSError * _Nullable))failure{
    //url处理
    NSString *getUrl = parameters[NETWORK_URL_KEY];
    if (getUrl == nil) {
        getUrl = [[LBNetworkManager manager].baseUrlString stringByAppendingPathComponent:parameters[NETWORK_API_KEY]];
    }
    
    //参数处理
    NSMutableDictionary *newParams = [NSMutableDictionary dictionary];
    [newParams addEntriesFromDictionary:parameters];
    [newParams removeObjectForKey:NETWORK_API_KEY];
    [newParams removeObjectForKey:NETWORK_URL_KEY];
    
    NSMutableDictionary *newHeaders = [NSMutableDictionary dictionary];
    [newHeaders addEntriesFromDictionary:headers];
    
    if ([LBNetworkManager manager].GETCustomConfigHandler) {
        [LBNetworkManager manager].GETCustomConfigHandler(newParams,newHeaders);
    }
    [[LBNetworkManager manager].sessionManager GET:getUrl parameters:newParams headers:newHeaders progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success?success(responseObject):NULL;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NetworkResponseSuccessedNotificationName object:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure?failure(error):NULL;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NetworkResponseFailedNotificationName object:error];
    }];
}


+(void)uploadFiles:(NSArray<NSData *> *)filesData
        parameters:(NSDictionary<NSString *,id> *)parameters
           headers:(nullable NSDictionary <NSString *, NSString *> *)headers
          progress:(void (^)(NSProgress * _Nonnull))progress
           success:(void (^)(id _Nullable))success failure:(void (^)(NSError * _Nullable))failure{
    //url处理
    NSString *uploadUrl = parameters[NETWORK_URL_KEY];
    if (uploadUrl == nil) {
        uploadUrl = [[LBNetworkManager manager].baseUrlString stringByAppendingPathComponent:parameters[NETWORK_API_KEY]];
    }
    
    //参数处理
    NSMutableDictionary *newParams = [NSMutableDictionary dictionary];
    [newParams addEntriesFromDictionary:parameters];
    [newParams removeObjectForKey:NETWORK_API_KEY];
    [newParams removeObjectForKey:NETWORK_URL_KEY];
    
    NSMutableDictionary *newHeaders = [NSMutableDictionary dictionary];
    [newHeaders addEntriesFromDictionary:headers];
    
    if ([LBNetworkManager manager].UPLOADCustomConfigHandler) {
        [LBNetworkManager manager].UPLOADCustomConfigHandler(newParams,newHeaders);
    }
    
    [[LBNetworkManager manager].sessionManager POST:uploadUrl parameters:newParams headers:newHeaders constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [filesData enumerateObjectsUsingBlock:^(NSData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [formData appendPartWithFileData:obj name:parameters[NetworkUploadFileNameKey] fileName:@"file.jpg" mimeType:@"image/jpeg"];
        }];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress?progress(uploadProgress):NULL;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success?success(responseObject):NULL;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NetworkResponseSuccessedNotificationName object:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure?failure(error):NULL;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NetworkResponseFailedNotificationName object:error];
    }];
}


+(void)PUTWithParameters:(NSDictionary<NSString *,id> *)parameters
                 headers:(NSDictionary<NSString *,NSString *> *)headers
                 success:(nullable void (^)(id _Nullable))success
                 failure:(nullable void (^)(NSError * _Nullable))failure{
    //url处理
    NSString *putUrl = parameters[NETWORK_URL_KEY];
    if (putUrl == nil) {
        putUrl = [[LBNetworkManager manager].baseUrlString stringByAppendingPathComponent:parameters[NETWORK_API_KEY]];
    }
    
    //参数处理
    NSMutableDictionary *newParams = [NSMutableDictionary dictionary];
    [newParams addEntriesFromDictionary:parameters];
    [newParams removeObjectForKey:NETWORK_API_KEY];
    [newParams removeObjectForKey:NETWORK_URL_KEY];
    
    NSMutableDictionary *newHeaders = [NSMutableDictionary dictionary];
    [newHeaders addEntriesFromDictionary:headers];
    
    if ([LBNetworkManager manager].PUTCustomConfigHandler) {
        [LBNetworkManager manager].PUTCustomConfigHandler(newParams,newHeaders);
    }
    
    [[LBNetworkManager manager].sessionManager PUT:putUrl parameters:newParams headers:newHeaders success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success?success(responseObject):NULL;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NetworkResponseSuccessedNotificationName object:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure?failure(error):NULL;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NetworkResponseFailedNotificationName object:error];
    }];
}

+(void)PATCHWithParameters:(NSDictionary<NSString *, id> *)parameters
                   headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                   success:(nullable void (^)(id _Nullable result))success
                   failure:(nullable void (^)(NSError *_Nullable error))failure{
    //url处理
    NSString *patchUrl = parameters[NETWORK_URL_KEY];
    if (patchUrl == nil) {
        patchUrl = [[LBNetworkManager manager].baseUrlString stringByAppendingPathComponent:parameters[NETWORK_API_KEY]];
    }
    
    //参数处理
    NSMutableDictionary *newParams = [NSMutableDictionary dictionary];
    [newParams addEntriesFromDictionary:parameters];
    [newParams removeObjectForKey:NETWORK_API_KEY];
    [newParams removeObjectForKey:NETWORK_URL_KEY];
    
    NSMutableDictionary *newHeaders = [NSMutableDictionary dictionary];
    [newHeaders addEntriesFromDictionary:headers];
    
    if ([LBNetworkManager manager].PATCHCustomConfigHandler) {
        [LBNetworkManager manager].PATCHCustomConfigHandler(newParams,newHeaders);
    }
    
    [[LBNetworkManager manager].sessionManager PATCH:patchUrl parameters:newParams headers:newHeaders success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success?success(responseObject):NULL;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NetworkResponseSuccessedNotificationName object:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure?failure(error):NULL;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NetworkResponseFailedNotificationName object:error];
    }];
}

+(void)DELETEWithParameters:(NSDictionary<NSString *, id> *)parameters
                    headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                    success:(nullable void (^)(id _Nullable result))success
                    failure:(nullable void (^)(NSError *_Nullable error))failure{
    //url处理
    NSString *deleteUrl = parameters[NETWORK_URL_KEY];
    if (deleteUrl == nil) {
        deleteUrl = [[LBNetworkManager manager].baseUrlString stringByAppendingPathComponent:parameters[NETWORK_API_KEY]];
    }
    
    //参数处理
    NSMutableDictionary *newParams = [NSMutableDictionary dictionary];
    [newParams addEntriesFromDictionary:parameters];
    [newParams removeObjectForKey:NETWORK_API_KEY];
    [newParams removeObjectForKey:NETWORK_URL_KEY];
    
    NSMutableDictionary *newHeaders = [NSMutableDictionary dictionary];
    [newHeaders addEntriesFromDictionary:headers];
    
    if ([LBNetworkManager manager].DELETECustomConfigHandler) {
        [LBNetworkManager manager].DELETECustomConfigHandler(newParams,newHeaders);
    }
    
    [[LBNetworkManager manager].sessionManager DELETE:deleteUrl parameters:newParams headers:newHeaders success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success?success(responseObject):NULL;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NetworkResponseSuccessedNotificationName object:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure?failure(error):NULL;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NetworkResponseFailedNotificationName object:error];
    }];
}

#pragma mark getter
-(NSString *)baseUrlString{
    if (_baseUrlString.length == 0) {
        _baseUrlString = @"";
    }
    return _baseUrlString;
}
@end
