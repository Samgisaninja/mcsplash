#include "CoreText/CTFontManager.h"

UILabel *splashLabel;
NSTimer *shrinkTimer;
NSTimer *growTimer;
NSTimer *delayShrinkTimer;

@interface SBLockScreenDateViewController : UIViewController
-(float)MCSxOffset;
-(float)MCSyOffset;
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

%hook SBLockScreenDateViewController

-(void)viewDidLoad{
    NSDictionary *prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.samgisaninja.mcsplashprefs"];
    if (!splashLabel) {
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

-(void)viewDidAppear:(BOOL)animated{
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
    [[self view] addSubview:splashLabel];
    NSDictionary *prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.samgisaninja.mcsplashprefs"];
    if ([[prefs objectForKey:@"hideDate"] boolValue]) {
        SBFLockScreenDateSubtitleDateView *dateView = MSHookIvar<SBFLockScreenDateSubtitleDateView *>([self view], "_dateSubtitleView");
        [dateView setHidden:TRUE];
    } else {
        SBFLockScreenDateSubtitleDateView *dateView = MSHookIvar<SBFLockScreenDateSubtitleDateView *>([self view], "_dateSubtitleView");
        [dateView setHidden:FALSE];
    }
    if ([[prefs objectForKey:@"hideTime"] boolValue]) {
        SBUILegibilityLabel *timeView = MSHookIvar<SBUILegibilityLabel *>([self view], "_timeLabel");
        [timeView setHidden:TRUE];
    } else {
        SBUILegibilityLabel *timeView = MSHookIvar<SBUILegibilityLabel *>([self view], "_timeLabel");
        [timeView setHidden:FALSE];
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

%hook SparkAlwaysOnController

- (void)setScreenIsOn:(_Bool)arg1 withForceShow:(_Bool)arg2{
    if (arg1){
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
    %orig;
}

%end


%ctor{
    NSDictionary *prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.samgisaninja.mcsplashprefs"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL firstLoad = FALSE;
    NSMutableDictionary *mutablePrefs = [[NSMutableDictionary alloc] init];
    if (!prefs) {
        [mutablePrefs setObject:@TRUE forKey:@"isEnabled"];
        [mutablePrefs setObject:@TRUE forKey:@"enableAnimations"];
        [mutablePrefs setObject:@FALSE forKey:@"hideTime"];
        [mutablePrefs setObject:@FALSE forKey:@"hideDate"];
        [mutablePrefs setObject:@FALSE forKey:@"hypShow"];
        [mutablePrefs setObject:@(1) forKey:@"splashSide"];
        [mutablePrefs setObject:@TRUE forKey:@"blockAFont"];
        [mutablePrefs setObject:@(0) forKey:@"xOff"];
        [mutablePrefs setObject:@(0) forKey:@"yOff"];
        [defaults setPersistentDomain:mutablePrefs forName:@"com.samgisaninja.mcsplashprefs"];
        firstLoad = TRUE;
    } else {
        if (![[prefs allKeys] containsObject:@"isEnabled"]){
            [mutablePrefs setObject:@TRUE forKey:@"isEnabled"];
            [defaults setPersistentDomain:mutablePrefs forName:@"com.samgisaninja.mcsplashprefs"];
            firstLoad = TRUE;
        }
        if (![[prefs allKeys] containsObject:@"enableAnimations"]){
            [mutablePrefs setObject:@TRUE forKey:@"enableAnimations"];
            [defaults setPersistentDomain:mutablePrefs forName:@"com.samgisaninja.mcsplashprefs"];
        }
        if (![[prefs allKeys] containsObject:@"hideTime"]){
            [mutablePrefs setObject:@FALSE forKey:@"hideTime"];
            [defaults setPersistentDomain:mutablePrefs forName:@"com.samgisaninja.mcsplashprefs"];
        }
        if (![[prefs allKeys] containsObject:@"hideDate"]){
            [mutablePrefs setObject:@FALSE forKey:@"hideDate"];
            [defaults setPersistentDomain:mutablePrefs forName:@"com.samgisaninja.mcsplashprefs"];
        }
        if (![[prefs allKeys] containsObject:@"hypShow"]){
            [mutablePrefs setObject:@FALSE forKey:@"hypShow"];
            [defaults setPersistentDomain:mutablePrefs forName:@"com.samgisaninja.mcsplashprefs"];
        }
        if (![[prefs allKeys] containsObject:@"splashSide"]){
            [mutablePrefs setObject:@(1) forKey:@"splashSide"];
            [defaults setPersistentDomain:mutablePrefs forName:@"com.samgisaninja.mcsplashprefs"];
        }
        if (![[prefs allKeys] containsObject:@"blockAFont"]){
            [mutablePrefs setObject:@TRUE forKey:@"blockAFont"];
            [defaults setPersistentDomain:mutablePrefs forName:@"com.samgisaninja.mcsplashprefs"];
        }
        if (![[prefs allKeys] containsObject:@"xOff"]){
            [mutablePrefs setObject:@(0) forKey:@"xOff"];
            [defaults setPersistentDomain:mutablePrefs forName:@"com.samgisaninja.mcsplashprefs"];
        }
        if (![[prefs allKeys] containsObject:@"yOff"]){
            [mutablePrefs setObject:@(0) forKey:@"yOff"];
            [defaults setPersistentDomain:mutablePrefs forName:@"com.samgisaninja.mcsplashprefs"];
        }
    }
    if ([[prefs objectForKey:@"isEnabled"] boolValue] || firstLoad) {
        %init;
    }
}
