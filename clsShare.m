//
//  clsViewEditor.m
//  FotoKartoon
//
//  Created by Vishalsinh Jhala on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "clsShare.h"
#import <QuartzCore/QuartzCore.h>
#import "clsViewEditor.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "GAI.h"
#import "clsAppDelegate.h"


@interface clsShare ()

@property(nonatomic, assign) clsAppDelegate *appDelegate;


@end

@implementation clsShare

-(void) viewWillAppear:(BOOL)animated
{
    clsViewEditor* viewEdit = (clsViewEditor*)[self.tabBarController.viewControllers objectAtIndex:1];
    m_imgViewInPhoto.image = [viewEdit.m_vwCanvas GetCurrentEffect];

    viewEdit = nil;
    //data = nil;
    
    /*iUserRating = -1;
    for(int j=0;j<5;j++)
    {
        UIButton* btn = [arrStarButton objectAtIndex:j];
        [btn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"StarRating0" ofType:@"png"]] forState:UIControlStateNormal];
    }
*/

    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //m_vwFeedback = nil;
    //bDelCrashLog = FALSE;
    self.trackedViewName = @"Share Screen";

    self.appDelegate = [UIApplication sharedApplication].delegate;
    self.view.backgroundColor = [UIColor lightGrayColor];

    UIView *vwPhoto = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.1, 10, self.view.frame.size.width*0.8, self.view.frame.size.height*0.7)];
    
    vwPhoto.backgroundColor = [UIColor whiteColor];
    vwPhoto.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    vwPhoto.clipsToBounds = TRUE;
    vwPhoto.layer.masksToBounds = NO;
    //vwPhoto.layer.cornerRadius = 10; // if you like rounded corners
    vwPhoto.layer.shadowOffset = CGSizeMake(0, 0);
    vwPhoto.layer.shadowRadius = 5;
    vwPhoto.layer.shadowOpacity = 1;

    [self.view addSubview:vwPhoto];
    
    m_imgViewInPhoto = [UIImageView new];
    m_imgViewInPhoto.contentMode=UIViewContentModeScaleAspectFit;
    m_imgViewInPhoto.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0f];
    m_imgViewInPhoto.clipsToBounds = TRUE;

    int iSpace = 5;
    int iButtonH = vwPhoto.frame.size.height+20;
    m_imgViewInPhoto.frame = CGRectMake(10, 10, vwPhoto.frame.size.width-20, vwPhoto.frame.size.height-60);
    m_imgViewInPhoto.layer.borderColor = [UIColor blackColor].CGColor;
    m_imgViewInPhoto.layer.borderWidth = 1.0;
    
    [vwPhoto addSubview:m_imgViewInPhoto];
    
    
    
    float iconSize = 48;
    float iWMargin = (self.view.frame.size.width-iconSize*4-15)/2.0;
    //Email Button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect rct = CGRectMake(iSpace*3+iconSize*2+iWMargin, iButtonH,iconSize,iconSize);
    button.frame = rct;
    button.tag = 401;
    [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"email1" ofType:@"png"]] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(singleTapGestureCaptured:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:button];

    //Save Button
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    rct = CGRectMake(iSpace*2+iconSize+iWMargin , iButtonH,iconSize,iconSize);
    button.frame = rct;
    button.tag = 402;
    [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"save" ofType:@"png"]] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(singleTapGestureCaptured:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    //Facebook Button
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    rct = CGRectMake(iSpace+iWMargin , iButtonH,iconSize,iconSize);
    button.frame = rct;
    button.tag = 403;
    [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"facebook" ofType:@"png"]] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(singleTapGestureCaptured:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];


    //Twitter Button
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    rct = CGRectMake(iSpace*4+iconSize*3+iWMargin, iButtonH,iconSize,iconSize);
    button.frame = rct;
    button.tag = 404;
    [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"twitter" ofType:@"png"]] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(singleTapGestureCaptured:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    //Rate us button
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rct = CGRectMake((vwPhoto.frame.size.width-230)/2.0,m_imgViewInPhoto.frame.size.height+15,230,40);
    button.frame = rct;
    button.tag = 405;
    [button setTitle:@"Like it! Rate on App Store" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(singleTapGestureCaptured:) forControlEvents:UIControlEventTouchUpInside];
    [vwPhoto addSubview:button];
    //Stars
    /*iconSize = 38;
    
    iSpace = (vwPhoto.frame.size.width -(iconSize+5)*5)/2.0;
    arrStarButton = [[NSMutableArray alloc] initWithCapacity:6];
    for(int i=0;i<5;i++)
    {
        
        UIImage *buttonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"StarRating0" ofType:@"png"]];
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button1 setImage:buttonImage forState:UIControlStateNormal];
        button1.frame = CGRectMake(iSpace+i*(iconSize+5), m_imgViewInPhoto.frame.size.height+15, iconSize, iconSize);
        button1.tag = 301+i;
        button1.showsTouchWhenHighlighted = TRUE;
        [arrStarButton addObject:button1];
        [button1 addTarget:self action:@selector(updateStar:) forControlEvents:UIControlEventTouchUpInside];

        [vwPhoto addSubview:button1];
        
        buttonImage = NULL;
        button1 = NULL;
    }
*/
    

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    //[m_vwFeedback JSDestructor];
    m_imgViewInPhoto.image = nil;
    
    // Release any retained subviews of the main view.

}
-(void)JSConstructor
{
    
}
-(void)JSDestructor
{
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)singleTapGestureCaptured:(UIButton *)gesture
{
    
    clsViewEditor* viewEdit = (clsViewEditor*)[self.tabBarController.viewControllers objectAtIndex:1];
    if(m_imgViewInPhoto.image == NULL && gesture.tag>=401 && gesture.tag<=404)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Looks applied"
                                                        message:@"Select a photo and apply looks before share/Save."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        alert = NULL;
        return;
    }

    //id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-37566182-1"];

    //Email Clicked
    if(gesture.tag ==401)
    {
        
        [self.appDelegate.tracker sendEventWithCategory:@"Share"
                            withAction:@"Email"
                             withLabel:[viewEdit.m_vwCanvas.m_eff GetEffectName]
                             withValue:[NSNumber numberWithInt:1]];
        [self SendPhotoEmail];
        return;
        
    }
    //Save
    if(gesture.tag ==402)
    {
        [self.appDelegate.tracker sendEventWithCategory:@"Share"
                            withAction:@"SaveToDisk"
                             withLabel:[viewEdit.m_vwCanvas.m_eff GetEffectName]
                             withValue:[NSNumber numberWithInt:1]];
        UIImageWriteToSavedPhotosAlbum(m_imgViewInPhoto.image,
                                       self,
                                       nil,
                                       nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save"
                                                        message:@"Photo saved to album."
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles: nil];
        [alert show];
        alert = NULL;

        return;
    }
    //FaceBook
    if(gesture.tag ==403)
    {
        [self.appDelegate.tracker sendEventWithCategory:@"Share"
                            withAction:@"Facebook"
                             withLabel:[viewEdit.m_vwCanvas.m_eff GetEffectName]
                             withValue:[NSNumber numberWithInt:1]];
        [self PostOnFB];
    }
    //Twitter    
    if(gesture.tag ==404)
    {
        [self.appDelegate.tracker sendEventWithCategory:@"Share"
                            withAction:@"Twitter"
                             withLabel:[viewEdit.m_vwCanvas.m_eff GetEffectName]
                             withValue:[NSNumber numberWithInt:1]];
        [self TweetMyLooks];
    }
    //rate
    if(gesture.tag==405)
    {
        NSString *str = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa";
        str = [NSString stringWithFormat:@"%@/wa/viewContentsUserReviews?", str];
        //str = [NSString stringWithFormat:@"%@type=Purple+Software&id=", str];
        
        // Here is the app id from itunesconnect
        str = [NSString stringWithFormat:@"%@576724283", str];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=576724283&amp;amp;amp;amp;mt=8"]];
        
        //[[UIApplication sharedApplication]
         //openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Vishalsinh+Jhala&id=576724283"]];
    }

}
-(void)TweetMyLooks
{

    // Create an account store object.
	ACAccountStore *accountStore = [[ACAccountStore alloc] init];
	
	// Create an account type that ensures Twitter accounts are retrieved.
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
	
	// Request access from the user to use their Twitter accounts.
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        if(granted) {
			// Get the list of Twitter accounts.
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
			
			// For the sake of brevity, we'll assume there is only one Twitter account present.
			// You would ideally ask the user which account they want to tweet from, if there is more than one Twitter account present.
			if ([accountsArray count] > 0) 
            {
				// Grab the initial Twitter account to tweet from.
				ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
    
                TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://upload.twitter.com/1/statuses/update_with_media.json"] parameters:nil requestMethod:TWRequestMethodPOST];
    
                UIImage * image = m_imgViewInPhoto.image;
    
                //add text
                [postRequest addMultiPartData:[@"CartoonLooks" dataUsingEncoding:NSUTF8StringEncoding] withName:@"status" type:@"multipart/form-data"];
                //add image
                [postRequest addMultiPartData:UIImagePNGRepresentation(image) withName:@"media" type:@"multipart/form-data"];
    
                // Set the account used to post the tweet.
                [postRequest setAccount:twitterAccount];
    
                // Perform the request created above and create a handler block to handle the response.
                [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        
                    [self performSelectorOnMainThread:@selector(displayText:) withObject:error waitUntilDone:NO];
                }]; 
                [self ShowAlertView];

            }}}];
}

