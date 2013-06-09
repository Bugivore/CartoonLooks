//
//  effSumo.m
//  FotoKartoon
//
//  Created by Vishalsinh Jhala on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "effGeek.h"

@implementation effGeek

-(id)init:(clsDataFace*)inFaceData:(Boolean)bIsMale
{
    self = [super init];
    
    if(bIsMale)
    {
        //Percentage Face Width
        fLeftMargin = 0.0;
        fRightMargin = 0.0;
        fTopMargin = 100/530.0;
        fBottomMargin = 0;
        
    }
    else {
        //Percentage Face Width
        fLeftMargin = 96/550.0;
        fRightMargin = 34/550.0;
        fTopMargin = 220/550.0;
        fBottomMargin = 0;
        
    }
    
    super.iNewW = inFaceData.imgSketch.size.width + inFaceData.imgSketch.size.width*fLeftMargin + inFaceData.imgSketch.size.width*fRightMargin;
    super.iNewH = inFaceData.imgSketch.size.height + inFaceData.imgSketch.size.height*fTopMargin + inFaceData.imgSketch.size.height*fBottomMargin;
    
    super.iStartX = inFaceData.imgSketch.size.width  * fLeftMargin;
    super.iStartY = inFaceData.imgSketch.size.height * fTopMargin;
    super.m_ArrElements = [[NSMutableArray alloc] initWithCapacity:3];
    
    //Sketch
    {
        clsDataElement * element = [clsDataElement alloc];
        element.imgElement = inFaceData.imgSketch;
        element.imgElementOrig = element.imgElement;
        element.bIsSketch = TRUE;
        element.bVisible = TRUE;
        //element.bDraggable = FALSE;
        element.rctFrame =  CGRectMake(super.iStartX,super.iNewH-super.iStartY-inFaceData.imgSketch.size.height,inFaceData.imgSketch.size.width,inFaceData.imgSketch.size.height);
        element.pntDrag = CGPointMake(0, 0);
        element.fAngleRotation = 0.0;
        element.fScaleFactor = 1.0;
        element.iGender = bIsMale;
        //element.iLayerID = 0;
        element.cgBlendMode = kCGBlendModeNormal;
        [super.m_ArrElements addObject:element];
        element = nil;
    }
    // Hair
    if(bIsMale)
    {
        clsDataElement * element = [clsDataElement alloc];
        element.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"geekman hair" ofType:@"png"]];
        element.imgElementOrig = element.imgElement;
        element.bIsSketch = FALSE;
        element.bVisible = TRUE;
        //element.bDraggable = TRUE;
        //UIImage*imgTemp = [UIImage imageNamed:element.strImageName];
        int iHeadHgt = super.iNewW*(float)element.imgElement.size.height/element.imgElement.size.width;
        element.rctFrame = CGRectMake(0, super.iNewH-iHeadHgt, super.iNewW,iHeadHgt);
        element.pntDrag = CGPointMake(0, 0);
        element.fAngleRotation = 0.0;
        element.fScaleFactor = 1.0;
        element.iGender = bIsMale;
        //element.iLayerID = 1;
        element.cgBlendMode = kCGBlendModeNormal;
        [super.m_ArrElements addObject:element];
        element = nil;

    }
    else
    {
        clsDataElement * element = [clsDataElement alloc];
        element.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"GeekWoman hair" ofType:@"png"]];
        element.imgElementOrig = element.imgElement;
        element.bIsSketch = FALSE;
        element.bVisible = TRUE;
        //element.bDraggable = TRUE;
        //UIImage*imgTemp = [UIImage imageNamed:element.strImageName];
        int iHeadHgt = super.iNewW*(float)element.imgElement.size.height/element.imgElement.size.width;
        element.rctFrame = CGRectMake(0, 0, super.iNewW,iHeadHgt);
        element.pntDrag = CGPointMake(0, 0);
        element.fAngleRotation = 0.0;
        element.fScaleFactor = 1.0;
        element.iGender = bIsMale;
        //element.iLayerID = 1;
        element.cgBlendMode = kCGBlendModeNormal;
        [super.m_ArrElements addObject:element];
        element = nil;

    }
        
    //Specs
    if(bIsMale)
    {
        clsDataElement * element = [clsDataElement alloc];
        element.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"geekman spec" ofType:@"png"]];
        element.imgElementOrig = element.imgElement;
        element.bIsSketch = FALSE;
        element.bVisible = TRUE;
        //UIImage*imgTemp = [UIImage imageNamed:element.strImageName];
        int iSpecH = inFaceData.iFaceHeight*(float)element.imgElement.size.height/element.imgElement.size.width;
        element.rctFrame = CGRectMake(super.iStartX,super.iNewH-super.iStartY-inFaceData.pntLeftEyeStart.y-iSpecH,inFaceData.iFaceWidth,iSpecH);
        //element.bDraggable = TRUE;
        element.pntDrag = CGPointMake(0, 0);
        element.fAngleRotation = 0.0;
        element.fScaleFactor = 1.0;
        element.iGender = bIsMale;
        //element.iLayerID = 2;
        element.cgBlendMode = kCGBlendModeNormal;
        [super.m_ArrElements addObject:element];
        element = nil;

    }
    else
    {
        clsDataElement * element = [clsDataElement alloc];
        element.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"geekwoman spec" ofType:@"png"]];
        element.imgElementOrig = element.imgElement;
        element.bIsSketch = FALSE;
        element.bVisible = TRUE;
        //UIImage*imgTemp = [UIImage imageNamed:element.strImageName];
        int iSpecH = inFaceData.iFaceHeight*(float)element.imgElement.size.height/element.imgElement.size.width;
        element.rctFrame = CGRectMake(super.iStartX,super.iNewH-super.iStartY-inFaceData.pntLeftEyeStart.y-iSpecH,inFaceData.iFaceWidth,iSpecH);
        //element.bDraggable = TRUE;
        element.pntDrag = CGPointMake(0, 0);
        element.fAngleRotation = 0.0;
        element.fScaleFactor = 1.0;
        element.iGender = bIsMale;
        //element.iLayerID = 2;
        element.cgBlendMode = kCGBlendModeNormal;
        [super.m_ArrElements addObject:element];
        element = nil;

    }
    
    return self;
}
-(NSString*)GetEffectName
{
    return @"Geek";
}

