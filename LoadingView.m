//
//  LoadingView.m
//  LoadingView
//
//  Created by Vishalsinh Jhala on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoadingView.h"
#import <QuartzCore/QuartzCore.h>

@implementation LoadingView
@synthesize m_arrMessages;

-(void)ShowAlertView
{
    
    [self Messages];
    m_alert = [[UIAlertView alloc] initWithTitle:@"Please Wait..." message:@"Performing Stretch test on Tongue" delegate:self cancelButtonTitle:nil otherButtonTitles: nil] ;
    [m_alert show];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    // Adjust the indicator so it is up a few pixels from the bottom of the alert
    indicator.center = CGPointMake(m_alert.bounds.size.width / 2, m_alert.bounds.size.height - 50);
    [indicator startAnimating];
    [m_alert addSubview:indicator];
    indicator = nil;
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(GetNextMessage:)
                                   userInfo:nil
                                    repeats:YES];
    
}

//Creepy messages to scare the shit out and keep users busy.
-(void)Messages
{
    m_arrMessages = [[NSMutableArray alloc] initWithCapacity:20];
    [m_arrMessages addObject:@"Performing plastic Surgery"];
    [m_arrMessages addObject:@"Poking eye balls"];
    [m_arrMessages addObject:@"Drilling teeth"];
    [m_arrMessages addObject:@"Stretching the nose"];
    [m_arrMessages addObject:@"Cleaning nose hair"];
    [m_arrMessages addObject:@"Shaving (face)"];
    [m_arrMessages addObject:@"Hammering the head"];
    [m_arrMessages addObject:@"Carving the skull"];
    [m_arrMessages addObject:@"Applying noodle beard"];
    [m_arrMessages addObject:@"Moulding the jaws"];
    [m_arrMessages addObject:@"Cutting mammoth size ears"];
    [m_arrMessages addObject:@"Stitching lips"];
    [m_arrMessages addObject:@"Replacing brain with recycled fur"];
    [m_arrMessages addObject:@"Performing Stretch test on Tongue"];
    [m_arrMessages addObject:@"Preparing wig from Gorilla hair"];
    [m_arrMessages addObject:@"Growing eyebrows"];
    [m_arrMessages addObject:@"Horns look cool"];
    [m_arrMessages addObject:@"Chubby cheeks are only for babies"];
    [m_arrMessages addObject:@"Chimpanzee looks - a natural fit"];
    [m_arrMessages addObject:@"Cleaning face with sulphuric acid"];    
}
-(void)GetNextMessage:(NSTimer *)timer
{
    int r = arc4random() % ([m_arrMessages count]-1);
    [m_alert performSelectorOnMainThread:@selector( setMessage:) withObject:[m_arrMessages objectAtIndex:r] waitUntilDone:NO];    
    //loadingLabel.text = ;
}
-(void)RemoveView
{
    [myTimer invalidate];
    myTimer = nil;
    [m_alert dismissWithClickedButtonIndex:0 animated:YES];
}
//
// dealloc
//
// Release instance memory.
//
- (void)dealloc
{
    //[super dealloc];
}

@end
