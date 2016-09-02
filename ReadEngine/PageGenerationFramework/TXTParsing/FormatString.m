//
//  FormatString.m
//  创新版
//
//  Created by XuPeng on 16/5/21.
//  Copyright © 2016年 cxb. All rights reserved.
//

#import "FormatString.h"

#define kStringMaxLength  1024

@implementation FormatString

+ (NSString *)formatString:(NSString *)string {
    return [self processingChapterContent:string];
}

+ (NSString *)processingChapterContent:(NSString *)chapterStr {
    NSString *chapterContent = [[NSString alloc] init];
    NSInteger stringPointer  = 0;
    while (YES) {
        NSRange range;
        if (stringPointer + kStringMaxLength > chapterStr.length) {
            NSString *str = [chapterStr substringFromIndex:stringPointer];
            str           = [self stringProcessing:str];
            chapterContent = [chapterContent stringByAppendingString:str];
            break;
        } else {
            range.location = stringPointer;
            range.length   = kStringMaxLength;
            NSString *str  = [chapterStr substringWithRange:range];
            chapterContent = [chapterContent stringByAppendingString:[self stringProcessing:str]];
            stringPointer  += kStringMaxLength;
        }
    }
    chapterContent = [self stringHeadAndTailProcessing:chapterContent];
    chapterContent = [NSString stringWithFormat:@"\n\n　　%@",chapterContent];
    return chapterContent;
}
+ (NSString *)stringHeadAndTailProcessing:(NSString *)str {
    if ([str hasPrefix:@"\n　　"]) {
        str = [str substringFromIndex:3];
    }
    if ([str hasSuffix:@"\n　　"]) {
        str = [str substringToIndex:str.length - 3];
    }
    return str;
}
+ (NSString *)stringProcessing:(NSString *)str {
    str = [str stringByReplacingOccurrencesOfString:@"　" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    while (YES) {
        if ([str rangeOfString:@"\r\n"].location == NSNotFound) {
            break;
        }
        str = [str stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
    }
    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    while (YES) {
        if ([str rangeOfString:@"\n\n"].location == NSNotFound) {
            break;
        }
        str = [str stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
    }
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@"\n　　"];
    return str;
}

@end
