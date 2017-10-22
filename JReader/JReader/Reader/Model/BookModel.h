//
//  BookModel.h
//  JReader
//
//  Created by Jerry on 2017/10/20.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChapterModel.h"
#import "MarkModel.h"

@interface BookModel : NSObject

@property (nonatomic, strong) NSString *bookName;
@property (nonatomic, assign) NSInteger chapterIndex;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray<ChapterModel *> * bookChapterArr;
@property (nonatomic, strong) NSMutableArray <MarkModel *> *bookMarkArr;

@end