/*-(UIImage*)DrawElements:(clsDataFace*)inFaceData
{
    UIGraphicsBeginImageContext(CGSizeMake(super.iNewW,super.iNewH));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // Flip Context
    CGContextTranslateCTM(ctx, 0, super.iNewH);
    CGContextScaleCTM(ctx, 1.0f, -1.0f);
    UIImage *imgTemp;
    //clsDataElement *element;
    for (clsDataElement* element in super.m_ArrElements)
    {
        //element = [super.m_ArrElements objectAtIndex:i];
        if( !element.bVisible)
            continue;
        
        CGContextSetBlendMode(ctx, element.cgBlendMode);
        
        if (element.imgElement)
            imgTemp = element.imgElement;
        else
            imgTemp = inFaceData.imgSketch;//[UIImage imageNamed:.strImageName];
        
        //Resize
        CGRect rctTemp = element.rctFrame;
        if(element.fScaleFactor !=1.0)
        {    
            int iX = element.rctFrame.origin.x +( element.rctFrame.size.width-
                                                 element.rctFrame.size.width*element.fScaleFactor)/2.0;
            int iY = element.rctFrame.origin.y +( element.rctFrame.size.height-
                                                 element.rctFrame.size.height*element.fScaleFactor)/2.0;
            rctTemp = CGRectMake(iX, iY, element.rctFrame.size.width*element.fScaleFactor, element.rctFrame.size.height*element.fScaleFactor);
        }
        //Rotate
        if(element.fAngleRotation != 0.0)
        {
            clsGlobalHelper* gh = [clsGlobalHelper alloc];
            imgTemp = [gh imageRotatedByRadians:imgTemp :element.fAngleRotation:CGPointMake(imgTemp.size.width/2.0 ,imgTemp.size.height/2.0)];
            
        }
        //MoveDrag
        if(element.pntDrag.x!=0.0 || element.pntDrag.y !=0.0)
        {
            rctTemp.origin.x += element.pntDrag.x;
            rctTemp.origin.y += element.pntDrag.y;
        }
        
        CGContextDrawImage(ctx, rctTemp, imgTemp.CGImage);
        
        imgTemp = NULL;
    }
    
    UIImage *imgOutCanvas = UIGraphicsGetImageFromCurrentImageContext();
    
    return imgOutCanvas;
}*/
/*-(int)DragElements:(CGPoint) pntStart
{
    int clickY = super.iNewH - pntStart.y;
    pntStart.y = clickY;
    
    for (int i=0; i<super.m_ArrElements.count; i++) 
    {
        CGRect rctTemp;
        clsDataElement *element = [super.m_ArrElements objectAtIndex:i];
        if (!element.bDraggable) {
            continue;
        }
        rctTemp = element.rctFrame;
        if(element.fScaleFactor !=1.0)
        {    
            int iX = element.rctFrame.origin.x +( element.rctFrame.size.width-
                                                 element.rctFrame.size.width*element.fScaleFactor)/2.0;
            int iY = element.rctFrame.origin.y +( element.rctFrame.size.height-
                                                 element.rctFrame.size.height*element.fScaleFactor)/2.0;
            rctTemp = CGRectMake(iX, iY, element.rctFrame.size.width*element.fScaleFactor, element.rctFrame.size.height*element.fScaleFactor);
        }
        //MoveDrag
        if(element.pntDrag.x!=0.0 || element.pntDrag.y !=0.0)
        {
            rctTemp.origin.x += element.pntDrag.x;
            rctTemp.origin.y += element.pntDrag.y;
        }
        
        if(CGRectContainsPoint(rctTemp, pntStart))
        {
            return i;
        }
        
    }
    return -1;
}*/

@end
