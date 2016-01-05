//
//  MainTableViewCell.m
//  Black-Weekend
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "MainTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface MainTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;   //活动图片
@property (weak, nonatomic) IBOutlet UILabel *activityNameLabel;       //活动姓名
@property (weak, nonatomic) IBOutlet UILabel *activityPrice;           //活动价格
@property (weak, nonatomic) IBOutlet UIButton *activityDistanceBtn;    //活动距离

@end

@implementation MainTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

//在model的set方法中赋值
- (void)setMainModel:(MainModel *)mainModel{
    [self.activityImageView sd_setImageWithURL:[NSURL URLWithString:mainModel.iamge_big] placeholderImage:nil];
    self.activityNameLabel.text = mainModel.title;
    self.activityPrice.text = mainModel.price;
    //[self.activityDistanceBtn setTitle:<#(nullable NSString *)#> forState:<#(UIControlState)#>];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
