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
        
        self.keyboardAdjustingBottomConstraint.constant = 0;
        [self.view layoutIfNeeded];
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
        CGRect newFrame = [self.view convertRect:frame fromView:[[UIApplication sharedApplication] delegate].window];
        self.keyboardAdjustingBottomConstraint.constant = newFrame.origin.y - CGRectGetHeight(self.view.frame);
        [self.view layoutIfNeeded];
    }
}

@end
