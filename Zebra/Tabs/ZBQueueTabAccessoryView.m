//
//  ZBQueueTabAccessoryView.m
//  Zebra
//
//  Created by Adam Demasi on 26/3/2026.
//  Copyright © 2026 Zebra Team. All rights reserved.
//

#import "ZBQueueTabAccessoryView.h"

#ifdef __IPHONE_26_0

@implementation ZBQueueTabAccessoryView

- (instancetype)init {
    self = [super init];

    if (self) {
        if (@available(iOS 26, *)) {
            _titleLabel = [[UILabel alloc] init];
            _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
            _titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
            [self addSubview:_titleLabel];

            UIImageView *chevron = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"chevron.up"]];
            chevron.translatesAutoresizingMaskIntoConstraints = NO;
            chevron.tintColor = [UIColor secondaryLabelColor];
            [self addSubview:chevron];

            [NSLayoutConstraint activateConstraints:@[
                [_titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16],
                [_titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:14],
                [_titleLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-14],
                [chevron.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16],
                [chevron.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            ]];
        }
    }

    return self;
}

@end

#endif
