//
//  ActivityDetailView.m
//  Black-Weekend
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "ActivityDetailView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ActivityDetailView ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityPriceLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UILabel *activityAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityPhoneLabel;



@end

@implementation ActivityDetailView

- (void)awakeFromNib{
    self.mainScrollView.contentSize = CGSizeMake(kScreenWidth, 1000);
}
//在set方法中赋值
- (void)setDataDic:(NSDictionary *)dataDic{
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"image"]] placeholderImage:nil];
    self.activityTitleLabel.text = dataDic[@"title"];
    self.favoriteLabel.text = [NSString stringWithFormat:@"%@人已收藏",dataDic[@"fav"]];
    self.activityPriceLabel.text = [NSString stringWithFormat:@"参考价格:%@",dataDic[@"pricedesc"]];
    self.activityAddressLabel.text = dataDic[@"address"];
    self.activityPhoneLabel.text = dataDic[@"tel"];
}

@end
