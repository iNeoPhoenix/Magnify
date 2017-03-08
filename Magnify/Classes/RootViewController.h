//
//  RootViewController.h
//  Magnify
//
//  Created by Stéphane Chrétien on 30/07/09.
//  Copyright 2009 Cokoala. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootView;

@interface RootViewController : UIViewController {
	RootView*	m_RootView;
	CGFloat		m_Value;
}

- (void)onSlideChangeCB;
- (void)save;
- (void)updateScale;

@end
