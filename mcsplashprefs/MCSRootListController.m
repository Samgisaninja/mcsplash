#include "MCSRootListController.h"
#import <spawn.h>

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
	if (@available(iOS 11, *)){
		pid_t pid;
    	const char* args[] = {"sbreload", NULL};
    	posix_spawn(&pid, "/usr/bin/sbreload", NULL, NULL, (char* const*)args, NULL);
	} else {
		pid_t pid;
    	const char* args[] = {"killall", "backboardd", NULL};
    	posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
	}
}

@end
