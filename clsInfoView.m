//
//  clsInfoView.m
//  FotoKartoon
//
//  Created by Vishalsinh Jhala on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "clsInfoView.h"
#import "clsglobalhelper.h"
#import <QuartzCore/QuartzCore.h>
#import "clsEditor.h"

@implementation clsInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tag = 132;
        /*[self.layer setCornerRadius:30.0f];
        [self.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [self.layer setBorderWidth:1.5f];
        [self.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.layer setShadowOpacity:0.8];
        [self.layer setShadowRadius:3.0];
        [self.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
        self.backgroundColor =[UIColor colorWithHue:0 saturation:0 brightness:0.2 alpha:0.8];*/
        self.alpha = 0.9;
        self.clipsToBounds = TRUE;
        self.layer.cornerRadius = 5;
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor darkGrayColor] CGColor], (id)[[UIColor lightGrayColor] CGColor], nil];
        gradient.frame = self.bounds;
        //[self.layer insertSublayer:gradient atIndex:0];
        self.backgroundColor =[UIColor darkGrayColor];

        
        //Select Photo Label
        [self addSubview:[clsGlobalHelper GetGradientLabel:@"Face Analysis" :CGRectMake(0,0, self.frame.size.width, 30) :18.0  ]];

        
        UITapGestureRecognizer *gestTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
        [self addGestureRecognizer:gestTap]; 

    }
    
    return self;
}
-(void)Create:(long[3][256])m_lHistogram:(int)iFW:(int)iFH:(UIImage*)imgFace:(float) m_fExposure:(int) m_iISOSpeed
{
    
    m_iFaceHeight = iFH;
    //m_inOrientation = orient;
    clsEditor *edit = (clsEditor*)self.superview;
    [edit ResetAllEvents:FALSE:4];

    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetTextMatrix(context, CGAffineTransformMake(1.0,0.0, 0.0, -1.0, 0.0, 0.0));
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 1.0);
    
    //Header
    /*NSString *str = @"Face Analysis";
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue-Bold"  size:20.0f];
    CGSize textSize = [str sizeWithFont:font];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
    label.textColor =[UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor]; 
    label.text = str;
    label.font = font;
    label.shadowColor = [UIColor lightGrayColor ];
    label.shadowOffset = CGSizeMake(0,-1);
    label.textAlignment = UITextAlignmentCenter;
    [self addSubview:label];
    
    label.frame = CGRectMake((self.frame.size.width-label.frame.size.width)/2.0, 15, label.frame.size.width, label.frame.size.height);
    
    */
    int iSX=10,iSY=50;
    char sz[100];sz[0]=0;
    
    //Face Photo
    float fS;
    UIImage* imgFaceScaled = [clsGlobalHelper resizeImage:imgFace :70 :&fS];
    //imgFaceScaled  = [clsGlobalHelper rotateToOrientUp:imgFaceScaled:m_inOrientation];

    
    UIImageView *imgView = [UIImageView new];
    imgView.image = imgFaceScaled;
    CGRect rect = CGRectMake(iSX, iSY, 70, 70);
    imgView.frame = rect;
    imgView.layer.borderWidth = 1;
    imgView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self addSubview:imgView];
    
    long iMaxLvlR=0; long iMaxLvlG=0;long iMaxLvlB = 0;
    m_iTotalPixels = 0;
    //Histogram
    for(int i=0;i<256;i++)
    {
        m_iTotalPixels+=m_lHistogram[0][i];
        if(m_lHistogram[0][i]>iMaxLvlR)
            iMaxLvlR = m_lHistogram[0][i];
        if(m_lHistogram[1][i]>iMaxLvlG)
            iMaxLvlG = m_lHistogram[1][i];
        if(m_lHistogram[2][i]>iMaxLvlB)
            iMaxLvlB = m_lHistogram[2][i];
        
    }
    
    //Graph
    iSX=150;iSY=70;
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 1.0);
    iSX = 150; iSY=70;
    CGContextMoveToPoint(context, iSX,iSY);
    iSY+=51;
    CGContextAddLineToPoint(context,iSX, iSY);
    iSX+=128;
    CGContextAddLineToPoint(context,iSX, iSY);
    CGContextStrokePath(context);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    iSX-=128;int iCurrSY=iSY;
    for(int i=0;i<256;i+=2)
    {
        iSX++;
        iSY=iCurrSY;
        CGContextMoveToPoint(context, iSX,iSY);
        iSY -= (m_lHistogram[0][i]/(double)iMaxLvlR)*50.0;
        CGContextAddLineToPoint(context,iSX, iSY);
        
    }
    CGContextStrokePath(context);
    
    iSX=150;iSY=130;
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 1.0);
    iSX = 150; iSY=130;
    CGContextMoveToPoint(context, iSX,iSY);
    iSY+=51;
    CGContextAddLineToPoint(context,iSX, iSY);
    iSX+=128;
    CGContextAddLineToPoint(context,iSX, iSY);
    CGContextStrokePath(context);
    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    iSX-=128; iCurrSY=iSY;
    for(int i=0;i<256;i+=2)
    {
        iSX++;
        iSY=iCurrSY;
        CGContextMoveToPoint(context, iSX,iSY);
        iSY -= (m_lHistogram[1][i]/(double)iMaxLvlG)*50.0;
        CGContextAddLineToPoint(context,iSX, iSY);
        
    }
    CGContextStrokePath(context);

    
    iSX=150;iSY=190;
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 1.0);
    iSX = 150; iSY=190;
    CGContextMoveToPoint(context, iSX,iSY);
    iSY+=51;
    CGContextAddLineToPoint(context,iSX, iSY);
    iSX+=128;
    CGContextAddLineToPoint(context,iSX, iSY);
    CGContextStrokePath(context);
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    iSX-=128; iCurrSY=iSY;
    for(int i=0;i<256;i+=2)
    {
        iSX++;
        iSY=iCurrSY;
        CGContextMoveToPoint(context, iSX,iSY);
        iSY -= (m_lHistogram[2][i]/(double)iMaxLvlB)*50.0;
        CGContextAddLineToPoint(context,iSX, iSY);
        
    }
    CGContextStrokePath(context);
    
    
    //size
    iSX=10;iSY= 150;
    CGContextSelectFont(context, "HelveticaNeue-Bold", 14, kCGEncodingMacRoman);

    sprintf(sz, "Size: %d X %d",iFW,iFH);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextShowTextAtPoint(context, iSX, iSY, sz, strlen(sz)); 

    
    //ISO
    iSX=10;iSY= 180;
    sprintf(sz, "ISO: %d",m_iISOSpeed);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextShowTextAtPoint(context, iSX, iSY, sz, strlen(sz)); 
    if(m_iISOSpeed==0)
    {
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextShowTextAtPoint(context, iSX,iSY+20, "Can't Detect", strlen("Can't Detect"));
    }
    else if(m_iISOSpeed<=250)
    {
        CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
        CGContextShowTextAtPoint(context, iSX,iSY+20, "Normal", strlen("Normal"));
    }
    else if(m_iISOSpeed>250 && m_iISOSpeed<=400)
    {
        CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
        CGContextShowTextAtPoint(context, iSX,iSY+20, "Grainy", strlen("Grainy"));

    }
    else
    {
        CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
        CGContextShowTextAtPoint(context, iSX,iSY+20, "Very Grainy", strlen("Very Grainy"));
        
    }
    //Exposure
    iSX=10;iSY= 230;
    sprintf(sz, "Exposure: %f",m_fExposure);

    //CGContextSelectFont(context, "Helvetica", 12, kCGEncodingMacRoman);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextShowTextAtPoint(context, iSX, iSY, sz, strlen(sz)); 
    if(m_fExposure==0.0)
    {
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextShowTextAtPoint(context, iSX,iSY+20, "Can't Detect", strlen("Can't Detect"));
    }
    else if(m_fExposure<0.05)
    {
        CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
        CGContextShowTextAtPoint(context, iSX,iSY+20, "Normal", strlen("Normal"));
    }
    else if(m_fExposure>=0.05 && m_fExposure<0.1)
    {
        CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
        CGContextShowTextAtPoint(context, iSX,iSY+20, "Low Light", strlen("Low Light"));
    }
    else
    {
        CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
        CGContextShowTextAtPoint(context, iSX,iSY+20, "Severe Low Light", strlen("Severe Low Light"));
    }

    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.layer.contents = (id)image.CGImage;
    
    image = NULL;
    imgFaceScaled = NULL;
    imgView = NULL;
	//CGContextRef ctx = UIGraphicsGetCurrentContext();
}
/*
-(UIImage*)RevertOrientation:(UIImage*)inImage:(UIImageOrientation)orient
{
    CGRect             bnds = CGRectZero;
    UIImage*           copy = nil;
    CGContextRef       ctxt = nil;
    CGImageRef         imag = inImage.CGImage;
    CGRect             rect = CGRectZero;
    CGAffineTransform  tran = CGAffineTransformIdentity;
    
    rect.size.width  = CGImageGetWidth(imag);
    rect.size.height = CGImageGetHeight(imag);
    
    bnds = rect;
    
    switch (orient)
    {
        case UIImageOrientationUp:
            // would get you an exact copy of the original
            //assert(false);
            return inImage;
            
        case UIImageOrientationUpMirrored:
            //tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
            //tran = CGAffineTransformScale(tran, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown:
            tran = CGAffineTransformMakeTranslation(rect.size.width,
                                                    rect.size.height);
            tran = CGAffineTransformRotate(tran, M_PI);
            break;
            
        case UIImageOrientationDownMirrored:
            //tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
            //tran = CGAffineTransformScale(tran, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeft:
            bnds = [self swapWidthAndHeight:bnds];
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
            tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeftMirrored:
            //bnds = swapWidthAndHeight(bnds);
            //tran = CGAffineTransformMakeTranslation(rect.size.height,
            //rect.size.width);
            //tran = CGAffineTransformScale(tran, -1.0, 1.0);
            //tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRight:
            bnds = [self swapWidthAndHeight:bnds];
            tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
            tran = CGAffineTransformRotate(tran, M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored:
            //bnds = swapWidthAndHeight(bnds);
            //tran = CGAffineTransformMakeScale(-1.0, 1.0);
            //tran = CGAffineTransformRotate(tran, M_PI / 2.0);
            break;
            
        default:
            // orientation value supplied is invalid
            assert(false);
            return nil;
    }
    
    UIGraphicsBeginImageContext(bnds.size);
    ctxt = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(ctxt, kCGInterpolationHigh);
    
    switch (orient)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextScaleCTM(ctxt, -1.0, 1.0);
            CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
            break;
            
        default:
            CGContextScaleCTM(ctxt, 1.0, -1.0);
            CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
            break;
    }
    
    CGContextConcatCTM(ctxt, tran);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, imag);
    
    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return copy;
}
-(CGRect) swapWidthAndHeight:(CGRect) rect
{
    CGFloat  swap = rect.size.width;
    
    rect.size.width  = rect.size.height;
    rect.size.height = swap;
    
    return rect;
}*/
-(void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture 
{
    UIView* view = gesture.view;
    CGPoint loc = [gesture locationInView:view];
    UIView* subview = [view hitTest:loc withEvent:nil]; 
    
    if(subview.tag==132)
    {
        clsEditor *edit = (clsEditor*)self.superview;
        [edit ResetAllEvents:TRUE:4];
        [self removeFromSuperview];
        return;
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
