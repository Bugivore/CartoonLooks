//
//  clsEditor.h
//  MessMyLooks
//
//  Created by Vishalsinh Jhala on 9/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "clsDataFace.h"
#import "LoadingView.h"
#import "clsEffectBase.h"
#import "clsEditToolbar.h"
#import "clsSelectLayer.h"
#import "dlgSelectEffect.h"
#import "clsViewElement.h"
#import "clsInfoView.h"

@interface clsEditor : UIView <UIGestureRecognizerDelegate,UIAlertViewDelegate>

{
    //Events
    UIPanGestureRecognizer *gestDrag; 
    //UITapGestureRecognizer *gestTap;
    UIPinchGestureRecognizer *gestPinch;
    UIRotationGestureRecognizer *gestRotate;
    float m_fOldPinchScale;
    float m_fOldRotation;
    CGPoint m_pntOldDrag;
    float m_fRotationDelta;
    int m_iLastLooks;
    
    //SubViews/Editor Specific
    clsSelectLayer *m_dlgSelectLayer;
    clsInfoView *m_dlgInformation;
    dlgSelectEffect *m_dlgSelectEffect;
    //NSMutableArray *m_ErrViewElement;
    clsViewElement *m_viewElement;
    clsEditToolbar *m_Toolbar;
    UIPopoverController *popover;
    long m_lHistogram[3][256];
    //long m_lEdges;
    //UIImageOrientation m_inOrientation;
    float m_fExposure;
    int m_iISOSpeed;
    UIButton *m_btnToolbar;
    Boolean m_bWindowActive;
    
    //Sketch Specific
    clsDataFace *m_inFace;
    LoadingView *m_LoadingView;
    
    CGDataProviderRef m_cgDataProviderSketch;
    CGImageRef m_cgImageRefSketch;
    UInt8 *m_piDataSketch;
    
    Boolean m_bIsMale;

}
@property clsEffectBase *m_eff;
@property int m_iSelectedElement;
@property float m_fScaleToView;
@property int iMarginX;
@property int iMarginY;

-(void)MakeAvatar:(clsDataFace*)inFace:(Boolean)bIsMale:(float) fExposure:(int) iIsoSpeed;
//-(CGRect)GetRectForBlendLayer:(int)i;
-(void)SelectALook:(int)i;
-(void)ResetAllEvents:(BOOL)bValue:(int)iBtn;
-(void)RefreshEditorView;
-(UIImage*)GetCurrentEffect;
//-(clsDataFeedback *)GetFeedbackData;



@end
