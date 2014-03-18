LHSKeyboardAdjusting
--------------------

After one too many times of referencing a [Gist](https://gist.github.com/dlo/8572874) I wrote on how to set up automatic view resizing when a keyboard appears in iOS, I decided to just abstract the entire thing and throw it up on GitHub.

LHSKeyboardAdjusting will adjust the height of your UIScrollView or UITableView when a keyboard appears on screen using Auto Layout. All you have to do is provide LHSKeyboardAdjusting with an NSLayoutConstraint that pins the bottom of your view to the bottom of the screen. LHSKeyboardAdjusting will automatically adjust that constraint and pin it to the top of the keyboard when it appears.

Installation
------------

LHSKeyboardAdjusting uses Cocoapods, so in your Podfile, just add something like this:

    pod 'LHSKeyboardAdjusting'

Then run `pod install` and you'll be ready to go.

Usage
-----

1. In your view controller's header file, import and assign the `LHSKeyboardAdjusting` protocol.

        #import <LHSKeyboardAdjusting/LHSKeyboardAdjusting.h>

        @interface AViewController : UIViewController <LHSKeyboardAdjusting>

2. Inside your `viewWillAppear:` method, call `lhs_activateKeyboardAdjustment`.

        - (void)viewWillAppear:(BOOL)animated {
            [super viewWillAppear:animated];
            [self lhs_activateKeyboardAdjustment];
        }

3. Inside your `viewWillDisappear:` method, call `lhs_deactivateKeyboardAdjustment`.

        - (void)viewWillDisappear:(BOOL)animated {
            [super viewWillDisappear:animated];
            [self lhs_deactivateKeyboardAdjustment];
        }

4. You're done!

