//
//  ViewController.m
//  LHSKeyboardAdjustingExample
//
//  Created by Daniel Loewenherz on 7/27/16.
//  Copyright © 2016 Lionheart Software LLC. All rights reserved.
//

#import "ViewController.h"
#import <LHSKeyboardAdjusting/UIViewController+LHSKeyboardAdjustment.h>

static NSString *CellIdentifier = @"CellIdentifier";
static NSUInteger numRows = 50;

@interface ViewController ()

@property (nonatomic, strong) NSLayoutConstraint *bottomConstraint;
@property (nonatomic, strong) NSMutableArray<UITextField *> *fields;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"LHSKeyboardAdjusting";

    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.fields = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<numRows; i++) {
        UITextField *field = [[UITextField alloc] init];
        field.delegate = self;
        field.translatesAutoresizingMaskIntoConstraints = NO;
        field.placeholder = @"Please type here.";
        field.returnKeyType = UIReturnKeyDone;
        [self.fields addObject:field];
    }

    self.tableView = [[UITableView alloc] init];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];

    [self.view addSubview:self.tableView];
    [self.tableView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.tableView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;

    self.bottomConstraint = [self lhs_initializeKeyboardAdjustingConstraintForView:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self lhs_activateKeyboardAdjustmentWithShow:^{
        NSLog(@"hi");
    } hide:^{
        NSLog(@"bai");
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self lhs_deactivateKeyboardAdjustment];
}

- (NSLayoutConstraint *)keyboardAdjustingBottomConstraint {
    return self.bottomConstraint;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return numRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"Cell #%lu", indexPath.row + 1];

    UITextField *field = self.fields[indexPath.row];
    [cell.contentView addSubview:field];

    [field.trailingAnchor constraintEqualToAnchor:cell.contentView.layoutMarginsGuide.trailingAnchor].active = YES;
    [field.topAnchor constraintEqualToAnchor:cell.contentView.topAnchor].active = YES;
    [field.bottomAnchor constraintEqualToAnchor:cell.contentView.bottomAnchor].active = YES;
    [field.widthAnchor constraintEqualToConstant:200].active = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UITextField *field = self.fields[indexPath.row];
    [field becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
