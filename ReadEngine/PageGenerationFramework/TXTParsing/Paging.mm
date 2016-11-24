//
//  Paging.m
//  创新版
//
//  Created by XuPeng on 16/5/21.
//  Copyright © 2016年 cxb. All rights reserved.
//

#import "Paging.h"
#import <CoreText/CoreText.h>

#include <vector>
#include <fstream>
#include <iostream>
using namespace std;

#define CHAR_PER_LOAD     50000    // 文本最大长度  超出的不处理

@implementation Paging {
    vector<NSUInteger> _pageOffsets;
    CGRect             _rect;
    NSString           *_contentText;
    CGFloat            _font;
}

- (instancetype)initWithFont:(CGFloat)font pageRect:(CGRect)pageRect {
    self = [super init];
    if (self) {
        _font = font;
        _rect = pageRect;
    }
    return self;
}

#pragma mark - 对外暴露方法
#pragma mark 分页
- (void)paginate:(NSString *)contentText {
    _contentText                          = [NSString stringWithString:contentText];
    //页偏移量        清空
    _pageOffsets.clear();
    NSString *buffer                      = [self subStringWithRange:NSMakeRange(0, CHAR_PER_LOAD) contenText:_contentText];
    // 富文本
    NSMutableAttributedString *attrString = [[NSMutableAttributedString  alloc] initWithString:buffer];
    buffer                                = nil;// 马上释放
    // 设置富文本属性
    NSDictionary *strAttr                 = [self stringAttrWithFont:_font];
    [attrString setAttributes:strAttr range:NSMakeRange(0, attrString.length)];
    CTFramesetterRef frameSetter          = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attrString);
    CGPathRef path                        = CGPathCreateWithRect(_rect, NULL);
    
    // 当前页面在全文中的起始位置
    int currentOffset                     = 0;
    // 内部偏移量
    int currentInnerOffset                = 0;
    // 是否有更多的页面
    BOOL hasMorePages                     = YES;
    // 防止死循环，如果在同一个位置获取CTFrame超过2次，则跳出循环
    int preventDeadLoopSign               = currentOffset;
    // 同一个地方的重复引用计数
    int samePlaceRepeatCount              = 0;
    while (hasMorePages) {
        if (preventDeadLoopSign == currentOffset) {
            ++samePlaceRepeatCount;
        } else {
            samePlaceRepeatCount = 0;
        }
        if (samePlaceRepeatCount > 1) {
            // 退出循环前检查一下最后一页是否已经加上
            if (_pageOffsets.size() == 0) {
                _pageOffsets.push_back(currentOffset);
            } else {
                NSUInteger lastOffset = _pageOffsets.back();
                if (lastOffset != currentOffset) {
                    _pageOffsets.push_back(currentOffset);
                }
            }
            break;
        }
        // 在向量数组尾部加入一个偏移量
        _pageOffsets.push_back(currentOffset);
        CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(currentInnerOffset, 0), path, NULL);
        CFRange range    = CTFrameGetVisibleStringRange(frame);
        if ((range.location + range.length) != attrString.length) {
            currentOffset      += range.length;
            currentInnerOffset += range.length;
        } else if ((range.location + range.length) == attrString.length && (currentOffset + range.length) != [_contentText length]) {
            // 加载后面的
            CFRelease(frame); frame = NULL;
            CFRelease(frameSetter);
            _pageOffsets.pop_back();
            buffer                  = [self subStringWithRange:NSMakeRange(currentOffset, CHAR_PER_LOAD) contenText:_contentText];
            attrString              = [[NSMutableAttributedString alloc] initWithString:buffer];
            [attrString setAttributes:strAttr range:NSMakeRange(0, attrString.length)];
            buffer                  = nil;
            currentInnerOffset      = 0;
            frameSetter             = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attrString);
        } else {
            // 已经分完，提示跳出循环
            hasMorePages = NO;
        }
        if (frame) CFRelease(frame);
    }
    
    CGPathRelease(path);
    CFRelease(frameSetter);
}

#pragma mark 分页后总页数
- (NSUInteger)pageCount {
    
    return _pageOffsets.size();
}

#pragma mark 修改字体大小
- (void)setFont:(CGFloat)font {
    _font = font;
    [self paginate:_contentText];
}
#pragma mark 指定页内容
- (NSString *)stringOfPage:(NSUInteger)page {
    if (page >= [self pageCount]) return @"";
    NSUInteger head = _pageOffsets[page];
    NSUInteger tail = _contentText.length;
    if (page+1 < [self pageCount]) {
        tail = _pageOffsets[page+1];
    }
    return [self subStringWithRange:NSMakeRange(head, tail-head) contenText:_contentText];
}

#pragma mark - 内部方法
#pragma mark 在全文中截取字符串
- (NSString *)subStringWithRange:(NSRange)range contenText:(NSString *)contenText {
    if (range.location == NSNotFound) return @"";
    NSUInteger head = range.location;
    if (head >= contenText.length) return @"";
    NSUInteger tail = (range.location + range.length);
    tail            = tail > contenText.length ? contenText.length : tail;
    if ((NSUInteger)(tail - head) == 4294602370) {
        return @"";
    }
    return [contenText substringWithRange:NSMakeRange(head, tail - head)];
}

#pragma mark 设置字体大小
- (NSDictionary *)stringAttrWithFont:(NSUInteger )fontSize {
    UIFont *font                            = [UIFont fontWithName:@"HelveticaNeue" size:fontSize];
    // 段的样式设置
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //行间距
    paragraphStyle.lineSpacing              = font.pointSize / 3;
    paragraphStyle.paragraphSpacing         = font.pointSize * 0.5;
    // 对齐
    paragraphStyle.alignment                = NSTextAlignmentJustified;
    // @{}  初始化不可变字典
    return @{NSParagraphStyleAttributeName: paragraphStyle, NSFontAttributeName:font};
}

@end
