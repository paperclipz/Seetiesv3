//
//  EditCollectionDetailViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 9/23/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "EditCollectionDetailViewController.h"
#import "EditTagCollectionViewCell.h"
#import "TLTagsControl.h"

#define TITLE_MAX_COUNT 70
#define DESC_MAX_COUNT 150


@interface EditCollectionDetailViewController ()<TLTagsControlDelegate>
{

    __weak IBOutlet UIButton *btnSetPrivate;
    __weak IBOutlet UILabel *lblSetAsPublic;
    __weak IBOutlet UIView *ibPrivacyView;
    __weak IBOutlet UILabel *lblSetAsPublicDesc;
}
@property (weak, nonatomic) IBOutlet UILabel *lblWordCountTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblWordCountDesc;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextView *txtDesc;
@property (weak, nonatomic) IBOutlet UIScrollView *ibScrollView;
@property (strong, nonatomic) IBOutlet UIView *ibContentView;
@property (weak, nonatomic) IBOutlet UICollectionView *ibCollectionTagView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTagHeight;
@property (nonatomic, strong) IBOutlet TLTagsControl *blueEditingTagControl;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblCollectionName;
@property (weak, nonatomic) IBOutlet UILabel *lblCollectionDesc;
@property (strong, nonatomic)CollectionModel* collectionModel;
@property (nonatomic, strong) NSMutableArray *tagList;

@end

@implementation EditCollectionDetailViewController

- (IBAction)btnPrivateClicked:(id)sender {
    
    UIButton* button = (UIButton*)sender;
    button.selected = !button.selected;
}
- (IBAction)btnDoneClicked:(id)sender {
    
    if ([self.txtName.text isEqualToString:@""]) {
        [TSMessage showNotificationInViewController:self title:@"" subtitle:@"Collection name must be at least 6 characters" type:TSMessageNotificationTypeError];
    }else{
        
        if (self.btnDoneBlock) {
            [self saveData];
            self.btnDoneBlock(self.collectionModel);
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
    
    [self initSelfView];
    self.txtName.enabled = !self.collectionModel.is_default;
    self.txtName.text = self.collectionModel.name;
    self.txtDesc.text = self.collectionModel.postDesc;
    
    if (self.collectionModel.isPrivate) {
        btnSetPrivate.selected = !self.collectionModel.isPrivate;
        btnSetPrivate.enabled = YES;
    }
    else{
        btnSetPrivate.enabled = false;
    }
    
    [self getCounterText:self.lblWordCountTitle maxCount:TITLE_MAX_COUNT textInputCount:(int)self.txtName.text.length];
    [self getCounterText:self.lblWordCountDesc maxCount:DESC_MAX_COUNT textInputCount:(int)self.txtDesc.text.length];
    [Utils setRoundBorder:ibPrivacyView color:TWO_ZERO_FOUR_COLOR borderRadius:0];
    
    [self changeLanguage];

  
    
}
#define CELL_HEIGHT 40
#define CELL_PADDING 10
-(void)initSelfView
{
    
    [self.txtName addTarget:self
                      action:@selector(textFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
    
    [Utils setRoundBorder:self.txtDesc color:[UIColor lightGrayColor] borderRadius:5.0f borderWidth:0.5f];
    [self.ibScrollView addSubview:self.ibContentView];
       [self initCollectionViewWithDelegate:self];

    
    [self initTagView];
    

    [self adjustView];
    

}

-(void)adjustView
{
//    // ====== for tag adjust ment ======
//    float count = (self.tagList.count%2 != 0)?(self.tagList.count+1)/2:self.tagList.count/2;
//    float collectionheight = (CELL_HEIGHT+CELL_PADDING)* count;
//    
//    self.ibContentView.frame = CGRectMake( self.ibContentView.frame.origin.x,  self.ibContentView.frame.origin.y,  self.ibContentView.frame.size.width,  self.blueEditingTagControl.frame.size.height+ self.blueEditingTagControl.frame.origin.y+30 + collectionheight);
    
    // ====== for tag adjust ment ======

    CGRect frame = [Utils getDeviceScreenSize];
    self.ibContentView.frame = CGRectMake(0, 0, frame.size.width, self.ibContentView.frame.size.height);
    self.ibScrollView.contentSize = self.ibContentView.frame.size;

    [self.ibScrollView needsUpdateConstraints];
}

-(void)initTagView
{
    _blueEditingTagControl.tags = [self.collectionModel.tagList mutableCopy];
    _blueEditingTagControl.tagPlaceholder = @"Tag";
    
    _blueEditingTagControl.delegate  = self;
       UIColor *whiteTextColor = [UIColor whiteColor];
    
    _blueEditingTagControl.tagsBackgroundColor = DEVICE_COLOR;
    _blueEditingTagControl.tagsDeleteButtonColor = whiteTextColor;
    _blueEditingTagControl.tagsTextColor = whiteTextColor;
    
    
    [_blueEditingTagControl reloadTagSubviews];
   
    __weak typeof (self)weakSelf = self;
    
    _blueEditingTagControl.tagBlock = ^(NSString* string)
    {
        [weakSelf requestServerForTag:string];
    };
    
}

-(void)initCollectionViewWithDelegate:(id)sender
{

    self.ibCollectionTagView.delegate = self;
    self.ibCollectionTagView.dataSource = self;
    [self.ibCollectionTagView registerClass:[EditTagCollectionViewCell class] forCellWithReuseIdentifier:@"EditTagCollectionViewCell"];
}


-(void)initData:(CollectionModel*)model
{
    self.collectionModel = [model copy];
   // self.tagList = self.collectionModel.tagList;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextfield delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField.text.length >= TITLE_MAX_COUNT) {
        if ([string isEqualToString:@""]) {
            return YES;
            
        }
        return NO;
    }
    else{
        return YES;
    }
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length>=TITLE_MAX_COUNT) {
        
        NSString *currentString = [textField.text substringWithRange:NSMakeRange(0, textField.text.length>=TITLE_MAX_COUNT?TITLE_MAX_COUNT:textField.text.length)];
        
        textField.text = currentString;
    }
    
    
    [self getCounterText:self.lblWordCountTitle maxCount:TITLE_MAX_COUNT textInputCount:(int)textField.text.length];
    
}
#pragma mark - UITextView Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length >= DESC_MAX_COUNT) {
        
        if ([text isEqualToString:@""]) {
            return YES;
            
        }
        return NO;
        
    }
    else{
        return YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.text.length >= DESC_MAX_COUNT) {
        NSString *currentString = [textView.text substringWithRange:NSMakeRange(0, textView.text.length>=DESC_MAX_COUNT?DESC_MAX_COUNT:textView.text.length)];
        
        textView.text = currentString;
        
    }
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
   
    self.collectionModel.isPrivate = !btnSetPrivate.enabled;
    self.collectionModel.tagList = self.blueEditingTagControl.tags;
}

