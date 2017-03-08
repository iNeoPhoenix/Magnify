//
//  RootViewController.m
//  Magnify
//
//  Created by Stéphane Chrétien on 30/07/09.
//  Copyright 2009 Cokoala. All rights reserved.
//

#import "RootViewController.h"
#import "RootView.h"
#import "MagnifyNotifications.h"


@implementation RootViewController

- (id)init {
    if (self = [super initWithNibName:nil bundle:nil]) {
        // Create the custom view
		m_RootView = [[RootView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		//self.view = m_RootView; //TODO : Remove this line
		self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
		self.view.backgroundColor = [UIColor redColor];
		
		// Retrieved stored value to set start up state
		m_Value = [[NSUserDefaults standardUserDefaults] floatForKey:@"MagnifyValue"];
		m_RootView.value = m_Value;
		
		// Listen to UI notifications
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSlideChangeCB) name:sliderChangeNtf object:nil];
		
    }
    return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[m_RootView release];
    [super		dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
	// Check if the Camera is available
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		// Display the UIImagePickerController
		UIImagePickerController* picker = [[UIImagePickerController alloc] init]; 
		picker.sourceType = UIImagePickerControllerSourceTypeCamera; 
		picker.showsCameraControls = NO;
		picker.videoQuality = UIImagePickerControllerQualityTypeHigh;
		picker.cameraOverlayView = m_RootView;
		[self presentModalViewController:picker animated:NO];
		[self updateScale];
		
	} else {
		// Display an error message, this should never arrive
		UIAlertView* errorAlert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ErrorTitle", nil) 
															  message:NSLocalizedString(@"ErrorMessage", nil) 
															 delegate:nil 
													cancelButtonTitle:NSLocalizedString(@"ErrorOk", nil) 
													otherButtonTitles:nil] autorelease];
		[errorAlert show];
	}
	
	
}
/*	
- (void)viewDidAppear:(BOOL)animated {
	[self updateScale];
	[super viewDidAppear:animated];
}
*/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark Specific methods
- (void)onSlideChangeCB {
	// Get slider value
	m_Value = m_RootView.value;
	
	// Upate magnifying value
	[self updateScale];
}

- (void)save {
	[[NSUserDefaults standardUserDefaults] setFloat:m_Value forKey:@"MagnifyValue"];
}

- (void)updateScale {
	// Compute scale
	CGFloat scale = m_Value * 4 + 1.25;
	
	// Compute the corresponding transform
	CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
	
	// Set the transform to the view
	UIImagePickerController* cameraController = (UIImagePickerController*)self.modalViewController;
	cameraController.cameraViewTransform = transform;
}

@end
