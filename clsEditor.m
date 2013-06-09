//
//  clsEditor.m
//  MessMyLooks
//
//  Created by Vishalsinh Jhala on 9/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "clsEditor.h"
#import "clsGlobalHelper.h"
#import "effZombie.h"
#import "effSportFan.h"
#import "effJoker.h"
#import "effPirate.h"
#import "effTribal.h"
#import "effFerros.h"
#import "effPilot.h"
#import "effSanta.h"
#import "effGeek.h"
#import "clsBilateralFilter.h"
#import "GAI.h"
#import "clsAppDelegate.h"

#import <QuartzCore/QuartzCore.h>

@interface clsEditor ()

@property(nonatomic, assign) clsAppDelegate *appDelegate;

@end


@implementation clsEditor
@synthesize m_eff;
@synthesize m_iSelectedElement;
@synthesize m_fScaleToView;
@synthesize iMarginX;
@synthesize iMarginY;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.appDelegate = [UIApplication sharedApplication].delegate;

        m_cgDataProviderSketch = nil;
        m_cgImageRefSketch = nil;
        m_piDataSketch = nil;
        
        gestDrag = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragGesture:)];
        [gestDrag setMinimumNumberOfTouches:1];
        [gestDrag setMaximumNumberOfTouches:1];
        [self addGestureRecognizer:gestDrag]; 
        gestDrag.delegate = self;
        m_iSelectedElement = -1;
        
        gestPinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        [self addGestureRecognizer:gestPinch];
        gestPinch.delegate = self;
        
        gestRotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
        [self addGestureRecognizer:gestRotate];
        gestRotate.delegate = self;
        
        // Initialization code
        m_dlgSelectLayer = nil;
        m_bWindowActive = false;
    }
    return self;
}
////////////////////////////////
/// Event Management
////////////////////////////////
-(void)ResetAllEvents:(BOOL)bValue:(int)iBtn
{
    if(bValue)
    {
        if(m_btnToolbar)
        m_btnToolbar.layer.shadowColor = [[UIColor clearColor] CGColor];
        //m_btnToolbar.layer.shadowRadius = 4.0f;
        //m_btnToolbar.layer.shadowOpacity = .9;
        //m_btnToolbar.layer.shadowOffset = CGSizeZero;
        //m_btnToolbar.layer.masksToBounds = NO;

        m_bWindowActive = FALSE;
        for(int i=0;i<5;i++)
            if (i!=iBtn)
                [(UIButton*)[m_Toolbar.m_arrButtons objectAtIndex:i] setHidden:FALSE];

        //[self addGestureRecognizer:gestTap];
        [self addGestureRecognizer:gestDrag];
        [self addGestureRecognizer:gestPinch];
        [self addGestureRecognizer:gestRotate];
    }
    else
    {
        m_bWindowActive = TRUE;
        for(int i=0;i<5;i++)
            if (i!=iBtn)
                [(UIButton*)[m_Toolbar.m_arrButtons objectAtIndex:i] setHidden:TRUE];
        //[self removeGestureRecognizer:gestTap];
        [self removeGestureRecognizer:gestDrag];
        [self removeGestureRecognizer:gestPinch];
        [self removeGestureRecognizer:gestRotate];
    }
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    if(m_iSelectedElement<0)
        return;//[self ShowLayerWindow];
    
    clsDataElement* element = [m_eff.m_ArrElements objectAtIndex:m_iSelectedElement];
    m_pntOldDrag = element.pntDrag;
    element = nil;
    
}
-(void)dragGesture:(UIPanGestureRecognizer*)gesture
{
    if(!m_inFace)
        return;
    if(m_iSelectedElement<0)
    {
        [self ShowLayerWindow];
        return;
    }

    if([(UIPanGestureRecognizer*)gesture state] == UIGestureRecognizerStateChanged) {
        
        
        clsDataElement *element = [m_eff.m_ArrElements objectAtIndex:m_iSelectedElement];

        CGPoint pnt = [gesture translationInView:self];
        pnt = [self TranslateVwPnt2Img:pnt];
        
        element.pntDrag = CGPointMake(pnt.x+m_pntOldDrag.x,-pnt.y+m_pntOldDrag.y);
        
        [m_viewElement setNeedsDisplay];
        
        element = nil;
        
    }        
}
-(void)singleTapGestureCaptured:(UIButton *)gesture
{
    //UIView* view = gesture.view;
    //CGPoint loc = [gesture locationInView:view];
    //UIView* subview = [view hitTest:loc withEvent:nil];
    if(!m_inFace  || m_bWindowActive)
        return;
    //Select Layer
    if(gesture.tag ==101)
    {
        m_btnToolbar = gesture;
        gesture.layer.shadowColor = [[UIColor yellowColor] CGColor];
        gesture.layer.shadowRadius = 4.0f;
        gesture.layer.shadowOpacity = .9;
        gesture.layer.shadowOffset = CGSizeZero;
        gesture.layer.masksToBounds = NO;
        
        [self ShowLayerWindow];
        
        //id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-37566182-1"];

        [self.appDelegate.tracker sendEventWithCategory:@"Customize"
                            withAction:@"Select Layer"
                             withLabel:[m_eff GetEffectName]
                             withValue:[NSNumber numberWithInt:1]];

    }
    //Eye
    if(gesture.tag ==102)
    {
        if(m_iSelectedElement<0)
        {
            [self ShowLayerWindow];
            return;
        }

        clsDataElement *element = [m_eff.m_ArrElements objectAtIndex:m_iSelectedElement];
        if(element.bIsSketch)
            return;
        element.bVisible = !element.bVisible;
        [m_viewElement setNeedsDisplay];
        element = nil;
        
    }
    //Effect
    if(gesture.tag ==103)
    {
        m_btnToolbar = gesture;
        gesture.layer.shadowColor = [[UIColor yellowColor] CGColor];
        gesture.layer.shadowRadius = 4.0f;
        gesture.layer.shadowOpacity = 1.0;
        gesture.layer.shadowOffset = CGSizeZero;
        gesture.layer.masksToBounds = NO;

        
        if(m_dlgSelectEffect)
        {
            [m_dlgSelectEffect removeFromSuperview];
            m_dlgSelectEffect = nil;
        }
        m_dlgSelectEffect = [[dlgSelectEffect alloc] initWithFrame:CGRectMake(0.0f+10, 0.0f+50, self.frame.size.width-20, self.frame.size.height-60)];
        
            
        [self addSubview:m_dlgSelectEffect];
        [m_dlgSelectEffect Create];
    }
    //reset
    if(gesture.tag ==104)
    {
        UIAlertView *replay = [[UIAlertView alloc] initWithTitle:@"Reset" message:@"Changes will be lost" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Reset",nil];
        
        [replay show];

    }
    //Information
    if(gesture.tag ==105)
    {
        m_btnToolbar = gesture;
        gesture.layer.shadowColor = [[UIColor yellowColor] CGColor];
        gesture.layer.shadowRadius = 4.0f;
        gesture.layer.shadowOpacity = 1.0;
        gesture.layer.shadowOffset = CGSizeZero;
        gesture.layer.masksToBounds = NO;

        if(m_dlgInformation)
        {
            [m_dlgInformation removeFromSuperview];
            m_dlgInformation = nil;
        }
        
        m_dlgInformation = [[clsInfoView alloc] initWithFrame:CGRectMake(self.frame.size.width-300, 0.0f+50, 290, 350)];
        
        [self addSubview:m_dlgInformation];

            CATransition *animation = [CATransition animation];
            [animation setDuration:0.5];
            [animation setType:kCATransitionReveal];
            [animation setSubtype:kCATransitionFromBottom];
            [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            
            [[self layer] addAnimation:animation forKey:@"SwitchToView1"];
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            
        [m_dlgInformation Create:m_lHistogram:m_inFace.iFaceWidth:m_inFace.iFaceHeight:m_inFace.img:m_fExposure:m_iISOSpeed];
        
            [UIView commitAnimations]; 
            animation = nil;
        //}
        
        

    }
    
    //view = NULL;
    //subview = NULL;
    
    
}
-(void)RefreshEditorView
{
    [m_viewElement setNeedsDisplay];
}
-(void)singleTapGestureCaptured1:(UITapGestureRecognizer *)gesture
{
    UIView* view = gesture.view;
    CGPoint loc = [gesture locationInView:view];
    UIView* subview = [view hitTest:loc withEvent:nil];
    
    if(!m_inFace)
        return;
    //Clicked on View anywhere
    if(subview.tag == 201)
    {
        
        if(m_Toolbar.alpha<0.6)
        {
            [self doSingleViewShowAnimation];
            [self performSelector:@selector(doSingleViewHideAnimation) withObject:nil afterDelay:5];
        }
    }
}
    
    //Select Layer

-(void)ShowLayerWindow
{
    if(m_dlgSelectLayer)
    {
        [m_dlgSelectLayer removeFromSuperview];
        m_dlgSelectLayer = nil;
    }
    m_dlgSelectLayer = [[clsSelectLayer alloc] initWithFrame:CGRectMake(10,50,100,275)];

    [self addSubview:m_dlgSelectLayer];
    
    if([m_eff isKindOfClass:[effSportFan class]])
    {   
        m_dlgSelectLayer.frame = CGRectMake(10,50,250,275);
        
        [m_dlgSelectLayer Create:TRUE];
    }
    else
        [m_dlgSelectLayer Create:FALSE];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	// NO = 0, YES = 1
	if(buttonIndex == 1)
        [self SelectALook:m_iLastLooks];

        
}
- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer {    

    if(!m_inFace)
        return;
    if(m_iSelectedElement<0)
    {
        [self ShowLayerWindow];
        return;
    }
    
    clsDataElement *element = [m_eff.m_ArrElements objectAtIndex:m_iSelectedElement];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        m_fOldPinchScale = element.fScaleFactor;
        return;
    }
    
    element.fScaleFactor = m_fOldPinchScale+ (recognizer.scale-1);
    if(element.fScaleFactor<0.5)
        element.fScaleFactor = 0.5;
    if(element.fScaleFactor>2.0)
        element.fScaleFactor=2.0;
    
    [m_viewElement setNeedsDisplay];

    
    
}
    
- (void)handleRotate:(UIRotationGestureRecognizer *)recognizer {    
    
    if(!m_inFace)
        return;
    if(m_iSelectedElement<0)
    {
        [self ShowLayerWindow];
        return;
    }

    clsDataElement *element = [m_eff.m_ArrElements objectAtIndex:m_iSelectedElement];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        m_fOldRotation = element.fAngleRotation;
        return;
    }
    
    if(fabs(recognizer.rotation-m_fRotationDelta)<0.1)
        return;

    element.fAngleRotation = m_fOldRotation + recognizer.rotation;
    m_fRotationDelta = recognizer.rotation;
    
    [m_viewElement setNeedsDisplay];
    element = nil;
    
}
-(CGPoint)TranslateVwPnt2Img:(CGPoint)pntIn
{
    CGPoint pntClick = CGPointMake(pntIn.x*1/m_fScaleToView, pntIn.y*1/m_fScaleToView);
    return pntClick;
}



