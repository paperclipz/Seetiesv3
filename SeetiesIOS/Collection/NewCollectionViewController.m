//
//  NewCollectionViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 9/21/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "NewCollectionViewController.h"
#import "UITextView+Placeholder.h"

#define TITLE_MAX_COUNT 70
#define DESC_MAX_COUNT 150

@interface NewCollectionViewController ()
{
    IBOutlet TPKeyboardAvoidingScrollView *MainScroll;
    IBOutlet UIImageView *BarImage;
    IBOutlet UILabel *ShowTitle;
    
    IBOutlet UITextView *txtNameView;
    IBOutlet UITextView *txtDescriptionView;
    IBOutlet UITextField *TagsField;
    IBOutlet UILabel *ShowNameCount;
    IBOutlet UILabel *ShowDescriptionCount;
    
    IBOutlet UIView *SetPublicView;
    IBOutlet UIView *SetTagsView;
    
    IBOutlet UIButton *SaveButton;
    IBOutlet UIButton *TagsLine;

}
@property (weak, nonatomic) IBOutlet UISwitch *ibSwitch;

@end

@implementation NewCollectionViewController

-(void)initSelfView
{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    MainScroll.delegate = self;
    [MainScroll setContentSize:CGSizeMake(screenWidth, 700)];
    MainScroll.frame = CGRectMake(0, 64, screenWidth, screenHeight - 64 - 61);
    SetPublicView.frame = CGRectMake(0, screenHeight - 61, screenWidth, 61);
    ShowTitle.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    
    txtNameView.frame = CGRectMake(20, 37, screenWidth - 40, 67);
    ShowNameCount.frame = CGRectMake(screenWidth - 20 - 80, 104, 80, 21);
    
    txtDescriptionView.frame = CGRectMake(20, 146, screenWidth - 40, 100);
    ShowDescriptionCount.frame = CGRectMake(screenWidth - 20 - 80, 247, 80, 21);
    
    TagsField.frame = CGRectMake(15, 13, screenWidth - 70, 30);
    
    txtNameView.delegate = self;
    [Utils setRoundBorder:txtNameView color:[UIColor grayColor] borderRadius:5.0f];
    
    txtDescriptionView.delegate = self;
    [Utils setRoundBorder:txtDescriptionView color:[UIColor grayColor] borderRadius:5.0f];

    
    SaveButton.frame = CGRectMake(screenWidth - 60, 20, 60, 44);
    
    SetTagsView.frame = CGRectMake(20, 300, screenWidth - 40, 200);
    SetTagsView.layer.cornerRadius = 5;
    SetTagsView.layer.borderWidth=1;
    SetTagsView.layer.borderColor=[[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f] CGColor];
    
    TagsLine.frame = CGRectMake(0, 50, screenWidth - 40 , 1);
  
    self.ibSwitch.on = false;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)BackButton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // [self.view endEditing:YES];// this will do the trick
    [txtNameView resignFirstResponder];
    [txtDescriptionView resignFirstResponder];
    [TagsField resignFirstResponder];
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView == txtNameView) {
        NSUInteger len = textView.text.length;
        ShowNameCount.text = [NSString stringWithFormat:@"%lu / %d",TITLE_MAX_COUNT - len,TITLE_MAX_COUNT];
    }else{
        NSUInteger len = textView.text.length;
        ShowDescriptionCount.text = [NSString stringWithFormat:@"%lu / %d",150 - len,DESC_MAX_COUNT];
    }

    
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView == txtNameView) {
        if ([text isEqualToString:@"\n"]) {
            // Be sure to test for equality using the "isEqualToString" message
            [textView resignFirstResponder];
            // Return FALSE so that the final '\n' character doesn't get added
            return FALSE;
        }else{
            if([text length] == 0)
            {
                if([textView.text length] != 0)
                {
                    return YES;
                }
            }
            else if([[textView text] length] >= 30)
            {
                ShowNameCount.text = [NSString stringWithFormat:@"%d / %d",0,TITLE_MAX_COUNT];
                ShowNameCount.textColor = [UIColor redColor];
                return NO;
            }
        }
    }else{
        if ([text isEqualToString:@"\n"]) {
            // Be sure to test for equality using the "isEqualToString" message
            [textView resignFirstResponder];
            // Return FALSE so that the final '\n' character doesn't get added
            return FALSE;
        }else{
            if([text length] == 0)
            {
                if([textView.text length] != 0)
                {
                    return YES;
                }
            }
            
            else if([[textView text] length] >= 30)
            {
                ShowDescriptionCount.text = [NSString stringWithFormat:@"%d / %d",0,DESC_MAX_COUNT];
                ShowDescriptionCount.textColor = [UIColor redColor];
                return NO;
            }
        }
    }
    
    return YES;
}
-(IBAction)SaveButton:(id)sender{
    
    if ([txtNameView.text isEqualToString:@""]) {
         [TSMessage showNotificationInViewController:self title:@"" subtitle:@"Collection name must be at least 6 characters" type:TSMessageNotificationTypeError];
    }else{
        [self requestServerForCreateCollection];
    }
    

}

-(void)requestServerForCreateCollection{

    if ([TagsField.text isEqualToString:@""]) {
        TagsField.text = @"";
    }
    
    NSDictionary* dict = @{@"token":[Utils getAppToken],
                           @"name":txtNameView.text,
                           @"access":self.ibSwitch.on?@0:@1,
                           @"description":txtDescriptionView.text,
                           @"tags":@""};
    
    NSString* appendString = [NSString stringWithFormat:@"%@/Collections",[Utils getUserID]];
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypePostCreateCollection param:dict appendString:appendString completeHandler:^(id object) {
        
        [TSMessage showNotificationInViewController:self title:@"" subtitle:@"Success Create New Collections" type:TSMessageNotificationTypeSuccess];

    } errorBlock:nil];
    
}


-(void)requestServerForUpdateCollection{
    
    if ([TagsField.text isEqualToString:@""]) {
        TagsField.text = @"";
    }
    
    NSDictionary* dict = @{@"token":[Utils getAppToken],
                           @"collection_id":@"",
                           @"name":txtNameView.text,
                           @"access":self.ibSwitch.on?@0:@1,
                           @"description":txtDescriptionView.text,
                           @"tags":@""
                           };
    
    NSString* appendString = [NSString stringWithFormat:@"%@/Collections",[Utils getUserID]];
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypePostCreateCollection param:dict appendString:appendString completeHandler:^(id object) {
        
        [TSMessage showNotificationInViewController:self title:@"" subtitle:@"Success Create New Collections" type:TSMessageNotificationTypeSuccess];
        
    } errorBlock:nil];
    
}



@end
