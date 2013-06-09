//
//  clsViewEditor.m
//  FotoKartoon
//
//  Created by Vishalsinh Jhala on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "clsTips.h"
#import <QuartzCore/QuartzCore.h>
#import "clsViewEditor.h"

@interface clsTips ()

@end

@implementation clsTips

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    
	webView.delegate = self;
	
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Tip" ofType:@"html" inDirectory:nil]];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
	[self.view addSubview:webView];
    webView = nil;
    url = nil;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.

}
-(void)JSConstructor
{
    
}
-(void)JSDestructor
{
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
