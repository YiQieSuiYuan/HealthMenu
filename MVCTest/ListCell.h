//
//  ListCell.h
//  MVCTest
//
//  Created by 乐业天空 on 16/1/6.
//  Copyright © 2016年 myjobsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end
