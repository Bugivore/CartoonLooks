//
//  clsInfoView.h
//  FotoKartoon
//
//  Created by Vishalsinh Jhala on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface clsInfoView : UIView
{
    long m_iTotalPixels;
    int m_iFaceHeight;
    int m_iISOLvl;
    int m_iExposureLvl;
    //UIImageOrientation m_inOrientation;
    
}
-(void)Create:(long[3][256])m_lHistogram:(int)iFW:(int)iFH:(UIImage*)imgFace:(float) m_fExposure:(int) m_iISOSpeed;
@end
