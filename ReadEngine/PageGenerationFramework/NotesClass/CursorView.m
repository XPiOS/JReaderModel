//
//  CursorView.m
//  创新版
//
//  Created by XuPeng on 16/5/25.
//  Copyright © 2016年 cxb. All rights reserved.
//

#import "CursorView.h"
#define kE_CursorWidth 4

@implementation CursorView

- (id)initWithType:(CursorType)type andHeight:(float)cursorHeight byDrawColor:(UIColor *)drawColor {
    self = [super init];
    if (self) {
        _direction         = type;
        _cursorHeight      = cursorHeight;
        _cursorColor       = drawColor;
        self.clipsToBounds = NO;
    }
    return self;
}
- (void)setSetupPoint:(CGPoint)setupPoint{
    self.backgroundColor = _cursorColor;
    if (_dragDot) {
        [_dragDot removeFromSuperview];
        _dragDot = nil;
    }
    _dragDot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"r_drag-dot.png"]];
    if (_direction == CursorLeft) {
        self.frame     = CGRectMake(setupPoint.x - kE_CursorWidth, setupPoint.y - _cursorHeight, kE_CursorWidth, _cursorHeight);
        _dragDot.frame = CGRectMake(-6, -14, 15, 17);

    }else{
        self.frame     = CGRectMake(setupPoint.x, setupPoint.y - _cursorHeight, kE_CursorWidth, _cursorHeight);
        _dragDot.frame = CGRectMake(-6, _cursorHeight, 15, 17);
    }
    [self addSubview:_dragDot];
}
- (float) heightForFontSize:(float)fontSize {
    CGSize sizeToFit = [@"阅读引擎" sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(100.0f, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    return sizeToFit.height;
}

@end
