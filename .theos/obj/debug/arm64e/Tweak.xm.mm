#line 1 "Tweak.xm"
#include "CoreText/CTFontManager.h"

UILabel *splashLabel;
NSTimer *shrinkTimer;
NSTimer *growTimer;
NSTimer *delayShrinkTimer;

@interface SpringBoard
-(float)MCSxOffset;
-(float)MCSyOffset;
@end

@interface SBRootFolderView: UIView
@end

@interface SBFLockScreenDateView : UIView
@end

@interface SBFLockScreenDateSubtitleDateView : UIView
@property (nonatomic, assign, readwrite) BOOL hidden;
@end

@interface SBUILegibilityLabel : UIView
@property (nonatomic, assign, readwrite) BOOL hidden;
@end

@interface UIFont (AFontPrivate)
+ (id)fontWithNameWithoutAFont:(NSString *)arg1 size:(double)arg2;
@end



#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class SparkAlwaysOnController; @class SpringBoard; @class SBFLockScreenDateView; @class SBRootFolderView; 
static void (*_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$)(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$SpringBoard$MCSCreateShrinkTimer(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SpringBoard$MCSGrowLabel(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SpringBoard$MCSShrinkLabel(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL); static float _logos_method$_ungrouped$SpringBoard$MCSxOffset(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL); static float _logos_method$_ungrouped$SpringBoard$MCSyOffset(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$SBFLockScreenDateView$updateFormat)(_LOGOS_SELF_TYPE_NORMAL SBFLockScreenDateView* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBFLockScreenDateView$updateFormat(_LOGOS_SELF_TYPE_NORMAL SBFLockScreenDateView* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$SBRootFolderView$_coverSheetWillPresent$)(_LOGOS_SELF_TYPE_NORMAL SBRootFolderView* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$SBRootFolderView$_coverSheetWillPresent$(_LOGOS_SELF_TYPE_NORMAL SBRootFolderView* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$_ungrouped$SparkAlwaysOnController$setScreenIsOn$withForceShow$)(_LOGOS_SELF_TYPE_NORMAL SparkAlwaysOnController* _LOGOS_SELF_CONST, SEL, _Bool, _Bool); static void _logos_method$_ungrouped$SparkAlwaysOnController$setScreenIsOn$withForceShow$(_LOGOS_SELF_TYPE_NORMAL SparkAlwaysOnController* _LOGOS_SELF_CONST, SEL, _Bool, _Bool); 

#line 32 "Tweak.xm"


static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1){
    
	if (!splashLabel) {
        NSDictionary *prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.samgisaninja.mcsplashprefs"];
        splashLabel = [[UILabel alloc] initWithFrame:CGRectMake([self MCSxOffset], [self MCSyOffset], 300, 20)];
        if ([[prefs objectForKey:@"splashSide"] isEqual:@(0)]) {
            [splashLabel setTransform:CGAffineTransformMakeRotation(7 * -M_PI / 4)];
        } else {
            [splashLabel setTransform:CGAffineTransformMakeRotation(-M_PI / 4)];            
        }
        NSData *fontData = [NSData dataWithContentsOfFile:@"/Library/Application Support/mcsplash/minecraft.ttf"];
        CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)fontData);
        CGFontRef font = CGFontCreateWithDataProvider(provider);
        CTFontManagerRegisterGraphicsFont(font, nil);
        CFRelease(font);
        CFRelease(provider);
        if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/AFont.dylib"]) {
            if ([prefs objectForKey:@"blockAFont"]) {
                if ([[prefs objectForKey:@"blockAFont"] boolValue]){
                    [splashLabel setFont:[UIFont fontWithNameWithoutAFont:@"minecraft" size:11]];
                } else {
                    [splashLabel setFont:[UIFont fontWithName:@"minecraft" size:11]];
                }
            } else {
                [splashLabel setFont:[UIFont fontWithNameWithoutAFont:@"minecraft" size:11]];
            }
        } else {
            [splashLabel setFont:[UIFont fontWithName:@"minecraft" size:11]];
        }
        [splashLabel sizeToFit];

        
	}
    NSArray *allSplashes = [NSArray arrayWithContentsOfFile:@"/Library/Application Support/mcsplash/splashes.plist"];
    NSUInteger randInx = arc4random() % [allSplashes count];
    NSString *text = [allSplashes objectAtIndex:(unsigned long)randInx];
    if ([text isEqualToString:@"§1C§2o§3l§4o§5r§6m§7a§8t§9i§ac"]){
            NSMutableAttributedString *coloredText = [[NSMutableAttributedString alloc] initWithString:@"Colormatic"];
            [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.0/255.0 green:20.0/255.0 blue:163.0/255.0 alpha:1.0] range:NSMakeRange(0,1)];
            [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:76.0/255.0 green:166.0/255.0 blue:48.0/255.0 alpha:1.0] range:NSMakeRange(1,1)];
            [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:74.0/255.0 green:167.0/255.0 blue:169.0/255.0 alpha:1.0] range:NSMakeRange(2,1)];
            [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:156.0/255.0 green:30.0/255.0 blue:20.0/255.0 alpha:1.0] range:NSMakeRange(3,1)];
            [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:156.0/255.0 green:39.0/255.0 blue:164.0/255.0 alpha:1.0] range:NSMakeRange(4,1)];
            [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:243.0/255.0 green:172.0/255.0 blue:61.0/255.0 alpha:1.0] range:NSMakeRange(5,1)];
            [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0] range:NSMakeRange(6,1)];
            [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1.0] range:NSMakeRange(7,1)];
            [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:82.0/255.0 green:92.0/255.0 blue:246.0/255.0 alpha:1.0] range:NSMakeRange(8,1)];
            [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:138.0/255.0 green:250.0/255.0 blue:110.0/255.0 alpha:1.0] range:NSMakeRange(9,1)];
            [splashLabel setAttributedText:coloredText];
        } else {
            [splashLabel setTextColor:[UIColor colorWithRed:(250.0 / 255.0) green:(250.0 / 255.0) blue:(83.0 / 255.0) alpha:1.0]];
    	    [splashLabel setBackgroundColor:[UIColor clearColor]];
            [splashLabel setText:text];
        }
    NSDictionary *prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.samgisaninja.mcsplashprefs"];
    if ([[prefs objectForKey:@"enableAnimations"] boolValue]) {
        if (!growTimer) {
            growTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(MCSGrowLabel) userInfo:nil repeats:TRUE];
            delayShrinkTimer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(MCSCreateShrinkTimer) userInfo:nil repeats:TRUE];
        }
    } else {
        if (!growTimer) {
            growTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(MCSGrowLabel) userInfo:nil repeats:FALSE];
            delayShrinkTimer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(MCSCreateShrinkTimer) userInfo:nil repeats:FALSE];
        }
    }
    
    _logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$(self, _cmd, arg1);
}


