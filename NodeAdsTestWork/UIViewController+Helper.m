//
//  UIViewController+Helper.m
//  NodeAdsTestWork
//
//  Created by Oleh on 5/5/17.
//  Copyright © 2017 Oleh. All rights reserved.
//

#import "UIViewController+Helper.h"

@implementation UIViewController (Helper)

- (void)showAlertForError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Помилка", nil) message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
