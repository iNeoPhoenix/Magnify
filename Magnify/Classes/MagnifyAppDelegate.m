//
//  MagnifyAppDelegate.m
//  Magnify
//
//  Created by Stéphane Chrétien on 29/07/09.
//  Copyright Cokoala 2009. All rights reserved.
//

#import "MagnifyAppDelegate.h"
#import "RootViewController.h"


@implementation MagnifyAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	// Window
	//self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
	//self.window.backgroundColor = [UIColor greenColor];
	
	// Create the root view controller
	m_RootViewController = [[RootViewController alloc] init];
	
	// Create a navigation controller using the new controller
	UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:m_RootViewController];
	
	// Add the navigation's view to the window
    window.rootViewController = navigationController;
    
    // Display the window
    [window makeKeyAndVisible];
	
	// If this is the first launch, we display a help alert
	NSInteger alreadyLaunched = [[NSUserDefaults standardUserDefaults] integerForKey:@"AlreadyLaunchedV3"]; // alreadyLaunched = 0 if it is the first time (AlreadyLaunched not defined)
	if (!alreadyLaunched) {
		UIAlertView* tutoAlert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TutoTitle", nil) 
													   message:NSLocalizedString(@"TutoMessage", nil) 
													   delegate:nil 
												       cancelButtonTitle:NSLocalizedString(@"TutoOk", nil) 
													   otherButtonTitles:nil] autorelease];
		[tutoAlert show];
		[[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"AlreadyLaunchedV3"]; // set AlreadyLaunched for next launches
	}
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[m_RootViewController save];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	NSLog(@"Warning memory warning...");
}

- (void)dealloc {
	[m_RootViewController	release];
    [window					release];
	
    [super dealloc];
}

@end
