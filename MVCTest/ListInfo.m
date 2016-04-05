//
//  ListInfo.m
//  MVCTest
//
//  Created by zhanglei on 16/1/5.
//  Copyright © 2016年 zhanglei. All rights reserved.
//

#import "ListInfo.h"

@implementation ListInfo

// 返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"listid" : @"id",
             @"descriptionStr" : @"description"};
}


@end
