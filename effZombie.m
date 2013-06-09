//
//  effSumo.m
//  FotoKartoon
//
//  Created by Vishalsinh Jhala on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "effZombie.h"

@implementation effZombie

-(id)init:(clsDataFace*)inFaceData:(Boolean)bIsMale
{
    self = [super init];
    
    /*if(bIsMale)
    {
        //Percentage Face Width
        fLeftMargin = 0.0;
        fRightMargin = 0.0;
        fTopMargin = 250/713.0;
        fBottomMargin = 0.0;
        
    }
    else*/ {
        //Percentage Face Width
        fLeftMargin = 70/440.0;
        fRightMargin = 73/440.0;
        fTopMargin = 230/440.0;
        fBottomMargin = 122/440.0;
        
    }
    super.iNewW = inFaceData.imgSketch.size.width + inFaceData.imgSketch.size.width*fLeftMargin + inFaceData.imgSketch.size.width*fRightMargin;
    super.iNewH = inFaceData.imgSketch.size.height + inFaceData.imgSketch.size.height*fTopMargin + inFaceData.imgSketch.size.height*fBottomMargin;

    super.iStartX = inFaceData.imgSketch.size.width  * fLeftMargin;
    super.iStartY = inFaceData.imgSketch.size.height * fTopMargin;
    super.m_ArrElements = [[NSMutableArray alloc] initWithCapacity:7];

    //Left Eye
    {
        clsDataElement * element = [clsDataElement alloc];
        element.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"zombieeye" ofType:@"png"]];
        element.imgElementOrig = element.imgElement;
        element.bVisible = TRUE;
        element.rctFrame = CGRectMake(super.iStartX+inFaceData.pntLeftEyeStart.x,
        super.iNewH- super.iStartY- inFaceData.pntLeftEyeStart.y-inFaceData.iEyeHgt,inFaceData.iEyeWdt,inFaceData.iEyeHgt);

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
        element.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"zombieeyeright" ofType:@"png"]];
        element.imgElementOrig = element.imgElement;
        element.bVisible = TRUE;
        //element.bDraggable = TRUE;
        element.bIsSketch = FALSE;
        element.rctFrame = CGRectMake(super.iStartX+inFaceData.pntRightEyeStart.x,
        super.iNewH- super.iStartY- inFaceData.pntRightEyeStart.y-inFaceData.iEyeHgt,
        inFaceData.iEyeWdt,inFaceData.iEyeHgt);
        element.pntDrag = CGPointMake(0, 0);
        element.fAngleRotation = 0.0;
        element.fScaleFactor = 1.0;
        element.iGender = bIsMale;
        //element.iLayerID = 0;
        element.cgBlendMode = kCGBlendModeNormal;
        [super.m_ArrElements addObject:element];
        element = nil;

    }
    //Sketch
    {
        clsDataElement * element = [clsDataElement alloc];
        element.imgElementOrig = inFaceData.imgSketch;
        element.imgElement = inFaceData.imgSketch;
        element.bVisible = TRUE;
        //element.bDraggable = FALSE;
        element.bIsSketch = TRUE;
        element.rctFrame = CGRectMake(super.iStartX,super.iNewH-super.iStartY-inFaceData.imgSketch.size.height,inFaceData.imgSketch.size.width,inFaceData.imgSketch.size.height);
        element.pntDrag = CGPointMake(0, 0);
        element.fAngleRotation = 0.0;
        element.fScaleFactor = 1.0;
        element.iGender = bIsMale;
        //element.iLayerID = 0;
        element.cgBlendMode = kCGBlendModeMultiply;
        [super.m_ArrElements addObject:element];
        element = nil;

    }
    //Mouth Blood
    {
        clsDataElement * element = [clsDataElement alloc];
        element.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"zombieMouthBlood" ofType:@"png"]];
        element.imgElementOrig = element.imgElement;

        //UIImage*imgTemp = [UIImage imageNamed:element.strImageName];
        int iMHgt = inFaceData.iMouthWdt*0.2*(float)element.imgElement.size.height/element.imgElement.size.width;
        element.bVisible = TRUE;
        //element.bDraggable = TRUE;
        element.bIsSketch = FALSE;
        element.rctFrame =CGRectMake(super.iStartX+inFaceData.pntMouthStart.x+0.7*inFaceData.iMouthWdt,super.iNewH-super.iStartY-inFaceData.pntMouthStart.y-inFaceData.iMouthHgt*2,
                                     inFaceData.iMouthWdt*0.2,iMHgt);
        element.pntDrag = CGPointMake(0, 0);
        element.fAngleRotation = 0.0;
        element.fScaleFactor = 1.0;
        element.iGender = bIsMale;
        //element.iLayerID = 1;
        element.cgBlendMode = kCGBlendModeMultiply;
        [super.m_ArrElements addObject:element];
        element = nil;

    }
    //Cheek Cut
    {
        clsDataElement * element = [clsDataElement alloc];
        element.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"zombieCut" ofType:@"png"]];
        element.imgElementOrig = element.imgElement;
        element.bVisible = TRUE;
        //element.bDraggable = TRUE;
        element.bIsSketch = FALSE;
        //UIImage*imgTemp = [UIImage imageNamed:element.strImageName];
        element.rctFrame = CGRectMake(inFaceData.pntLeftEyeStart.x+(inFaceData.imgSketch.size.width*fLeftMargin),super.iNewH-super.iStartY-inFaceData.pntLeftEyeStart.y-inFaceData.iEyeHgt*1.5,inFaceData.iEyeWdt*0.75,inFaceData.iEyeWdt*((float)element.imgElement.size.width/element.imgElement.size.height)*0.75);
        element.pntDrag = CGPointMake(0, 0);
        element.fAngleRotation = 0.0;
        element.fScaleFactor = 1.0;
        element.iGender = bIsMale;
        //element.iLayerID = 2;
        element.cgBlendMode = kCGBlendModeNormal;
        [super.m_ArrElements addObject:element];
        element = nil;

    }
    //Male Hair
   /*if(bIsMale)
   {
       clsDataElement * element = [clsDataElement alloc];
   
       element.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"zombie M Hair" ofType:@"png"]];
       element.imgElementOrig = element.imgElement;
       element.bVisible = TRUE;
       //element.bDraggable = TRUE;
       element.bIsSketch = FALSE;
        //UIImage*imgTemp = [UIImage imageNamed:element.strImageName];
        int iHeadHgt = super.iNewW*(float)element.imgElement.size.height/element.imgElement.size.width;
        element.rctFrame = CGRectMake(0, super.iNewH-iHeadHgt, super.iNewW,iHeadHgt);
        element.pntDrag = CGPointMake(0, 0);
        element.fAngleRotation = 0.0;
        element.fScaleFactor = 1.0;
        element.iGender = bIsMale;
        //element.iLayerID = 3;
        element.cgBlendMode = kCGBlendModeNormal;
        [super.m_ArrElements addObject:element];
       element = nil;

   }
   else */
   {
        //Female Hair
        clsDataElement * element = [clsDataElement alloc];
       element.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"zombieF Hair" ofType:@"png"]];
       element.imgElementOrig = element.imgElement;
       element.bVisible = TRUE;
       //element.bDraggable = TRUE;
       element.bIsSketch = FALSE;
        //UIImage*imgTemp = [UIImage imageNamed:element.strImageName];
        int iHeadHgt = super.iNewW*(float)element.imgElement.size.height/element.imgElement.size.width;
        element.rctFrame = CGRectMake(0, 0, super.iNewW,iHeadHgt);
        element.pntDrag = CGPointMake(0, 0);
        element.fAngleRotation = 0.0;
        element.fScaleFactor = 1.0;
        element.iGender = bIsMale;
        //element.iLayerID = 3;
        element.cgBlendMode = kCGBlendModeNormal;
        [super.m_ArrElements addObject:element];
       element = nil;


   }
    return self;
}
-(NSString*)GetEffectName
{
    return @"Zombie";
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
