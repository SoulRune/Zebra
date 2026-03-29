//
//  UIImageView+Zebra.m
//  Zebra
//
//  Created by Wilson Styres on 1/11/20.
//  Copyright © 2020 Wilson Styres. All rights reserved.
//

#import "UIColor+GlobalColors.h"
#import "UIImageView+Zebra.h"
#import "UIView+Private.h"
#import "UIImage+Private.h"

@implementation UIImageView (Zebra)

- (void)applyBorder {
    self.layer.borderColor = [UIColor imageBorderColor].CGColor;
    self.layer.borderWidth = 0.5;
    self.clipsToBounds = YES;
}

- (void)removeBorder {
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.borderWidth = 0.0;
    self.clipsToBounds = YES;
}

- (void)setColor:(UIColor *)color {
    CGSize size = CGSizeMake(30, 30);

    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    [color setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    self.image = colorImage;
    [self resize:size applyRadius:NO];
    
    self.layer.cornerRadius = size.width / 2;
    self.clipsToBounds = YES;
}

- (void)setLeftColor:(UIColor *)leftColor rightColor:(UIColor *)rightColor {
    if ([leftColor isEqual:rightColor]) {
        [self setColor:leftColor];
        return;
    }
    
    CGSize size = CGSizeMake(30, 30);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), NO, 0.0);
    
    UIBezierPath *leftTriangle = [[UIBezierPath alloc] init];
    [leftTriangle moveToPoint:CGPointMake(0, 0)];
    [leftTriangle addLineToPoint:CGPointMake(0, size.height)];
    [leftTriangle addLineToPoint:CGPointMake(size.width, 0)];
    [leftTriangle closePath];
    
    [leftColor setFill];
    [leftTriangle fill];
    
    UIBezierPath *rightTriangle = [[UIBezierPath alloc] init];
    [rightTriangle moveToPoint:CGPointMake(size.width, size.height)];
    [rightTriangle addLineToPoint:CGPointMake(0, size.height)];
    [rightTriangle addLineToPoint:CGPointMake(size.width, 0)];
    [rightTriangle closePath];
    
    [rightColor setFill];
    [rightTriangle fill];

    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.image = colorImage;
    [self resize:size applyRadius:NO];
    
    self.layer.cornerRadius = size.width / 2;
    self.clipsToBounds = YES;
}

- (void)setIconImage:(UIImage *)image variant:(MIIconVariant)variant {
    CGFloat size = 0;
    switch (variant) {
    case MIIconVariantSpotlight:
        size = 40;
        break;
    case MIIconVariantDefault:
        size = 60;
        break;
    case MIIconVariantSettings:
        size = 29;
        break;
    }

    UIScreen *screen = self.window.screen ?: [UIScreen mainScreen];
    CGSize scaledSize = CGSizeMake(size * screen.scale, size * screen.scale);

    if (!CGSizeEqualToSize(image.size, scaledSize)) {
        UIGraphicsBeginImageContextWithOptions(scaledSize, NO, screen.scale);
        CGRect rect = CGRectMake(0, 0, scaledSize.width, scaledSize.height);
        [image drawInRect:rect];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }

    self.image = [image _applicationIconImageForFormat:variant precomposed:YES scale:screen.scale];
}

- (void)resize:(CGSize)size applyRadius:(BOOL)radius {
    UIScreen *screen = self.window.screen ?: [UIScreen mainScreen];
    UIGraphicsBeginImageContextWithOptions(size, NO, screen.scale);

    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [self.image drawInRect:rect];
    
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (radius) {
        self.layer.cornerRadius = 0.2237 * size.width;
        if (@available(iOS 13, *)) {
            self.layer.cornerCurve = kCACornerCurveContinuous;
        } else if (@available(iOS 11, *)) {
            self._continuousCornerRadius = self.layer.cornerRadius;
        }
        self.clipsToBounds = YES;
    }
}

@end
