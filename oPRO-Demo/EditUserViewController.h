//
//  EditUserViewController.h
//  oPRO-Demo
//
//  Created by schneems on 8/8/12.
//
//

#import <Foundation/Foundation.h>

@interface EditUserViewController : UIViewController <UITextFieldDelegate>
{
  IBOutlet UITextField *userEmailField;
  IBOutlet UITextField *userTwitterField;
  IBOutlet UITextField *userZipField;
  
  IBOutlet UILabel *successLabel;

}


@end
