//
//  ZBSettings.h
//  Zebra
//
//  Compatibility shim bridging old ZBSettings API to the new Preferences system.
//

#import <Foundation/Foundation.h>

// Matches AccentColor Swift enum (raw Int values)
typedef NSInteger ZBAccentColor;
static const ZBAccentColor ZBAccentColorSystem        = -1;
static const ZBAccentColor ZBAccentColorAquaVelvet    = 0;
static const ZBAccentColor ZBAccentColorCornflowerBlue = 1;
static const ZBAccentColor ZBAccentColorEmeraldCity   = 2;
static const ZBAccentColor ZBAccentColorGoldenTainoi  = 3;
static const ZBAccentColor ZBAccentColorIrisBlue      = 4;
static const ZBAccentColor ZBAccentColorLotusPink     = 5;
static const ZBAccentColor ZBAccentColorMonochrome    = 6;
static const ZBAccentColor ZBAccentColorMountainMeadow = 7;
static const ZBAccentColor ZBAccentColorPastelRed     = 8;
static const ZBAccentColor ZBAccentColorPurpleHeart   = 9;
static const ZBAccentColor ZBAccentColorRoyalBlue     = 10;
static const ZBAccentColor ZBAccentColorShark         = 11;
static const ZBAccentColor ZBAccentColorStorm         = 12;

typedef NSInteger ZBInterfaceStyle;
static const ZBInterfaceStyle ZBInterfaceStyleLight   = 0;
static const ZBInterfaceStyle ZBInterfaceStyleDark    = 1;

@interface ZBSettings : NSObject

// Language
+ (BOOL)usesSystemLanguage;
+ (void)setUsesSystemLanguage:(BOOL)usesSystemLanguage;
+ (NSString *)selectedLanguage;
+ (void)setSelectedLanguage:(NSString *)selectedLanguage;

// Appearance
+ (ZBAccentColor)accentColor;
+ (void)setAccentColor:(ZBAccentColor)accentColor;
+ (BOOL)usesSystemAppearance;
+ (void)setUsesSystemAppearance:(BOOL)usesSystemAppearance;
+ (ZBInterfaceStyle)interfaceStyle;
+ (void)setInterfaceStyle:(ZBInterfaceStyle)interfaceStyle;

// Auto Refresh
+ (BOOL)wantsAutoRefresh;
+ (NSDate *)lastSourceUpdate;
+ (void)updateLastSourceUpdate;

@end
