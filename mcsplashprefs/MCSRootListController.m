#include "MCSRootListController.h"
#import "NSTask.h"

@implementation MCSRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

- (void)openGithub{
	NSDictionary *URLOptions = @{UIApplicationOpenURLOptionUniversalLinksOnly : @FALSE};
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.github.com/Samgisaninja/"] options:URLOptions completionHandler:nil];
}

- (void)openMyReddit{
	NSDictionary *URLOptions = @{UIApplicationOpenURLOptionUniversalLinksOnly : @FALSE};
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.reddit.com/u/Samg_is_a_Ninja"] options:URLOptions completionHandler:nil];
}

- (void)sendMail{
	NSDictionary *URLOptions = @{UIApplicationOpenURLOptionUniversalLinksOnly : @FALSE};
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:stgardner4@att.net"] options:URLOptions completionHandler:nil];
}

- (void)giveMeMoney{
	NSDictionary *URLOptions = @{UIApplicationOpenURLOptionUniversalLinksOnly : @FALSE};
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.me/SamGardner4"] options:URLOptions completionHandler:nil];
}

-(void)respringDevice{
	NSTask *respringTask = [[NSTask alloc] init];
	if ([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/bin/sbreload"]){
		[respringTask setLaunchPath:@"/usr/bin/sbreload"];
		[respringTask launch];
	} else {
		[respringTask setLaunchPath:@"/usr/bin/killall"];
		NSArray *respringArgs = [NSArray arrayWithObjects:@"-9", @"SpringBoard", nil];
		[respringTask setArguments:respringArgs];
		[respringTask launch];
	}
}

@end
