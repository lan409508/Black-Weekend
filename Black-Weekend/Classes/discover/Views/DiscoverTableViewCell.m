//
//  DiscoverTableViewCell.m
//  Black-Weekend
//
//  Created by scjy on 16/1/12.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "DiscoverTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface DiscoverTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *activityImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;



@end

@implementation DiscoverTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setDiscoverModel:(DiscoverModel *)discoverModel{
    [self.activityImage sd_setImageWithURL:[NSURL URLWithString:discoverModel.image] placeholderImage:nil];
    self.activityImage.clipsToBounds = YES;
    self.activityImage.layer.cornerRadius = 45;
    self.titleLabel.text = discoverModel.title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
