//
//  clsDataFace.h
//  FotoKartoon
//
//  Created by Vishalsinh Jhala on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface clsDataFeedback : NSObject
{
    
}
@property int iRating;
@property NSString* strEffectName;
@property int iWidth ;
@property int iHeight;
@property NSString* strHistogram;
@property float fExposureTime;
@property float fISOSensitivity;
@property int iEdgePercent;
@property NSString* strPhoneModel;
@property NSString*  strOSVer;
@property NSString* strFeedback;

@end
