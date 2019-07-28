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

%hook SpringBoard

-(void)applicationDidFinishLaunching:(id)arg1{
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
    %orig;
}

%new
-(void)MCSCreateShrinkTimer{
    if (!shrinkTimer) {
        shrinkTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(MCSShrinkLabel) userInfo:nil repeats:YES];
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
        NSLog(@"NSLogify: %@", prefs);
    } else {
        [splashLabel setHidden:TRUE];
    }
    %orig;
}

%end


%ctor{
    prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.samgisaninja.mcsplashprefs"];
    if (!prefs) {
        NSMutableDictionary *mutablePrefs = [[NSMutableDictionary alloc] init];
        [mutablePrefs setObject:@TRUE forKey:@"isEnabled"];
        [mutablePrefs setObject:@TRUE forKey:@"isEnabled"];
    }
    %init;
}
