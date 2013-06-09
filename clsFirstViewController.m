//
//  clsFirstViewController.m
//  FotoKartoon
//
//  Created by Vishalsinh Jhala on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "clsFirstViewController.h"
#import "clsViewEditor.h"
#import "clsDataFace.h"
#import "clsGlobalHelper.h"
#import <QuartzCore/QuartzCore.h>

const float c_iPerEyeWdt=0.30;
const float c_iPerEyeHgt=0.30;
const float c_iPerMouthWdt=0.40;
const float c_iPerMouthHgt=0.10;


@interface clsNewPhoto ()

@end

@implementation clsNewPhoto
@synthesize dataObject = _dataObject;
-(void)viewWillAppear:(BOOL)animated 
{ 

    [super viewWillAppear:animated]; 
    [self JSDestructor];
    [self CreateScrollView];
    [self CreateMFView];
    [self doSingleViewHideAnimation:0];

    
}
-(void)backPressed: (id)sender
{
    [self.navigationController popViewControllerAnimated: YES]; // or popToRoot... if required.
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIView* vwHeading = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"HeadingBar" ofType:@"jpg"];
    vwHeading.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:fileName]];
    vwHeading.layer.shadowColor = [UIColor blackColor].CGColor;
    vwHeading.layer.masksToBounds = NO;
    vwHeading.layer.shadowOffset = CGSizeMake(0, 0);
    vwHeading.layer.shadowRadius = 5;
    vwHeading.layer.shadowOpacity = 1;

    [self.view addSubview:vwHeading];
     
    UIImage*imgBk =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"background" ofType:@"jpg"]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:imgBk];
    
    [self CreatePhotoView];

}
-(void)JSDestructor
{
    //Cleanup any subview if present
    for(UIView *subview in [m_sviewFaces subviews]) {
        [subview removeFromSuperview];
    }
    [m_sviewFaces removeFromSuperview];
    m_sviewFaces = nil;
    
    features=nil;
    m_inImgOriginal = nil;
    m_inImgOriginal = nil;
    [m_MFView removeFromSuperview];
    m_MFView = nil;
    m_alert = nil;
}
-(void)CreateScrollView
{
    //Create Face View
    int iScreenW = self.view.frame.size.width*0.8;

    m_sviewFaces   = [[UIScrollView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-iScreenW)/2.0, photoView.frame.origin.y+photoView.frame.size.height+10, iScreenW, 30)];
    [self.view addSubview:m_sviewFaces];
    m_sviewFaces.alpha = 0.9;
    m_sviewFaces.layer.cornerRadius = 5;
    
    /*CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor darkGrayColor] CGColor], (id)[[UIColor lightGrayColor] CGColor], nil];
    gradient.frame = CGRectMake(0, 0, photoView.frame.size.width, self.view.frame.size.height-100);
    [m_sviewFaces.layer insertSublayer:gradient atIndex:0];
    */
    //Select Face Label
    [m_sviewFaces addSubview:[clsGlobalHelper GetGradientLabel:@"Select Face" :CGRectMake(0,0, photoView.frame.size.width, 30) :18.0  ]];
    
    [m_sviewFaces setCanCancelContentTouches:NO];
    
    m_sviewFaces.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    m_sviewFaces.clipsToBounds = YES;
    m_sviewFaces.scrollEnabled = YES;
    m_sviewFaces.pagingEnabled = YES;

}
-(void)CreatePhotoView
{
    int iScreenW = self.view.frame.size.width*0.8;
    int iScreenH = 150;
    
    photoView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-iScreenW)/2.0, (self.view.frame.size.height-self.tabBarController.tabBar.frame.size.height -iScreenH)/2.0, iScreenW, iScreenH)];
    photoView.alpha = 0.9;
    photoView.clipsToBounds = TRUE;
    photoView.layer.cornerRadius = 5;
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor darkGrayColor] CGColor], (id)[[UIColor lightGrayColor] CGColor], nil];
    gradient.frame = photoView.bounds;
    [photoView.layer insertSublayer:gradient atIndex:0];

    //Select Photo Label
    [photoView addSubview:[clsGlobalHelper GetGradientLabel:@"Select Photo" :CGRectMake(0,0, photoView.frame.size.width, 30) :18.0  ]];

    
    //Image Folder Button
    float iconSize = 88;
    int xMargin = (photoView.frame.size.width-2*iconSize)/3.0;
    UIButton *buttonF = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonF.frame = CGRectMake(xMargin , 50,iconSize,iconSize);;
    [buttonF setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ImageFolder" ofType:@"png"]] forState:UIControlStateNormal];
    buttonF.showsTouchWhenHighlighted = TRUE;
    [photoView addSubview:buttonF];
    [buttonF addTarget:self action:@selector(btnCameraRoll) forControlEvents:UIControlEventTouchUpInside];

    //Camera Button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(xMargin*2+iconSize,50,iconSize,iconSize);
    [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"camera" ofType:@"png"]] forState:UIControlStateNormal];
    button.showsTouchWhenHighlighted = TRUE;
    [button addTarget:self action:@selector(btnCamera) forControlEvents:UIControlEventTouchUpInside];
    [photoView addSubview:button];
    
    button = NULL;
    buttonF = NULL;
    
    {
        UIImage *buttonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Photosback" ofType:@"png"]];
        m_btnPhotosBack = [UIButton buttonWithType:UIButtonTypeCustom];
        [m_btnPhotosBack setImage:buttonImage forState:UIControlStateNormal];
        m_btnPhotosBack.frame = CGRectMake(0,0,buttonImage.size.width,buttonImage.size.height);
        m_btnPhotosBack.tag = 101;
        [m_btnPhotosBack addTarget:self action:@selector(btnSelectBack:) forControlEvents:UIControlEventTouchUpInside];
        m_btnPhotosBack.showsTouchWhenHighlighted = TRUE;
        [photoView addSubview:m_btnPhotosBack];
        m_btnPhotosBack.hidden = TRUE;

        buttonImage = NULL;
        //m_btnPhotosBack = NULL;
    }
    
    [self.view addSubview:photoView];
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}
- (void)btnCameraRoll{
    
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = 
        UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *) kUTTypeImage,
                                  nil];
        imagePicker.allowsEditing = NO;
        //[self presentModalViewController:imagePicker animated:YES];
        
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            popover = nil;
            popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
            [popover presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2.0,self.view.frame.size.height,1,1)
 inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            popover.delegate = self;
            
             //self. = popover;
        } else {
            [self presentModalViewController:imagePicker animated:YES];
        }

        
        
        imagePicker = nil;
        //[imagePicker release];
        m_bNewMedia = NO;
    }
    
    
}
-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    //UIImage *originalImage, *editedImage, *imageToSave;
    [self dismissModalViewControllerAnimated:YES];

    // Handle a still image capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        
        rawShutterSpeed = 0.0;
        ExifISOSpeed = 0;
        
        //editedImage = (UIImage *) [info objectForKey:
                                   //UIImagePickerControllerEditedImage];
        m_inImgOriginal = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        UIImageOrientation m_uiOrient = [m_inImgOriginal imageOrientation];
        /*NSString *strOrient;
        
        switch (m_uiOrient)
        {
            case UIImageOrientationUp:
                strOrient = @"UIImageOrientationUp";
                break;
            case UIImageOrientationUpMirrored:
                strOrient = @"UIImageOrientationUpMirrored";
                break;
                
            case UIImageOrientationDown:
                strOrient = @"UIImageOrientationDown";
                break;
                
            case UIImageOrientationDownMirrored:
                strOrient = @"UIImageOrientationDownMirrored";
                
                break;
                
            case UIImageOrientationLeft:
                strOrient = @"UIImageOrientationLeft";
                
                break;
                
            case UIImageOrientationLeftMirrored:
                strOrient = @"UIImageOrientationLeftMirrored";
                
                break;
                
            case UIImageOrientationRight:
                strOrient = @"UIImageOrientationRight";
                
                break;
                
            case UIImageOrientationRightMirrored:
                strOrient = @"UIImageOrientationRightMirrored";
                
                break;
                
            default:
                strOrient = @"No orientation";
                
        }
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Orientation Debug Trace"
                              message: strOrient
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        alert = NULL;
*/
        
        // Get the image metadata
        UIImagePickerControllerSourceType pickerType = picker.sourceType;
        if(pickerType == UIImagePickerControllerSourceTypeCamera)
        {
            NSDictionary *imageMetadata = [info objectForKey:
                                           UIImagePickerControllerMediaMetadata];
            
            NSDictionary *exifDic = [imageMetadata objectForKey:(NSString *)kCGImagePropertyExifDictionary];
            ExifISOSpeed  = [[exifDic objectForKey:(NSString*)kCGImagePropertyExifISOSpeedRatings] objectAtIndex:0];
            
            rawShutterSpeed = [[exifDic objectForKey:(NSString *)kCGImagePropertyExifExposureTime] floatValue];

            
            // Get the assets library
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            ALAssetsLibraryWriteImageCompletionBlock imageWriteCompletionBlock =
            ^(NSURL *newURL, NSError *error) {
                if (error) {
                    NSLog( @"Error writing image with metadata to Photo Library: %@", error );
                } else {
                    NSLog( @"Wrote image with metadata to Photo Library");
                }
            };
            
            // Save the new image (original or edited) to the Camera Roll
            [library writeImageToSavedPhotosAlbum:[m_inImgOriginal CGImage]
                                         metadata:imageMetadata
                                  completionBlock:imageWriteCompletionBlock];
        }
        else
            [self getMetadataFromAssetForURL1:[info objectForKey:UIImagePickerControllerReferenceURL]];
        
        m_inImgOriginal = [clsGlobalHelper rotateToOrientUp:m_inImgOriginal:m_uiOrient];
        
        [self threadFaceDetection:nil];
        [self ShowAlertView];
        picker = nil;
        [popover dismissPopoverAnimated:YES];
    }
    
}

