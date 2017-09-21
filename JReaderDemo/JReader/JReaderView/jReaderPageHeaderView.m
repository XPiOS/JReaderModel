//
//  jReaderPageHeaderView.m
//  JReaderDemo
//
//  Created by Jerry on 2017/9/18.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "jReaderPageHeaderView.h"

@implementation jReaderPageHeaderView

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addSubview:self.titleLabel];
    self.titleLabel.frame = self.bounds;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithRed:68 / 255.0f green:68 / 255.0 blue:68 / 255.0 alpha:1.0f];
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

@end
