//
//  HttpManager.m
//  MVCTest
//
//  Created by zhanglei on 15/7/3.
//  Copyright (c) 2015年 myjobsky. All rights reserved.
//

#import "HttpManager.h"

@implementation HttpManager

+(void)getInfoWithDictionary:(NSDictionary *)dic withSuccess:(SuccessDicBlack)successDicBlack withError:(ErrorStrBlack)errorStrBlack
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:@"http://ip.taobao.com/service/getIpInfo.php?ip=63.223.108.42" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation);
        NSLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation);
        NSLog(@"%@",error);
    }];
}

+(void)postInfoWithDictionary:(NSDictionary *)dic withSuccess:(SuccessDicBlack)successDicBlack withError:(ErrorStrBlack)errorStrBlack
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:@"http://www.baidu.com" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",operation);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        NSLog(@"%@",operation);
    }];
}

// 通用post请求
+ (void)post:(NSString *)URLString pars:(NSDictionary *)dic success:(SuccessDicBlack)successDicBlack failure:(ErrorBlack)errBlock
{
    NSLog(@"url:%@\n%@",URLString,dic);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"url:%@\n%@\nresponse:%@",URLString,dic,responseObject);
        
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            successDicBlack([NSMutableDictionary dictionaryWithDictionary:responseObject]);
        }
        else
        {
            errBlock();
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
        errBlock();
    }];
}

@end
