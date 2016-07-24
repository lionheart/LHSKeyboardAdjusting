//
//  UIViewController+LHSKeyboardAdjustment.m
//  LHSKeyboardAdjusting
//
//  Created by Dan Loewenherz on 3/18/14.
//
//  Copyright 2014 Lionheart Software LLC
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
                                               object:show];
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
        if (self.keyboardAdjustingAnimated) {
            UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState | curve;
            [UIView animateWithDuration:duration delay:0 options:options animations:^{
                [self.view layoutIfNeeded];
            } completion:nil];
        }
        else {
            [self.view layoutIfNeeded];
        }
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

        if (self.keyboardAdjustingAnimated) {
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | curve animations:^{
                [self.view layoutIfNeeded];
            } completion:nil];
        }
        else {
            [self.view layoutIfNeeded];
        }
    }
}

- (NSLayoutConstraint * _Nullable)keyboardAdjustingBottomConstraint {
    [NSException raise:NSInternalInconsistencyException format:@"'%@' must override -keyboardAdjustingBottomConstraint", NSStringFromClass(self.class)];
    return nil;
}

- (BOOL)keyboardAdjustingAnimated {
    return NO;
}

@end
