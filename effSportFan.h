//
//  effSumo.h
//  FotoKartoon
//
//  Created by Vishalsinh Jhala on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "clsDataFace.h"
#import "clsEffectBase.h"

@interface effSportFan : clsEffectBase
{
    NSString *m_strCountry;
    NSString *m_strCountryCap;
    int m_iCountryID;
}
//-(UIImage*)DrawElements:(clsDataFace*)inFaceData;
-(id)init:(clsDataFace*)inFaceData:(Boolean)bIsMale;
-(int)getCountryID;
-(void)setCountryID:(int)iCountry;
-(NSString*)GetEffectName;

@end
