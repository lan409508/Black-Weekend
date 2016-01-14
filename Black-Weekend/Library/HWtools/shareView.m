//
//  ShareView.m
//  Black-Weekend
//
//  Created by scjy on 16/1/14.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "ShareView.h"
#import "WeiboSDK.h"

@interface ShareView ()

@property (nonatomic, strong) UIView *shareView;
@property (nonatomic, strong) UIView *grayView;

@end
@implementation ShareView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self config];
    }
    return self;
}

- (void)config {
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
