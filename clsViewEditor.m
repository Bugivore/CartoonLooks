//
//  clsViewEditor.m
//  FotoKartoon
//
//  Created by Vishalsinh Jhala on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "clsViewEditor.h"
#import <QuartzCore/QuartzCore.h>

@interface clsViewEditor ()

@end

@implementation clsViewEditor
@synthesize m_vwCanvas;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.trackedViewName = @"Editor Screen";

    m_vwCanvas = [[clsEditor alloc] initWithFrame:self.view.frame];
    
    
    [m_vwCanvas.layer setCornerRadius:10.0f];
    self.view.backgroundColor = [UIColor colorWithRed:66/255.0 green:66/255.0 blue:66/255.0 alpha:1.0f];

    m_vwCanvas.backgroundColor = [UIColor lightGrayColor];

    [self.view addSubview:m_vwCanvas];
    
    [self createAdBannerView];
    [self.view addSubview:adBannerView];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    m_vwCanvas.frame = self.view.frame;
    //m_vwCanvas.frame = CGRectMake(10,54,self.view.frame.size.width-20,self.view.frame.size.height-64);
    
    
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.

}
-(void)JSConstructor
{
    
}
-(void)JSDestructor
{
    //pInfoView = NULL;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)MakeAvatar:(clsDataFace*)inFace:(Boolean)bIsMale:(float) fExposure:(int) iIsoSpeed
{
    for (UIView *view in m_vwCanvas.subviews) {
        [view removeFromSuperview];
    }

    
    [m_vwCanvas MakeAvatar:inFace :bIsMale  :fExposure :iIsoSpeed];
}
- (void) createAdBannerView
{
    adBannerView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    CGRect bannerFrame = adBannerView.frame;
    bannerFrame.origin.y = self.view.frame.size.height;
    adBannerView.frame = bannerFrame;
    
    adBannerView.delegate = self;
    adBannerView.requiredContentSizeIdentifiers = [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];
}
- (void) adjustBannerView
{
    CGRect contentViewFrame = self.view.bounds;
    CGRect adBannerFrame = adBannerView.frame;
    
    if([adBannerView isBannerLoaded])
    {
        CGSize bannerSize = [ADBannerView sizeFromBannerContentSizeIdentifier:adBannerView.currentContentSizeIdentifier];
        contentViewFrame.size.height = contentViewFrame.size.height - bannerSize.height;
        adBannerFrame.origin.y = contentViewFrame.size.height;
    }
    else
    {
        adBannerFrame.origin.y = contentViewFrame.size.height;
    }
    [UIView animateWithDuration:0.5 animations:^{
        adBannerView.frame = adBannerFrame;
        self.view.frame = contentViewFrame;
    }];
}
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [self adjustBannerView];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [self adjustBannerView];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
}
@end
