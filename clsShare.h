//
//  clsViewEditor.h
//  FotoKartoon
//
//  Created by Vishalsinh Jhala on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "clsDataFace.h"
#import "LoadingView.h"
#import <MessageUI/MessageUI.h>
#import "GAITrackedViewController.h"

@interface clsShare : GAITrackedViewController <MFMailComposeViewControllerDelegate,NSURLConnectionDelegate>

{
    UIImageView *m_imgViewInPhoto;
    //clsFeedback *m_vwFeedback;
    UIAlertView *m_alertTweet;
    UIAlertView *m_alertFB;
    //Boolean bDelCrashLog;
    //NSMutableArray *arrStarButton;
    //int iUserRating;
    //clsDataFeedback *m_dataFB;
    UIAlertView *m_alert;



}
@end
