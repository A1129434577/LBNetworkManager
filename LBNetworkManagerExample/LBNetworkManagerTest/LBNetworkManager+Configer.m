//
//  NetworkManager+Configer.m
//  SunsharpPay
//
//  Created by 刘彬 on 2020/9/3.
//  Copyright © 2020 刘彬. All rights reserved.
//

#import "LBNetworkManager+Configer.h"
#import "NSObject+LBTypeSafe.h"
#import "LBUserModel.h"

#import "CommonCrypto/CommonDigest.h"

#define SigKey  @"9d59ce5f7f14a181e74575a8083717f96e963954"

@implementation LBNetworkManager (Configer)
+(void)YCPOSTWithAPI:(NSString *)api
          parameters:(NSDictionary<NSString *, id> *_Nullable)parameters
             success:(nullable void (^)(NSDictionary* _Nullable result))success
             failure:(nullable void (^)(NSError *_Nullable error))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:parameters];
    [params setValue:api forKey:NETWORK_API_KEY];
    [LBNetworkManager POSTWithParameters:parameters headers:nil success:^(id  _Nullable result) {
        [[LBNetworkManager manager] responseSuccessed:result success:success failure:failure];
    } failure:^(NSError * _Nullable error) {
        [[LBNetworkManager manager] responseFailed:error failure:failure];
    }];
}

+(void)YCGETWithAPI:(NSString *)api
         parameters:(NSDictionary<NSString *,id> *_Nullable)parameters
            success:(void (^)(NSDictionary * _Nullable))success
            failure:(void (^)(NSError * _Nullable))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:parameters];
    [params setValue:api forKey:NETWORK_API_KEY];
    [LBNetworkManager GETWithParameters:parameters headers:nil success:^(id  _Nullable result) {
        [[LBNetworkManager manager] responseSuccessed:result success:success failure:failure];
    } failure:^(NSError * _Nullable error) {
        [[LBNetworkManager manager] responseFailed:error failure:failure];
    }];
    
}

+(void)YCUploadWithAPI:(NSString *)api
                 files:(NSArray<NSData *> *)filesData
            parameters:(NSDictionary<NSString *,id> *_Nullable)parameters
              progress:(void (^)(NSProgress * _Nonnull))progress
               success:(void (^)(NSDictionary * _Nullable))success
               failure:(void (^)(NSError * _Nullable))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:parameters];
    [params setValue:api forKey:NETWORK_API_KEY];
    [LBNetworkManager uploadFiles:filesData parameters:parameters headers:nil progress:progress success:^(id  _Nullable result) {
        [[LBNetworkManager manager] responseSuccessed:result success:success failure:failure];
    } failure:^(NSError * _Nullable error) {
        [[LBNetworkManager manager] responseFailed:error failure:failure];
    }];
    
}
+(void)load{
    [LBNetworkManager manager].sessionManagerCustomConfigHandler = ^(AFHTTPSessionManager * _Nonnull sessionManager) {
        
    };
    
    [LBNetworkManager manager].POSTCustomConfigHandler = ^(NSMutableDictionary<NSString *,id> * _Nonnull parameters, NSMutableDictionary<NSString *,NSString *> * _Nonnull headers) {
        [LBNetworkManager handleHeaders:headers];
        //[NetworkManager handleParameters:parameters];
    };
    
    
    [LBNetworkManager manager].GETCustomConfigHandler = ^(NSMutableDictionary<NSString *,id> * _Nonnull parameters, NSMutableDictionary<NSString *,NSString *> * _Nonnull headers) {
        [LBNetworkManager handleHeaders:headers];
        //[NetworkManager handleParameters:parameters];
    };
    
    [LBNetworkManager manager].UPLOADCustomConfigHandler = ^(NSMutableDictionary<NSString *,id> * _Nonnull parameters, NSMutableDictionary<NSString *,NSString *> * _Nonnull headers) {
        [LBNetworkManager handleHeaders:headers];
        //[NetworkManager handleParameters:parameters];
    };
}
#pragma mark 参数预处理
+(void)handleHeaders:(NSMutableDictionary *)headers{
    //token
    NSString *token = [LBUserModel shareInstanse].userInfo[LBToken];
    if (token) {
        [headers setValue:token forKey:@"Authorization"];
    }
    //版本号，后面就要加密
    [headers setValue:@"2.0.0" forKey:@"version"];
    //设备类型
    [headers setValue:@"IOS" forKey:@"deviceType"];
    //时区
    [headers setValue:[NSTimeZone localTimeZone].name forKey:@"timeZone"];
    
    //时间
    NSTimeInterval millisecond = [[NSDate date] timeIntervalSince1970]*1000;
    [headers setValue:[NSString stringWithFormat:@"%.0f", millisecond] forKey:@"timestamp"];
}
+(void)handleParameters:(NSMutableDictionary *)parameters{
    [parameters setObject:[[LBNetworkManager manager].sessionManager.requestSerializer valueForHTTPHeaderField:@"timestamp"] forKey:@"timestamp"];
    
    NSMutableArray *keyArray = [parameters.allKeys mutableCopy];
    [keyArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];;
    }];
    
    NSMutableArray<NSString *> *keyValuesArray = [NSMutableArray array];
    [keyArray enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        [keyValuesArray addObject:[NSString stringWithFormat:@"%@=%@",key,parameters[key]]];
    }];
    
    [keyValuesArray addObject:[NSString stringWithFormat:@"%@=%@",@"key",SigKey]];
    NSString *keyValueString = [keyValuesArray componentsJoinedByString:@"&"];
    keyValueString = [[LBNetworkManager md5String:keyValueString] uppercaseString];
    
    [parameters removeAllObjects];
    [parameters setValue:keyValueString forKey:@"sign"];
}