///////////////////////////////////
// Editor UI and helpers
////////////////////////////////////
-(void)CleanUpEditor
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    m_pntOldDrag = CGPointZero;
    m_fOldPinchScale = 1.0;
    m_fOldRotation = 0.0;
    
    //[m_ErrViewElement removeAllObjects];
    m_viewElement = nil;
    m_iSelectedElement = -1;
    [self ResetAllEvents:TRUE:6];
    

    
    
}
/*-(CGRect)GetRectForBlendLayer:(int)i
{
    return ((clsViewElement*)[m_ErrViewElement objectAtIndex:i]).frame;
}*/

-(void)CreateElementViews
{
    
    [self CleanUpEditor];
    
    
    for (clsDataElement* element in m_eff.m_ArrElements)
    {
        m_viewElement = [[clsViewElement alloc] initWithFrame:CGRectMake(10,44,self.frame.size.width-20,self.frame.size.height-94)];
        m_viewElement.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        m_viewElement.clipsToBounds = TRUE;
        m_viewElement.layer.masksToBounds = NO;
        m_viewElement.layer.cornerRadius = 10; // if you like rounded corners
        m_viewElement.layer.shadowOffset = CGSizeMake(0, 0);
        m_viewElement.layer.shadowRadius = 5;
        m_viewElement.layer.shadowOpacity = 1;
        

        [self addSubview:m_viewElement];
        //[m_ErrViewElement addObject:view];
        
    }
    float fSH = (float)m_viewElement.frame.size.height/m_eff.iNewH;
    float fSW = (float)m_viewElement.frame.size.width/m_eff.iNewW;
    m_fScaleToView = MIN(fSH, fSW);
    
    //Calculate Margin
    iMarginX = (m_viewElement.frame.size.width -  m_eff.iNewW*m_fScaleToView)/2.0;
    iMarginY = (m_viewElement.frame.size.height - m_eff.iNewH*m_fScaleToView)/2.0;
    
    [m_viewElement  setNeedsDisplay];
    
}
-(void)SelectALook:(int)i
{
    [self GetLooks:i];
    
    //Save Image
    [self CreateElementViews];
    [self CreateToolBar];
}
-(UIImage*)GetCurrentEffect
{
    UIGraphicsBeginImageContext(CGSizeMake(m_eff.iNewW,m_eff.iNewH));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // Flip Context
    CGContextTranslateCTM(ctx, 0, m_eff.iNewH);
    CGContextScaleCTM(ctx, 1.0f, -1.0f);
    
    for (clsDataElement *element in m_eff.m_ArrElements)
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
                
        CGContextSetBlendMode(ctx, element.cgBlendMode);
        
        CGContextDrawImage(ctx, rctTemp  , element.imgElement.CGImage);
    }
    UIImage *imgOutCanvas = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imgOutCanvas;
}
/*-(clsDataFeedback *)GetFeedbackData
{
     clsDataFeedback *data = [clsDataFeedback new];
     data.iWidth = m_inFace.iFaceWidth;
     data.iHeight = m_inFace.iFaceHeight;
     
     NSMutableString *strTemp = [[NSMutableString alloc ] init];
     
     for(int i=0;i<256;i++)
         [strTemp appendFormat:@"%ld,", m_lHistogram[i]];
     
    data.strEffectName = [m_eff GetEffectName];
     data.strHistogram = [NSString stringWithString:strTemp];
     data.fExposureTime = m_fExposure;
     data.fISOSensitivity = m_iISOSpeed;
     data.iEdgePercent = (float)m_lEdges*100/(m_inFace.iFaceWidth*m_inFace.iFaceHeight);
    
    strTemp = nil;
    
    return data;

}*/
-(void)GetLooks:(int)iAdder
{
    m_eff = nil;
    m_iLastLooks = iAdder;
    //appDelegate = ;
    //id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-37566182-1"];

    switch (iAdder) {
        case 0:
            m_eff = [[effZombie alloc] init:m_inFace :m_bIsMale];
            break;
        case 1:
            m_eff = [[effPirate new] init:m_inFace :m_bIsMale];
            break;
        case 2:
            m_eff = [[effJoker new] init:m_inFace :m_bIsMale];
            break;
        case 3:
            m_eff = [[effTribal new] init:m_inFace :m_bIsMale];
            break;
        case 4:
            m_eff = [[effGeek new] init:m_inFace :m_bIsMale];
            break;
        case 5:
            m_eff = [[effFerros new] init:m_inFace :m_bIsMale];
            break;
        case 6:
            m_eff = [[effSportFan new] init:m_inFace :m_bIsMale];
            break;
        case 7:
            m_eff = [[effPilot new] init:m_inFace :m_bIsMale];
            break;
        case 8:
            m_eff = [[effSanta new] init:m_inFace :m_bIsMale];
            break;
            
        default:
            break;
    }
    [self.appDelegate.tracker sendEventWithCategory:@"NewLooks"
                        withAction:[m_eff GetEffectName]
                         withLabel:[m_eff GetEffectName]
                         withValue:[NSNumber numberWithInt:1]];
    
}
-(void)CreateToolBar
{
    
    m_Toolbar = [[clsEditToolbar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];

    
    [m_Toolbar Prepare];             
    [self addSubview:m_Toolbar];
    m_Toolbar.hidden = FALSE;
    
}
-(void)doSingleViewHideAnimation
{   
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    //[animation setSubtype:kCATransitionFromTop];
    
    [animation setDuration:0.5];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[m_Toolbar layer] addAnimation:animation forKey:kCATransition];
    
    [UIView beginAnimations:nil context:NULL];
    m_Toolbar.alpha = 0.5;
    [UIView commitAnimations];   
    
    animation = nil;
}
-(void)doSingleViewShowAnimation
{   
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    //[animation setSubtype:kCATransitionFromBottom];
    
    [animation setDuration:0.5];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[m_Toolbar layer] addAnimation:animation forKey:kCATransition];
    
    [UIView beginAnimations:nil context:NULL];
    //m_Toolbar.hidden = NO;
    m_Toolbar.alpha = 0.85;

    [UIView commitAnimations];    
    animation = nil;

}

