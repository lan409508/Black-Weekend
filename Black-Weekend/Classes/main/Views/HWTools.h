//
//  HWTools.h
//  Black-Weekend
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWTools : NSObject

#pragma mark ----------  时间转换相关的方法
+ (NSString *)getDateFromString:(NSString *)timestamp;

#pragma mark ----------  根据文字最大显示宽高和文字显示内容返回文字高度
+ (CGFloat)getTextHeightWithText:(NSString *)text BigestSize:(CGSize)bigSize textFont:(CGFloat)font;

@end
