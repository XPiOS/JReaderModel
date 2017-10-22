//
//  JReaderModel.m
//  JReaderDemo
//
//  Created by Jerry on 2017/8/1.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "JReaderModel.h"

@implementation JReaderModel

- (NSDictionary *)jReaderAttributes {
    if (!_jReaderAttributes) {
        _jReaderAttributes = [self getAttributes];
    }
    return _jReaderAttributes;
}

#pragma mark 默认富文本属性
- (NSDictionary *)getAttributes {
    // 段的样式设置
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //行间距
    paragraphStyle.lineSpacing = 16 / 3;
    paragraphStyle.paragraphSpacing = 16 * 0.5;
    // 对齐
    paragraphStyle.alignment = NSTextAlignmentJustified;
    // @{}  初始化不可变字典
    return @{NSParagraphStyleAttributeName: paragraphStyle, NSFontAttributeName:[UIFont systemFontOfSize:16]};
}
#pragma mark 默认标题属性
- (NSDictionary *)jReaderChapterNameAttributes {
    if (!_jReaderChapterNameAttributes && self.jReaderAttributes) {
        UIFont *font = self.jReaderAttributes[@"NSFont"];
        NSParagraphStyle *paragraphStyle = self.jReaderAttributes[@"NSParagraphStyle"];
        UIFont *chapterNameFont = [UIFont fontWithName:font.fontName size:font.pointSize * 1.5];
        NSMutableParagraphStyle *chapterNameParagraphStyle = [paragraphStyle mutableCopy];
        chapterNameParagraphStyle.lineSpacing = (chapterNameFont.pointSize) / 3;
        chapterNameParagraphStyle.paragraphSpacing = chapterNameFont.pointSize * 0.5;
        _jReaderChapterNameAttributes = @{NSParagraphStyleAttributeName: chapterNameParagraphStyle, NSFontAttributeName:chapterNameFont};
    }
    return _jReaderChapterNameAttributes;
}
#pragma mark 设置章节标题时，加上一个换行
- (void)setJReaderChapterName:(NSString *)jReaderChapterName {
    _jReaderChapterName = [NSString stringWithFormat:@"\n%@", jReaderChapterName];
}
@end
