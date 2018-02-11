//
//  ViewController.m
//  networkapihelper
//
//  Created by XMYY-25 on 2018/2/1.
//  Copyright © 2018年 XMYY-25. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "PMRequestManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        [self getSceneList:[NSString stringWithFormat:@"http://192.168.6.61:8083/rest/rules?tags=App"] uuid:@"" complationBlock:^(BOOL isSuccess) {
        }];
    
    //    [self test1];
//    [self test3];
    
}

- (void)test3{
    NSString *url = @"http://192.168.6.220:8080/buz/productPublish/publishProductInfo?productUUID=1516255679767&key=d41d8cd98f00b204e9800998ecf8427e";
    NSString *urlUTF8 = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    PMRequestManager *manager = [PMRequestManager sharedManager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager requestDataTaskWithServicePath:url requestMethod:PMRequestMethodGet httpHeader:nil parameters:nil acquirePolicy:PMAcquireCacheDataWithUpdate successBlock:^(NSURLSessionTask *task, id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)data;
            NSLog(@"-----------------dic:-----------------\n:%@",dic);
        }
    } failureBlock:^(NSURLSessionTask *task, NSError *error) {
        NSLog(@"======================================");
    }];
}

-(void)test2{
    NSString *url = @"http://192.168.6.220:8080/buz/productPublish/publishProductInfo?productUUID=1516255679767&key=d41d8cd98f00b204e9800998ecf8427e";
    NSString *urlUTF8 = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    PMRequestManager *manager = [PMRequestManager sharedManager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager requestDataTaskWithServicePath:urlUTF8 requestMethod:PMRequestMethodGet httpHeader:nil parameters:nil acquirePolicy:PMAcquireCacheDataWithUpdate successBlock:^(NSURLSessionTask *task, NSDictionary *dic) {
        
        NSLog(@"-----------------dic:-----------------\n:%@",dic);
    } failureBlock:^(NSURLSessionTask *task, NSError *error) {
        NSLog(@"======================================");
    }];
}

- (void)test1{
    NSString *url = @"http://192.168.6.213:80/xmyyapp/getusers";
    NSDictionary *dic = @{@"username":@"13631157951",@"password":@"oh123456",@"uuid":@""};
    PMRequestManager *commandhttpManager = [PMRequestManager sharedManager];
    NSURL *commandUrl = [[NSURL alloc] initWithString:url];
    [commandhttpManager sessiondataTaskWithServicePath:commandUrl httpBody:dic requestMethod:PMRequestMethodPost authorizationUsername:@"" uathorizationPassword:@"" completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([[dic objectForKey:@"resultcode"] isEqualToString:@"200"]) {
            NSLog(@"-----------------dic:-----------------\n:%@",dic);
        }else
            NSLog(@"======================================");
    }];
}

- (void)getSceneList:(NSString *)pageUrl uuid:(NSString *)uuid complationBlock:(void (^)(BOOL isSuccess)) complationBlock{
    if (pageUrl == nil) {
        return;
    }
    // If this is the first request to the page make a bulk call to pageNetworkStatusChanged
    // to save current reachability status.
    
    PMRequestManager *currenthttpManager = [PMRequestManager manager];
    NSMutableDictionary *headDic = [NSMutableDictionary dictionary];
    currenthttpManager.requestSerializer = [AFJSONRequestSerializer serializer];
    currenthttpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [headDic setValue:@"application/json" forKey:@"Content－Type"];
    [headDic setValue:uuid?:@"" forKey:@"uuid"];
    
    [currenthttpManager requestDataTaskWithServicePath:pageUrl requestMethod:PMRequestMethodGet httpHeader:headDic parameters:nil acquirePolicy:PMAcquireCacheDataWithUpdate successBlock:^(NSURLSessionTask *task, id data) {
        if (data && [data isKindOfClass:[NSArray class]]) {
            NSArray *dic = (NSArray *)data;
        }

    } failureBlock:^(NSURLSessionTask *task, NSError *error) {
        NSLog(@"======================================");
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
