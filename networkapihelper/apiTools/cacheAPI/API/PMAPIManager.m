//
//  PMAPIManager.m
//  MJ001
//
//  Created by MJ001 on 2017/8/4.
//  Copyright © 2018年 立通无限. All rights reserved.
//

#import "PMAPIManager.h"
#import "NSObject+YYModel.h"

@implementation PMAPIManager

+ (id)modelWithDictionary:(NSDictionary *)dictionary forModel:(id)model {
    return [[model class] yy_modelWithDictionary:dictionary];
}

@end
