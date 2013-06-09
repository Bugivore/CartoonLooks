//
//  clsViewElement.m
//  MessMyLooks
//
//  Created by Vishalsinh Jhala on 9/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "clsViewElement.h"
#import "clsEditor.h"

@implementation clsViewElement

- (id)initWithFrame:(CGRect)frame/*:(NSMutableArray*)arr:(int)iLayerID*/
{
    if ((self = [super initWithFrame:frame])) {
       // m_iLayerID = iLayerID;
        self.backgroundColor = [UIColor clearColor];
        self.tag = 201;
    }

    return self;     
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    // Flip Context
    CGContextTranslateCTM(ctx, 0, self.frame.size.height);
    CGContextScaleCTM(ctx, 1.0f, -1.0f);
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextFillRect(ctx, self.bounds);

    clsEditor *edit = (clsEditor*)self.superview;
    
    for( clsDataElement*element in edit.m_eff.m_ArrElements)
    {
        if( !element.bVisible)
            continue;
        
        CGSize rotatedSize;// = elem.rctFrame.size;
        //Resize
        CGRect rctTemp = element.rctFrame;
        
        if(element.fScaleFactor !=1.0)
        {
            int iX = rctTemp.origin.x +( rctTemp.size.width-
                                        rctTemp.size.width*element.fScaleFactor)/2.0;
            int iY = rctTemp.origin.y +( rctTemp.size.height-
                                        rctTemp.size.height*element.fScaleFactor)/2.0;
            rctTemp = CGRectMake(iX, iY, rctTemp.size.width*element.fScaleFactor, rctTemp.size.height*element.fScaleFactor);
        }
        //MoveDrag
        if(element.pntDrag.x!=0.0 || element.pntDrag.y !=0.0)
        {
            rctTemp.origin.x += element.pntDrag.x;
            rctTemp.origin.y += element.pntDrag.y;
        }
        //Rotate
        if(element.fAngleRotation != 0.0)
        {
            element.imgElement = nil;
            element.imgElement = [clsGlobalHelper imageRotatedByRadians:element.imgElementOrig :element.fAngleRotation:CGPointMake(element.imgElementOrig.size.width/2.0 ,element.imgElementOrig.size.height/2.0)];
            UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,rctTemp.size.width, rctTemp.size.height)];
            
            CGAffineTransform t = CGAffineTransformMakeRotation(element.fAngleRotation);
            rotatedViewBox.transform = t;
            rotatedSize = CGSizeMake(rotatedViewBox.frame.size.width,rotatedViewBox.frame.size.height);
            
            rctTemp.size = rotatedSize;
            
        }
        
        rctTemp = CGRectMake(rctTemp.origin.x*edit.m_fScaleToView+edit.iMarginX, rctTemp.origin.y*edit.m_fScaleToView+edit.iMarginY, rctTemp.size.width*edit.m_fScaleToView, rctTemp.size.height*edit.m_fScaleToView);
        
        CGContextSetBlendMode(ctx, element.cgBlendMode);
        
        //if(!element.bIsSketch)
        CGContextDrawImage(ctx, rctTemp  , element.imgElement.CGImage);
    }
    edit = nil;
}


@end
