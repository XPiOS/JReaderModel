//
//  MarkTableViewCell.m
//  JReaderDemo
//
//  Created by Jerry on 2017/9/27.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "MarkTableViewCell.h"
@interface MarkTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel  *contentLabel;

@end

@implementation MarkTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}
- (void)initView {
    [self addSubview:self.titleLabel];
    self.titleLabel.wd_layout
    .topSpaceToSuperView(10)
    .leftSpaceToSuperView(15)
    .autoresizingMaxWidth(0)
    .autoHeightRatio(0);
    
    [self addSubview:self.contentLabel];
    self.contentLabel.wd_layout
    .topSpaceToView(self.titleLabel, 5)
    .leftEqualToView(self.titleLabel)
    .rightSpaceToSuperView(15)
    .height(40);
}

- (CGFloat)heightStr: (CGFloat)width string: (NSString *)string font: (UIFont *)font {
    CGSize size = CGSizeMake(width, 9999);
    return [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName:font} context:nil].size.height;
}
#pragma mark - get/set
- (void)setMarkModel:(MarkModel *)markModel {
    _markModel = markModel;
    self.titleLabel.text = markModel.chapterName;
    [self.titleLabel wd_updateLayout];
    
    self.contentLabel.text = markModel.markContent;
    CGFloat height = [self heightStr:SCREEN_WIDTH - 60 - 30 string:markModel.markContent font:[UIFont systemFontOfSize:16]];
    height = height > 40 ? 40 : height;
    self.contentLabel.wd_layout
    .height(height);
    [self.contentLabel wd_updateLayout];
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor colorWithRed:155 / 255.0 green:140 / 255.0 blue:104 / 255.0 alpha:1];
    }
    return _titleLabel;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:16];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
