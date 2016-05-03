//
//  LJYTrendTableViewCell.m
//  ClashRoyaleChest
//
//  Created by liujunyi on 16/4/13.
//  Copyright © 2016年 LJY. All rights reserved.
//

#import "LJYTrendTableViewCell.h"

@implementation LJYTrendTableViewCell

@synthesize titleLabel;
@synthesize thumbView;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.thumbView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 111, 80)];
        self.thumbView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 0, self.bounds.size.width - 140, 90)];
        self.titleLabel.numberOfLines = 0;
        
        
        [self addSubview:self.thumbView];
        [self addSubview:self.titleLabel];
        
        
    }
    
    self.backgroundColor = [UIColor colorWithRed:23/255.0 green:139.0/255 blue:253.0/255 alpha:1];
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    
    return self;
}

@end
