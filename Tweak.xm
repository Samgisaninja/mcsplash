#include "CoreText/CTFontManager.h"

UILabel *splashLabel;
NSTimer *shrinkTimer;
NSTimer *growTimer;
NSTimer *delayShrinkTimer;
NSMutableDictionary *localPrefs;
BOOL updatedPreferencesForcibly;

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

%hook SpringBoard

-(void)applicationDidFinishLaunching:(id)arg1{
    
	if (!splashLabel) {
        NSDictionary *prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.samgisaninja.mcsplashprefs"];
        if ([[prefs objectForKey:@"splashSide"] isEqual:@(0)]) {
            splashLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 300, 20)];
            [splashLabel setTransform:CGAffineTransformMakeRotation(7 * -M_PI / 4)];
        } else {
            splashLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 300, 20)];
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
        [splashLabel setFont:[UIFont fontWithName:@"minecraft" size:11]];
        [splashLabel sizeToFit];

        
	}
    NSArray *allSplashes = [NSArray arrayWithContentsOfFile:@"/Library/Application Support/mcsplash/splashes.plist"];
    NSUInteger randInx = arc4random() % [allSplashes count];
    [splashLabel setText:[allSplashes objectAtIndex:randInx]];
    NSDictionary *prefs;
    if (updatedPreferencesForcibly) {
        prefs = [NSDictionary dictionaryWithDictionary:localPrefs];
    } else {
        prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.samgisaninja.mcsplashprefs"];
    }
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
    NSDictionary *prefs;
    if (updatedPreferencesForcibly) {
        prefs = [NSDictionary dictionaryWithDictionary:localPrefs];
    } else {
        prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.samgisaninja.mcsplashprefs"];
    }
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

%end

%hook SBFLockScreenDateView


-(void)updateFormat{
    [self addSubview:splashLabel];
    NSDictionary *prefs;
    if (updatedPreferencesForcibly) {
        prefs = [NSDictionary dictionaryWithDictionary:localPrefs];
    } else {
        prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.samgisaninja.mcsplashprefs"];
    }
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
        NSDictionary *prefs;
    if (updatedPreferencesForcibly) {
        prefs = [NSDictionary dictionaryWithDictionary:localPrefs];
    } else {
        prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.samgisaninja.mcsplashprefs"];
    }
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
    if (![localPrefs objectForKey:@"hideDate"]){
        NSLog(@"NSLOGIFY: created object hideDate");
        [localPrefs setObject:@FALSE forKey:@"hideDate"];
        [[NSFileManager defaultManager] removeItemAtPath:@"/var/mobile/Library/Preferences/com.samgisaninja.mcsplashprefs.plist" error:nil];
        [localPrefs writeToFile:@"/var/mobile/Library/Preferences/com.samgisaninja.mcsplashprefs.plist" atomically:TRUE];
        updatedPreferencesForcibly = FALSE;
    }
    if (![localPrefs objectForKey:@"hypShow"]){
        NSLog(@"NSLOGIFY: created object hypShow");
        [localPrefs setObject:@FALSE forKey:@"hypShow"];
        [[NSFileManager defaultManager] removeItemAtPath:@"/var/mobile/Library/Preferences/com.samgisaninja.mcsplashprefs.plist" error:nil];
        [localPrefs writeToFile:@"/var/mobile/Library/Preferences/com.samgisaninja.mcsplashprefs.plist" atomically:TRUE];
        updatedPreferencesForcibly = FALSE;
    }
    if ([[localPrefs objectForKey:@"isEnabled"] boolValue]) {
        NSLog(@"NSLOGIFY: initializing...");
        %init;
    } 
}
