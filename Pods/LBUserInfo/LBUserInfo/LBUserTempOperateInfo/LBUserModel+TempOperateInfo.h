//
//  UserModel+TempOperateInfo.h
//  TransitBox
//
//  Created by 刘彬 on 2019/3/8.
//  Copyright © 2019 BIN. All rights reserved.
//

#import "LBUserModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^NeedRefreshDataBlock)(id info);
@interface LBUserModel (TempOperateInfo)
//一些临时需要多级传值的时候用，该属性可随意根据当前操作流程更改其内容
@property (nonatomic,strong)NSMutableDictionary *tempOperateInfo;
@property (nonatomic,copy) NeedRefreshDataBlock needRefreshDataBlock;
@end

NS_ASSUME_NONNULL_END
