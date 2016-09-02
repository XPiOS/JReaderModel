//
//  PageGenerationHeader.m
//  创新版
//
//  Created by XuPeng on 16/5/24.
//  Copyright © 2016年 cxb. All rights reserved.
//

#import "PageGenerationHeader.h"

#define kTimeLabelX            (self.frame.size.width - 70.0f)
#define kTimeLabelY            0.0f
#define kTimeLabelWidth        70.0f
#define kTimeLabelHeight       44.0f

#define kBookNameLabelX        0.0f
#define kBookNameLabelY        0.0f
#define kBookNameLabelWidth    160.0f
#define kBookNameLabelHeight   44.0f

#define kFontColor             [UIColor colorWithRed:153 / 255.0f green:153 / 255.0 blue:153 / 255.0 alpha:1.0f]

@implementation PageGenerationHeader {
    UILabel    *_bookNameLabel;
    UILabel    *_timeLabel;
}

+(PageGenerationHeader *)sharePageGenerationHeader {
    return [[PageGenerationHeader alloc] init];
}
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializeView];
    }
    return self;
}

- (void)initializeView {
    self.backgroundColor         = [UIColor clearColor];
    _timeLabel                   = [[UILabel alloc] init];
    _timeLabel.textAlignment     = NSTextAlignmentRight;
    _timeLabel.font              = [UIFont systemFontOfSize:12.0f];
    _timeLabel.text              = [self get_time];
    _timeLabel.textColor         = kFontColor;
    [self addSubview:_timeLabel];
    _bookNameLabel               = [[UILabel alloc] init];
    _bookNameLabel.textAlignment = NSTextAlignmentLeft;
    _bookNameLabel.font          = [UIFont systemFontOfSize:12.0f];
    _bookNameLabel.textColor     = kFontColor;
    [self addSubview:_bookNameLabel];
}
- (NSString *)get_time {
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"hh:mm"];
    NSString* date             = [formatter stringFromDate:[NSDate date]];
    return date;
}
#pragma mark - get/set
- (void)setBookName:(NSString *)bookName {
    _bookName           = bookName;
    _bookNameLabel.text = _bookName;
}
- (void)setTextColor:(UIColor *)textColor {
    _textColor               = textColor;
    _bookNameLabel.textColor = _textColor;
    _timeLabel.textColor     = _textColor;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _timeLabel.frame     = CGRectMake(kTimeLabelX, kTimeLabelY, kTimeLabelWidth, kTimeLabelHeight);
    _bookNameLabel.frame = CGRectMake(kBookNameLabelX, kBookNameLabelY, kBookNameLabelWidth, kBookNameLabelHeight);
}

@end
