//
//  DetailViewController.m
//  MVCTest
//
//  Created by zhanglei on 16/1/5.
//  Copyright © 2016年 zhanglei. All rights reserved.
//

#import "DetailViewController.h"
#import "MethodDetailViewController.h"
#import "SFTagView.h"
#import "SFTag.h"

#import "DetailCell.h"

#import "DetailInfo.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UIImageView *headerImage;
@property (nonatomic,strong) DetailInfo *detailInfo;
@property (nonatomic,assign) CGFloat foodTagViewHeight;     // 食材
@property (nonatomic,assign) CGFloat keywordTagViewHeight;  // 关键词

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self initView];
    
    [self getDetailTask];
}

- (void)initView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailCell" bundle:nil] forCellReuseIdentifier:@"DetailCell"];
    
    // header
    self.headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth/4.0*3)];
    self.tableView.tableHeaderView = self.headerImage;
}

#pragma mark - 表代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    for (UIView *v in cell.desLabel.subviews)
    {
        [v removeFromSuperview];
    }
    
    switch (indexPath.row)
    {
        case 0:
        {
            cell.nameLabel.text = @"名称";
            cell.desLabel.text = self.detailInfo.name;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
        case 1:
        {
            cell.nameLabel.text = @"描述";
            cell.desLabel.text = self.detailInfo.descriptionStr;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
        case 2:
        {
            cell.nameLabel.text = @"食材";
            cell.desLabel.text = @"";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            SFTagView *tagView = [[SFTagView alloc] initWithFrame:CGRectMake(0, 0, cell.desLabel.bounds.size.width, 0)];
            tagView.margin    = UIEdgeInsetsMake(5, 0, 5, 0);
            tagView.insets    = 5;
            tagView.lineSpace = 5;
            tagView.alignment = 1;
            [cell.desLabel addSubview:tagView];
            
            [[Tools componentsStringByString:self.detailInfo.food string:@","] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
             {
                 SFTag *tag = [SFTag tagWithText:obj];
                 tag.textColor = [UIColor whiteColor];
                 tag.bgColor = Color;
                 tag.target = self;
                 tag.cornerRadius = 2;
                 [tagView addTag:tag];
             }];
            
            self.foodTagViewHeight = tagView.bounds.size.height;
        }
            break;
        case 3:
        {
            cell.nameLabel.text = @"关键词";
            cell.desLabel.text = @"";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            SFTagView *tagView = [[SFTagView alloc] initWithFrame:CGRectMake(0, 0, cell.desLabel.bounds.size.width, 0)];
            tagView.margin    = UIEdgeInsetsMake(5, 0, 5, 0);
            tagView.insets    = 5;
            tagView.lineSpace = 5;
            tagView.alignment = 1;
            [cell.desLabel addSubview:tagView];
            
            [[Tools componentsStringByString:self.detailInfo.keywords string:@" "] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
             {
                 SFTag *tag = [SFTag tagWithText:obj];
                 tag.textColor = [UIColor whiteColor];
                 tag.bgColor = Color;
                 tag.target = self;
                 tag.cornerRadius = 2;
                 [tagView addTag:tag];
             }];
            
            self.keywordTagViewHeight = tagView.bounds.size.height;
        }
            break;
        case 4:
        {
            cell.nameLabel.text = @"做法";
            cell.desLabel.text = @"详细步骤";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 5:
        {
            cell.nameLabel.text = @"查看更多";
            cell.desLabel.text = @"相关做法";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    switch (indexPath.row)
    {
        case 0:
        {
            height = [Tools sizeWithMulString:self.detailInfo.name withFont:[UIFont systemFontOfSize:16] withSize:CGSizeMake(ScreenWidth-15-10-80, CGFLOAT_MAX)].height;
        }
            break;
        case 1:
        {
            height = [Tools sizeWithMulString:self.detailInfo.descriptionStr withFont:[UIFont systemFontOfSize:16] withSize:CGSizeMake(ScreenWidth-15-10-80, CGFLOAT_MAX)].height;
        }
            break;
        case 2:
        {
            height = self.foodTagViewHeight;
        }
            break;
        case 3:
        {
            height = self.keywordTagViewHeight;
        }
            break;
            
        default:
            break;
    }
    
    return MAX(height+10, 44);
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
    
    if (indexPath.row == 4)
    {
        MethodDetailViewController *vc = [[MethodDetailViewController alloc] init];
        vc.type = 0;
        vc.string = self.detailInfo.message;
        vc.title = self.detailInfo.name;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 5)
    {
        MethodDetailViewController *vc = [[MethodDetailViewController alloc] init];
        vc.type = 1;
        vc.string = self.detailInfo.url;
        vc.title = self.detailInfo.name;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 网络响应
- (void)getDetailTask
{
    [self showIndicatorWithTitle:LOADING_INFO];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",LOCAL_HOST_URL, GET_SHOW_URL];
    [HttpManager post:urlStr
                 pars:@{@"id":@(self.listid)}
              success:^(NSMutableDictionary *sucRetDic) {
                  [self hideIndicatorView];
                  self.detailInfo= [DetailInfo yy_modelWithJSON:sucRetDic];
                  
                  self.title = self.detailInfo.name;
                  [self.headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_URL,self.detailInfo.img]]];
                  [self.tableView reloadData];
                  
              } failure:^{
                  [self showTipView:TipTypeInfo withTitle:API_ERROR_INFO];
                  [self hideIndicatorView];
              }];
}

@end
