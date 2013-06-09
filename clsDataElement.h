//
//  clsDataFace.h
//  FotoKartoon
//
//  Created by Vishalsinh Jhala on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface clsDataElement : NSObject
{
    
}
@property UIImage *imgElementOrig;
@property UIImage* imgElement;
@property BOOL bVisible ;
@property BOOL bIsSketch;
@property CGRect rctFrame;
@property CGPoint pntDrag;
@property float fAngleRotation;
@property float fScaleFactor;
@property int iGender;
//@property int iLayerID;
@property CGBlendMode  cgBlendMode;

@end
