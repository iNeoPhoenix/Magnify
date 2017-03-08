//
//  MagnifyAppDelegate.h
//  Magnify
//
//  Created by Stéphane Chrétien on 29/07/09.
//  Copyright Cokoala 2009. All rights reserved.
//

#import <UIKit/UIKit.h>


@class RootViewController;

@interface MagnifyAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow*			window;
	RootViewController* m_RootViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
