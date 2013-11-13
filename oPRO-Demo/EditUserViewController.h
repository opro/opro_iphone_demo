//
//  EditUserViewController.h
//  oPRO-Demo
//
//  Created by schneems on 8/8/12.
//
//

#import <Foundation/Foundation.h>

@interface EditUserViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITextField *twitterTextField;
@property (nonatomic, weak) IBOutlet UITextField *zipTextField;
@property (nonatomic, weak) IBOutlet UILabel *successLabel;

- (IBAction)updateAccountButtonPressed:(id)sender;
- (IBAction)logoutButtonPressed:(id)sender;

@end
