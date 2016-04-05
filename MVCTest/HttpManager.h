//
//  HttpManager.h
//  MVCTest
//
//  Created by 乐业天空 on 15/7/3.
//  Copyright (c) 2015年 myjobsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpManager : NSObject

/**
 请求成功回掉
 retDic       结果字典
 retStr       结果字符串
 */
typedef void(^SuccessBlack)(void);
typedef void(^SuccessArrBlack)(NSMutableArray *sucRetArr);
typedef void(^SuccessDicBlack)(NSMutableDictionary *sucRetDic);
typedef void(^SuccessStrBlack)(NSString *sucRetStr);

/**
 请求失败回掉
 retDic       结果字典
 retStr       结果字符串
 */
typedef void(^ErrorBlack)(void);
typedef void(^ErrorArrBlack)(NSMutableArray *errorRetArr);
typedef void(^ErrorDicBlack)(NSMutableDictionary *errRetDic);
typedef void(^ErrorStrBlack)(NSString *errRetStr);


+(void)getInfoWithDictionary:(NSDictionary *)dic withSuccess:(SuccessDicBlack)successDicBlack withError:(ErrorStrBlack)errorStrBlack;
+(void)postInfoWithDictionary:(NSDictionary *)dic withSuccess:(SuccessDicBlack)successDicBlack withError:(ErrorStrBlack)errorStrBlack;

+ (void)post:(NSString *)URLString pars:(NSDictionary *)dic success:(SuccessDicBlack)successDicBlack failure:(ErrorBlack)errBlock;

@end
