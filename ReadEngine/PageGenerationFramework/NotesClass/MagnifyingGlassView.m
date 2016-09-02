//
//  MagnifyingGlassView.m
//  创新版
//
//  Created by XuPeng on 16/5/24.
//  Copyright © 2016年 cxb. All rights reserved.
//

#import "MagnifyingGlassView.h"

@implementation MagnifyingGlassView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame               = CGRectMake(0, 0, 100, 100);
        self.layer.borderColor   = [[UIColor lightGrayColor] CGColor];
        self.layer.borderWidth   = 1;
        self.layer.cornerRadius  = 50;
        self.layer.masksToBounds = YES;
    }
    return self;
}
- (void)setTouchPoint:(CGPoint)touchPoint {
    _touchPoint = touchPoint;
    self.center = CGPointMake(touchPoint.x, touchPoint.y - 100);
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, self.frame.size.width * 0.5,self.frame.size.height * 0.5);
    CGContextScaleCTM(context, 1.5, 1.5);
    CGContextTranslateCTM(context, -1 * (_touchPoint.x), -1 * (_touchPoint.y));
    [self.viewToMagnify.layer renderInContext:context];
}
@end
