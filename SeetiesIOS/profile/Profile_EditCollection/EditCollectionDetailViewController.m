//
//  EditCollectionDetailViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 9/23/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "EditCollectionDetailViewController.h"
#import "Bostring.h"
#import "EditTagCollectionViewCell.h"

#import "ZFTokenField.h"

#define TITLE_MAX_COUNT 70
#define DESC_MAX_COUNT 150


@interface EditCollectionDetailViewController () <ZFTokenFieldDataSource, ZFTokenFieldDelegate>
{

    __weak IBOutlet UISwitch *btnPrivate;
    __weak IBOutlet UILabel *lblSetAsPublic;

    __weak IBOutlet UILabel *lblSetAsPublicDesc;
}
@property (weak, nonatomic) IBOutlet UILabel *lblWordCountTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblWordCountDesc;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextView *txtDesc;
@property (strong, nonatomic)CollectionModel* collectionModel;
@property (weak, nonatomic) IBOutlet UIScrollView *ibScrollView;
@property (strong, nonatomic) IBOutlet UIView *ibContentView;
@property (weak, nonatomic) IBOutlet UICollectionView *ibCollectionTagView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTagHeight;

@property (weak, nonatomic) IBOutlet ZFTokenField *ibTokenField;
@property (nonatomic, strong) NSMutableArray *tokens;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UILabel *lblCollectionName;
@property (weak, nonatomic) IBOutlet UILabel *lblCollectionDesc;
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
- (IBAction)btnPrivateClicked:(id)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSelfView];
    self.txtName.enabled = !self.collectionModel.is_default;
    self.txtName.text = self.collectionModel.name;
    self.txtDesc.text = self.collectionModel.postDesc;
    
    [self getCounterText:self.lblWordCountTitle maxCount:TITLE_MAX_COUNT textInputCount:(int)self.txtName.text.length];
    [self getCounterText:self.lblWordCountDesc maxCount:DESC_MAX_COUNT textInputCount:(int)self.txtDesc.text.length];
    
    [self changeLanguage];
    // Do any additional setup after loading the view from its nib.
}

-(void)initSelfView
{
    
    [Utils setRoundBorder:self.txtDesc color:[UIColor lightGrayColor] borderRadius:5.0f borderWidth:0.5f];
    [self.ibScrollView addSubview:self.ibContentView];
    CGRect frame = [Utils getDeviceScreenSize];
    self.ibContentView.frame = CGRectMake(0, 0, frame.size.width, self.ibContentView.frame.size.height);
    self.ibScrollView.contentSize = self.ibContentView.frame.size;
    [self initCollectionViewWithDelegate:self];
//    self.tokens = [NSMutableArray array];
//    self.ibTokenField.dataSource = self;
//    self.ibTokenField.delegate = self;
//    self.ibTokenField.textField.placeholder = @"Enter here";
    //[self.ibTokenField reloadData];

  //  [self.ibTokenField.textField becomeFirstResponder];

}

-(void)initCollectionViewWithDelegate:(id)sender
{

    self.ibCollectionTagView.delegate = self;
    self.ibCollectionTagView.dataSource = self;
    [self.ibCollectionTagView registerClass:[EditTagCollectionViewCell class] forCellWithReuseIdentifier:@"EditTagCollectionViewCell"];
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






#pragma mark - UICollectionView data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    EditTagCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EditTagCollectionViewCell" forIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   // [self.toRecipients addObject:@"apple"];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    CGRect frame = collectionView.frame;
    
    float width = frame.size.width/2 -10;
    return CGSizeMake(width, 35);
}
#pragma mark - UICollectionView Delegate
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
#pragma mark - change language
-(void)changeLanguage
{
    self.lblTitle.text = LocalisedString(@"Edit Collection");
    self.lblCollectionName.text = LocalisedString(@"Collection title");
    self.lblCollectionDesc.text = LocalisedString(@"Collection description");
    self.txtDesc.placeholder = LocalisedString(@"eg: Top 10 coffee hideouts in KL, Best spas in Bangkok");
    lblSetAsPublic.text = LocalisedString(@"Set as public");
    lblSetAsPublicDesc.text = LocalisedString(@"You will not be able to change your privacy settings for this collection once it goes public.");

}
@end
