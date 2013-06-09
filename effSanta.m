//
//  effSumo.m
//  FotoKartoon
//
//  Created by Vishalsinh Jhala on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "effSanta.h"

@implementation effSanta

-(id)init:(clsDataFace*)inFaceData:(Boolean)bIsMale
{
    self = [super init];
    
    //Percentage Face Width
    fLeftMargin = 230/600.0;
    fRightMargin = 50/600.0;
    fTopMargin = 320/600.0;
    fBottomMargin = 356/600.0;

    super.iNewW = inFaceData.imgSketch.size.width + inFaceData.imgSketch.size.width*fLeftMargin + inFaceData.imgSketch.size.width*fRightMargin;
    super.iNewH = inFaceData.imgSketch.size.height + inFaceData.imgSketch.size.height*fTopMargin + inFaceData.imgSketch.size.height*fBottomMargin;
    
    super.iStartX = inFaceData.imgSketch.size.width  * fLeftMargin;
    super.iStartY = inFaceData.imgSketch.size.height * fTopMargin;
    super.m_ArrElements = [[NSMutableArray alloc] initWithCapacity:5];
    
    //Sketch
    {
        clsDataElement * element = [clsDataElement alloc];
        element.bIsSketch = TRUE;
        element.imgElement = inFaceData.imgSketch;
        element.imgElementOrig = element.imgElement;
        element.bVisible = TRUE;
        //element.bDraggable = FALSE;
        element.rctFrame = CGRectMake(super.iStartX,super.iNewH-super.iStartY-inFaceData.imgSketch.size.height,inFaceData.imgSketch.size.width,inFaceData.imgSketch.size.height);
        element.pntDrag = CGPointMake(0, 0);
        element.fAngleRotation = 0.0;
        element.fScaleFactor = 1.0;
        element.iGender = bIsMale;
        //element.iLayerID = 0;
        element.cgBlendMode = kCGBlendModeNormal;
        [super.m_ArrElements addObject:element];
        element = nil;

    }
    //Left Eye
    {
        clsDataElement * element = [clsDataElement alloc];
        element.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SantaEyebrowL" ofType:@"png"]];
        element.imgElementOrig = element.imgElement;
        element.bVisible = TRUE;
        int iEyebrowH = inFaceData.iEyeWdt*(element.imgElement.size.height/(double)element.imgElement.size.width);

        element.rctFrame = CGRectMake(super.iStartX+inFaceData.pntLeftEyeStart.x,
                                      super.iNewH- super.iStartY- inFaceData.pntLeftEyeStart.y-inFaceData.iEyeHgt*0.5,inFaceData.iEyeWdt,iEyebrowH);
        
        ////element.bDraggable = TRUE;
        element.bIsSketch = FALSE;
        element.pntDrag = CGPointMake(0, 0);
        element.fAngleRotation = 0.0;
        element.fScaleFactor = 1.0;
        element.iGender = bIsMale;
        //element.iLayerID = 0;
        element.cgBlendMode = kCGBlendModeNormal;
        [super.m_ArrElements addObject:element];
        element = nil;
        
    }
    //Right Eye
    {
        clsDataElement * element = [clsDataElement alloc];
        element.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SantaEyebrowR" ofType:@"png"]];
        element.imgElementOrig = element.imgElement;
        element.bVisible = TRUE;
        //element.bDraggable = TRUE;
        element.bIsSketch = FALSE;
        int iEyebrowH = inFaceData.iEyeWdt*(element.imgElement.size.height/(double)element.imgElement.size.width);

        element.rctFrame = CGRectMake(super.iStartX+inFaceData.pntRightEyeStart.x,
                                      super.iNewH- super.iStartY- inFaceData.pntRightEyeStart.y-inFaceData.iEyeHgt*0.5,
                                      inFaceData.iEyeWdt,iEyebrowH);
        element.pntDrag = CGPointMake(0, 0);
        element.fAngleRotation = 0.0;
        element.fScaleFactor = 1.0;
        element.iGender = bIsMale;
        //element.iLayerID = 0;
        element.cgBlendMode = kCGBlendModeNormal;
        [super.m_ArrElements addObject:element];
        element = nil;
        
    }

/*    //Beard
    {
        clsDataElement * element = [clsDataElement alloc];
        element.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"santa beard" ofType:@"png"]];
        element.imgElementOrig = element.imgElement;
        element.bIsSketch = FALSE;
        int iMouthW = inFaceData.imgSketch.size.width;
        int iMouthH = inFaceData.imgSketch.size.height - inFaceData.pntMouthStart.y+inFaceData.iMouthHgt;
        element.bVisible = TRUE;
        element.rctFrame = CGRectMake(super.iStartX,
            super.iNewH-super.iStartY-inFaceData.pntMouthStart.y-iMouthH,
                                      iMouthW,iMouthH);
        //element.bDraggable = TRUE;
        element.pntDrag = CGPointMake(0, 0);
        element.fAngleRotation = 0.0;
        element.fScaleFactor = 1.0;
        element.iGender = bIsMale;
        //element.iLayerID = 1;
        element.cgBlendMode = kCGBlendModeNormal;
        [super.m_ArrElements addObject:element];
        element = nil;

    }*/
    //Mouth
    {
        clsDataElement * element = [clsDataElement alloc];
        element.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SantaMouth" ofType:@"png"]];
        element.imgElementOrig = element.imgElement;
        element.bIsSketch = FALSE;
        int iLipHgt = inFaceData.iMouthWdt*(float)element.imgElement.size.height/element.imgElement.size.width;
        element.bVisible = TRUE;
        element.rctFrame = CGRectMake(super.iStartX+inFaceData.pntMouthStart.x*1.2,
                            super.iNewH-super.iStartY-inFaceData.pntMouthStart.y-inFaceData.iMouthHgt,inFaceData.iMouthWdt,iLipHgt);
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
    //Mostache
    {
        clsDataElement * element = [clsDataElement alloc];
        element.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SantaMostache" ofType:@"png"]];
        element.imgElementOrig = element.imgElement;
        element.bIsSketch = FALSE;
        element.bVisible = TRUE;
        int iMostacheW = inFaceData.pntRightEyeStart.x+inFaceData.iEyeWdt-inFaceData.pntLeftEyeStart.x;
        int iMostacheH = iMostacheW*(element.imgElement.size.height/(double)element.imgElement.size.width);
        element.rctFrame =CGRectMake(inFaceData.pntLeftEyeStart.x+super.iStartX, super.iNewH-super.iStartY-inFaceData.pntMouthStart.y-inFaceData.iMouthHgt*0.5,iMostacheW,iMostacheH);
        /*int iMouthW = inFaceData.imgSketch.size.width;
        int iMouthH = inFaceData.imgSketch.size.height - inFaceData.pntMouthStart.y+inFaceData.iMouthHgt;
        element.rctFrame = CGRectMake(iStartX,
        inFaceData.pntMouthStart.y+iStartY-inFaceData.iMouthHgt,iMouthW,iMouthH);*/
        //element.bDraggable = TRUE;
        element.pntDrag = CGPointMake(0, 0);
        element.fAngleRotation = 0.0;
        element.fScaleFactor = 1.0;
        element.iGender = bIsMale;
        //element.iLayerID = 3;
        element.cgBlendMode = kCGBlendModeNormal;
        [super.m_ArrElements addObject:element];
        element = nil;
        
    }
    // Hair
    {
        clsDataElement * element = [clsDataElement alloc];
        element.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Santa" ofType:@"png"]];
        element.imgElementOrig = element.imgElement;
        element.bIsSketch = FALSE;
        element.bVisible = TRUE;
        //element.bDraggable = TRUE;
        int iHeadHgt = super.iNewW*(float)element.imgElement.size.height/element.imgElement.size.width;
        element.rctFrame = CGRectMake(0, 0, super.iNewW,iHeadHgt);
        element.pntDrag = CGPointMake(0, 0);
        element.fAngleRotation = 0.0;
        element.fScaleFactor = 1.0;
        element.iGender = bIsMale;
        //element.iLayerID = 4;
        element.cgBlendMode = kCGBlendModeNormal;
        [super.m_ArrElements addObject:element];
        element = nil;

    }
    
    return self;
}
-(NSString*)GetEffectName
{
    return @"Santa";
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
