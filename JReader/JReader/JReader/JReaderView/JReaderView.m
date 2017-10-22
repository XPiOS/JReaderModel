//
//  JReaderView.m
//  JReaderDemo
//
//  Created by Jerry on 2017/9/4.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "JReaderView.h"
#import <CoreText/CoreText.h>

@interface JReaderView ()

@property (nonatomic, assign) CTFrameRef readerCTFrame;

@end

@implementation JReaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setRender];
}

#pragma mark 重写父类的绘制方法
- (void)drawRect:(CGRect)rect {
    if (!self.readerCTFrame) return;
    CGContextRef context        = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGAffineTransform transform = CGAffineTransformMake(1,0,0,-1,0,self.bounds.size.height);
    CGContextConcatCTM(context, transform);
    CTFrameDraw(self.readerCTFrame, context);
}

#pragma mark - 设置渲染参数
- (void)setRender {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString  alloc] initWithString:self.jReaderContentStr];
    [attrString setAttributes:self.jReaderNameAttributes range:self.jReaderNameRange];
    [attrString setAttributes:self.jReaderAttributes range:NSMakeRange(self.jReaderNameRange.length, attrString.length - self.jReaderNameRange.length)];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attrString);
    CGPathRef path = CGPathCreateWithRect(self.bounds, NULL);
    if (self.readerCTFrame != NULL) {
        CFRelease(self.readerCTFrame);
        self.readerCTFrame = NULL;
    }
    self.readerCTFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    CFRelease(frameSetter);
}

@end
