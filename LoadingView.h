//
//  LoadingView.h
//  LoadingView
//
//  Created by Vishalsinh Jhala on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView
{
    UIAlertView * m_alert;
    NSTimer *myTimer;

}
@property NSMutableArray *m_arrMessages;
-(void)GetNextMessage:(NSTimer *)timer;
-(void)RemoveView;
-(void)ShowAlertView;


@end