///////////////////////////////////
// Making initial sketch
////////////////////////////////////

-(void)threadSketching
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Apply Sketch Effect
        UIImage*imgSkew = [[UIImage alloc] initWithCGImage:m_inFace.img.CGImage ];//m_inFace.img;

        float fS=0;
        imgSkew = [clsGlobalHelper resizeImage:imgSkew :200 :&fS];
        
        UIImage *imgSketch;
        imgSketch = [self Sketch:imgSkew];
        imgSketch = [clsGlobalHelper resizeImage:imgSketch :m_inFace.img.size.width :&fS];

        m_inFace.imgSketch = imgSketch;
        
        imgSketch = NULL;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self ShowSketchInMain];
        });
        
    });
    
}
-(void)ShowSketchInMain
{
    [self GetLooks:0];
    
    //Save Image
    [self CreateElementViews];
    [self CreateToolBar];
    
    [m_LoadingView RemoveView];
    m_LoadingView = nil;
    
    /*if(m_dlgInformation)
    {
        [m_dlgInformation removeFromSuperview];
        m_dlgInformation = nil;
    }
    
    m_dlgInformation = [[clsInfoView alloc] initWithFrame:CGRectMake(self.frame.size.width-300, 0.0f+50, 290, 350)];
    
    [m_dlgInformation Create:m_lHistogram:m_inFace.iFaceWidth:m_inFace.iFaceHeight:m_lEdges:m_inFace.img:m_fExposure:m_iISOSpeed];

    if( [m_dlgInformation CalculateValues:m_lHistogram:m_inFace.iFaceWidth:m_lEdges:m_fExposure:m_iISOSpeed] >= 2 )
    {
        NSString *msg = [NSString stringWithFormat:@"%@\n%@",
         [m_dlgInformation GetIssueMessage],
         @"Checkout the Tips for details."];

         UIAlertView *replay = [[UIAlertView alloc] initWithTitle:@"Failed to Draw Good Cartoon"
        message:msg delegate:self cancelButtonTitle:@"Got it!" otherButtonTitles:nil, nil ,nil];
        
        [replay show];

    }*/
}
-(void)MakeAvatar:(clsDataFace*)inFace:(Boolean)bIsMale:(float) fExposure:(int) iIsoSpeed
{      
    
    //[m_viewElement removeFromSuperview];

    m_LoadingView = [LoadingView new];
    [m_LoadingView ShowAlertView];
    m_inFace = NULL;
    m_inFace = inFace;
    m_bIsMale = bIsMale;
    //m_inOrientation = inOrient;
    //m_fExposure = fExposure;
    //m_iISOSpeed = iIsoSpeed;
    
    
    if(m_cgImageRefSketch)
        CGImageRelease(m_cgImageRefSketch);
    
    if(m_cgDataProviderSketch)
        CGDataProviderRelease(m_cgDataProviderSketch);
    
    if(m_piDataSketch)
        free(m_piDataSketch);

    [self threadSketching];
    
}
-(UIImage*)Sketch:(UIImage*)inImage
{
    NSDate *methodStart;// = [NSDate date];
    NSDate *methodFinish;// = [NSDate date];
    NSTimeInterval executionTime;// = [methodFinish timeIntervalSinceDate:methodStart];
    
    methodStart = [NSDate date];

    
    //////////////////////////////
    // Filter
    //////////////////////////////
    
    
    //////////////////////////////
    // Bilateral
    //////////////////////////////
    imatrix *imgR,*imgG,*imgB;
    imgR= [imatrix new];
	[imgR initVal:inImage.size.height: inImage.size.width];
    
    imgG = [imatrix new];
	[imgG initVal:inImage.size.height: inImage.size.width];
    
    imgB = [imatrix new];
	[imgB initVal:inImage.size.height: inImage.size.width];

    [self ManipulateImagePixelData:inImage.CGImage:imgR:imgG:imgB:true];
    
    clsBilateralFilter *bf = [clsBilateralFilter alloc];
    [bf BFilterMain:imgR:imgG:imgB:7 :10.5 :0.2 :inImage.size.height :inImage.size.width];
    //UIImage* finalImage = [self CopyMatrix2Img:inImage:img];
    UIImage* finalImage = [self convertBitmapRGBA8ToUIImage:imgR:imgG:imgB:inImage.size.width: inImage.size.height];
     imgR = imgG = imgB = NULL;
    
    
    /*CIImage *ciImageScaled = [[CIImage alloc] initWithImage:finalImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorPosterize" ];//CILineOverlay  CIColorPosterize
    [filter setDefaults];
    [filter setValue:[NSNumber numberWithDouble:32.0] forKey:@"inputLevels"];
    [filter setValue: ciImageScaled forKey:@"inputImage"];
    CIImage *outputCIImage = [filter outputImage];
    CGImageRef cgimg = [context createCGImage:outputCIImage fromRect:[outputCIImage extent]];
    finalImage = [UIImage imageWithCGImage:cgimg];*/
    //finalImage = [UIImage imageWithCIImage:outputCIImage ];
    
    
    //finalImage = [clsGlobalHelper rotateToOrientUp:finalImage:m_inOrientation];
    
    methodFinish = [NSDate date];
    executionTime = [methodFinish timeIntervalSinceDate:methodStart];
    NSLog(@"Feature Execution Time: %f", executionTime);
    
    
    return finalImage;
    
}
-(UIImage *) convertBitmapRGBA8ToUIImage:(imatrix*)imgR:(imatrix*)imgG:(imatrix*)imgB
                                        :(int) width
                                        :(int) height
{
	
    m_piDataSketch = malloc( width*height*4);
    
	int iStep,jStep;
    for (int i = 0; i < height; i++)
    {
        iStep = i*width*4;
        for (int j = 0; j < width; j++)
        {
            jStep = j*4;
            m_piDataSketch[iStep+jStep+0] =imgR.p[i][j];
            m_piDataSketch[iStep+jStep+1] =imgG.p[i][j];
            m_piDataSketch[iStep+jStep+2] = imgB.p[i][j];
            
            //if(img.p[i][j]<128)
              //  m_lEdges++;

        }
    }
    
    m_cgDataProviderSketch = CGDataProviderCreateWithData(NULL,
                                                            m_piDataSketch,
                                                            width*height*4,
                                                            NULL);
    
    m_cgImageRefSketch = CGImageCreate(width, height, 8, 32, width*4, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaNoneSkipLast, m_cgDataProviderSketch, NULL, false, kCGRenderingIntentDefault);
	
	UIImage *finalImage = [UIImage imageWithCGImage:m_cgImageRefSketch];

	
    return finalImage;
    
}
-(void) ManipulateImagePixelData:(CGImageRef)inImage:(imatrix*)imgR:(imatrix*)imgG:(imatrix*)imgB:(Boolean)bUpdateHistogram
{
    // Create the bitmap context
    CGContextRef cgctx = [self CreateARGBBitmapContext:inImage];
    if (cgctx == NULL)
    {
        // error creating context
        return;
    }
    
    // Get image width, height. We'll use the entire image.
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(cgctx, rect, inImage);
    
    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    UInt8 *data = CGBitmapContextGetData (cgctx);
    //int bits = CGBitmapContextGetBitsPerPixel(cgctx);
    //int bytesprrow = CGBitmapContextGetBytesPerRow(cgctx);
    
    if (data != NULL)
    {
        
        // **** You have a pointer to the image data ****
        
        // **** Do stuff with the data here ****
        //Convert GreyScale and copy data
        if(bUpdateHistogram)
            for(int i=0;i<256;i++)
                m_lHistogram[0][i]=m_lHistogram[1][i]=m_lHistogram[2][i]=0;
        
        int iStep,jStep;
        
        for (int i = 0; i < h; i++)
        {
            iStep = i*w*4;
            //iStepGrey = i*m_iW;
            for (int j = 0; j < w; j++)
            {
                jStep = j*4;
                imgR.p[i][j] = data[iStep + jStep];
                imgG.p[i][j] = data[iStep + jStep +1];
                imgB.p[i][j] = data[iStep + jStep +2];
                if(bUpdateHistogram)
                {
                    m_lHistogram[0][imgR.p[i][j]]++;
                    m_lHistogram[1][imgG.p[i][j]]++;
                    m_lHistogram[2][imgB.p[i][j]]++;

                }

            }
        }
        
    }
    
    // When finished, release the context
    CGContextRelease(cgctx);
    // Free image data memory for the context
    if (data)
    {
        free(data);
    }
    
}

-(CGContextRef )CreateARGBBitmapContext: (CGImageRef) inImage
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    //colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaNoneSkipLast);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    
    return context;
}

@end