- (void)btnCamera{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = 
        UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *) kUTTypeImage,
                                  nil];
        imagePicker.allowsEditing = NO;
        [self presentModalViewController:imagePicker 
                                animated:YES];
        imagePicker = NULL;

        m_bNewMedia = YES;
    }
    
}

-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error 
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"\
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        alert = NULL;

    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}
-(void)btnSelectFace:(UIButton*)sender{
    
    m_iFace = sender.tag-300;
    [self doSingleViewHideAnimation:2];
        //m_MFView = [self CreateMFView];
        //[self.view addSubview:m_MFView];

}
-(void)btnSelectGender:(UIButton*)sender{
    //Male Clicked
    if(sender.tag ==203)
    {
        clsDataFace *face = [self ProcessSelectedFace];
        
        if(face == NULL)
            return;
        self.tabBarController.selectedIndex = 1;
        clsViewEditor* viewEdit = (clsViewEditor*)self.tabBarController.selectedViewController;

        
        [viewEdit MakeAvatar:face:true:rawShutterSpeed:[ExifISOSpeed intValue]];
        [self JSDestructor];
        face = NULL;
        [m_MFView removeFromSuperview];
        m_MFView = NULL;
        
    }
    //Female Clicked
    if(sender.tag ==204)
    {
        clsDataFace *face = [self ProcessSelectedFace];
        if(face == NULL)
            return;
        self.tabBarController.selectedIndex = 1;
        clsViewEditor* viewEdit = (clsViewEditor*)self.tabBarController.selectedViewController;
        [viewEdit MakeAvatar:face:false:rawShutterSpeed:[ExifISOSpeed intValue]];
        [self JSDestructor];
        face = NULL;
        [m_MFView removeFromSuperview];
        m_MFView = NULL;
    }

}
-(void) btnSelectBack:(UIButton*)sender
{
    [self JSDestructor];
    [self CreateScrollView];
    [self CreateMFView];
    [self doSingleViewHideAnimation:0];


}
-(void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{ 
    
    UIView* view = gesture.view;
    CGPoint loc = [gesture locationInView:view];
    UIView* subview = [view hitTest:loc withEvent:nil];    
    
    //int testtag = subview.tag;
    //Image Folder clicked
    /*if(subview.tag ==201)
    {
        //[self btnCameraRoll];
    }
    //Camera Clicked
    if(subview.tag ==202)
    {
        [self btnCamera];
    }*/
    
    //back select button
    if(subview.tag==101)
    {

    }
    view = NULL;subview = NULL;
}
-(void)GoToSelectState
{
    [self JSDestructor];
   // [m_MFView removeFromSuperview];
    //m_MFView = NULL;

}
/*
-(CGRect)GetOrientedRect:(CGRect) rectFace
{
    CGRect bnds = CGRectMake(rectFace.origin.x, rectFace.origin.y, rectFace.size.width, rectFace.size.height); 
    
    switch (m_uiOrient)
    {
        case UIImageOrientationUp:
            break;
            
        case UIImageOrientationUpMirrored:
            break;
            	
        case UIImageOrientationDown:
            bnds.origin.y = m_inImgOriented.size.height*m_fScaleUp - (rectFace.origin.y+ rectFace.size.height);
            bnds.origin.x = m_inImgOriented.size.width*m_fScaleUp -  (rectFace.origin.x+rectFace.size.width);
            break;
            
        case UIImageOrientationDownMirrored:
            break;
            
        case UIImageOrientationLeft:
            bnds.origin.x = m_inImgOriented.size.height*m_fScaleUp -  (rectFace.origin.y+rectFace.size.height);
            bnds.origin.y = rectFace.origin.x;
            bnds.size.width = rectFace.size.height;
            bnds.size.height = rectFace.size.width;
            break;
            
        case UIImageOrientationLeftMirrored:
            break;
            
        case UIImageOrientationRight:
            bnds.origin.x = rectFace.origin.y;
            bnds.origin.y = m_inImgOriented.size.width*m_fScaleUp - rectFace.origin.x-rectFace.size.height;
            bnds.size.width = rectFace.size.height;
            bnds.size.height = rectFace.size.width;
            break;
            
        case UIImageOrientationRightMirrored:
            break;
            
        default:
            break;
    }
    
    return bnds;
}*/
-(void)threadFaceDetection:(id)data
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //Scale down the image
    float fScale=1.0;
        
    UIImage*inImageScaled = m_inImgOriginal;
        UIImageOrientation ori;
    if(m_inImgOriginal.size.width>1024 || m_inImgOriginal.size.height>1024)
    {
        inImageScaled = [clsGlobalHelper resizeImage:m_inImgOriginal :1024:&fScale];
        ori = inImageScaled.imageOrientation;
    }
    m_fScaleUp = 1/fScale;
    
    //Detect Faces from Main Image    
    CIImage *ciImageScaled = [[CIImage alloc] initWithImage:inImageScaled];

    NSString *accuracy =  CIDetectorAccuracyHigh;
    NSDictionary *options = [NSDictionary dictionaryWithObject:accuracy forKey:CIDetectorAccuracy];
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:options];
    
    features = [detector featuresInImage:ciImageScaled];
        
    ciImageScaled = NULL;
    accuracy = NULL;
    options = NULL;
    detector = NULL;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self AddFacesToView];
        });
        
    });

    
}
-(void)doSingleViewHideAnimation:(int)iStep
{
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    //[animation setSubtype:kCATransitionFromTop];
    
    [animation setDuration:1];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[photoView layer] addAnimation:animation forKey:kCATransition];
    
    [UIView beginAnimations:nil context:NULL];
    int iScreenW = self.view.frame.size.width*0.8;
    if(iStep==0)
    {
        photoView.frame = CGRectMake((self.view.frame.size.width-iScreenW)/2.0, (self.view.frame.size.height-150)/2.0, iScreenW, 150);
        m_sviewFaces.frame = CGRectMake(photoView.frame.origin.x, photoView.frame.origin.y+photoView.frame.size.height+10, photoView.frame.size.width, 30);
        m_MFView.frame = CGRectMake(photoView.frame.origin.x, m_sviewFaces.frame.origin.y+m_sviewFaces.frame.size.height+10, photoView.frame.size.width, 30);
        m_btnPhotosBack.hidden = true;
        
        m_sviewFaces.hidden = true;
        m_MFView.hidden = true;

    
    }
    if(iStep==1)
    {
        photoView.frame = CGRectMake(photoView.frame.origin.x, 50, photoView.frame.size.width, 30);
        m_sviewFaces.frame = CGRectMake(photoView.frame.origin.x, 90, photoView.frame.size.width, self.view.frame.size.height-100);
        m_MFView.frame = CGRectMake(photoView.frame.origin.x, m_sviewFaces.frame.origin.y+m_sviewFaces.frame.size.height+10, photoView.frame.size.width, 30);
        m_btnPhotosBack.hidden = FALSE;

        m_sviewFaces.hidden = FALSE;
        m_MFView.hidden = true;

            
    }
    if(iStep==2)
    {
        photoView.frame = CGRectMake(photoView.frame.origin.x, 50, photoView.frame.size.width, 30);
        m_sviewFaces.frame = CGRectMake(photoView.frame.origin.x, photoView.frame.origin.y+photoView.frame.size.height+10, photoView.frame.size.width, 30);
        m_MFView.frame = CGRectMake(photoView.frame.origin.x, m_sviewFaces.frame.origin.y+m_sviewFaces.frame.size.height+10, photoView.frame.size.width, 150);
        m_btnPhotosBack.hidden = FALSE;

        m_sviewFaces.hidden = TRUE;
        m_MFView.hidden = FALSE;

    }
    
    [UIView commitAnimations];
    
    animation = nil;
}
-(void)AddFacesToView
{
    //Setup the view
    [self doSingleViewHideAnimation:1 ];
    
    int iCnt=0;
    for (CIFaceFeature *feature in features) 
    {
        
        CGRect rectFaceScaled = CGRectMake(feature.bounds.origin.x*m_fScaleUp,feature.bounds.origin.y*m_fScaleUp,feature.bounds.size.width*m_fScaleUp,feature.bounds.size.height*m_fScaleUp);
        rectFaceScaled.origin.y = m_inImgOriginal.size.height- rectFaceScaled.size.height - rectFaceScaled.origin.y;
        
        CGImageRef imageRef = CGImageCreateWithImageInRect([m_inImgOriginal CGImage], rectFaceScaled);
        UIImage *img = [UIImage imageWithCGImage:imageRef]; 
        CGImageRelease(imageRef);
        
        float fS=0;
        UIImage *imgTN = [clsGlobalHelper resizeImage:img :100 :&fS];
        
        UIButton *imageView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //imageView.layer.backgroundColor = [UIColor colorWithRed:66/255.0 green:66/255.0 blue:66/255.0 alpha:1.0f].CGColor;
        //imageView.layer.borderWidth = 1;
        [[imageView layer] setCornerRadius:8.0];
        imageView.clipsToBounds = TRUE;
        //imageView.layer.borderColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0f].CGColor;
        
        CGRect rect = CGRectMake(m_sviewFaces.frame.size.width/2.0-50, iCnt*105+35, 100, 100);
        imageView.frame = rect;
        imageView.tag = 300+iCnt;
        [imageView setImage:imgTN forState:UIControlStateNormal];
        [m_sviewFaces addSubview:imageView];
        [imageView addTarget:self action:@selector(btnSelectFace:) forControlEvents:UIControlEventTouchUpInside];
        
        iCnt++;
        
        img = NULL;
        imageView = NULL;
    }
    if(iCnt==0)
    {
        [m_alert dismissWithClickedButtonIndex:0 animated:YES];

        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Error"
                              message: @"Oops. No Faces. Select another photo."\
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        alert = NULL;
        
        [self GoToSelectState];
        
    }
    [m_sviewFaces setContentSize:CGSizeMake(m_sviewFaces.frame.size.width, iCnt*105)];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor darkGrayColor] CGColor], (id)[[UIColor lightGrayColor] CGColor], nil];
    if(iCnt*105<m_sviewFaces.frame.size.height)
        iCnt = m_sviewFaces.frame.size.height;
    gradient.frame = CGRectMake(0, 0, photoView.frame.size.width, iCnt*105);
    [m_sviewFaces.layer insertSublayer:gradient atIndex:0];

    [m_alert dismissWithClickedButtonIndex:0 animated:YES];
}
-(clsDataFace *)ProcessSelectedFace
{
    //Get original image in original size
    CIFaceFeature *feature = [features objectAtIndex:m_iFace];
    
    //if Features are missing
    if( !feature.hasLeftEyePosition || !feature.hasRightEyePosition || !feature.hasMouthPosition)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Error"
                              message: @"Features missing in Face. Select Another Face."\
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        alert = NULL;
        return NULL;
    }
    
    int iFaceW = feature.bounds.size.width*m_fScaleUp;
    int iFaceH = feature.bounds.size.height*m_fScaleUp;
    //If Face is too small
    if(iFaceH<150 || iFaceW<150)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Error"
                              message: @"Selected Face is too small. Select another Face/Photo with slightly higher resolution."\
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        alert = NULL;
        [self GoToSelectState];
        
        return NULL;
        
    }
    
    CGRect rectFace = CGRectMake( feature.bounds.origin.x *m_fScaleUp, m_inImgOriginal.size.height-feature.bounds.size.width*m_fScaleUp-feature.bounds.origin.y*m_fScaleUp,iFaceW,iFaceH);
    //rectFaceScaled.origin.y = m_inImgOriented.size.height- rectFaceScaled.size.height - rectFaceScaled.origin.y;
    
    //CGRect rectFaceNew = [self GetOrientedRect:rectFace];
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([m_inImgOriginal CGImage], rectFace);
    UIImage* imgFaceCut = [UIImage imageWithCGImage:imageRef]; 
    CGImageRelease(imageRef);
    
    /*CGImageRef imageRefOrig = CGImageCreateWithImageInRect([m_inImgOriginal CGImage], rectFaceNew);
    UIImage* imgFaceCut = [UIImage imageWithCGImage:imageRefOrig]; 
    CGImageRelease(imageRefOrig);*/
    /*UIImageWriteToSavedPhotosAlbum(imgFaceCut, 
                                   self,
                                   nil,
                                   nil);*/
    
    
    //Resize if size >750
    //if(iFaceH>1000 || iFaceW>1000)
