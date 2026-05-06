//
//  ZBSettings.m
//  Zebra
//
//  Compatibility shim bridging old ZBSettings API to the new Preferences system.
//

#import "ZBSettings.h"

static NSString * const ZBSettingsAppleLanguagesKey     = @"AppleLanguages";
static NSString * const ZBSettingsAccentColorKey        = @"AccentColor";
static NSString * const ZBSettingsManualAppearanceKey   = @"ManualAppearance";
static NSString * const ZBSettingsInterfaceStyleKey     = @"InterfaceStyle";
static NSString * const ZBSettingsAutoRefreshKey        = @"AutoRefresh";
static NSString * const ZBSettingsLastSourceUpdateKey   = @"lastUpdatedDate";

@implementation ZBSettings

#pragma mark - Language

+ (BOOL)usesSystemLanguage {
    return [[NSUserDefaults standardUserDefaults] objectForKey:ZBSettingsAppleLanguagesKey] == nil;
}

+ (void)setUsesSystemLanguage:(BOOL)usesSystemLanguage {
    if (usesSystemLanguage) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:ZBSettingsAppleLanguagesKey];
    }
}

+ (NSString *)selectedLanguage {
    NSArray *languages = [[NSUserDefaults standardUserDefaults] arrayForKey:ZBSettingsAppleLanguagesKey];
    return languages.firstObject;
}

+ (void)setSelectedLanguage:(NSString *)selectedLanguage {
    if (selectedLanguage) {
        [[NSUserDefaults standardUserDefaults] setObject:@[selectedLanguage] forKey:ZBSettingsAppleLanguagesKey];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:ZBSettingsAppleLanguagesKey];
    }
}

#pragma mark - Appearance

+ (ZBAccentColor)accentColor {
    return (ZBAccentColor)[[NSUserDefaults standardUserDefaults] integerForKey:ZBSettingsAccentColorKey];
}

+ (void)setAccentColor:(ZBAccentColor)accentColor {
    [[NSUserDefaults standardUserDefaults] setInteger:accentColor forKey:ZBSettingsAccentColorKey];
}

+ (BOOL)usesSystemAppearance {
    return ![[NSUserDefaults standardUserDefaults] boolForKey:ZBSettingsManualAppearanceKey];
}

+ (void)setUsesSystemAppearance:(BOOL)usesSystemAppearance {
    [[NSUserDefaults standardUserDefaults] setBool:!usesSystemAppearance forKey:ZBSettingsManualAppearanceKey];
}

+ (ZBInterfaceStyle)interfaceStyle {
    return (ZBInterfaceStyle)[[NSUserDefaults standardUserDefaults] integerForKey:ZBSettingsInterfaceStyleKey];
}

+ (void)setInterfaceStyle:(ZBInterfaceStyle)interfaceStyle {
    [[NSUserDefaults standardUserDefaults] setInteger:interfaceStyle forKey:ZBSettingsInterfaceStyleKey];
}

#pragma mark - Auto Refresh

+ (BOOL)wantsAutoRefresh {
    return [[NSUserDefaults standardUserDefaults] boolForKey:ZBSettingsAutoRefreshKey];
}

+ (NSDate *)lastSourceUpdate {
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:ZBSettingsLastSourceUpdateKey];
    return date ?: [NSDate distantPast];
}

+ (void)updateLastSourceUpdate {
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:ZBSettingsLastSourceUpdateKey];
}

@end
