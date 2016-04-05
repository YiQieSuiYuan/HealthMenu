//
//  HomeViewController.m
//  MVCTest
//
//  Created by zhanglei on 16/1/5.
//  Copyright © 2016年 zhanglei. All rights reserved.
//

#import "HomeViewController.h"
#import "DetailViewController.h"
#import "SettingViewController.h"

#import "ListCell.h"

#import "ListInfo.h"

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.title = @"首页";
    self.dataArray = [NSMutableArray new];
    
    [self initView];
    [self getListTask];
}

- (void)initView
{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];[self.tableView registerNib:[UINib nibWithNibName:@"ListCell" bundle:nil] forCellReuseIdentifier:@"ListCell"];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    // 设置
    UIButton *setttingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setttingBtn.frame = CGRectMake(0, 0, 44, 44);
    [setttingBtn setImage:[Tools imageWithColor:[UIColor whiteColor] image:[UIImage imageNamed:@"MoreSetting.png"]] forState:UIControlStateNormal];
    [setttingBtn addTarget:self action:@selector(settingButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithCustomView:setttingBtn];
    self.navigationItem.rightBarButtonItem = button;
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
    vc.hidesBottomBarWhenPushed = YES;
    vc.listid = info.listid;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - DZNEmpty delegete
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"点击重新加载";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    [self getListTask];
}

#pragma mark - 一般响应
- (void)settingButton:(UIButton *)sender
{
    SettingViewController *vc = [[SettingViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 网络响应
- (void)getListTask
{
    [self showIndicatorWithTitle:LOADING_INFO];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",LOCAL_HOST_URL, GET_LIST_URL];
    [HttpManager post:urlStr
                 pars:@{@"id":@(1),
                        @"page":@(1),
                        @"rows":@(20)}
              success:^(NSMutableDictionary *sucRetDic) {
                  
                  [self hideIndicatorView];
                  
                  NSArray *array = [sucRetDic objectForKey:@"tngou"];
                  for (NSDictionary *dic in array)
                  {
                      ListInfo *info = [ListInfo yy_modelWithJSON:dic];
                      [self.dataArray addObject:info];
                  }
                  
                  [self.tableView reloadData];
              } failure:^{
                  [self hideIndicatorView];
                  [self showTipView:TipTypeInfo withTitle:API_ERROR_INFO];
              }];
}

@end
