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
#import "LHSKeyboardAdjusting.h"

@implementation UIViewController (LHSKeyboardAdjustment)

- (void)lhs_activateKeyboardAdjustment {
    [self lhs_activateKeyboardAdjustmentWithShow:^{} hide:^{}];
}

- (void)lhs_activateKeyboardAdjustmentWithShow:(LHSKeyboardAdjustingBlock)show hide:(LHSKeyboardAdjustingBlock)hide {
    if ([self conformsToProtocol:@protocol(LHSKeyboardAdjusting)]) {
        id<LHSKeyboardAdjusting> adjusting = (id<LHSKeyboardAdjusting>)self;
        adjusting.keyboardAdjustingBottomConstraint = [self lhs_keyboardAdjustingConstraintForView:adjusting.keyboardAdjustingView];
    } else {
        NSAssert(NO, @"This object must conform to LHSKeyboardAdjusting to enable automatic keyboard adjustment.");
    }

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
    BOOL enabled = [self conformsToProtocol:@protocol(LHSKeyboardAdjusting)];
    NSAssert(enabled, @"keyboardAdjustingBottomConstraint must be implemented to enable automatic keyboard adjustment.");

    if (enabled) {
        id<LHSKeyboardAdjusting> adjusting = (id<LHSKeyboardAdjusting>)self;

        NSDictionary *userInfo = sender.userInfo;
        NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        UIViewAnimationCurve curve = (UIViewAnimationCurve) [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];

        adjusting.keyboardAdjustingBottomConstraint.constant = 0;
        if (adjusting.keyboardAdjustingAnimated) {
            UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState | curve;
            [UIView animateWithDuration:duration delay:0 options:options animations:^{
                [self.view layoutIfNeeded];
            } completion:nil];
        } else {
            [self.view layoutIfNeeded];
        }
    }
}

- (void)lhs_keyboardDidShow:(NSNotification *)sender {
    BOOL enabled = [self conformsToProtocol:@protocol(LHSKeyboardAdjusting)];
    NSAssert(enabled, @"keyboardAdjustingBottomConstraint must be implemented to enable automatic keyboard adjustment.");

    if (enabled) {
        id<LHSKeyboardAdjusting> adjusting = (id<LHSKeyboardAdjusting>)self;

        CGRect frame = [sender.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGRect keyboardFrameInViewCoordinates = [self.view convertRect:frame fromView:nil];
        NSDictionary *userInfo = sender.userInfo;
        NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        UIViewAnimationCurve curve = (UIViewAnimationCurve) [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];

        adjusting.keyboardAdjustingBottomConstraint.constant = CGRectGetHeight(self.view.bounds) - keyboardFrameInViewCoordinates.origin.y;
        if (adjusting.keyboardAdjustingAnimated) {
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | curve animations:^{
                [self.view layoutIfNeeded];
            } completion:nil];
        } else {
            [self.view layoutIfNeeded];
        }
    }
}

- (BOOL)keyboardAdjustingAnimated {
    return NO;
}

- (NSLayoutConstraint *)lhs_keyboardAdjustingConstraintForView:(UIView *)theView {
    if ([self.view respondsToSelector:@selector(bottomAnchor)]) {
        NSLayoutConstraint *constraint = [self.view.bottomAnchor constraintEqualToAnchor:theView.bottomAnchor];
        constraint.active = YES;
        return constraint;
    } else {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:theView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        [self.view addConstraint:constraint];
        return constraint;
    }
}

@end
