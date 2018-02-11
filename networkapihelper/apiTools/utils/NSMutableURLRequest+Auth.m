//
//  NSURLRequest+Auth.m
//  HelloRestKit
//
//  Created by Victor Belov on 10/01/14.
//  Copyright (c) 2014 Victor Belov. All rights reserved.
//

#import "NSMutableURLRequest+Auth.h"

@implementation NSMutableURLRequest (Auth)

- (void) setAuthCredentials:(NSString *)username andPassword:(NSString *)password
{
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", username, password];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
    [self setValue:authValue forHTTPHeaderField:@"Authorization"];
}

- (void) setUUID:(NSString *)curUUID{
    //这里要改造，如果是局域网的时候，直接发送内网的IP,这个时候就不需要发送UUID
    [self setValue:curUUID forHTTPHeaderField:@"uuid"];
}

@end
