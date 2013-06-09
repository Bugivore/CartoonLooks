//
//  clsAppDelegate.h
//  FotoKartoon
//
//  Created by Vishalsinh Jhala on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAI.h"

@interface clsAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, retain) id<GAITracker> tracker;

@end
