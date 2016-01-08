//
//  ActivityTableViewCell.m
//  
//
//  Created by scjy on 16/1/8.
//
//

#import "ActivityTableViewCell.h"

@interface ActivityTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityDistanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *loveCountButton;



@end

@implementation ActivityTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.frame = CGRectMake(0, 0, kScreenHeight, 90);
}

- (void)setActivityModel:(ActivityModel *)activityModel{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
