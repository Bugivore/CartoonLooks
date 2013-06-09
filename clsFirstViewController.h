//
//  clsFirstViewController.h
//  FotoKartoon
//
//  Created by Vishalsinh Jhala on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MessageUI/MessageUI.h>


@interface clsNewPhoto : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate>
{
    BOOL m_bNewMedia;
    float m_fScaleUp;
    NSNumber *ExifISOSpeed;
    float rawShutterSpeed;
    int m_iFace;
    float m_fAngle;
    //UIImageOrientation m_uiOrient;
    
    UIAlertView * m_alert;
    UIView* photoView;
    UIView* m_MFView;
    UIScrollView *m_sviewFaces;
    UIImage *m_inImgOriginal;
    //UIImage *m_inImgOriented;
    NSArray *features;
    UIPopoverController *popover;
    UIButton *m_btnPhotosBack;
}
@property (strong, nonatomic) id dataObject;
-(void)GoToSelectState;
-(void)btnCameraRoll;

@end
