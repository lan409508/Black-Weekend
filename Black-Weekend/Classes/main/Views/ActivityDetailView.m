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
    //上张图片的高度
    CGFloat _previousImageHeight;
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
    self.mainScrollView.contentSize = CGSizeMake(kScreenWidth, 6000);
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

- (void)drawContentWithArray:(NSArray *)contentArray{
    
   /* NSDictionary *dic = contentArray[0];
    CGFloat height = [HWTools getTextHeightWithText:dic[@"description"] BigestSize:CGSizeMake(kScreenWidth, 1000) textFont:15.0];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 500, kScreenWidth, height)];
    label.text = dic[@"description"];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:15.0];
    [self.mainScrollView addSubview:label];
    
    NSArray *urlsArray = dic[@"urls"];
    CGFloat width = [urlsArray[0][@"width"] integerValue];
    CGFloat Height = [urlsArray[0][@"height"] integerValue];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, label.bottom, kScreenWidth - 20, (kScreenWidth - 20)/width * Height)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:urlsArray[0][@"url"]] placeholderImage:nil];
    [self.mainScrollView addSubview:imageView];
    */
    for (NSDictionary *dic in contentArray) {
      
        //每一段活动信息
        CGFloat height = [HWTools getTextHeightWithText:dic[@"description"] BigestSize:CGSizeMake(kScreenWidth, 1000) textFont:15.0];
        CGFloat y;
        if (_previousImageBottom > 480) {//如果图片底部没有值（小于500）就说明是加载第一label，那么y的值不应该减去500
            y = 480 + _previousImageBottom - 480;
        } else {
            y = 480 + _previousImageBottom;
        }
        
        //如果标题存在,标题的高度应该是上次图片的底部高度
        NSString *title = dic[@"title"];
        if (title != nil) {
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, y, kScreenWidth - 20, 30)];
            titleLabel.text = title;
            [self.mainScrollView addSubview:titleLabel];
            //下边的详细信息label显示的时候，高度的坐标应该＋30，也就是标题的高度
            y += 30;
        }
//        } else {
//            
//        }
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, y, kScreenWidth - 20, height)];
        label.text = dic[@"description"];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:15.0];
        [self.mainScrollView addSubview:label];
        
        
        
        NSArray *urlArray = dic[@"urls"];
        if (urlArray == nil) { //当某一个段落中没有图片的时候，上次图片的高度用上次label的地步高度＋20
            _previousImageBottom = label.bottom + 20;
        } else {
        for (NSDictionary *urlDic in urlArray) {
            CGFloat imgHeight;
            if (urlArray.count > 1) {
                //图片不止一张的情况
                imgHeight = label.bottom + imgHeight;
            } else {
                //单张图片的情况下
                imgHeight = label.bottom;
            }
            CGFloat width = [urlDic[@"width"]integerValue];
            CGFloat height = [urlDic[@"height"]integerValue];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, label.bottom, kScreenWidth - 20, (kScreenWidth - 20)/width * height)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:urlArray[0][@"url"]] placeholderImage:nil];
            [self.mainScrollView addSubview:imageView];
            //每次都保留最新的图片底部高度
            _previousImageBottom = imageView.bottom;
            _previousImageHeight = imageView.height;
        }
            
        }
        for (NSDictionary *urlDic in urlArray) {
            CGFloat width = [urlDic[@"width"]integerValue];
            CGFloat height = [urlDic[@"height"]integerValue];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, label.bottom, kScreenWidth - 20, (kScreenWidth - 20)/width * height)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:urlArray[0][@"url"]] placeholderImage:nil];
            [self.mainScrollView addSubview:imageView];
            //每次都保留最新的图片底部高度
            _previousImageBottom = imageView.bottom;
        }
    }
}

@end
