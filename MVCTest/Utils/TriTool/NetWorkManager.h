//
//  NetWorkManager.h
//  MVCTest
//
//  Created by zhanglei on 15/6/30.
//  Copyright (c) 2015年 myjobsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface NetWorkManager : NSObject

//判断网络是否可以用
+ (BOOL)isNetworkConnectionAvailable;

@end
