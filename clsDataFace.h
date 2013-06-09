//
//  clsDataFace.h
//  FotoKartoon
//
//  Created by Vishalsinh Jhala on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface clsDataFace : NSObject
{
    
}
@property int iFaceWidth;
@property int iFaceHeight;
@property CGPoint pntLeftEyeStart;
@property CGPoint pntRightEyeStart;
@property CGPoint pntMouthStart;
@property UIImage *img;
@property UIImage *imgSketch;
@property int iEyeWdt;
@property int iEyeHgt;
@property int iMouthWdt;
@property int iMouthHgt;

@end
