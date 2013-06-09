//
//  clsBilateralFilter.h
//  CartoonLooks
//
//  Created by Vishalsinh Jhala on 1/3/13.
//  Copyright (c) 2013 CartoonLooks.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "imatrix.h"

@interface clsBilateralFilter : NSObject
-(void)BFilterMain:(imatrix*)imgR:(imatrix*)imgG:(imatrix*)imgB:(int) iFilterSize: (float) fSigmaDist: (float) fSigmaColor:(int) iNR:(int) iNC;
@end
