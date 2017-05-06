//
//  DeclarationViewController.m
//  NodeAdsTestWork
//
//  Created by Oleh on 5/5/17.
//  Copyright © 2017 Oleh. All rights reserved.
//

#import "DeclarationViewController.h"
#import "UIViewController+Helper.h"

@interface DeclarationViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *declarationWebView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mainActivityIndicator;

@end

@implementation DeclarationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.navigationTitle;
    
    self.declarationWebView.autoresizesSubviews = YES;
    self.declarationWebView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    
    NSURL *linkPDF = [NSURL URLWithString:self.url];
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:linkPDF];
    
    [self.declarationWebView loadRequest:myRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    _navigationTitle = nil;
    _url = nil;
}

#pragma mark - UIWebView delegete methods

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.mainActivityIndicator startAnimating];
    self.view.userInteractionEnabled = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.mainActivityIndicator stopAnimating];
    self.view.userInteractionEnabled = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self showAlertForError:error];
    [self.mainActivityIndicator stopAnimating];
    self.view.userInteractionEnabled = YES;
}

@end
