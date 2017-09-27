//
//  ReaderModel.h
//  JReaderDemo
//
//  Created by Jerry on 2017/9/21.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChapterModel.h"
#import "MarkModel.h"

@interface ReaderModel : NSObject

@property (nonatomic, strong) NSString *bookName;
@property (nonatomic, strong) NSMutableArray<ChapterModel *> * bookChapterArr;
@property (nonatomic, strong) NSMutableArray <MarkModel *> *bookMarkArr;

@end