static void _logos_method$_ungrouped$SpringBoard$MCSCreateShrinkTimer(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    NSDictionary *prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.samgisaninja.mcsplashprefs"];
    if (!shrinkTimer) {
        if ([[prefs objectForKey:@"enableAnimations"] boolValue]) {
            shrinkTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(MCSShrinkLabel) userInfo:nil repeats:TRUE];
        } else {
            shrinkTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(MCSShrinkLabel) userInfo:nil repeats:FALSE];
        }
    }
    [delayShrinkTimer invalidate];
    delayShrinkTimer = nil;
}


static void _logos_method$_ungrouped$SpringBoard$MCSGrowLabel(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    [UIView animateWithDuration:0.25 animations:^{
        [splashLabel setTransform:CGAffineTransformScale([splashLabel transform], 1.25, 1.25)];
        [splashLabel setCenter:[splashLabel center]];
    } completion:^(BOOL finished) {
        [splashLabel sizeToFit];
    }];
}


static void _logos_method$_ungrouped$SpringBoard$MCSShrinkLabel(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    [UIView animateWithDuration:0.25 animations:^{
        [splashLabel setTransform:CGAffineTransformScale([splashLabel transform], 0.8, 0.8)];
        [splashLabel setCenter:[splashLabel center]];
    } completion:^(BOOL finished) {
        [splashLabel sizeToFit];
    }];
}

 
static float _logos_method$_ungrouped$SpringBoard$MCSxOffset(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    CGFloat width = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    float deviceConst = width * 100 / 375.0;

    NSDictionary *prefs;
    prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.samgisaninja.mcsplashprefs"];
    if ([prefs objectForKey:@"xOff"]){
        if ([[prefs objectForKey:@"splashSide"] isEqual:@(0)]) {
            return [[prefs objectForKey:@"xOff"] floatValue] - deviceConst;
        } else {
            return [[prefs objectForKey:@"xOff"] floatValue] + deviceConst;
        }
    } else {
        if ([[prefs objectForKey:@"splashSide"] isEqual:@(0)]) {
            return -deviceConst;
        } else {
            return deviceConst;
        }
    }
}

 
static float _logos_method$_ungrouped$SpringBoard$MCSyOffset(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    NSDictionary *prefs;
    prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.samgisaninja.mcsplashprefs"];
    if ([prefs objectForKey:@"yOff"]){
        return [[prefs objectForKey:@"yOff"] floatValue]+ 100;
    } else {
        return 100;
    }
}






