//
//  dlgSelectEffect.m
//  MessMyLooks
//
//  Created by Vishalsinh Jhala on 9/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "dlgSelectEffect.h"
#import <QuartzCore/QuartzCore.h>
#import "clsEditor.h"

@implementation dlgSelectEffect

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /*[self.layer setCornerRadius:30.0f];
        [self.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [self.layer setBorderWidth:1.5f];
        [self.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.layer setShadowOpacity:0.8];
        [self.layer setShadowRadius:3.0];
        [self.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
        self.backgroundColor =[UIColor colorWithHue:0 saturation:0 brightness:0.2 alpha:0.8];*/
        
        //int iScreenW = self.frame.size.width*0.8;
        //int iScreenH = 150;
        
        
        self.alpha = 0.9;
        self.clipsToBounds = TRUE;
        self.layer.cornerRadius = 5;
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor darkGrayColor] CGColor], (id)[[UIColor lightGrayColor] CGColor], nil];
        gradient.frame = self.bounds;
        [self.layer insertSublayer:gradient atIndex:0];
        
        //Select Photo Label
        [self addSubview:[clsGlobalHelper GetGradientLabel:@"Select Looks" :CGRectMake(0,0, self.frame.size.width, 30) :18.0  ]];

        
        

    }
    return self;
}
-(void)Create
{
    clsEditor *edit = (clsEditor*)self.superview;
    [edit ResetAllEvents:FALSE:2];

    int iMargin;// = (self.frame.size.width-48*3)/4.0;
    int iIconSize;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        iIconSize = 96;
        iMargin = (self.frame.size.width-96*3)/4.0;
    }
    else {
        iIconSize = 48;
        iMargin = (self.frame.size.width-48*3)/4.0;
    }
    
    for(int i=0;i<3;i++)
    {
        for(int j=0;j<3;j++)
        {
            //NSString *strName = @"Looks"+@".jpg";
            NSString* s = [NSString stringWithFormat:@"Looks%d",i*3+j];
            UIImage *imgTN = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:s ofType:@"jpg"]];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            btn.clipsToBounds = YES;
            btn.layer.backgroundColor = [UIColor clearColor].CGColor;
            btn.layer.borderWidth = 1;
            [[btn layer] setCornerRadius:8.0];
            btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            btn.frame = CGRectMake(iMargin*(j+1)+j*iIconSize, iMargin*(i+1)+i*iIconSize+20, iIconSize, iIconSize);
            [btn setImage:imgTN forState:UIControlStateNormal];
            btn.tag = 300+i*3+j;
            btn.layer.shadowRadius = 6;
            btn.layer.shadowOffset = CGSizeMake(0, 2);
            btn.layer.shadowColor = [UIColor yellowColor].CGColor ;
            btn.userInteractionEnabled = TRUE;
            btn.showsTouchWhenHighlighted = TRUE;
            [self addSubview:btn];
            [btn addTarget:self action:@selector(singleTapGestureCaptured:) forControlEvents:UIControlEventTouchUpInside];

            btn = nil;
            imgTN = nil;
            s = nil;
            
        }
    }
    
    UIImage *buttonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"btnClose" ofType:@"png"]];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setImage:buttonImage forState:UIControlStateNormal];
    button1.frame = CGRectMake(0, 0, 40 , 40);
    //button1.alpha = 0.8;
    button1.tag = 132;
    button1.showsTouchWhenHighlighted = TRUE;
    [self addSubview:button1];
    [button1 addTarget:self action:@selector(singleTapGestureCaptured:) forControlEvents:UIControlEventTouchUpInside];
    
    buttonImage = NULL;
    button1 = NULL;

    
    [self setContentSize:CGSizeMake(self.frame.size.width, iMargin*(3+1)+3*iIconSize)];
    edit = nil;
    
}
-(void)singleTapGestureCaptured:(UIButton *)gesture
{
    //UIView* view = gesture.view;
    //CGPoint loc = [gesture locationInView:view];
    //UIView* subview = [view hitTest:loc withEvent:nil];
    
    
    if(gesture.tag>=300)
    {
        clsEditor *edit = (clsEditor*)self.superview;
        [edit SelectALook:gesture.tag-300];
        [edit ResetAllEvents:TRUE:2];
        [self removeFromSuperview];
        edit = nil;
        return;
    }
    if(gesture.tag==132)
    {
        clsEditor *edit = (clsEditor*)self.superview;
        [edit ResetAllEvents:TRUE:2];
        [self removeFromSuperview];
        edit = nil;
        return;
        
    }
    
}
/*
-(void)singleTapGestureCaptured1:(UITapGestureRecognizer *)gesture
{
    UIView* view = gesture.view;
    CGPoint loc = [gesture locationInView:view];
    UIView* subview = [view hitTest:loc withEvent:nil];
    

}*/
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
