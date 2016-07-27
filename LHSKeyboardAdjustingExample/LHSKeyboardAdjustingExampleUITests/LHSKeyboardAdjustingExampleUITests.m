//
//  LHSKeyboardAdjustingExampleUITests.m
//  LHSKeyboardAdjustingExampleUITests
//
//  Created by Daniel Loewenherz on 7/27/16.
//  Copyright © 2016 Lionheart Software LLC. All rights reserved.
//

@import XCTest;

@interface LHSKeyboardAdjustingExampleUITests : XCTestCase

@end

@implementation LHSKeyboardAdjustingExampleUITests

- (void)setUp {
    [super setUp];

    self.continueAfterFailure = NO;
    [[[XCUIApplication alloc] init] launch];

    /*
     Apple engineer work around:

     "The second possibility is that you are running into a problem that sometimes occurs where the application finishes launching but the splash screen doesn't immediately disappear and events dispatched to the app are not handled properly.

     To try to work around that issue, consider placing a small delay at the beginning of your test (sleep(1) should be enough)."
     */
    // See https://openradar.appspot.com/26320475
    sleep(1);
}

- (void)testKeyboardAdjusting {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *cell = [app.tables.cells elementBoundByIndex:0];
    [cell tap];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"count > 0"];
    [self expectationForPredicate:predicate evaluatedWithObject:app.keyboards handler:nil];
    [self waitForExpectationsWithTimeout:5 handler:nil];

    XCUIElement *lastCell = [app.tables.cells elementBoundByIndex:49];
    XCUIElement *table = [app.tables elementBoundByIndex:0];

    for (NSInteger i=0; i<3; i++) {
        [table swipeUp];
    }

    XCTAssert(CGRectContainsRect([app.windows elementBoundByIndex:0].frame, lastCell.frame));
}

@end
