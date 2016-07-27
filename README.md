For the Swift port of this project, please see [KeyboardAdjuster](https://github.com/lionheart/KeyboardAdjuster).

LHSKeyboardAdjusting
--------------------

After one too many times of referencing a [Gist](https://gist.github.com/dlo/8572874) I wrote on how to set up automatic view resizing when a keyboard appears in iOS, I decided to just abstract the entire thing and throw it up on GitHub.

LHSKeyboardAdjusting will adjust the bottom position of your UIScrollView or UITableView when a keyboard appears on screen using Auto Layout. All you have to do is provide LHSKeyboardAdjusting with an NSLayoutConstraint that pins the bottom of your view to the bottom of the screen. LHSKeyboardAdjusting will automatically adjust that constraint and pin it to the top of the keyboard when it appears.

Note: LHSKeyboardAdjusting requires Auto Layout in your build target, so it will only work with iOS 6+.

### Installation

LHSKeyboardAdjusting uses CocoaPods, so in your Podfile, just add something like this:

    pod 'LHSKeyboardAdjusting'

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

3. And you're done! Whenever a keyboard appears, this view will be automatically resized.

If you need more pointers on how to set everything up, clone this repo and check out the included example project (LHSKeyboardAdjustingExample).

### License

Apache 2.0, see [LICENSE](LICENSE) file for details.
