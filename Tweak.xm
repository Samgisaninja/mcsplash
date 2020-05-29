#include "CoreText/CTFontManager.h"
#import <Cephei/HBPreferences.h>

UILabel *splashLabel;
NSTimer *shrinkTimer;
NSTimer *growTimer;
NSTimer *delayShrinkTimer;

@interface SBLockScreenDateViewController : UIViewController
-(float)MCSxOffset;
-(float)MCSyOffset;
@end

@interface SBFLockScreenDateViewController : UIViewController
-(float)MCSxOffset;
-(float)MCSyOffset;
-(UIView *)dateView;
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


BOOL isEnabled;
BOOL enableAnimations;
NSInteger splashSide;
NSInteger xOff;
NSInteger yOff;
NSInteger rotation;
NSInteger textSize;
BOOL hideTime;
BOOL hideDate;
BOOL hypShow;
BOOL blockAFont;

%group iosTwelve

%hook SBLockScreenDateViewController

-(void)viewDidLoad{
    if (!splashLabel) {
        splashLabel = [[UILabel alloc] initWithFrame:CGRectMake([self MCSxOffset], [self MCSyOffset], 300, 20)];
        [splashLabel setTransform:CGAffineTransformMakeRotation(rotation * -M_PI / 180)];
        NSData *fontData = [NSData dataWithContentsOfFile:@"/Library/Application Support/mcsplash/minecraft.otf"];
        CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)fontData);
        CGFontRef font = CGFontCreateWithDataProvider(provider);
        CTFontManagerRegisterGraphicsFont(font, nil);
        CFRelease(font);
        CFRelease(provider);
        if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/AFont.dylib"] && blockAFont) {
            [splashLabel setFont:[UIFont fontWithNameWithoutAFont:@"minecraft" size:textSize]];
        } else {
            [splashLabel setFont:[UIFont fontWithName:@"minecraft" size:textSize]];
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
    if (enableAnimations) {
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
    if (hideDate) {
        SBFLockScreenDateSubtitleDateView *dateView = MSHookIvar<SBFLockScreenDateSubtitleDateView *>([self view], "_dateSubtitleView");
        [dateView setHidden:TRUE];
    } else {
        SBFLockScreenDateSubtitleDateView *dateView = MSHookIvar<SBFLockScreenDateSubtitleDateView *>([self view], "_dateSubtitleView");
        [dateView setHidden:FALSE];
    }
    if (hideTime) {
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
    if (!shrinkTimer) {
        if (enableAnimations) {
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
    if (xOff){
        if (splashSide == 0) {
            return xOff - deviceConst;
        } else {
            return xOff + deviceConst;
        }
    } else {
        if (splashSide == 0) {
            return -deviceConst;
        } else {
            return deviceConst;
        }
    }
}

%new 
-(float)MCSyOffset{
    if (yOff){
        return yOff + 100;
    } else {
        return 100;
    }
}

%end

%end

%group iosThirteen

%hook SBFLockScreenDateViewController

-(void)viewDidLoad{
    if (!splashLabel) {
        splashLabel = [[UILabel alloc] initWithFrame:CGRectMake([self MCSxOffset], [self MCSyOffset], 300, 20)];
        [splashLabel setTransform:CGAffineTransformMakeRotation(rotation * -M_PI / 180)];
        NSData *fontData = [NSData dataWithContentsOfFile:@"/Library/Application Support/mcsplash/minecraft.otf"];
        CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)fontData);
        CGFontRef font = CGFontCreateWithDataProvider(provider);
        CTFontManagerRegisterGraphicsFont(font, nil);
        CFRelease(font);
        CFRelease(provider);
        if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/AFont.dylib"] && blockAFont) {
            [splashLabel setFont:[UIFont fontWithNameWithoutAFont:@"minecraft" size:textSize]];
        } else {
            [splashLabel setFont:[UIFont fontWithName:@"minecraft" size:textSize]];
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
    if (enableAnimations) {
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
    [[self dateView] addSubview:splashLabel];
    if (hideDate) {
        SBFLockScreenDateSubtitleDateView *dateView = MSHookIvar<SBFLockScreenDateSubtitleDateView *>([self view], "_dateSubtitleView");
        [dateView setHidden:TRUE];
    } else {
        SBFLockScreenDateSubtitleDateView *dateView = MSHookIvar<SBFLockScreenDateSubtitleDateView *>([self view], "_dateSubtitleView");
        [dateView setHidden:FALSE];
    }
    if (hideTime) {
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
    if (!shrinkTimer) {
        if (enableAnimations) {
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
    if (xOff){
        if (splashSide == 0) {
            return xOff - deviceConst;
        } else {
            return xOff + deviceConst;
        }
    } else {
        if (splashSide == 0) {
            return -deviceConst;
        } else {
            return deviceConst;
        }
    }
}

%new 
-(float)MCSyOffset{
    if (yOff){
        return yOff + 100;
    } else {
        return 100;
    }
}

%end

%end

%group hyperionCompat

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
        if (!hypShow) {
            [splashLabel setHidden:TRUE];
        }
    }
    %orig;
}

%end

%end


%ctor{
    HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:@"com.samgisaninja.mcsplashprefs"];
    [prefs registerBool:&isEnabled default:TRUE forKey:@"isEnabled"];
    [prefs registerBool:&enableAnimations default:TRUE forKey:@"enableAnimations"];
    [prefs registerInteger:&splashSide default:1 forKey:@"splashSide"];
    [prefs registerInteger:&xOff default:0 forKey:@"xOff"];
    [prefs registerInteger:&yOff default:0 forKey:@"yOff"];
    [prefs registerInteger:&rotation default:0 forKey:@"rotation"];
    [prefs registerInteger:&textSize default:11 forKey:@"textSize"];
    [prefs registerBool:&hideTime default:FALSE forKey:@"hideTime"];
    [prefs registerBool:&hideDate default:FALSE forKey:@"hideDate"];
    [prefs registerBool:&hypShow default:FALSE forKey:@"hypShow"];
    [prefs registerBool:&blockAFont default:TRUE forKey:@"blockAFont"];
    if (isEnabled) {
        if (kCFCoreFoundationVersionNumber >= 1600) {
            %init(iosThirteen);
        } else {
           %init(iosTwelve);
        }
        %init(hyperionCompat);
    }
    
}
