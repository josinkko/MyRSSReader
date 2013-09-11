//
//  WebViewController.m
//  MyRSSReader
//
//  Created by Johanna Sinkkonen on 8/28/13.
//  Copyright (c) 2013 Johanna Sinkkonen. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController

-(void)loadView
{
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    UIWebView *wv = [[UIWebView alloc] initWithFrame:screenFrame];
    [self setView:wv];
}

- (UIWebView *)webView
{
    return (UIWebView *)[self view];
}

@end
