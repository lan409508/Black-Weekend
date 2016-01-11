//
//  DiscoveryTableViewCell.m
//  Black-Weekend
//
//  Created by scjy on 16/1/11.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "DiscoveryTableViewCell.h"

@implementation DiscoveryTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.frame = CGRectMake(0, 0, kScreenWidth, 150);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
