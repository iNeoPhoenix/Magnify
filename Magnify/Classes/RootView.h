//
//  RootView.h
//  Magnify
//
//  Created by Stéphane Chrétien on 30/07/09.
//  Copyright 2009 Cokoala. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RootView : UIView {
	UIView*			m_FrontView;
	UIImageView*	m_SliderImageView;
	UIImageView*	m_SliderImageViewFullScreen;
	
	UIImageView*	m_MessageBox;
	UILabel*		m_Label;
	
	CGFloat			m_Value;
	BOOL			m_IsFullScreen;
}

@property(assign)CGFloat value;

- (void)setFullScreenMode:(BOOL)isFullScreen animated:(BOOL)animated;

@end
