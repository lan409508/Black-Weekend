//
//  HotModel.m
//  Black-Weekend
//
//  Created by scjy on 16/1/10.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "HotModel.h"

@implementation HotModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.headImage = dict[@"img"];
        self.hotId = dict[@"id"];
    }
    return self;
}

@end
