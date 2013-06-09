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

@interface effFerros : clsEffectBase
{

}
//-(UIImage*)DrawElements:(clsDataFace*)inFaceData;
-(id)init:(clsDataFace*)inFaceData:(Boolean)bIsMale;
-(NSString*)GetEffectName;

@end
