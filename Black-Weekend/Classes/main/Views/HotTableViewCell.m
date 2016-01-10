//
//  HotTableViewCell.m
//  Black-Weekend
//
//  Created by scjy on 16/1/10.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "HotTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HotTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;



@end

@implementation HotTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.frame = CGRectMake(0, 0, kScreenWidth, 150);
    
}

- (void)setHotModel:(HotModel *)hotModel{
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:hotModel.headImage] placeholderImage:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
