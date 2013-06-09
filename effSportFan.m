//
//  effSumo.m
//  FotoKartoon
//
//  Created by Vishalsinh Jhala on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "effSportFan.h"

@implementation effSportFan

-(id)init:(clsDataFace*)inFaceData:(Boolean)bIsMale
{
    self = [super init];
    m_iCountryID = 9;
    //Percentage Face Width
    fLeftMargin = 0.0;
    fRightMargin = 0.0;
    fTopMargin = 125/481.0;
    fBottomMargin = 0;
    
    super.iNewW = inFaceData.imgSketch.size.width + inFaceData.imgSketch.size.width*fLeftMargin + inFaceData.imgSketch.size.width*fRightMargin;
    super.iNewH = inFaceData.imgSketch.size.height + inFaceData.imgSketch.size.height*fTopMargin + inFaceData.imgSketch.size.height*fBottomMargin;
    
    super.iStartX = inFaceData.imgSketch.size.width  * fLeftMargin;
    super.iStartY = inFaceData.imgSketch.size.height * fTopMargin;
    super.m_ArrElements = [[NSMutableArray alloc] initWithCapacity:3];
    
    m_strCountry = @"sport-usa1";
    m_strCountryCap = @"sport-usa cap1";
    //flag
    {
        clsDataElement * element = [clsDataElement alloc];
        element.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:m_strCountry ofType:@"png"]];
        element.imgElementOrig = element.imgElement;
        element.bIsSketch = FALSE;
        element.bVisible = TRUE;
        element.rctFrame = CGRectMake(0,0 ,inFaceData.imgSketch.size.width,inFaceData.imgSketch.size.height);
        //element.bDraggable = TRUE;
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
        element.imgElement = inFaceData.imgSketch;
        element.imgElementOrig = element.imgElement;
        element.bIsSketch = TRUE;
        element.bVisible = TRUE;
        //element.bDraggable = FALSE;
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
    // Hair
    {
        clsDataElement * element = [clsDataElement alloc];
        element.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:m_strCountryCap ofType:@"png"]];
        element.imgElementOrig = element.imgElement;
        element.bIsSketch = FALSE;
        element.bVisible = TRUE;
        //element.bDraggable = TRUE;
        element.rctFrame = CGRectMake(0, 0, super.iNewW,super.iNewH);
        element.pntDrag = CGPointMake(0, 0);
        element.fAngleRotation = 0.0;
        element.fScaleFactor = 1.0;
        element.iGender = bIsMale;
        //element.iLayerID = 1;
        element.cgBlendMode = kCGBlendModeNormal;
        [super.m_ArrElements addObject:element];
        element = nil;

    }

    
    
    return self;
}
-(int)getCountryID
{
    return m_iCountryID;
}
-(void)setCountryID:(int)iCountry
{
    /*@"Australia",
    @"Brazil",
    @"France",
    @"Germany",
    @"India",
    @"Italy",
    @"NewZealand",
    @"Spain",
    @"UK",
    @"USA",*/
    m_iCountryID = iCountry;
    clsDataElement *element = [super.m_ArrElements objectAtIndex:0];
    clsDataElement *elementC = [super.m_ArrElements objectAtIndex:2];
    
    switch (iCountry) {
        case 0:
            element.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sport-aus" ofType:@"png"]];
            elementC.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sport-aus cap" ofType:@"png"]];
            break;
        case 1:
            element.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sport-brazil" ofType:@"png"]];
            elementC.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sport-brazil cap" ofType:@"png"]];
            break;
        case 2:
            element.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sport-france" ofType:@"png"]];
            elementC.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sport-france cap" ofType:@"png"]];
            break;
        case 3:
            element.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sport-germany" ofType:@"png"]];
            elementC.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sport-germany cap" ofType:@"png"]];
            break;
        case 4:
            element.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sport-india" ofType:@"png"]];
            elementC.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sport-india cap" ofType:@"png"]];
            break;
        case 5:
            element.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sport-italy" ofType:@"png"]];
            elementC.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sport-italy cap" ofType:@"png"]];
            break;
        case 6:
            element.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sport-Kuwait" ofType:@"png"]];
            elementC.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sport-kuwait cap" ofType:@"png"]];
            break;
        case 7:
            element.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sport-nz" ofType:@"png"]];
            elementC.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sport-nz cap" ofType:@"png"]];
            break;
        case 8:
            element.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sport-spain" ofType:@"png"]];
            elementC.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sport-spain cap" ofType:@"png"]];
            break;
        case 9:
            element.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sport-uk" ofType:@"png"]];
            elementC.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sport-uk cap" ofType:@"png"]];
            break;
        case 10:
            element.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sport-usa1" ofType:@"png"]];
            elementC.imgElement = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sport-usa cap1" ofType:@"png"]];
            break;
    
        default:
            break;
    }

}
-(NSString*)GetEffectName
{
    return @"Spirit";
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
