//
//  AddNewPlaceSubView.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/20/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "AddNewPlaceSubView.h"

#define MAX_LENGTH 12
@interface AddNewPlaceSubView()
@property (weak, nonatomic) IBOutlet UILabel *lblPlaceName;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblURL;
@property (weak, nonatomic) IBOutlet UILabel *lblPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblPerpax;
@property (weak, nonatomic) IBOutlet UILabel *lblEditHour;
@property (weak, nonatomic) IBOutlet UIImageView *ibImgArrow;

@end

@implementation NSArray (Blocks)

-(int)getIndex:(NSString*)string
{
    for (int i = 0; i<self.count; i++) {
        
        if([self[i] isEqualToString:string])
        {
            return i;
        }
        
    }
    
    return 0;
}

@end

@implementation AddNewPlaceSubView
- (IBAction)btnEditHourClicked:(id)sender {
    
    if (self.btnEditHourClickedBlock) {
        self.btnEditHourClickedBlock(sender);
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initSelfView];
        
        NSLog(@"initWithFrame");
    }
    return self;
}

- (IBAction)btnCurrencyClicked:(id)sender {
    
    [self resignFirstResponder];
    NSArray *arrCurrency = [NSArray arrayWithObjects:USD, MYR, THB, SGD ,TWD, nil];
    
    [ActionSheetStringPicker showPickerWithTitle:@"Select A Currency"
                                            rows:arrCurrency
                                initialSelection:[arrCurrency getIndex:self.btnCurrency.titleLabel.text]
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           NSLog(@"Picker: %@, Index: %ld, value: %@",
                                                 picker, (long)selectedIndex, selectedValue);
                                           
                                           [self.btnCurrency setTitle:selectedValue forState:UIControlStateNormal];
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:sender];
    // You can also use self.view if you don't have a sender
}

+ (id)initializeCustomView
{
    NSString* viewName;
    
    viewName = NSStringFromClass([self class]);
    
    //    NSLog(@"name == %@",viewName);
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:viewName owner:nil options:nil];
    
    for (id currentObject in objects ){
        if ([currentObject isKindOfClass:[self class]])
            // NSLog(@"Nib View Added To [%@]", NSStringFromClass([self class]));
            
            [currentObject initSelfView];
        return currentObject;
    }
    //  NSLog(@"Nib View NOT Added To [%@]", NSStringFromClass([self class]));
    
    return nil;
}
-(void)initSelfView
{
    self.txtPerPax.delegate = self;
    self.txtPerPax.text = @"0.00";
    [Utils setButtonWithBorder:self.btnCurrency];
    [Utils setRoundBorder:self.btnEditHours color:TWO_ZERO_FOUR_COLOR borderRadius:self.btnEditHours.frame.size.height/2];
    [self.txtPhoneNo setKeyboardType:UIKeyboardTypePhonePad];
    
    CGRect frame = [Utils getDeviceScreenSize];
    self.btnEditHours.frame = CGRectMake((frame.size.width - self.btnEditHours.frame.size.width)/2, self.btnEditHours.frame.origin.y, self.btnEditHours.frame.size.width, self.btnEditHours.frame.size.height);
    [self changeLanguage];
    [self changeLanguage];
}

-(void)layoutSubviews
{
    self.ibImgArrow.frame = CGRectMake(self.btnCurrency.frame.origin.x + self.btnCurrency.frame.size.width - self.ibImgArrow.frame.size.width - 10, self.ibImgArrow.frame.origin.y, self.ibImgArrow.frame.size.width,self.ibImgArrow.frame.size.height);

}
#pragma mark - Change Language

-(void)changeLanguage
{
    self.lblPlaceName.text = LocalisedString(@"Place Name");
    self.lblAddress.text = LocalisedString(@"Address");
    self.lblURL.text = LocalisedString(@"URL / Facebook Page");
    self.lblPhoneNumber.text = LocalisedString(@"Phone No.");
    self.lblPrice.text = LocalisedString(@"Price");
    self.lblPerpax.text = LocalisedString(@"Per person");
    self.lblEditHour.text = LocalisedString(@"Business Hours");
    [self.btnEditHours setTitle:LocalisedString(@"Edit") forState:UIControlStateNormal];
  }

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >= MAX_LENGTH && range.length == 0)
    {
        return NO; // return NO to not change text
    }
    else
    {return YES;}
}

@end
