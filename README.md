For the Swift port of this project, please see [KeyboardAdjuster](https://github.com/lionheart/KeyboardAdjuster).

# LHSKeyboardAdjusting

[![CI Status](http://img.shields.io/travis/lionheart/LHSKeyboardAdjusting.svg?style=flat)](https://travis-ci.org/lionheart/LHSKeyboardAdjusting)
[![Version](https://img.shields.io/cocoapods/v/LHSKeyboardAdjusting.svg?style=flat)](http://cocoapods.org/pods/LHSKeyboardAdjusting)
[![License](https://img.shields.io/cocoapods/l/LHSKeyboardAdjusting.svg?style=flat)](http://cocoapods.org/pods/LHSKeyboardAdjusting)
[![Platform](https://img.shields.io/cocoapods/p/LHSKeyboardAdjusting.svg?style=flat)](http://cocoapods.org/pods/LHSKeyboardAdjusting)


LHSKeyboardAdjusting will adjust the bottom position of your UIScrollView or UITableView when a keyboard appears on screen using Auto Layout. All you have to do is provide LHSKeyboardAdjusting with an NSLayoutConstraint that pins the bottom of your view to the bottom of the screen. LHSKeyboardAdjusting will automatically adjust that constraint and pin it to the top of the keyboard when it appears.

LHSKeyboardAdjusting requires Auto Layout in your build target, so it will only work with iOS 6+.

#### NOTE

If you're currently using LHSKeyboardAdjusting 1.0+ in your project, note that some things have changed.

<hr/>

### Installation

LHSKeyboardAdjusting uses CocoaPods, so in your Podfile, just add something like this:

    pod 'LHSKeyboardAdjusting', '~> 2.0'

Then run `pod install` and you'll be ready to go.

If you don't use CocoaPods, dragging and dropping the `LHSKeyboardAdjusting` folder into your Xcode project will do the trick as well.

### Usage

1. In your view controller's header file, assign the `LHSKeyboardAdjusting` protocol to your class and define an `NSLayoutConstraint` property called `keyboardAdjustingBottomConstraint`.

   ```objc
   #import <LHSKeyboardAdjusting/LHSKeyboardAdjusting.h>

   @interface ViewController : UIViewController <LHSKeyboardAdjusting>

   @property (nonatomic, strong) NSLayoutConstraint *keyboardAdjustingBottomConstraint;

   @end
   ```

2. In your view controller, implement `keyboardAdjustingView` to return the view you'd like to pin to the top of the keyboard. It could be anything, but a UIScrollView, UITableView, or a UITextView are the most likely candidates.

   ```objc
   #pragma mark - LHSKeyboardAdjusting

   - (UIView *)keyboardAdjustingView {
       return self.tableView;
   }
   ```

   <!--
   Define the other constraints for this view (top, left, and right) just as you would normally. E.g.,

   ```objc
   - (void)viewDidLoad {
       [super viewDidLoad];

       [self.tableView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
       [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
       [self.tableView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
   }
   ```
   -->

3. Activate and deactivate the automatic adjustments in `viewWillAppear` and `viewWillDisappear`.

   ```objc
   #import <LHSKeyboardAdjusting/UIViewController+LHSKeyboardAdjustment.h>

   @implementation ViewController

   - (void)viewWillAppear:(BOOL)animated {
       [super viewWillAppear:animated];

       [self lhs_activateKeyboardAdjustment];
   }

   - (void)viewWillDisappear:(BOOL)animated {
       [super viewWillDisappear:animated];

       [self lhs_deactivateKeyboardAdjustment];
   }

   @end
   ```

   Note: you can also define callbacks on keyboard appearance or disappearance using `lhs_activateKeyboardAdjustmentWithShow:hide:`:

   ```objc
   - (void)viewWillAppear:(BOOL)animated {
       [super viewWillAppear:animated];

       [self lhs_activateKeyboardAdjustmentWithShow:^{
           NSLog(@"hi");
       } hide:^{
           NSLog(@"bai");
       }];
   }
   ```

3. And you're done! Whenever a keyboard appears, this view will be automatically resized.

If you need more pointers on how to set everything up, clone this repo and check out the included example project (LHSKeyboardAdjustingExample).

### License

Apache 2.0, see [LICENSE](LICENSE) file for details.
