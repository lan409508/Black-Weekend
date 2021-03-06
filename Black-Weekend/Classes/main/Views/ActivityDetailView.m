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

{
    //保存上一次图片底部的高度
    CGFloat _previousImageBottom;
    //最后一个label底部高度
    CGFloat _lastLabelBottom;
}

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
    self.mainScrollView.contentSize = CGSizeMake(kScreenWidth, 5000);
}
//在set方法中赋值
- (void)setDataDic:(NSDictionary *)dataDic{
    NSArray *urls = dataDic[@"urls"];
    NSString *Astr = urls[0];
    //活动图片
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:Astr] placeholderImage:nil];
    //活动标题
    self.activityTitleLabel.text = dataDic[@"title"];
    //活动起止时间
    NSString *startTime = [HWTools getDateFromString: dataDic[@"new_start_date"] ];
    NSString *endTime = [HWTools getDateFromString: dataDic[@"new_end_date"] ];
    self.activityTimeLabel.text = [NSString stringWithFormat:@" 正在进行: %@-%@",startTime,endTime];
    //已经有多少人喜欢
    self.favoriteLabel.text = [NSString stringWithFormat:@"%@人已收藏",dataDic[@"fav"]];
    //参考价格
    self.activityPriceLabel.text = [NSString stringWithFormat:@"价格参考:   %@",dataDic[@"pricedesc"]];
    //活动地址
    self.activityAddressLabel.text = dataDic[@"address"];
    //活动电话
    self.activityPhoneLabel.text = dataDic[@"tel"];
    //活动详情
    [self drawContentWithArray:dataDic[@"content"]];
}

- (void)drawContentWithArray:(NSArray *)contentArray {
    for (NSDictionary *dic in contentArray) {
        //每一段活动信息
        CGFloat height = [HWTools getTextHeightWithText:dic[@"description"] BigestSize:CGSizeMake(kScreenWidth, 1000) textFont:15.0];
        CGFloat y;
        if (_previousImageBottom > 450) { //如果图片底部的高度没有值（也就是小于450）,也就说明是加载第一个lable，那么y的值不应该减去450
            y = 450 + _previousImageBottom - 450;
        } else {
            y = 450 + _previousImageBottom;
        }
        NSString *title = dic[@"title"];
        if (title != nil) {
            //如果标题存在,标题的高度应该是上次图片的底部高度
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, y - 5, kScreenWidth - 20, 30)];
            titleLabel.text = title;
            [self.mainScrollView addSubview:titleLabel];
            //下边详细信息label显示的时候，高度的坐标应该再加30，也就是标题的高度。
            y += 30;
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, y - 5, kScreenWidth - 10, height)];
        label.text = dic[@"description"];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:15.0];
        [self.mainScrollView addSubview:label];
        //保留最后一个label的高度，+ 30是下边tabbar的高度
        _lastLabelBottom = label.bottom + 10 + 30;
        
        NSArray *urlsArray = dic[@"urls"];
        if (urlsArray == nil) { //当某一个段落中没有图片的时候，上次图片的高度用上次label的底部高度+10
            _previousImageBottom = label.bottom + 10;
        } else {
            CGFloat lastImgbottom = 0.0;
            for (NSDictionary *urlDic in urlsArray) {
                CGFloat imgY;
                if (urlsArray.count > 1) {
                    //图片不止一张的情况
                    if (lastImgbottom == 0.0) {
                        if (title != nil) { //有title的算上title的30像素
                            imgY = _previousImageBottom + label.height + 5;
                        } else {
                            imgY = _previousImageBottom + label.height + 5;
                        }
                    } else {
                        imgY = lastImgbottom + 10;
                    }
                    
                } else {
                    //单张图片的情况
                    imgY = label.bottom;
                }
                CGFloat width = [urlDic[@"width"] integerValue];
                CGFloat imageHeight = [urlDic[@"height"] integerValue];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, imgY, kScreenWidth - 20, (kScreenWidth - 20)/width * imageHeight)];
                imageView.backgroundColor = [UIColor redColor];
                [imageView sd_setImageWithURL:[NSURL URLWithString:urlDic[@"url"]] placeholderImage:nil];
                [self.mainScrollView addSubview:imageView];
                //每次都保留最新的图片底部高度
                _previousImageBottom = imageView.bottom + 10;
                if (urlsArray.count > 1) {
                    lastImgbottom = imageView.bottom;
                }
            }
        }
        //保留最后一个label的高度，+ 30是下边tabbar的高度
        _lastLabelBottom = label.bottom > _previousImageBottom ? label.bottom + 70 : _previousImageBottom + 70;
    }
    self.mainScrollView.contentSize = CGSizeMake(kScreenWidth,_lastLabelBottom);

}

@end
