//
//  ListViewController.m
//  MVCTest
//
//  Created by 乐业天空 on 16/1/5.
//  Copyright © 2016年 myjobsky. All rights reserved.
//

#import "ListViewController.h"
#import "DetailViewController.h"

#import "ListCell.h"

#import "PageInfo.h"
#import "ListInfo.h"

@interface ListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) PageInfo *pageInfo;
@end

@implementation ListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.pageInfo = [[PageInfo alloc] init];
    self.pageInfo.PageIndex = 1;
    self.pageInfo.IsNextPage = YES;
    self.pageInfo.PageSize = 20;
    
    [self initView];
}

- (void)initView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"ListCell" bundle:nil] forCellReuseIdentifier:@"ListCell"];

    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 重置已加载全部
        [self.tableView.mj_footer resetNoMoreData];
        [self getListTask:1];
        
        NSLog(@"下拉刷新");
    }];
    
    // 上拉加载
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if (self.pageInfo.IsNextPage)
        {
            [self getListTask:self.pageInfo.PageIndex];
        }
        else
        {
            // 变为加载完毕的状态
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        NSLog(@"上拉刷新");
    }];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 表代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListInfo *info = self.dataArray[indexPath.row];
    
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell"];
    [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_URL,info.img]] placeholderImage:[UIImage imageNamed:@"active.png"]];
    cell.nameLabel.text = info.name;
    cell.desLabel.text = info.descriptionStr;
    cell.countLabel.text = @(info.count).stringValue;
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ListInfo *info = self.dataArray[indexPath.row];
    
    DetailViewController *vc = [[DetailViewController alloc] init];
    vc.listid = info.listid;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 网络响应
- (void)getListTask:(NSInteger)index
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",LOCAL_HOST_URL, GET_LIST_URL];
    [HttpManager post:urlStr
                 pars:@{@"id":@(self.menuid),
                        @"page":@((index == 0)?1:index),
                        @"rows":@(self.pageInfo.PageSize)}
              success:^(NSMutableDictionary *sucRetDic) {
                  
                  NSArray *array = [sucRetDic objectForKey:@"tngou"];
                  
                  if (index == 1 || index == 0)
                  {
                      [self.dataArray removeAllObjects];
                      for (NSDictionary *dic in array)
                      {
                          ListInfo *info = [ListInfo yy_modelWithJSON:dic];
                          [self.dataArray addObject:info];
                      }
                  }
                  else
                  {
                      for (NSDictionary *dic in array)
                      {
                          ListInfo *info = [ListInfo yy_modelWithJSON:dic];
                          [self.dataArray addObject:info];
                      }
                  }
                  
                  if (array.count == 0)
                  {
                      self.pageInfo.IsNextPage = NO;
                      // 变为加载完毕的状态
                      [self.tableView.mj_footer endRefreshingWithNoMoreData];
                  }
                  else
                  {
                      self.pageInfo.PageIndex = self.pageInfo.PageIndex + 1;
                  }
                  
                  [self.tableView reloadData];
                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                      // 结束动画
                      [self.tableView.mj_header endRefreshing];
                      [self.tableView.mj_footer endRefreshing];
                  });
              } failure:^{
                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                      // 结束动画
                      [self.tableView.mj_header endRefreshing];
                      [self.tableView.mj_footer endRefreshing];
                  });
              }];
}

@end
