#line 1 "Tweak.xm"
#include "CoreText/CTFontManager.h"
UILabel *splashLabel;
NSTimer *shrinkTimer;
NSTimer *growTimer;
NSTimer *delayShrinkTimer;
NSDictionary *prefs;
@interface SBRootFolderView: UIView
@end

@interface SBFLockScreenDateView : UIView
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

@class SBRootFolderView; @class SparkAlwaysOnController; @class SpringBoard; @class SBFLockScreenDateView; 
static void (*_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$)(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$SpringBoard$MCSCreateShrinkTimer(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SpringBoard$MCSGrowLabel(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SpringBoard$MCSShrinkLabel(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$SBFLockScreenDateView$updateFormat)(_LOGOS_SELF_TYPE_NORMAL SBFLockScreenDateView* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBFLockScreenDateView$updateFormat(_LOGOS_SELF_TYPE_NORMAL SBFLockScreenDateView* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$SBRootFolderView$_coverSheetWillPresent$)(_LOGOS_SELF_TYPE_NORMAL SBRootFolderView* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$SBRootFolderView$_coverSheetWillPresent$(_LOGOS_SELF_TYPE_NORMAL SBRootFolderView* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$_ungrouped$SparkAlwaysOnController$setScreenIsOn$withForceShow$)(_LOGOS_SELF_TYPE_NORMAL SparkAlwaysOnController* _LOGOS_SELF_CONST, SEL, _Bool, _Bool); static void _logos_method$_ungrouped$SparkAlwaysOnController$setScreenIsOn$withForceShow$(_LOGOS_SELF_TYPE_NORMAL SparkAlwaysOnController* _LOGOS_SELF_CONST, SEL, _Bool, _Bool); 

#line 13 "Tweak.xm"


static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1){
	if (!splashLabel) {
    	splashLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 300, 20)];
    	[splashLabel setTextColor:[UIColor colorWithRed:(250.0 / 255.0) green:(250.0 / 255.0) blue:(83.0 / 255.0) alpha:1.0]];
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
    [splashLabel setText:[allSplashes objectAtIndex:randInx]];
    if (!growTimer) {
        growTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(MCSGrowLabel) userInfo:nil repeats:YES];
        delayShrinkTimer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(MCSCreateShrinkTimer) userInfo:nil repeats:YES];
    }
    _logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$(self, _cmd, arg1);
}


static void _logos_method$_ungrouped$SpringBoard$MCSCreateShrinkTimer(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    if (!shrinkTimer) {
        shrinkTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(MCSShrinkLabel) userInfo:nil repeats:YES];
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






static void _logos_method$_ungrouped$SBFLockScreenDateView$updateFormat(_LOGOS_SELF_TYPE_NORMAL SBFLockScreenDateView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    [self addSubview:splashLabel];
    _logos_orig$_ungrouped$SBFLockScreenDateView$updateFormat(self, _cmd);
}





static void _logos_method$_ungrouped$SBRootFolderView$_coverSheetWillPresent$(_LOGOS_SELF_TYPE_NORMAL SBRootFolderView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1){
	if (!splashLabel) {
    	splashLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 300, 20)];
    	[splashLabel setTextColor:[UIColor colorWithRed:(250.0 / 255.0) green:(250.0 / 255.0) blue:(83.0 / 255.0) alpha:1.0]];
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
    [splashLabel setText:[allSplashes objectAtIndex:randInx]];
    _logos_orig$_ungrouped$SBRootFolderView$_coverSheetWillPresent$(self, _cmd, arg1);
}





static void _logos_method$_ungrouped$SparkAlwaysOnController$setScreenIsOn$withForceShow$(_LOGOS_SELF_TYPE_NORMAL SparkAlwaysOnController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, _Bool arg1, _Bool arg2){
    if (arg1){
        if (!splashLabel) {
    	    splashLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 300, 20)];
    	    [splashLabel setTextColor:[UIColor colorWithRed:(250.0 / 255.0) green:(250.0 / 255.0) blue:(83.0 / 255.0) alpha:1.0]];
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
        [splashLabel setText:[allSplashes objectAtIndex:randInx]];
        [splashLabel setHidden:FALSE];
        NSLog(@"NSLogify: %@", prefs);
    } else {
        [splashLabel setHidden:TRUE];
    }
    _logos_orig$_ungrouped$SparkAlwaysOnController$setScreenIsOn$withForceShow$(self, _cmd, arg1, arg2);
}




static __attribute__((constructor)) void _logosLocalCtor_369bbb28(int __unused argc, char __unused **argv, char __unused **envp){
    prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.samgisaninja.mcsplashprefs"];
    if (!prefs) {
        NSMutableDictionary *mutablePrefs = [[NSMutableDictionary alloc] init];
        [mutablePrefs setObject:@TRUE forKey:@"isEnabled"];
        [mutablePrefs setObject:@TRUE forKey:@"isEnabled"];
    }
    {Class _logos_class$_ungrouped$SpringBoard = objc_getClass("SpringBoard"); MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(applicationDidFinishLaunching:), (IMP)&_logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$, (IMP*)&_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SpringBoard, @selector(MCSCreateShrinkTimer), (IMP)&_logos_method$_ungrouped$SpringBoard$MCSCreateShrinkTimer, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SpringBoard, @selector(MCSGrowLabel), (IMP)&_logos_method$_ungrouped$SpringBoard$MCSGrowLabel, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SpringBoard, @selector(MCSShrinkLabel), (IMP)&_logos_method$_ungrouped$SpringBoard$MCSShrinkLabel, _typeEncoding); }Class _logos_class$_ungrouped$SBFLockScreenDateView = objc_getClass("SBFLockScreenDateView"); MSHookMessageEx(_logos_class$_ungrouped$SBFLockScreenDateView, @selector(updateFormat), (IMP)&_logos_method$_ungrouped$SBFLockScreenDateView$updateFormat, (IMP*)&_logos_orig$_ungrouped$SBFLockScreenDateView$updateFormat);Class _logos_class$_ungrouped$SBRootFolderView = objc_getClass("SBRootFolderView"); MSHookMessageEx(_logos_class$_ungrouped$SBRootFolderView, @selector(_coverSheetWillPresent:), (IMP)&_logos_method$_ungrouped$SBRootFolderView$_coverSheetWillPresent$, (IMP*)&_logos_orig$_ungrouped$SBRootFolderView$_coverSheetWillPresent$);Class _logos_class$_ungrouped$SparkAlwaysOnController = objc_getClass("SparkAlwaysOnController"); MSHookMessageEx(_logos_class$_ungrouped$SparkAlwaysOnController, @selector(setScreenIsOn:withForceShow:), (IMP)&_logos_method$_ungrouped$SparkAlwaysOnController$setScreenIsOn$withForceShow$, (IMP*)&_logos_orig$_ungrouped$SparkAlwaysOnController$setScreenIsOn$withForceShow$);}
}
