//
//  ActivityTableViewCell.m
//  
//
//  Created by scjy on 16/1/8.
//
//

#import "ActivityTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ActivityTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityDistanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *loveCountButton;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;



@end

@implementation ActivityTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.frame = CGRectMake(0, 0, kScreenWidth, 90);
}

- (void)setActivityModel:(ActivityModel *)activityModel{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:activityModel.image] placeholderImage:nil];
    self.activityTitleLabel.text = activityModel.title;
    self.activityPriceLabel.text = activityModel.price;
    self.ageLabel.text = activityModel.age;
    [self.loveCountButton setTitle:[NSString stringWithFormat:@"%@",activityModel.counts]forState:UIControlStateNormal];
    self.activityDistanceLabel.text = @"521km";

   // self.headImageView.image = activityModel.image;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
