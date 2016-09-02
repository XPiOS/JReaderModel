//
//  PageGenerationFooter.h
//  创新版
//
//  Created by XuPeng on 16/5/24.
//  Copyright © 2016年 cxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageGenerationFooter : UIView

// 章节名称
@property (nonatomic, strong) NSString *chapterName;
// 阅读进度
@property (nonatomic, assign) CGFloat  readerProgress;
// 字体颜色
@property (nonatomic, strong) UIColor  *textColor;
// 电池图片name
@property (nonatomic, strong) NSString *batteryImageName;

+ (PageGenerationFooter *)sharePageGenerationFooter;

@end