/*    if(iFaceH>500 || iFaceW>500)
    {
        float fS=0;
        imgFaceCut = [clsGlobalHelper resizeImage:imgFaceCut :500 :&fS];
        
        m_fScaleUp = (m_fScaleUp*500.0)/iFaceW;
        iFaceW = iFaceH = 500;
        
    }*/
    
    //Prepare FaceData and return
    clsDataFace *face = [clsDataFace new];
    
    int iEyeWdt = c_iPerEyeWdt*iFaceW;
    int iEyeHgt = c_iPerEyeHgt*iFaceH;
    int iMouthWdt = c_iPerMouthWdt*iFaceW;
    int iMouthHgt = c_iPerMouthHgt*iFaceH;
    
    face.iFaceWidth = iFaceW;
    face.iFaceHeight = iFaceH;
    face.iEyeWdt = iEyeWdt;
    face.iEyeHgt = iEyeHgt;
    face.iMouthWdt = iMouthWdt;
    face.iMouthHgt = iMouthHgt;

    if (feature.hasLeftEyePosition) {
        face.pntLeftEyeStart = CGPointMake(feature.leftEyePosition.x*m_fScaleUp-iEyeWdt/2.0-feature.bounds.origin.x*m_fScaleUp, m_inImgOriginal.size.height-feature.leftEyePosition.y*m_fScaleUp-iEyeHgt/2.0-(m_inImgOriginal.size.height-feature.bounds.origin.y*m_fScaleUp-iFaceH));
    }
    
    if (feature.hasRightEyePosition) {
        face.pntRightEyeStart = CGPointMake(feature.rightEyePosition.x*m_fScaleUp-iEyeWdt/2.0-feature.bounds.origin.x*m_fScaleUp, m_inImgOriginal.size.height-feature.rightEyePosition.y*m_fScaleUp-iEyeHgt/2.0-(m_inImgOriginal.size.height-feature.bounds.origin.y*m_fScaleUp-iFaceH));
    }
    
    if (feature.hasMouthPosition) {
        face.pntMouthStart = CGPointMake(feature.mouthPosition.x*m_fScaleUp-iMouthWdt/2.0-feature.bounds.origin.x*m_fScaleUp, m_inImgOriginal.size.height-feature.mouthPosition.y*m_fScaleUp-iMouthHgt/2.0-(m_inImgOriginal.size.height-feature.bounds.origin.y*m_fScaleUp-iFaceH));
    }
    
    //Rotation
    /*if(abs(face.pntLeftEyeStart.y-face.pntRightEyeStart.y)>=iFaceH*0.05)
    {
        float rad = (-atan2(face.pntRightEyeStart.y-face.pntLeftEyeStart.y,face.pntRightEyeStart.x-face.pntLeftEyeStart.x));
        imgFaceCut = [clsGlobalHelper imageRotatedByRadians:imgFaceCut :rad :CGPointMake(iFaceW/2.0, iFaceH/2.0)];
        
    }*/
    
    face.img = imgFaceCut;

    return face;
    
}
-(void)CreateMFView
{
    int iScreenW = self.view.frame.size.width*0.8;
    
    m_MFView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-iScreenW)/2.0, m_sviewFaces.frame.origin.y+m_sviewFaces.frame.size.height+10, iScreenW, 30)];
    
    m_MFView.alpha = 0.9;
    m_MFView.clipsToBounds = TRUE;
    m_MFView.layer.cornerRadius = 5;
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor darkGrayColor] CGColor], (id)[[UIColor lightGrayColor] CGColor], nil];
    gradient.frame = CGRectMake(0, 0, m_MFView.frame.size.width, 150);
    [m_MFView.layer insertSublayer:gradient atIndex:0];
    
    //Select PHoto Label
    [m_MFView addSubview:[clsGlobalHelper GetGradientLabel:@"Select Gender" :CGRectMake(0,0, photoView.frame.size.width, 30) :18.0  ]];

    float iconSize = 88;
    int xMargin = (photoView.frame.size.width-2*iconSize)/3.0;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(xMargin , 50,iconSize,iconSize);
    [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"man" ofType:@"png"]] forState:UIControlStateNormal];
    button.tag = 203;
    [m_MFView addSubview:button];
    [button addTarget:self action:@selector(btnSelectGender:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *buttonF = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonF.frame = CGRectMake(xMargin*2+iconSize , 50,iconSize,iconSize);
    [buttonF setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Woman" ofType:@"png"]] forState:UIControlStateNormal];
    buttonF.tag = 204;

    [m_MFView addSubview:buttonF];
    [buttonF addTarget:self action:@selector(btnSelectGender:) forControlEvents:UIControlEventTouchUpInside];

    button = NULL;
    button = NULL;
    
    [self.view addSubview:m_MFView];
    
}
-(void)ShowAlertView
{
    
    m_alert = [[UIAlertView alloc] initWithTitle:@"Detecting Faces\nPlease Wait..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] ;
    [m_alert show];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    // Adjust the indicator so it is up a few pixels from the bottom of the alert
    indicator.center = CGPointMake(m_alert.bounds.size.width / 2, m_alert.bounds.size.height - 50);
    [indicator startAnimating];
    [m_alert addSubview:indicator];
    indicator = nil;
}
- (void) getMetadataFromAssetForURL1:(NSURL *)url  {
    
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    
    [assetslibrary assetForURL:url
                   resultBlock: ^(ALAsset *myasset) {
                       ALAssetRepresentation *rep = [myasset defaultRepresentation];
                       Byte *buf = malloc([rep size]);
                       NSError *err = nil;
                       NSUInteger bytes = [rep getBytes:buf fromOffset:0LL
                                                 length:[rep size] error:&err];
                       if (err || bytes == 0) {
                           //NSLog(@"error from getBytes: %@", err);
                           return;
                       }
                       NSData *imageJPEG = [NSData dataWithBytesNoCopy:buf length:[rep size] freeWhenDone:YES];
                       CGImageSourceRef  source ;
                       source = CGImageSourceCreateWithData((__bridge CFDataRef)imageJPEG, NULL);
                       NSDictionary *currentImageMetadata =  (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
 
                       NSDictionary *exifDic = [currentImageMetadata objectForKey:(NSString *)kCGImagePropertyExifDictionary];
                       ExifISOSpeed  = [[exifDic objectForKey:(NSString*)kCGImagePropertyExifISOSpeedRatings] objectAtIndex:0];
                       
                       rawShutterSpeed = [[exifDic objectForKey:(NSString *)kCGImagePropertyExifExposureTime] floatValue];
                       
                       //[self setMetaData:currentImageMetadata withMediaInfo:info];
                       //NSLog(@"Exposure Time: %f ISO Speed: %i", rawShutterSpeed,[ExifISOSpeed integerValue]);
                       CFRelease(source);
                       rep = nil;
                       buf = nil;
                       imageJPEG = nil;
                       
                       CFRelease((__bridge CFTypeRef)(currentImageMetadata));// = nil;
                       exifDic = nil;
                       //[NSException raise:NSInvalidArgumentException format:@"pageIndex is out of range"];
                   }
                  failureBlock: ^(NSError *err) {
                      //NSLog(@"can't get asset %@: %@", url, err);
                  }];
    assetslibrary =nil;
}

@end