-(void)ShowAlertView
{
    
    m_alertTweet = [[UIAlertView alloc] initWithTitle:@"Tweeting" message:@"Your new Looks. Please Wait..." delegate:self cancelButtonTitle:nil otherButtonTitles: nil] ;
    [m_alertTweet show];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    // Adjust the indicator so it is up a few pixels from the bottom of the alert
    indicator.center = CGPointMake(m_alertTweet.bounds.size.width / 2, m_alertTweet.bounds.size.height - 50);
    [indicator startAnimating];
    [m_alertTweet addSubview:indicator];
    indicator = nil;
}

-(void)displayText:(NSError*)output
{
    [m_alertTweet dismissWithClickedButtonIndex:0 animated:YES];

    /*NSString *str = @"Photo tweeted.";
    if(output)
        str = [output localizedDescription];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tweet"
                                                    message:str
                                                   delegate:nil
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles: nil];
    [alert show];
    alert = NULL;*/
    
    
}
-(void)PostOnFB
{
    m_alertFB = nil;
    [FBSession openActiveSessionWithPermissions:[NSArray arrayWithObjects:@"publish_actions", 
                                                 @"user_photos", 
                                                 nil] allowLoginUI:YES
                              completionHandler:^(FBSession *session,
                                                  FBSessionState status,
                                                  NSError *error) {
                                  // session might now be open.
                                  
      if (session.isOpen) {
          //Success code..
          
              
               if(!m_alertFB)
               {    m_alertFB = [[UIAlertView alloc] initWithTitle:@"Posting" message:@"Your new looks to Facebook Album..." delegate:self cancelButtonTitle:nil otherButtonTitles: nil] ;
                   [m_alertFB show];
              
                   UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
              
              // Adjust the indicator so it is up a few pixels from the bottom of the alert
                   indicator.center = CGPointMake(m_alertFB.bounds.size.width / 2, m_alertFB.bounds.size.height - 50);
                   [indicator startAnimating];
                   [m_alertFB addSubview:indicator];
                   indicator = nil;
               }
              
          
          FBRequestConnection *connection = [[FBRequestConnection alloc] init];

              // First request uploads the photo.
              FBRequest *request1 = [FBRequest 
                                     requestForUploadPhoto:m_imgViewInPhoto.image];
          
          
              [connection addRequest:request1
                   completionHandler:
               ^(FBRequestConnection *connection, id result, NSError *error) {
                   
                   [m_alertFB dismissWithClickedButtonIndex:0 animated:YES];
                   /*NSString *str = @"Photo saved in your Facebook Album";
                   if(error)
                       str = [error localizedDescription];
                  
                   
                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Post Photo To FB"
                                                                   message:str
                                                                  delegate:nil
                                                         cancelButtonTitle:@"Dismiss"
                                                         otherButtonTitles: nil];
                   [alert show];
                   alert = NULL;*/
               }
                      batchEntryName:@"CartoonLooks"
               ];   
          [connection start];

      }
      else {
          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                          message:@"Facebook Login Failed"
                                                         delegate:nil
                                                cancelButtonTitle:@"Dismiss"
                                                otherButtonTitles: nil];
          [alert show];
          alert = NULL;
      }
      
  }];
    
}
-(void) SendPhotoEmail
{
    if ([MFMailComposeViewController canSendMail])
    {
        
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:@"CartoonLooks - Look at this !"];
        
        NSArray *toRecipients = [NSArray arrayWithObjects:@"", nil];
        [mailer setToRecipients:toRecipients];
        
        //clsViewEditor* viewEdit = (clsViewEditor*)[self.tabBarController.viewControllers objectAtIndex:1];
        
        
        UIImage *myImage = m_imgViewInPhoto.image;//[UIImage imageNamed:@"mobiletuts-logo.png"];
        NSData *imageData = UIImageJPEGRepresentation(myImage, 1.0);
        [mailer addAttachmentData:imageData mimeType:@"image/jpeg" fileName:@"CartoonLooks"]; 
        
        NSString *emailBody = @"New Looks from CartoonLooks";
        [mailer setMessageBody:emailBody isHTML:NO];
        
        [self presentModalViewController:mailer animated:YES];
        myImage = NULL;
        imageData = NULL;
        mailer = NULL;
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        alert = NULL;
    }
    

}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{   
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            //NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            //NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email"
                                                            message:@"Send Successfully"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            alert = NULL;

        }
            break;
        case MFMailComposeResultFailed:
            //NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            //NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    [self dismissModalViewControllerAnimated:YES];
    //[m_alert dismissWithClickedButtonIndex:0 animated:YES];

}
/*
-(void)updateStar:(UIButton*)btn
{
    if(m_imgViewInPhoto.image == NULL)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Looks applied"
                                                        message:@"Select a photo and apply looks before rating."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        alert = NULL;
        return;
    }
    iUserRating = btn.tag-301+1;
    
    for(int j=0;j<=iUserRating-1;j++)
    {
        UIButton* btn = [arrStarButton objectAtIndex:j];
        [btn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"StarRating1" ofType:@"png"]] forState:UIControlStateNormal];
    }
    for(int j=iUserRating;j<5;j++)
    {
        UIButton* btn = [arrStarButton objectAtIndex:j];
        [btn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"StarRating0" ofType:@"png"]] forState:UIControlStateNormal];
    }
    [self OnSubmit];
    
}
-(void)OnSubmit
{
    if(iUserRating<0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Feedback"
                                                        message:@"Please click on Stars to rate us."
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles: nil];
        [alert show];
        alert = NULL;
        return;
    }
    //clsViewEditor* viewEdit = (clsViewEditor*)[self.tabBarController.viewControllers objectAtIndex:1];
    clsDataFeedback*m_dataFB;// = [viewEdit.m_vwCanvas GetFeedbackData];

    m_dataFB.strFeedback = @"";
    
    [self threadSubmitFB:m_dataFB];
    //[self removeFromSuperview];
}
-(void)threadSubmitFB:(clsDataFeedback*)data
{
    if(data == NULL)
    {
        data = [clsDataFeedback alloc];
        data.strFeedback = @"";;
        data.strEffectName = @"";
        data.strHistogram = @"";
    }
    
    UIDevice *currentDevice = [UIDevice currentDevice];
    NSString *model = [currentDevice model];
    NSString *systemVersion = [currentDevice systemVersion];
    
    data.iRating = iUserRating;
    data.strPhoneModel =model;
    data.strOSVer = systemVersion;
    
    NSURL *aUrl = [NSURL URLWithString:@"http://www.cartoonlooks.com/FeedbackFromApp.aspx"];
    
    NSArray *keys = [[NSArray alloc] initWithObjects:
                     @"iRating",
                     @"strPhoneModel",
                     @"strOSVer",
                     @"strFeedback",
                     @"strEffectName",
                     @"iWidth",
                     @"iHeight",
                     @"strHistogram",
                     @"fExposureTime",
                     @"fISOSensitivit",
                     @"iEdgePercent",nil];
    
    NSArray *objects = [[NSArray alloc] initWithObjects:
                        [NSString stringWithFormat:@"%d",data.iRating],
                        data.strPhoneModel,
                        data.strOSVer,
                        data.strFeedback,
                        data.strEffectName,
                        [NSString stringWithFormat:@"%d",data.iWidth],
                        [NSString stringWithFormat:@"%d",data.iHeight],
                        data.strHistogram,
                        [NSString stringWithFormat:@"%f",data.fExposureTime],
                        [NSString stringWithFormat:@"%f",data.fISOSensitivity],
                        [NSString stringWithFormat:@"%d",data.iEdgePercent],nil ];
    
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    
    NSMutableURLRequest *url = [clsGlobalHelper multipartRequestWithURL:aUrl andDataDictionary:dictionary];
    
    NSURLConnection *conn = [[NSURLConnection alloc]
                             initWithRequest:url
                             delegate:self];
    
    [self ShowAlertViewFeedback];
    
    dictionary = nil;
    url = nil;
    conn = nil;;
    currentDevice = nil; model = nil;systemVersion = nil;
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [m_alert dismissWithClickedButtonIndex:0 animated:YES];
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
                                message:[error localizedDescription]
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
                      otherButtonTitles:nil] show];
}

-(void)ShowAlertViewFeedback
{
    
    m_alert = [[UIAlertView alloc] initWithTitle:@"Submitting\nPlease Wait..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] ;
    [m_alert show];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    // Adjust the indicator so it is up a few pixels from the bottom of the alert
    indicator.center = CGPointMake(m_alert.bounds.size.width / 2, m_alert.bounds.size.height - 50);
    [indicator startAnimating];
    [m_alert addSubview:indicator];
    indicator = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [m_alert dismissWithClickedButtonIndex:0 animated:YES];
    
    //NSLog(@"connectionDidFinishLoading");
    // Do anything you want with it
    
}*/

/*-(void)ShowAlertView
{
    
    m_alert = [[UIAlertView alloc] initWithTitle:@"Sending Email\nPlease Wait..." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: nil] ;
    [m_alert show];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    // Adjust the indicator so it is up a few pixels from the bottom of the alert
    indicator.center = CGPointMake(m_alert.bounds.size.width / 2, m_alert.bounds.size.height - 50);
    [indicator startAnimating];
    [m_alert addSubview:indicator];
    indicator = nil;
}*/

@end
