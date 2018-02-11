//
//  PMAPIManager.h
//  MJ001
//
//  Created by MJ001 on 2017/8/4.
//  Copyright © 2018年 立通无限. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMRequestManager.h"

@interface PMAPIManager : NSObject

/**
 传入字典与模型，匹配字典中的数据

 @param dictionary 字典
 @param model 模型
 @return 模型
 */
+ (id)modelWithDictionary:(NSDictionary *)dictionary forModel:(id)model;

@end
