//
//  MethodDetailViewController.h
//  MVCTest
//
//  Created by zhanglei on 16/1/6.
//  Copyright © 2016年 myjobsky. All rights reserved.
//

#import "BaseViewController.h"

@interface MethodDetailViewController : BaseViewController

// 0 html 1 http
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,strong) NSString *string;

@end
