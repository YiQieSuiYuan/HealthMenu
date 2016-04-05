//
//  Configuration.h
//  MVCTest
//
//  Created by zhanglei on 15/6/30.
//  Copyright (c) 2015年 zhanglei. All rights reserved.
//

#ifndef MVCTest_Configuration_h
#define MVCTest_Configuration_h

/**
 * 网络配置文件
 */

// host
static const NSString *LOCAL_HOST_URL = @"http://www.tngou.net/";
static const NSString *IMAGE_URL = @"http://tnfs.tngou.net/image";// 图片地址

// api
static const NSString *GET_CLASSIFY_URL = @"api/cook/classify";   // 菜谱分类接口
static const NSString *GET_LIST_URL = @"api/cook/list";           // 菜谱分类列表接口
static const NSString *GET_SHOW_URL = @"api/cook/show";           // 菜谱详情API接口
static const NSString *GET_NAME_URL = @"api/cook/name";           // 菜谱名称详情接口

#endif
