//
//  jReaderPageFooterView.m
//  JReaderDemo
//
//  Created by Jerry on 2017/9/18.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "jReaderPageFooterView.h"

@implementation jReaderPageFooterView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self addSubview:self.progressLabel];
    self.progressLabel.frame = CGRectMake(self.bounds.size.width / 2, 0, self.bounds.size.width / 2, self.bounds.size.height);
    
    [self addSubview:self.batteryImageView];
    
    self.batteryImageView.frame = CGRectMake(0, (self.bounds.size.height - 10) / 2, 25.0f, 10.0f);
}

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.textAlignment = NSTextAlignmentRight;
        _progressLabel.textColor = [UIColor colorWithRed:68 / 255.0f green:68 / 255.0 blue:68 / 255.0 alpha:1.0f];
        _progressLabel.font = [UIFont systemFontOfSize:14];
    }
    return _progressLabel;
}
- (UIImageView *)batteryImageView {
    if (!_batteryImageView) {
        _batteryImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"battery"]];
        [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
        float electricity = [[UIDevice currentDevice] batteryLevel];
        UIView *batteryFillView = [[UIView alloc] initWithFrame:CGRectMake(1.5f, 1.5f, (25.0f - 5.0f) * electricity, (10.0f - 3.0f))];
        batteryFillView.backgroundColor = [UIColor colorWithRed:68 / 255.0f green:68 / 255.0 blue:68 / 255.0 alpha:1.0f];
        [_batteryImageView addSubview:batteryFillView];
    }
    return _batteryImageView;
}
@end
