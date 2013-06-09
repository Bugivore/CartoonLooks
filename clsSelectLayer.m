//
//  clsSelectLayer.m
//  MessMyLooks
//
//  Created by Vishalsinh Jhala on 9/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "clsSelectLayer.h"
#import <QuartzCore/QuartzCore.h>
#import "clsEditor.h"
#import "effSportFan.h"

@implementation clsSelectLayer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer setCornerRadius:20.0f];
        [self.layer setBorderColor:[UIColor darkGrayColor].CGColor];
        [self.layer setBorderWidth:1.5f];
        [self.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.layer setShadowOpacity:0.8];
        [self.layer setShadowRadius:3.0];
        [self.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
        self.backgroundColor =[UIColor lightGrayColor];
        self.clipsToBounds = TRUE;
        self.layer.masksToBounds  = FALSE;
    }
    return self;
}
-(void)Create:(BOOL)bFlag
{
    

    layerPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 10, 80,self.frame.size.height-50)];
    layerPickerView.delegate = self;
    layerPickerView.showsSelectionIndicator = YES;
    clsEditor *edit = (clsEditor*)self.superview;
    [edit ResetAllEvents:FALSE:0];
    
    int iTemp = edit.m_iSelectedElement;
    if(iTemp<0) iTemp = 0;
    
    [layerPickerView selectRow:iTemp inComponent:0 animated:YES];
    [self addSubview:layerPickerView];
    flagPickerView = nil;
    
    if(bFlag)
    {
        countryNames = [[NSArray alloc] initWithObjects:
                              @"Australia",
                              @"Brazil",
                              @"France",
                              @"Germany",
                              @"India",
                              @"Italy",
                              @"Kuwait",
                              @"NewZealand",
                              @"Spain",
                              @"UK",
                              @"USA", nil];

        flagPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(100, 10, 120,self.frame.size.height-50)];
        
        flagPickerView.delegate = self;
        flagPickerView.showsSelectionIndicator = YES;

        effSportFan *eff = (effSportFan*)edit.m_eff;
        
        [flagPickerView selectRow:[eff getCountryID] inComponent:0 animated:YES];
        [self addSubview:flagPickerView];
        eff = nil;

    
    }
    
    
    UIImage *buttonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"btnDismiss" ofType:@"png"]];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setImage:buttonImage forState:UIControlStateNormal];
    button1.frame = CGRectMake(10, 230, 80 , 35);
    //button1.alpha = 0.8;
    button1.tag = 132;
    button1.showsTouchWhenHighlighted = TRUE;
    [self addSubview:button1];
    [button1 addTarget:self action:@selector(singleTapGestureCaptured:) forControlEvents:UIControlEventTouchUpInside];
    
    buttonImage = NULL;
    button1 = NULL;
    edit = nil;

}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
   
    if(pickerView == layerPickerView)
    {
        clsEditor *edit = (clsEditor*)self.superview;
        NSInteger rowcnt = edit.m_eff.m_ArrElements.count;
        edit = nil;
        return rowcnt;
    }
    else {
        return 11;
    }
 }

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if(pickerView == layerPickerView)
    {
        clsEditor *edit = (clsEditor*)self.superview;
        UIImageView *imgView =[[UIImageView alloc] initWithImage:((clsDataElement*)[edit.m_eff.m_ArrElements objectAtIndex:row]).imgElementOrig];
        imgView.frame = CGRectMake(0, 0, 40, 40);
        edit = nil;
        return imgView;
    }
    else {
        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        NSString *str = [countryNames objectAtIndex:row];
        label.text = str;
        label.font = [UIFont fontWithName:@"HelveticaNeue-Bold"  size:14.0f];
        label.textAlignment = UITextAlignmentLeft; 
        label.backgroundColor = [UIColor clearColor];
        str = nil;
        return label;

    }
 }
/*- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component 
{
    return nil;
}*/

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth;
    if(pickerView == layerPickerView)
        sectionWidth= 60;
    else {
        sectionWidth = 100;
    }
    return sectionWidth;
}
-(void)singleTapGestureCaptured:(UIButton *)gesture
{
    //UIView* view = gesture.view;
    //CGPoint loc = [gesture locationInView:view];
    //UIView* subview = [view hitTest:loc withEvent:nil];
    
    if(gesture.tag==132)
    {
        clsEditor *edit = (clsEditor*)self.superview;

        edit.m_iSelectedElement =[layerPickerView selectedRowInComponent:0];
        
        if(flagPickerView)
        {
            effSportFan *eff = (effSportFan*)edit.m_eff;
            [eff setCountryID:[flagPickerView selectedRowInComponent:0]];
            [edit RefreshEditorView];
            eff = nil;

        }
        [edit ResetAllEvents:TRUE:0];
        edit = nil;

        [self removeFromSuperview];
        return;
    }
    
}

@end
