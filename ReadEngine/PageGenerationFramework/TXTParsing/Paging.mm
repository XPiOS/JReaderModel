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

#define CHAR_PER_LOAD     50000

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
- (void)paginate:(NSString *)contentText {
    _contentText                          = [NSString stringWithString:contentText];
    _pageOffsets.clear();
    NSString *buffer                      = [self subStringWithRange:NSMakeRange(0, CHAR_PER_LOAD) contenText:_contentText];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString  alloc] initWithString:buffer];
    buffer                                = nil;
    NSDictionary *strAttr                 = [self stringAttrWithFont:_font];
    [attrString setAttributes:strAttr range:NSMakeRange(0, attrString.length)];
    CTFramesetterRef frameSetter          = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attrString);
    CGPathRef path                        = CGPathCreateWithRect(_rect, NULL);
    int currentOffset                     = 0;
    int currentInnerOffset                = 0;
    BOOL hasMorePages                     = YES;
    int preventDeadLoopSign               = currentOffset;
    int samePlaceRepeatCount              = 0;
    while (hasMorePages) {
        if (preventDeadLoopSign == currentOffset) {
            ++samePlaceRepeatCount;
        } else {
            samePlaceRepeatCount = 0;
        }
        if (samePlaceRepeatCount > 1) {
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
        _pageOffsets.push_back(currentOffset);
        CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(currentInnerOffset, 0), path, NULL);
        CFRange range    = CTFrameGetVisibleStringRange(frame);
        if ((range.location + range.length) != attrString.length) {
            currentOffset      += range.length;
            currentInnerOffset += range.length;
        } else if ((range.location + range.length) == attrString.length && (currentOffset + range.length) != [_contentText length]) {
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
            hasMorePages = NO;
        }
        if (frame) CFRelease(frame);
    }
    
    CGPathRelease(path);
    CFRelease(frameSetter);
}

- (NSUInteger)pageCount {
    return _pageOffsets.size();
}

- (void)setFont:(CGFloat)font {
    _font = font;
    [self paginate:_contentText];
}

- (NSString *)stringOfPage:(NSUInteger)page {
    if (page >= [self pageCount]) return @"";
    NSUInteger head = _pageOffsets[page];
    NSUInteger tail = _contentText.length;
    if (page+1 < [self pageCount]) {
        tail = _pageOffsets[page+1];
    }
    return [self subStringWithRange:NSMakeRange(head, tail-head) contenText:_contentText];
}

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

- (NSDictionary *)stringAttrWithFont:(NSUInteger )fontSize {
    UIFont *font                            = [UIFont fontWithName:@"HelveticaNeue" size:fontSize];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing              = font.pointSize / 3;
    paragraphStyle.paragraphSpacing         = font.pointSize * 0.5;
    paragraphStyle.alignment                = NSTextAlignmentJustified;
    return @{NSParagraphStyleAttributeName: paragraphStyle, NSFontAttributeName:font};
}

@end
