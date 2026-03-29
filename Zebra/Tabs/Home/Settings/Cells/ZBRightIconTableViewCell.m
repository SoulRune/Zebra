//
//  ZBRightIconTableViewCell.m
//  Zebra
//
//  Created by Wilson Styres on 1/11/20.
//  Copyright © 2020 Wilson Styres. All rights reserved.
//

#import "ZBRightIconTableViewCell.h"
#import "UIImageView+Zebra.h"

@implementation ZBRightIconTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.label.font = self.textLabel.font;
}

- (void)setAppIcon:(UIImage *)icon {
    [self.iconView setIconImage:icon variant:MIIconVariantSettings];
}

@end
