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


%hook SpringBoard

-(void)applicationDidFinishLaunching:(id)arg1{
    
	if (!splashLabel) {
        NSDictionary *prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.samgisaninja.mcsplashprefs"];
        splashLabel = [[UILabel alloc] initWithFrame:CGRectMake([self MCSxOffset], [self MCSyOffset], 300, 20)];
        if ([[prefs objectForKey:@"splashSide"] isEqual:@(0)]) {
            [splashLabel setTransform:CGAffineTransformMakeRotation(7 * -M_PI / 4)];
        } else {
            [splashLabel setTransform:CGAffineTransformMakeRotation(-M_PI / 4)];            
        }
    	
    	[splashLabel setTextColor:[UIColor colorWithRed:(250.0 / 255.0) green:(250.0 / 255.0) blue:(83.0 / 255.0) alpha:1.0]];
    	[splashLabel setBackgroundColor:[UIColor clearColor]];
        
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
    [splashLabel setText:[allSplashes objectAtIndex:randInx]];
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
    
    %orig;
}

%new
-(void)MCSCreateShrinkTimer{
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

%new
-(void)MCSGrowLabel{
    [UIView animateWithDuration:0.25 animations:^{
        [splashLabel setTransform:CGAffineTransformScale([splashLabel transform], 1.25, 1.25)];
        [splashLabel setCenter:[splashLabel center]];
    } completion:^(BOOL finished) {
        [splashLabel sizeToFit];
    }];
}

%new
-(void)MCSShrinkLabel{
    [UIView animateWithDuration:0.25 animations:^{
        [splashLabel setTransform:CGAffineTransformScale([splashLabel transform], 0.8, 0.8)];
        [splashLabel setCenter:[splashLabel center]];
    } completion:^(BOOL finished) {
        [splashLabel sizeToFit];
    }];
}

%new 
-(float)MCSxOffset{
    NSDictionary *prefs;
    prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.samgisaninja.mcsplashprefs"];
    if ([prefs objectForKey:@"xOff"]){
        if ([[prefs objectForKey:@"splashSide"] isEqual:@(0)]) {
            return [[prefs objectForKey:@"xOff"] floatValue] - 100;
        } else {
            return [[prefs objectForKey:@"xOff"] floatValue] + 100;
        }
    } else {
        if ([[prefs objectForKey:@"splashSide"] isEqual:@(0)]) {
            return -100;
        } else {
            return 100;
        }
    }
}

%new 
-(float)MCSyOffset{
    NSDictionary *prefs;
    prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.samgisaninja.mcsplashprefs"];
    if ([prefs objectForKey:@"yOff"]){
        return [[prefs objectForKey:@"yOff"] floatValue]+ 100;
    } else {
        return 100;
    }
}

%end

%hook SBFLockScreenDateView


-(void)updateFormat{
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
    %orig;
}

%end

%hook SBRootFolderView

-(void)_coverSheetWillPresent:(id)arg1{
    NSDictionary *prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.samgisaninja.mcsplashprefs"];
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
	}
    NSArray *allSplashes = [NSArray arrayWithContentsOfFile:@"/Library/Application Support/mcsplash/splashes.plist"];
    NSUInteger randInx = arc4random() % [allSplashes count];
    [splashLabel setText:[allSplashes objectAtIndex:randInx]];
    [UIView animateWithDuration:0.1 animations:^{
        [splashLabel setTransform:CGAffineTransformScale([splashLabel transform], 1.0, 1.0)];
        [splashLabel setCenter:[splashLabel center]];
        } completion:^(BOOL finished) {
            [splashLabel sizeToFit];
        }];
    %orig;
}

%end

%hook SparkAlwaysOnController

- (void)setScreenIsOn:(_Bool)arg1 withForceShow:(_Bool)arg2{
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
    } else {
        NSDictionary *prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.samgisaninja.mcsplashprefs"];
        if (![[prefs objectForKey:@"hypShow"] boolValue]) {
            [splashLabel setHidden:TRUE];
        }
    }
    %orig;
}

%end


%ctor{
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
        %init;
    }
}