#pragma mark - UICollectionView data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tagList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    EditTagCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EditTagCollectionViewCell" forIndexPath:indexPath];
    
    cell.lblTitle.text = self.tagList[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   // [self.toRecipients addObject:@"apple"];
    [self.blueEditingTagControl addTag:self.tagList[indexPath.row]];
    
    [self.blueEditingTagControl getCurrentTextField].text = @"";
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
   
    
//    CATransform3D rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, .0, 0.5, 0.5);
//    cell.contentView.alpha = 0.8;
//    cell.contentView.layer.transform = rotation;
//    cell.contentView.layer.anchorPoint = CGPointMake(0, 0.5);
//    
//    [UIView animateWithDuration:.5
//                     animations:^{
//                         cell.contentView.layer.transform = CATransform3DIdentity;
//                         cell.contentView.alpha = 1;
//                         cell.contentView.layer.shadowOffset = CGSizeMake(0, 0);
//                     } completion:^(BOOL finished) {
//                     }];
    
    cell.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        cell.alpha = 1;

    }];

}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    CGRect frame = [Utils getDeviceScreenSize];
    
    float width = frame.size.width/2 -20;
    
    return CGSizeMake(width, 40);
}

#pragma mark - TLTagsControlDelegate
- (void)tagsControl:(TLTagsControl *)tagsControl tappedAtIndex:(NSInteger)index {
    NSLog(@"Tag \"%@\" was tapped", tagsControl.tags[index]);
    
   
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

#pragma mark - Request Server
-(void)requestServerForTag:(NSString*)tag
{
    
    NSString* tagStr = tag;
    //[LoadingManager show];
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetTagsSuggestion  param:nil appendString:tagStr completeHandler:^(id object) {
        
        self.tagList =[[NSMutableArray alloc]initWithArray:[[[ConnectionManager dataManager] tagModel] arrayTag] ];
        [self.ibCollectionTagView reloadData];
        
    } errorBlock:^(id object) {
        
    }];
}

@end
