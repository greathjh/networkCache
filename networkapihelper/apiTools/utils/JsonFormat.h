//
//  JsonFormat.h
//  openHAB
//
//  Created by XMYY-25 on 2017/12/7.
//  Copyright © 2018年 openHAB e.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonFormat : NSObject

+ (NSString *)stringWithDictionary:(NSDictionary *)dict;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end
