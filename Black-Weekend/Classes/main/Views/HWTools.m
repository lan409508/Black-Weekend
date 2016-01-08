//
//  HWTools.m
//  Black-Weekend
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "HWTools.h"

@implementation HWTools


+ (NSString *)getDateFromString:(NSString *)timestamp{
    
    NSTimeInterval timeInterval = [timestamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    NSString *timeStr = [dateFormatter stringFromDate:date];
    
    return timeStr;
}

#pragma mark ----------  根据文字最大显示宽高和文字显示内容返回文字高度
+ (CGFloat)getTextHeightWithText:(NSString *)text BigestSize:(CGSize)bigSize textFont:(CGFloat)font{

    CGRect textRect = [text boundingRectWithSize:bigSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil];
    return textRect.size.height;
}

+ (NSDate *)getSystemNowDate{
    //创建一个NSDataFormatter显示刷新时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init ];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [df stringFromDate:[NSDate date]];
    NSDate *date = [df dateFromString:dateStr];
    return date;
}
@end
