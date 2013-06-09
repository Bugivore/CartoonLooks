//
//  clsViewEditor.h
//  FotoKartoon
//
//  Created by Vishalsinh Jhala on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "clsDataFace.h"
#import "clsEditor.h"
#import <iAd/iAd.h>
#import "GAITrackedViewController.h"

@interface clsViewEditor : GAITrackedViewController <ADBannerViewDelegate>
{
    ADBannerView *adBannerView;
    

}
-(void)MakeAvatar:(clsDataFace*)inFace:(Boolean)bIsMale:(float) fExposure:(int) iIsoSpeed;

@property clsEditor* m_vwCanvas;

@end
