//
//  ReaderDirectoryViewController.h
//  JReaderDemo
//
//  Created by Jerry on 2017/9/26.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReaderDirectoryViewController : UIViewController

@property (nonatomic, copy) Parameter1Block chapterCellClickBlock;
@property (nonatomic, copy) Parameter1Block markCellClickBlock;
@property (nonatomic, copy) Parameter1Block cancelClickBlock;

- (void)refreshView: (NSMutableArray *)chapterArr markArr: (NSMutableArray *)markArr;

@end
