//
//  ZBLiveSearchResultTableViewCell.m
//  Zebra
//
//  Created by Andrew Abosh on 2020-03-29.
//  Copyright © 2020 Wilson Styres. All rights reserved.
//

#import "ZBLiveSearchResultTableViewCell.h"
#import "UIColor+GlobalColors.h"
#import "UIView+Zebra.h"
@import SDWebImage;

@implementation ZBLiveSearchResultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.isInstalledImageView.hidden = YES;
    self.isPaidImageView.hidden = YES;
    self.packageIconImageView.cornerRadius = 6;
    self.packageIconImageView.clipsToBounds = YES;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.isInstalledImageView.tintColor = [UIColor accentColor];
}

- (void)updateData:(ZBProxyPackage *)package {
    self.packageNameLabel.text = package.name;
    self.isInstalledImageView.hidden = !package.isInstalled;
    self.contentView.alpha = package.isArchitectureCompatible ? 1 : 0.5;
    
    [package setIconImageForImageView:self.packageIconImageView variant:MIIconVariantDefault];
}

- (void)setColors {
    self.packageNameLabel.textColor = [UIColor primaryTextColor];
    self.backgroundColor = [UIColor cellBackgroundColor];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [[self packageIconImageView] sd_cancelCurrentImageLoad];
    self.packageIconImageView.image = nil;
}

@end