static void _logos_method$_ungrouped$SBFLockScreenDateView$updateFormat(_LOGOS_SELF_TYPE_NORMAL SBFLockScreenDateView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    [self addSubview:splashLabel];
    NSDictionary *prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.samgisaninja.mcsplashprefs"];
    if ([[prefs objectForKey:@"hideDate"] boolValue]) {
        SBFLockScreenDateSubtitleDateView *dateView = MSHookIvar<SBFLockScreenDateSubtitleDateView *>(self, "_dateSubtitleView");
        [dateView setHidden:TRUE];
    } else {
        SBFLockScreenDateSubtitleDateView *dateView = MSHookIvar<SBFLockScreenDateSubtitleDateView *>(self, "_dateSubtitleView");
        [dateView setHidden:FALSE];
    }
    if ([[prefs objectForKey:@"hideTime"] boolValue]) {
        SBUILegibilityLabel *timeView = MSHookIvar<SBUILegibilityLabel *>(self, "_timeLabel");
        [timeView setHidden:TRUE];
    } else {
        SBUILegibilityLabel *timeView = MSHookIvar<SBUILegibilityLabel *>(self, "_timeLabel");
        [timeView setHidden:FALSE];
    }
    _logos_orig$_ungrouped$SBFLockScreenDateView$updateFormat(self, _cmd);
}





static void _logos_method$_ungrouped$SBRootFolderView$_coverSheetWillPresent$(_LOGOS_SELF_TYPE_NORMAL SBRootFolderView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1){
    NSArray *allSplashes = [NSArray arrayWithContentsOfFile:@"/Library/Application Support/mcsplash/splashes.plist"];
    NSUInteger randInx = arc4random() % [allSplashes count];
    NSString *text = [allSplashes objectAtIndex:(unsigned long)randInx];
    if ([text isEqualToString:@"§1C§2o§3l§4o§5r§6m§7a§8t§9i§ac"]){
            NSMutableAttributedString *coloredText = [[NSMutableAttributedString alloc] initWithString:@"Colormatic"];
            [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.0/255.0 green:20.0/255.0 blue:163.0/255.0 alpha:1.0] range:NSMakeRange(0,1)];
            [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:76.0/255.0 green:166.0/255.0 blue:48.0/255.0 alpha:1.0] range:NSMakeRange(1,1)];
            [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:74.0/255.0 green:167.0/255.0 blue:169.0/255.0 alpha:1.0] range:NSMakeRange(2,1)];
            [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:156.0/255.0 green:30.0/255.0 blue:20.0/255.0 alpha:1.0] range:NSMakeRange(3,1)];
            [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:156.0/255.0 green:39.0/255.0 blue:164.0/255.0 alpha:1.0] range:NSMakeRange(4,1)];
            [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:243.0/255.0 green:172.0/255.0 blue:61.0/255.0 alpha:1.0] range:NSMakeRange(5,1)];
            [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0] range:NSMakeRange(6,1)];
            [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1.0] range:NSMakeRange(7,1)];
            [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:82.0/255.0 green:92.0/255.0 blue:246.0/255.0 alpha:1.0] range:NSMakeRange(8,1)];
            [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:138.0/255.0 green:250.0/255.0 blue:110.0/255.0 alpha:1.0] range:NSMakeRange(9,1)];
            [splashLabel setAttributedText:coloredText];
        } else {
            [splashLabel setTextColor:[UIColor colorWithRed:(250.0 / 255.0) green:(250.0 / 255.0) blue:(83.0 / 255.0) alpha:1.0]];
    	    [splashLabel setBackgroundColor:[UIColor clearColor]];
            [splashLabel setText:text];
        }
    [UIView animateWithDuration:0.1 animations:^{
        [splashLabel setTransform:CGAffineTransformScale([splashLabel transform], 1.0, 1.0)];
        [splashLabel setCenter:[splashLabel center]];
        } completion:^(BOOL finished) {
            [splashLabel sizeToFit];
        }];
    _logos_orig$_ungrouped$SBRootFolderView$_coverSheetWillPresent$(self, _cmd, arg1);
}





