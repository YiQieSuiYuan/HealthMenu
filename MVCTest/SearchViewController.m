//
//  SearchViewController.m
//  MVCTest
//
//  Created by 乐业天空 on 16/1/5.
//  Copyright © 2016年 myjobsky. All rights reserved.
//

#import "SearchViewController.h"
#import "DetailViewController.h"

#import "ListCell.h"

#import "ListInfo.h"

@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.title = @"搜索";
    
    self.dataArray = [[NSMutableArray alloc] init];
    [self initView];
}

- (void)initView
{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];[self.tableView registerNib:[UINib nibWithNibName:@"ListCell" bundle:nil] forCellReuseIdentifier:@"ListCell"];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;

    // 搜索栏
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.frame = CGRectMake(0, 0, 320, 44);
    searchBar.placeholder = @"请输入菜名";
    searchBar.showsCancelButton = NO;
    searchBar.delegate = self;
    
    self.navigationItem.titleView = searchBar;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar;
{
    searchBar.showsCancelButton = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    if ([Tools isEmpty:searchBar.text])
    {
        [self showTipView:TipTypeError withTitle:@"搜索词不能为空"];
        return;
    }
    
    [self getNamelTask:searchBar.text];
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
    NSString *text = @"暂无结果";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

#pragma mark - 网络响应
- (void)getNamelTask:(NSString *)keyword
{
    [self showIndicatorWithTitle:@"搜索中..."];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",LOCAL_HOST_URL, GET_NAME_URL];
    [HttpManager post:urlStr
                 pars:@{@"name":[keyword stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]}
              success:^(NSMutableDictionary *sucRetDic) {
                  [self hideIndicatorView];
                  
                  NSArray *array = [sucRetDic objectForKey:@"tngou"];
                  
                  [self.dataArray removeAllObjects];
                  [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                      ListInfo *info = [ListInfo yy_modelWithJSON:obj];
                      [self.dataArray addObject:info];
                  }];
                  
                  if (array.count == 0)
                  {
                      [self showTipView:TipTypeInfo withTitle:[NSString stringWithFormat:@"没有[%@]菜谱",keyword]];
                  }
                  
                  [self.tableView reloadData];
              } failure:^{
                  [self hideIndicatorView];
                  [self showTipView:TipTypeInfo withTitle:API_ERROR_INFO];
              }];
}

@end
