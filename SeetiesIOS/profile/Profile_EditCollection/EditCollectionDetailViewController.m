//
//  EditCollectionDetailViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 9/23/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "EditCollectionDetailViewController.h"
#import "Bostring.h"
#import "ZFTokenField.h"

#define TITLE_MAX_COUNT 70
#define DESC_MAX_COUNT 150


@interface EditCollectionDetailViewController ()<ZFTokenFieldDataSource, ZFTokenFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblWordCountTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblWordCountDesc;

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextView *txtDesc;

@property (strong, nonatomic)CollectionModel* collectionModel;
@property (weak, nonatomic) IBOutlet UIScrollView *ibScrollView;
@property (strong, nonatomic) IBOutlet UIView *ibContentView;
@property (weak, nonatomic) IBOutlet ZFTokenField *ibTokenField;


@property (nonatomic, strong) NSMutableArray *tokens;


@end

@implementation EditCollectionDetailViewController
- (IBAction)btnDoneClicked:(id)sender {
    
    if ([self.txtName.text isEqualToString:@""]) {
        [TSMessage showNotificationInViewController:self title:@"" subtitle:@"Collection name must be at least 6 characters" type:TSMessageNotificationTypeError];
    }else{
        
        if (self.btnDoneBlock) {
            [self saveData];
            self.btnDoneBlock(nil);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }

}
- (IBAction)btnBackClicked:(id)sender {
    
    
    if (self.btnCancelBlock) {
        self.btnCancelBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tokens = [NSMutableArray array];

    
    [self initSelfView];
    self.txtName.enabled = !self.collectionModel.is_default;
    self.txtName.text = self.collectionModel.name;
    self.txtDesc.text = self.collectionModel.postDesc;
    
    [self getCounterText:self.lblWordCountTitle maxCount:TITLE_MAX_COUNT textInputCount:(int)self.txtName.text.length];
    [self getCounterText:self.lblWordCountDesc maxCount:DESC_MAX_COUNT textInputCount:(int)self.txtDesc.text.length];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)initSelfView
{
    [self.ibScrollView addSubview:self.ibContentView];
    CGRect frame = [Utils getDeviceScreenSize];
    self.ibContentView.frame = CGRectMake(0, 0, frame.size.width, self.ibContentView.frame.size.height);
    self.ibScrollView.contentSize = self.ibContentView.frame.size;
    
    self.ibTokenField.dataSource = self;
    self.ibTokenField.delegate = self;
    self.ibTokenField.textField.placeholder = @"Enter here";
    [self.ibTokenField reloadData];
    [self.ibTokenField.textField becomeFirstResponder];


}
-(void)viewDidAppear:(BOOL)animated
{
   

}

-(void)initData:(CollectionModel*)model
{
    self.collectionModel = model;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextfield delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    [self getCounterText:self.lblWordCountTitle maxCount:TITLE_MAX_COUNT textInputCount:(int)textField.text.length];
    
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView
{
    
    [self getCounterText:self.lblWordCountDesc maxCount:DESC_MAX_COUNT textInputCount:(int)textView.text.length];
    
}

-(void)getCounterText:(UILabel*)label  maxCount:(int)maxCount textInputCount:(int)txtCount
{
    if (txtCount>=maxCount) {
        
        label.textColor = [UIColor redColor];
    }
    else{
        
        label.textColor = [Utils defaultTextColor];
        
    }
    
    label.text = [NSString stringWithFormat:@"%d/%d",txtCount,maxCount];
    
}

-(void)saveData
{
    self.collectionModel.name = self.txtName.text;
    self.collectionModel.postDesc = self.txtDesc.text;
}



#pragma mark - ZFTokenField DataSource

- (CGFloat)lineHeightForTokenInField:(ZFTokenField *)tokenField
{
    return 40;
}

- (NSUInteger)numberOfTokenInField:(ZFTokenField *)tokenField
{
    return self.tokens.count;
}

- (UIView *)tokenField:(ZFTokenField *)tokenField viewForTokenAtIndex:(NSUInteger)index
{
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"TokenView" owner:nil options:nil];
    UIView *view = nibContents[0];
    UILabel *label = (UILabel *)[view viewWithTag:2];
    UIButton *button = (UIButton *)[view viewWithTag:3];
    
    [button addTarget:self action:@selector(tokenDeleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    label.text = self.tokens[index];
    CGSize size = [label sizeThatFits:CGSizeMake(1000, 40)];
    view.frame = CGRectMake(0, 0, size.width + 97, 40);
    return view;
}

#pragma mark - ZFTokenField Delegate

- (CGFloat)tokenMarginInTokenInField:(ZFTokenField *)tokenField
{
    return 5;
}

- (void)tokenField:(ZFTokenField *)tokenField didReturnWithText:(NSString *)text
{
    [self.tokens addObject:text];
    [tokenField reloadData];
}

- (void)tokenField:(ZFTokenField *)tokenField didRemoveTokenAtIndex:(NSUInteger)index
{
    [self.tokens removeObjectAtIndex:index];
}

- (BOOL)tokenFieldShouldEndEditing:(ZFTokenField *)textField
{
    return NO;
}

- (void)tokenDeleteButtonPressed:(UIButton *)tokenButton
{
    NSUInteger index = [self.ibTokenField indexOfTokenView:tokenButton.superview];
    if (index != NSNotFound) {
        [self.tokens removeObjectAtIndex:index];
        [self.ibTokenField reloadData];
    }
}


@end