static void _logos_method$_ungrouped$SparkAlwaysOnController$setScreenIsOn$withForceShow$(_LOGOS_SELF_TYPE_NORMAL SparkAlwaysOnController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, _Bool arg1, _Bool arg2){
    if (arg1){
        if (!splashLabel) {
    	    splashLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 300, 20)];
    	    [splashLabel setBackgroundColor:[UIColor clearColor]];
            [splashLabel setTransform:CGAffineTransformMakeRotation(-M_PI / 4)];
            NSData *fontData = [NSData dataWithContentsOfFile:@"/Library/Application Support/mcsplash/minecraft.ttf"];
            CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)fontData);
            CGFontRef font = CGFontCreateWithDataProvider(provider);
            CTFontManagerRegisterGraphicsFont(font, nil);
            CFRelease(font);
            CFRelease(provider);
            [splashLabel setFont:[UIFont fontWithName:@"minecraft" size:11]];
            [splashLabel sizeToFit];
	    }
        NSArray *allSplashes = [NSArray arrayWithContentsOfFile:@"/Library/Application Support/mcsplash/splashes.plist"];
        NSUInteger randInx = arc4random() % [allSplashes count];
        NSString *text = [allSplashes objectAtIndex:(unsigned long)randInx];
        if ([text isEqualToString:@"§1C§2o§3l§4o§5r§6m§7a§8t§9i§ac"]){
            NSMutableAttributedString *coloredText = [[NSMutableAttributedString alloc] initWithString:@"Colormatic"];
            [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.0/255.0 green:20.0/255.0 blue:163.0/255.0 alpha:1.0] range:NSMakeRange(0,1)];
            [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:76.0/255.0 green:166.0/255.0 blue:48.0/255.0 alpha:1.0] range:NSMakeRange(1,1)];
            [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:74.0/255.0 green:167.0/255.0 blue:169.0/255.0 alpha:1.0] range:NSMakeRange(2,1)];
            [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:156.0/255.0 green:30.0/255.0 blue:20.0/255.0 alpha:1.0] range:NSMakeRange(3,1)];
            [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:156.0/255.0 green:39.0/255.0 blue:164.0/255.0 alpha:1.0] range:NSMakeRange(4,1)];
            [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:243.0/255.0 green:172.0/255.0 blue:61.0/255.0 alpha:1.0] range:NSMakeRange(5,1)];
            [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0] range:NSMakeRange(6,1)];
            [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1.0] range:NSMakeRange(7,1)];
            [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:82.0/255.0 green:92.0/255.0 blue:246.0/255.0 alpha:1.0] range:NSMakeRange(8,1)];
            [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:138.0/255.0 green:250.0/255.0 blue:110.0/255.0 alpha:1.0] range:NSMakeRange(9,1)];
            [splashLabel setAttributedText:coloredText];
        } else {
            [splashLabel setTextColor:[UIColor colorWithRed:(250.0 / 255.0) green:(250.0 / 255.0) blue:(83.0 / 255.0) alpha:1.0]];
    	    [splashLabel setBackgroundColor:[UIColor clearColor]];
            [splashLabel setText:text];
        }
        [splashLabel setHidden:FALSE];
    } else {
        NSDictionary *prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.samgisaninja.mcsplashprefs"];
        if (![[prefs objectForKey:@"hypShow"] boolValue]) {
            [splashLabel setHidden:TRUE];
        }
    }
    _logos_orig$_ungrouped$SparkAlwaysOnController$setScreenIsOn$withForceShow$(self, _cmd, arg1, arg2);
}




