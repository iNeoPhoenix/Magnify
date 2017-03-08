//
//  RootView.m
//  Magnify
//
//  Created by Stéphane Chrétien on 30/07/09.
//  Copyright 2009 Cokoala. All rights reserved.
//

#import "RootView.h"
#import "MagnifyNotifications.h"

@implementation RootView

const NSInteger touchZoneBound = 60;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		m_Value = 0;
		
		m_IsFullScreen = NO;
		
		self.backgroundColor = [UIColor clearColor];
		
		m_FrontView = [[UIView alloc] initWithFrame:frame];

		UIImageView* backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Fond.png"]];
		[m_FrontView addSubview:backImageView];
		[backImageView release];

		UIImageView* backImageViewFullScreen = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FondFullScreen.png"]];
		[self addSubview:backImageViewFullScreen];
		[backImageViewFullScreen release];
		
		UIImageView* outlineShadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ContourOmbre.png"]];
		[m_FrontView addSubview:outlineShadowImageView];
		[outlineShadowImageView release];
		
		// note : rotation center : (160, 240)
		m_SliderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Slider.png"]];
		m_SliderImageView.userInteractionEnabled = YES;
		[m_FrontView addSubview:m_SliderImageView];
		self.value = m_Value;
		
		m_SliderImageViewFullScreen = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SliderFullScreen.png"]];
		m_SliderImageViewFullScreen.userInteractionEnabled = YES;
		[self addSubview:m_SliderImageViewFullScreen];
		
		UIImageView* outlineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Contour.png"]];
		[m_FrontView addSubview:outlineImageView];
		[outlineImageView release];
		
		m_MessageBox = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MessageBox.png"]];
		m_MessageBox.frame = CGRectMake(60, 200, 200, 40);
		[self addSubview:m_MessageBox];
		m_MessageBox.hidden = YES;
		
		m_Label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
		m_Label.textColor = [UIColor blackColor];
		m_Label.font = [UIFont systemFontOfSize:20];
		m_Label.textAlignment = UITextAlignmentCenter;
		m_Label.backgroundColor = [UIColor clearColor];
		[m_MessageBox addSubview:m_Label];
		
		[self addSubview:m_FrontView];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
}

- (void)dealloc {
	[m_SliderImageView				release];
	[m_SliderImageViewFullScreen	release];
	[m_FrontView					release];
	[m_MessageBox					release];
	[m_Label						release];
    [super dealloc];
}

#pragma mark Properties
- (CGFloat)value {
	return m_Value;
}

- (void)setValue:(CGFloat)value {
	if (value < 0.) value = 0.;
	if (value > 1.) value = 1.;
	
	m_Value = value;
	m_SliderImageView.transform = CGAffineTransformMakeRotation(m_Value * -90. * M_PI/180.);
	m_SliderImageViewFullScreen.transform = CGAffineTransformMakeRotation(m_Value * -90. * M_PI/180.);
}

#pragma mark UIView methods
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:self];
	
	CGFloat currentPixelPosition = self.value * 304 + 8;
	CGFloat touchedPixelPosition = location.x;
	
	if ((location.y > 285) && (location.y < 460)) {
		if ((touchedPixelPosition > 8) && (touchedPixelPosition < 311)) {
			if ((currentPixelPosition > touchedPixelPosition - touchZoneBound) && (currentPixelPosition < touchedPixelPosition + touchZoneBound)) {
				self.value = (location.x - 8) / 304.;
				[[NSNotificationCenter defaultCenter] postNotificationName:sliderChangeNtf object:nil];
			}
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	if (touch.tapCount == 2) {
		m_IsFullScreen = !m_IsFullScreen;
		[[NSNotificationCenter defaultCenter] postNotificationName:sliderChangeNtf object:nil];
		[self setFullScreenMode:m_IsFullScreen animated:YES];
	}
}

#pragma mark Public methods
- (void)setFullScreenMode:(BOOL)isFullScreen animated:(BOOL)animated {
	m_FrontView.hidden = (isFullScreen)? YES : NO;
	
	if (animated) {
		NSString* message = (isFullScreen) ? NSLocalizedString(@"FullScreenIn", nil) : NSLocalizedString(@"FullScreenOut", nil);
		
		m_Label.text = message;
		m_MessageBox.alpha = 0.8;
		m_MessageBox.hidden = NO;
		m_MessageBox.transform = CGAffineTransformMakeScale(0.01, 0.01);
		
		[UIView beginAnimations:@"FullScreenAnimation" context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(firstHalfAnimationDidStop:finished:context:)];
		[UIView setAnimationDuration:0.15];
		
		m_MessageBox.transform = CGAffineTransformMakeScale(1., 1.);
		
		[UIView commitAnimations];
	}
}

- (void)firstHalfAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	
	[UIView beginAnimations:@"FullScreenAnimation" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(secondHalfAnimationDidStop:finished:context:)];
	[UIView setAnimationDuration:.9];
	
	m_MessageBox.alpha = 0.;
	
	[UIView commitAnimations];
	
}

- (void)secondHalfAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	m_MessageBox.hidden = YES;
}

@end
