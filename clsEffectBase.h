//
//  clsEffectBase.h
//  MessMyLooks
//
//  Created by Vishalsinh Jhala on 8/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "clsDataFace.h"
#import "clsDataElement.h"
#import "clsGlobalHelper.h"

@interface clsEffectBase : NSObject
{
    float fLeftMargin;
    float fRightMargin;
    float fTopMargin;
    float fBottomMargin;

}
@property int iNewW;
@property int iNewH;
@property int iStartX;
@property int iStartY;
@property NSMutableArray* m_ArrElements;
-(NSString*)GetEffectName;


@end