+(NSString *)md5String:(NSString *)string{
    const char *cStr = [string UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (unsigned int) strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


#pragma mark 处理返回
-(void)responseSuccessed:(id)responseObject
                 success:(nullable void (^)(NSDictionary* _Nullable result))success
                 failure:(nullable void (^)(NSError *_Nullable error))failure{
    if ([self.sessionManager.responseSerializer isMemberOfClass:AFHTTPResponseSerializer.class]) {
        if (success) {
            success(responseObject);
        }
    }else{
        responseObject = [responseObject safeDictionary];
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 0) {
            if (success) {
                success([responseObject safeDictionary][@"data"]);
            }
        }else if (code == 4) {//强制下线
            [self loginErrorPrompt:responseObject[@"desc"]];
        }else{
            NSError *error = [NSError errorWithDomain:@"NetworkManagerError" code:code userInfo:@{NSLocalizedDescriptionKey:responseObject[@"desc"]}];
            if (failure) {
                failure(error);
            }
        }
        
    }
}
-(void)responseFailed:(NSError *)error failure:(nullable void (^)(NSError *_Nullable error))failure{
    NSDictionary *errorInfo = error.userInfo;
    if ([errorInfo.allKeys containsObject: AFNetworkingOperationFailingURLResponseDataErrorKey]){
        @try {
            NSData *errorData = errorInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSDictionary *errorDict = [NSJSONSerialization JSONObjectWithData: errorData options:NSJSONReadingAllowFragments error:nil];
            NSInteger code = [errorDict[@"code"] integerValue];
            if (code == 4) {//强制下线
                [self loginErrorPrompt:errorDict[@"desc"]];
            }else{
                if (failure) {
                    failure(error);
                }
            }
        } @catch (NSException *exception) {
        } @finally {
        }
    }else{
        if (failure) {
            failure(error);
        }
    }
}

-(void)loginErrorPrompt:(NSString *)prompt
{
    //       [AppDelegate loginOut];
    //        
    //        UIAlertController *accountAnomalyAlert = [UIAlertController alertControllerWithTitle:@"警告" message:prompt preferredStyle:UIAlertControllerStyleAlert];
    //        [accountAnomalyAlert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:NULL]];
    //        
    //        [LB_KEY_WINDOW.rootViewController presentViewController:accountAnomalyAlert animated:YES completion:nil];
}
@end
