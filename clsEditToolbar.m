//
//  clsEditToolbar.m
//  MessMyLooks
//
//  Created by Vishalsinh Jhala on 9/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "clsEditToolbar.h"
#import <QuartzCore/QuartzCore.h>

@implementation clsEditToolbar
@synthesize m_arrButtons;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"ToolbarBk" ofType:@"jpg"];
        self.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:fileName]];
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.masksToBounds = NO;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 1;

        //self.alpha = 0.5;
    }
    return self;
}
-(void)Prepare
{
    NSArray * arr= [NSArray arrayWithObjects:
                    [[NSBundle mainBundle] pathForResource:@"layers" ofType:@"png"],
                    [[NSBundle mainBundle] pathForResource:@"eye" ofType:@"png"],
                    [[NSBundle mainBundle] pathForResource:@"wand" ofType:@"png"],
                    [[NSBundle mainBundle] pathForResource:@"reset" ofType:@"png"],
                    [[NSBundle mainBundle] pathForResource:@"info" ofType:@"png"], nil];
    
    m_arrButtons = [[NSMutableArray alloc] initWithCapacity:5];
    
    int iconSize = 38;
    int iMargin = (self.frame.size.width-200)/4.0;
    for(int i=0;i<5;i++)
    {
        
        UIImage *buttonImage = [UIImage imageWithContentsOfFile:[arr objectAtIndex:i]];
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button1 setImage:buttonImage forState:UIControlStateNormal];
        button1.frame = CGRectMake(5+iconSize*i+iMargin*i, 2, iconSize, iconSize);
        button1.tag = 101+i;
        button1.alpha = 1;
        
        button1.showsTouchWhenHighlighted = TRUE;
        [self addSubview:button1];
        [button1 addTarget:self.superview action:@selector(singleTapGestureCaptured:) forControlEvents:UIControlEventTouchUpInside];
        [m_arrButtons addObject:button1];
        buttonImage = NULL;
        button1 = NULL;
    }
    arr = nil;
    
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
