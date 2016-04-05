//
//  MenuViewController.m
//  MVCTest
//
//  Created by zhanglei on 16/1/5.
//  Copyright © 2016年 myjobsky. All rights reserved.
//

#import "MenuViewController.h"
#import "ListViewController.h"
#import "MenuInfo.h"
#import "MenuCell.h"

@interface MenuViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.title = @"分类";
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    [self initView];
    
    [self getMenuTask];
}

- (void)initView
{
    [self.collectionView registerNib:[UINib nibWithNibName:@"MenuCell" bundle:nil] forCellWithReuseIdentifier:@"MenuCell"];
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
}

# pragma mark - UICollectionViewDataSource
//设置分区
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个分区上的元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
//设置元素内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MenuInfo *info = self.dataArray[indexPath.row];
  
    MenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MenuCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.clipsToBounds = YES;
    cell.layer.cornerRadius = 3;
    cell.nameLabel.text = info.name;
    
    NSArray *colorPool = @[@(0x7ecef4), @(0x84ccc9), @(0x88abda),@(0x7dc1dd),@(0xb6b8de)];
    cell.contentView.backgroundColor = RGBHEX([colorPool[arc4random() % colorPool.count] integerValue]);
    
    return cell;
}

//点击元素触发事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MenuInfo *info = self.dataArray[indexPath.row];
    
    ListViewController *vc = [[ListViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.title = info.name;
    vc.menuid = info.menuid;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --UICollectionViewDelegateFlowLayout
//设置每块大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //可以通过UICollectionViewFlowLayout属性设置itemSize
    return CGSizeMake((ScreenWidth-20)/3.0, (ScreenWidth-20)/3.0);
}

//设置边界间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //可以通过UICollectionViewFlowLayout属性设置sectionInset
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

//设置表头大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
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
    [self getMenuTask];
}

#pragma mark - 网络响应
- (void)getMenuTask
{
    [self showIndicatorWithTitle:LOADING_INFO];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",LOCAL_HOST_URL, GET_CLASSIFY_URL];
    [HttpManager post:urlStr
                 pars:@{@"id":@(0)}
              success:^(NSMutableDictionary *sucRetDic) {
        
                  [self hideIndicatorView];
                  NSArray *array = [sucRetDic objectForKey:@"tngou"];
                  
                  [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                      MenuInfo *info = [MenuInfo yy_modelWithJSON:obj];
                      [self.dataArray addObject:info];
                  }];
                  [self.collectionView reloadData];
    } failure:^{
        [self hideIndicatorView];
        [self showTipView:TipTypeInfo withTitle:API_ERROR_INFO];
    }];
}

@end