static __attribute__((constructor)) void _logosLocalCtor_b2dac52d(int __unused argc, char __unused **argv, char __unused **envp){
    NSDictionary *prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.samgisaninja.mcsplashprefs"];
    if (!prefs) {
        NSMutableDictionary *mutablePrefs = [[NSMutableDictionary alloc] init];
        [mutablePrefs setObject:@TRUE forKey:@"isEnabled"];
        [mutablePrefs setObject:@TRUE forKey:@"enableAnimations"];
        [mutablePrefs setObject:@FALSE forKey:@"hideTime"];
        [mutablePrefs setObject:@FALSE forKey:@"hideDate"];
        [mutablePrefs setObject:@FALSE forKey:@"hypShow"];
        [mutablePrefs setObject:@(1) forKey:@"splashSide"];
        prefs = [NSDictionary dictionaryWithDictionary:mutablePrefs];
    }
    if ([[prefs objectForKey:@"isEnabled"] boolValue]) {
        {Class _logos_class$_ungrouped$SpringBoard = objc_getClass("SpringBoard"); MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(applicationDidFinishLaunching:), (IMP)&_logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$, (IMP*)&_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SpringBoard, @selector(MCSCreateShrinkTimer), (IMP)&_logos_method$_ungrouped$SpringBoard$MCSCreateShrinkTimer, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SpringBoard, @selector(MCSGrowLabel), (IMP)&_logos_method$_ungrouped$SpringBoard$MCSGrowLabel, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SpringBoard, @selector(MCSShrinkLabel), (IMP)&_logos_method$_ungrouped$SpringBoard$MCSShrinkLabel, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'f'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SpringBoard, @selector(MCSxOffset), (IMP)&_logos_method$_ungrouped$SpringBoard$MCSxOffset, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'f'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SpringBoard, @selector(MCSyOffset), (IMP)&_logos_method$_ungrouped$SpringBoard$MCSyOffset, _typeEncoding); }Class _logos_class$_ungrouped$SBFLockScreenDateView = objc_getClass("SBFLockScreenDateView"); MSHookMessageEx(_logos_class$_ungrouped$SBFLockScreenDateView, @selector(updateFormat), (IMP)&_logos_method$_ungrouped$SBFLockScreenDateView$updateFormat, (IMP*)&_logos_orig$_ungrouped$SBFLockScreenDateView$updateFormat);Class _logos_class$_ungrouped$SBRootFolderView = objc_getClass("SBRootFolderView"); MSHookMessageEx(_logos_class$_ungrouped$SBRootFolderView, @selector(_coverSheetWillPresent:), (IMP)&_logos_method$_ungrouped$SBRootFolderView$_coverSheetWillPresent$, (IMP*)&_logos_orig$_ungrouped$SBRootFolderView$_coverSheetWillPresent$);Class _logos_class$_ungrouped$SparkAlwaysOnController = objc_getClass("SparkAlwaysOnController"); MSHookMessageEx(_logos_class$_ungrouped$SparkAlwaysOnController, @selector(setScreenIsOn:withForceShow:), (IMP)&_logos_method$_ungrouped$SparkAlwaysOnController$setScreenIsOn$withForceShow$, (IMP*)&_logos_orig$_ungrouped$SparkAlwaysOnController$setScreenIsOn$withForceShow$);}
    }
}
