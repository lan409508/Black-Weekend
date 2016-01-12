//
//  DiscoverModel.m
//  Black-Weekend
//
//  Created by scjy on 16/1/12.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "DiscoverModel.h"

@implementation DiscoverModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.activityId = dict[@"id"];
        self.title = dict[@"title"];
        self.image = dict[@"image"];
        self.type = dict[@"type"];
    }
    return self;
}

@end
