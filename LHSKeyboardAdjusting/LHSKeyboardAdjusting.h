//
//  LHSKeyboardAdjusting.h
//  LHSKeyboardAdjusting
//
//  Created by Dan Loewenherz on 3/18/14.
//  Copyright (c) 2014 Lionheart Software LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LHSKeyboardAdjusting <NSObject>

- (NSLayoutConstraint *)keyboardAdjustingBottomConstraint;

@end
