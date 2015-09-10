//
//  AddNewPlaceSubView.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/20/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "AddNewPlaceSubView.h"

#define MAX_LENGTH 12


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
    
    
    NSArray *arrCurrency = [NSArray arrayWithObjects:@"USD", @"MYR", @"THB", @"SGD", nil];
    
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
    
    [Utils setButtonWithBorder:self.btnCurrency];
    [Utils setButtonWithBorder:self.btnEditHours];

    
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
