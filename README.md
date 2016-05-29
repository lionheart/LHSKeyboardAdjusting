For the Swift port of this project, please see [KeyboardAdjuster](https://github.com/lionheart/KeyboardAdjuster).

LHSKeyboardAdjusting
--------------------

After one too many times of referencing a [Gist](https://gist.github.com/dlo/8572874) I wrote on how to set up automatic view resizing when a keyboard appears in iOS, I decided to just abstract the entire thing and throw it up on GitHub.

LHSKeyboardAdjusting will adjust the bottom position of your UIScrollView or UITableView when a keyboard appears on screen using Auto Layout. All you have to do is provide LHSKeyboardAdjusting with an NSLayoutConstraint that pins the bottom of your view to the bottom of the screen. LHSKeyboardAdjusting will automatically adjust that constraint and pin it to the top of the keyboard when it appears.

Note: LHSKeyboardAdjusting requires Auto Layout in your build target, so it will only work with iOS 6+.

### Installation

LHSKeyboardAdjusting uses CocoaPods, so in your Podfile, just add something like this:

    pod 'LHSKeyboardAdjusting', '~> 0.0'

Then run `pod install` and you'll be ready to go.

If you don't use CocoaPods, dragging and dropping the `LHSKeyboardAdjusting` folder into your Xcode project will do the trick as well.

### Usage

1. In your view controller's header file, import and assign the `LHSKeyboardAdjusting` protocol.

   ```objc
   #import <LHSKeyboardAdjusting/LHSKeyboardAdjusting.h>

   @interface AViewController : UIViewController <LHSKeyboardAdjusting>
   ```

2. Figure out which view you'd like to pin to the top of the keyboard. It could be anything, but a UIScrollView, UITableView, or a UITextView are the most likely candidates. Then, wherever you're setting up your view constraints, define an `NSLayoutConstraint` property that pins the bottom of this view to the bottom of the screen, like so:

   ```objc
   self.bottomConstraint = [NSLayoutConstraint constraintWithItem:self.adjustingView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0];
   [self.view addConstraint:self.bottomConstraint];
   ```

   After you've done this, define the `keyboardAdjustingBottomConstraint` delegate method to return this constraint:

   ```objc
   #pragma mark - LHSKeyboardAdjusting

   - (NSLayoutConstraint *)keyboardAdjustingBottomConstraint {
        return self.bottomConstraint;
   }
   ```

3. All you need to do now is activate and deactivate the automatic adjustments.

   ```objc
   #import <LHSKeyboardAdjusting/UIViewController+LHSKeyboardAdjustment.h>

   // other stuff here

   - (void)viewWillAppear:(BOOL)animated {
       [super viewWillAppear:animated];
       [self lhs_activateKeyboardAdjustment];
   }

   - (void)viewWillDisappear:(BOOL)animated {
       [super viewWillDisappear:animated];
       [self lhs_deactivateKeyboardAdjustment];
   }
   ```

3. And you're done! Whenever a keyboard appears, your views will be automatically resized.

### Contributing

The only big feature I see missing is iOS 5 support, but otherwise I don't think much else is needed for this project. If you see a bug, please file an issue and I'll look into it right away.

### License

Apache 2.0, see [LICENSE](LICENSE) file for details.
