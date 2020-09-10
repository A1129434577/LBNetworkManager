//
//  UserModel+TempOperateInfo.m
//  TransitBox
//
//  Created by 刘彬 on 2019/3/8.
//  Copyright © 2019 BIN. All rights reserved.
//

#import "LBUserModel+TempOperateInfo.h"
#import <objc/runtime.h>
@implementation LBUserModel (TempOperateInfo)

@dynamic tempOperateInfo;
static NSString *TempOperateInfoKey = @"TempOperateInfoKey";
static NSString *NeedRefreshDataBlockKey = @"NeedRefreshDataBlockKey";

- (NSMutableDictionary *)tempOperateInfo{
    return objc_getAssociatedObject(self, &TempOperateInfoKey);
}
-(void)setTempOperateInfo:(NSMutableDictionary *)tempOperateInfo{
    objc_setAssociatedObject(self, &TempOperateInfoKey, tempOperateInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NeedRefreshDataBlock)needRefreshDataBlock{
    return objc_getAssociatedObject(self, &NeedRefreshDataBlockKey);
}
- (void)setNeedRefreshDataBlock:(NeedRefreshDataBlock)needRefreshDataBlock{
    objc_setAssociatedObject(self, &NeedRefreshDataBlockKey, needRefreshDataBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end

