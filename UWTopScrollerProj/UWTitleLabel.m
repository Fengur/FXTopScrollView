//
//  UWTitleLabel.m
//  UWTopScrollerProj
//
//  Created by 王智超 on 15/11/23.
//  Copyright © 2015年 com.FengurDev. All rights reserved.
//

#import "UWTitleLabel.h"

@implementation UWTitleLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:18];

        self.scale = 0.0;
    }
    return self;
}

/** 通过scale的改变改变多种参数 */
- (void)setScale:(CGFloat)scale {
    _scale = scale;

    self.textColor = [UIColor colorWithRed:scale green:0.0 blue:0.0 alpha:1];

    CGFloat minScale = 0.7;
    CGFloat trueScale = minScale + (1 - minScale) * scale;
    self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
}

@end
