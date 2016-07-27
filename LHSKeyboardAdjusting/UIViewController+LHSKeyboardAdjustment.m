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
    [self lhs_activateKeyboardAdjustmentWithShow:^{} hide:^{}];
}

- (void)lhs_activateKeyboardAdjustmentWithShow:(LHSKeyboardAdjustingBlock)show hide:(LHSKeyboardAdjustingBlock)hide {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification
                                                      object:nil
                                                       queue:[NSOperationQueue currentQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      if (hide) {
                                                          hide();
                                                      }

                                                      [self lhs_keyboardWillHide:note];
                                                  }];

    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardDidShowNotification
                                                      object:nil
                                                       queue:[NSOperationQueue currentQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      if (show) {
                                                          show();
                                                      }

                                                      [self lhs_keyboardDidShow:note];
                                                  }];
}

- (void)lhs_deactivateKeyboardAdjustment {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

- (void)lhs_keyboardWillHide:(NSNotification *)sender {
    BOOL enabled = [self respondsToSelector:@selector(keyboardAdjustingBottomConstraint)];
    NSAssert(enabled, @"keyboardAdjustingBottomConstraint must be implemented to enable automatic keyboard adjustment.");
    
    if (enabled) {
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

- (nullable NSLayoutConstraint *)keyboardAdjustingBottomConstraint {
    [NSException raise:NSInternalInconsistencyException format:@"'%@' must override -keyboardAdjustingBottomConstraint", NSStringFromClass(self.class)];
    return nil;
}

- (BOOL)keyboardAdjustingAnimated {
    return NO;
}

- (NSLayoutConstraint *)initializeKeyboardAdjustingConstraintForView:(UIView *)theView {
    NSLayoutConstraint *constraint = [self.view.bottomAnchor constraintEqualToAnchor:theView.bottomAnchor];
    constraint.active = YES;
    return constraint;
}

@end
