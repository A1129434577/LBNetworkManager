//
//  LoginInfo.h
//  MBP_MAPP
//
//  Created by 刘彬 on 16/4/19.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString *const LBToken;//登录token
extern NSString *const LBAccount;

@interface LBUserModel : NSObject
//用户登录信息
@property(nonatomic,readonly,strong)NSDictionary *userInfo;

- (void)setLBUserInfoObject:(id)anObject forKey:(id)aKey;
- (void)addEntriesForLBUserInfoFromDictionary:(NSDictionary *)otherDictionary;
- (void)removeLBUserInfoAllObjects;
- (void)removeLBUserInfoObjectForKey:(id)aKey;
- (void)removeLBUserInfoObjectsForKeys:(NSArray*)keyArray;

+(LBUserModel *)shareInstanse;
- (void)removeUserInfo;
@end
