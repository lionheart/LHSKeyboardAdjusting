//
//  ViewController.h
//  LHSKeyboardAdjustingExample
//
//  Created by Daniel Loewenherz on 7/27/16.
//  Copyright © 2016 Lionheart Software LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LHSKeyboardAdjusting/LHSKeyboardAdjusting.h>

@interface ViewController : UIViewController <LHSKeyboardAdjusting, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

