//
//  MobileIcons.h
//  Zebra
//
//  Created by Adam Demasi on 23/3/2026.
//  Copyright © 2026 Zebra Team. All rights reserved.
//

@import Foundation;
@import CoreGraphics;

typedef NS_ENUM(NSUInteger, MIIconVariant) {
    MIIconVariantSpotlight = 1,
    MIIconVariantDefault = 2,
    MIIconVariantSettings = 9
};

FOUNDATION_EXPORT CGImageRef LICreateDefaultIcon(MIIconVariant variant);
