#include "CoreText/CTFontManager.h"
UILabel *splashLabel;
NSTimer *shrinkTimer;
NSTimer *growTimer;
NSTimer *delayShrinkTimer;
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
        CFErrorRef error;
        CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)fontData);
        CGFontRef font = CGFontCreateWithDataProvider(provider);
        if (! CTFontManagerRegisterGraphicsFont(font, &error)) {
            CFStringRef errorDescription = CFErrorCopyDescription(error);
            NSLog(@"Failed to load font: %@", errorDescription);
            CFRelease(errorDescription);
        }
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

-(void)_coverSheetWillDismiss:(id)arg1{
	%orig;
    [shrinkTimer invalidate];
    [growTimer invalidate];
    [delayShrinkTimer invalidate];
}

-(void)_coverSheetWillPresent:(id)arg1{
	if (!splashLabel) {
    	splashLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 300, 20)];
    	[splashLabel setTextColor:[UIColor colorWithRed:(250.0 / 255.0) green:(250.0 / 255.0) blue:(83.0 / 255.0) alpha:1.0]];
    	[splashLabel setBackgroundColor:[UIColor clearColor]];
        [splashLabel setTransform:CGAffineTransformMakeRotation(-M_PI / 4)];
        NSData *fontData = [NSData dataWithContentsOfFile:@"/Library/Application Support/mcsplash/minecraft.ttf"];
        CFErrorRef error;
        CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)fontData);
        CGFontRef font = CGFontCreateWithDataProvider(provider);
        if (! CTFontManagerRegisterGraphicsFont(font, &error)) {
            CFStringRef errorDescription = CFErrorCopyDescription(error);
            NSLog(@"Failed to load font: %@", errorDescription);
            CFRelease(errorDescription);
        }
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

%end
