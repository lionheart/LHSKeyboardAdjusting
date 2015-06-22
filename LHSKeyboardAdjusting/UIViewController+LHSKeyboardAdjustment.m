//
//  UIViewController+LHSKeyboardAdjustment.m
//  LHSKeyboardAdjusting
//
//  Created by Dan Loewenherz on 3/18/14.
//  Copyright (c) 2014 Lionheart Software LLC. All rights reserved.
//

#import "UIViewController+LHSKeyboardAdjustment.h"

@implementation UIViewController (LHSKeyboardAdjustment)

- (void)lhs_activateKeyboardAdjustment {
    [self lhs_activateKeyboardAdjustmentWithShow:nil hide:nil];
}

- (void)lhs_activateKeyboardAdjustmentWithShow:(LHSKeyboardAdjustingBlock)show hide:(LHSKeyboardAdjustingBlock)hide {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(lhs_keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:hide];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(lhs_keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:show];;
}

- (void)lhs_deactivateKeyboardAdjustment {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

- (void)lhs_keyboardWillHide:(NSNotification *)sender {
    BOOL enabled = [self respondsToSelector:@selector(keyboardAdjustingBottomConstraint)];
    NSAssert(enabled, @"keyboardAdjustingBottomConstraint must be implemented to enable automatic keyboard adjustment.");
    
    if (enabled) {
        LHSKeyboardAdjustingBlock block = sender.object;
        if (block) {
            block();
        }
        
        NSDictionary *userInfo = sender.userInfo;
        NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        UIViewAnimationCurve curve = (UIViewAnimationCurve) [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];

        
        self.keyboardAdjustingBottomConstraint.constant = 0;
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | curve animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];
    }
}

- (void)lhs_keyboardDidShow:(NSNotification *)sender {
    BOOL enabled = [self respondsToSelector:@selector(keyboardAdjustingBottomConstraint)];
    NSAssert(enabled, @"keyboardAdjustingBottomConstraint must be implemented to enable automatic keyboard adjustment.");
    
    if (enabled) {
        LHSKeyboardAdjustingBlock block = sender.object;
        if (block) {
            block();
        }
        
        CGRect frame = [sender.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGRect keyboardFrameInViewCoordinates = [self.view convertRect:frame fromView:nil];
        NSDictionary *userInfo = sender.userInfo;
        NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        UIViewAnimationCurve curve = (UIViewAnimationCurve) [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];

        self.keyboardAdjustingBottomConstraint.constant = CGRectGetHeight(self.view.bounds) - keyboardFrameInViewCoordinates.origin.y;

        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | curve animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];
    }
}

@end
