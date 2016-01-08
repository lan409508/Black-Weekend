//
//  ActivityTableViewCell.h
//  
//
//  Created by scjy on 16/1/8.
//
//

#import <UIKit/UIKit.h>
#import "ActivityModel.h"
@interface ActivityTableViewCell : UITableViewCell

@property(nonatomic, strong) ActivityModel *activityModel;
@property(nonatomic, strong) NSDictionary *dataDic;

@end
