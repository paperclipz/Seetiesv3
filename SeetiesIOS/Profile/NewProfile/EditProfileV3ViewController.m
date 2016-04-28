//
//  EditProfileV3ViewController.m
//  SeetiesIOS
//
//  Created by Lai on 18/04/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "EditProfileV3ViewController.h"
#import "PSearchLocationViewController.h"
#import "IQUIViewController+Additions.h"
#import "TLTagsControl.h"
#import "GenericObject.h"
#import "AsyncImageView.h"

typedef enum {
    UsernameField,
    Namefield,
    LocationField,
    WebsiteLinkField,
    TaggingField,
    AboutMeField,
    DOBField,
    GenderField
}ControlType;

@interface EditProfileV3ViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, searchLocationDelegate>

@property (weak, nonatomic) IBOutlet AsyncImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIButton *profileImageButton;
@property (weak, nonatomic) IBOutlet UITableView *profileTableView;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;
@property (weak, nonatomic) IBOutlet UITextView *aboutTextView;
@property (weak, nonatomic) IBOutlet AsyncImageView *coverImageView;
@property (nonatomic) BOOL isUploadCoverPhoto;

@property (strong, nonatomic) UITextField *activeField;
@property (weak, nonatomic) IBOutlet TLTagsControl *tagControl;
@property (strong, nonatomic) UIDatePicker *birthdayDatePicker;
@property (strong, nonatomic) UIPickerView *genderPickerView;

@property (strong, nonatomic) NSIndexPath *datePickerIndexPath;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTextField;
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;

@property (strong, nonatomic) NSArray *genderArray;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSMutableDictionary *locationDict;

@end

@implementation EditProfileV3ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initializeView];
    [self populateDate];
    
    //Register keyboard notification
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initialize method

- (void)initializeView {
    
    //navigation bar layout
    self.title = LocalisedString(@"Edit Profile");
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"TitleBar"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    //initialize date formatter
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //Make profile image button rounded
    [Utils setRoundBorder:self.profileImageView color:TWO_ZERO_FOUR_COLOR borderRadius:self.profileImageView.frame.size.height/2 borderWidth:0.5f];
    [Utils setRoundBorder:self.profileImageButton color:[UIColor whiteColor] borderRadius:self.profileImageButton.frame.size.height/2 borderWidth:4.0f];
    
    //tag control setting
    self.tagControl.tagsBackgroundColor = [UIColor whiteColor];
    self.tagControl.tagsDeleteButtonColor = TWO_ZERO_FOUR_COLOR;
    self.tagControl.tagsTextColor = TWO_ZERO_FOUR_COLOR;
    
    UITextField *tagTextField = self.tagControl.getCurrentTextField;
    tagTextField.font = [UIFont systemFontOfSize:15];
    
    self.locationDict = [NSMutableDictionary new];
    
    [self createPicker];
    [self initGenderArray];
}

- (void)initGenderArray {
    
    GenericObject *male = [[GenericObject alloc] init];
    male.text =LocalisedString(@"Male");
    male.value = @"m";
    
    GenericObject *female = [[GenericObject alloc] init];
    female.text =LocalisedString(@"Female");
    female.value = @"f";
    
    self.genderArray = [[NSArray alloc] initWithObjects:male, female, nil];
}

- (void)populateDate {
    
    if (!self.userProfileData) { return; }
    
    //localization
    for (UITextField *textField in _textFields) {
        textField.placeholder = [self getLocalisedString:textField.tag];
        textField.text = [self getValueForTextField:textField.tag];
    }
    
    self.aboutTextView.placeholder = [self getLocalisedString:self.aboutTextView.tag];
    self.tagControl.tagPlaceholder = [self getLocalisedString:self.tagControl.tag];
    
    self.coverImageView.imageURL = [[NSURL alloc] initWithString:self.userProfileData.wallpaper];
    self.profileImageView.imageURL = [[NSURL alloc] initWithString:self.userProfileData.profile_photo_images];
    
    self.tagControl.tags = [[NSMutableArray alloc] initWithArray:self.userProfileData.personal_tags];
    [self.tagControl reloadTagSubviews];
    
    self.birthdayDatePicker.date = [NSDate date];
    
    if (![self.userProfileData.dob isEqualToString:@""] && ![self.userProfileData.dob isEqualToString:@"0000-00-00"]) {
        self.birthdayTextField.text = self.userProfileData.dob;
        self.birthdayDatePicker.date = [self.dateFormatter dateFromString:self.userProfileData.dob];
    }
    
    self.aboutTextView.text = self.userProfileData.profileDescription;
    
    if (self.userProfileData.gender && ![self.userProfileData.gender isEqualToString:@""]) {
        [self.genderPickerView selectRow:[self.userProfileData.gender isEqualToString:@"m"] ? 0 : 1 inComponent:0 animated:YES];
        self.genderTextField.text = [self.userProfileData.gender isEqualToString:@"m"] ? @"male" : @"female";
    }
}

- (void)createPicker {
    
    self.birthdayDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 216, CGRectGetWidth(self.view.frame), 216)];
    
    self.birthdayDatePicker.datePickerMode = UIDatePickerModeDate;
    self.birthdayDatePicker.backgroundColor = [UIColor whiteColor];
    [self.birthdayDatePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];

    self.birthdayTextField.inputView = self.birthdayDatePicker;
    
    self.genderPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 216, CGRectGetWidth(self.view.frame), 216)];
    
    self.genderPickerView.delegate = self;
    self.genderPickerView.backgroundColor = [UIColor whiteColor];
    
    self.genderTextField.inputView = self.genderPickerView;
    
}

#pragma mark - private method

- (void)openPhotoActionSheet {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:LocalisedString(@"Howdoyouwanttodoaddimage")
                                                             delegate:self
                                                    cancelButtonTitle:LocalisedString(@"SettingsPage_Cancel")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:LocalisedString(@"PhotoLibrary"), LocalisedString(@"Camera"), nil];
    
    [actionSheet showInView:self.view];
}

- (void)dateChanged:(id)sender {
    
    UIDatePicker *datePicker = sender;
    
    self.birthdayTextField.text = [self.dateFormatter stringFromDate:datePicker.date];
    
}

- (NSString *)getLocalisedString:(NSInteger)tag {
    
    switch (tag) {
        case UsernameField:
            return LocalisedString(@"Username");
            break;
        case Namefield:
            return LocalisedString(@"Name");
            break;
        case LocationField:
            return LocalisedString(@"Location");
            break;
        case WebsiteLinkField:
            return LocalisedString(@"Website");
            break;
        case TaggingField:
            return LocalisedString(@"Separate tags with space. Eg. Foodie, photographer, gym buff etc.");
            break;
        case AboutMeField:
            return LocalisedString(@"About me");
            break;
        case DOBField:
            return LocalisedString(@"ddmmyyyy");
            break;
        case GenderField:
            return LocalisedString(@"Gender");
            break;
        default:
            return @"";
            break;
    }
}

- (NSString *)getValueForTextField:(NSInteger)row {
    
    switch (row) {
        case UsernameField:
            return self.userProfileData.username;
            break;
        case Namefield:
            return self.userProfileData.name;
            break;
        case LocationField:
            return self.userProfileData.location;
            break;
        case WebsiteLinkField:
            return self.userProfileData.personal_link;
            break;
        default:
            return @"";
            break;
    }
}

- (NSString *)getDictionaryKeyForTextField:(NSInteger)tag {
    switch (tag) {
        case UsernameField:
            return @"username";
            break;
        case Namefield:
            return @"name";
            break;
        case LocationField:
            return @"location";
            break;
        case WebsiteLinkField:
            return @"personal_link";
            break;
        case DOBField:
            return @"dob";
            break;
        default:
            return @"";
            break;
    }

}

- (NSMutableDictionary *)getDataForPost {
    
    NSMutableDictionary *dataToPost = [NSMutableDictionary new];
    
    [dataToPost setObject:[Utils getAppToken] forKey:@"token"];

    for (UITextField *textField in self.textFields) {
        [dataToPost setObject:textField.text forKey:[self getDictionaryKeyForTextField:textField.tag]];
    }
    
    int i = 0;
    
    for (NSString *tag in self.tagControl.tags) {
        [dataToPost setObject:tag forKey:[NSString stringWithFormat:@"personal_tags[%i]", i]];
        
        i++;
    }
    
    if (self.tagControl.tags.count < 1) {
        [dataToPost setObject:@"" forKey:@"personal_tags"];
    }
    
    [dataToPost setObject:self.aboutTextView.text forKey:@"description"];
    
//    if (![self.birthdayTextField.text isEqualToString:@""]) {
//        [dataToPost setObject:self.birthdayTextField.text forKey:@"dob"];
//    }
    
    if (![self.genderTextField.text isEqualToString:@""]) {
        NSInteger selectedIndex = [self.genderPickerView selectedRowInComponent:0];
        
        GenericObject *gender = self.genderArray[selectedIndex];
        
        [dataToPost setObject:gender.value forKey:@"gender"];
    }
    
    //location setting
    if (self.locationDict.count > 0) {
        [dataToPost setObject:[Utils convertToJsonString:self.locationDict] forKey:@"home_city"];
    }
    
    return dataToPost;
}

#pragma mark - button events

- (IBAction)coverImageButtonClicked:(id)sender {
    
    [self.view endEditing:YES];
    self.isUploadCoverPhoto = YES;
    [self openPhotoActionSheet];
}

- (IBAction)profileImageButtonClicked:(id)sender {
    
    [self.view endEditing:YES];
    self.isUploadCoverPhoto = NO;
    [self openPhotoActionSheet];
}

- (IBAction)backButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonClicked:(id)sender {
    [self.view endEditing:YES];
    
    __weak EditProfileV3ViewController *weakSelf = self;
    
    NSMutableArray *imageData = [NSMutableArray new];
    
    if (self.profileImageView.image) {
        PhotoModel *photo = [[PhotoModel alloc] init];
        
        photo.photo_id = @"profile_photo";
        photo.image = self.profileImageView.image;
//        photo.caption = @"profilePic123";
        
        [imageData addObject:photo];
    }
    
    if (self.coverImageView.image) {
        PhotoModel *photo = [[PhotoModel alloc] init];
        
        photo.photo_id = @"wallpaper";
        photo.image = self.coverImageView.image;
//        photo.caption = @"wallpaper123";
        
        [imageData addObject:photo];
    }
    
    [LoadingManager show];
    
    [[ConnectionManager Instance] requestServerWithPost:ServerRequestTypePostUserProfile param:[self getDataForPost] appendString:[NSString stringWithFormat:@"%@", [Utils getUserID]] meta:imageData completeHandler:^(id object) {
        
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        
    } errorBlock:^(id object) {
        
        [MessageManager showMessage:@"Failed to update Profile!" SubTitle:nil Type:TSMessageNotificationTypeError];
        
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    
//    [[ConnectionManager Instance] requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostUserProfile parameter:[self getDataForPost] appendString:[NSString stringWithFormat:@"%@", [Utils getUserID]] success:^(id object) {
//        
////        [MessageManager showMessage:LocalisedString(@"Successfully share to friend") SubTitle:nil Type:TSMessageNotificationTypeSuccess];
//        
//        [weakSelf dismissViewControllerAnimated:YES completion:nil];
//        
//    } failure:^(id object) {
//        
//    }];
}

#pragma mark - UITableViewDataSource method

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return LocalisedString(@"Personal Information");
    }
    
    return @"";
}

#pragma mark - UITableViewDelegate method

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 2) {
        PSearchLocationViewController *PSearchLocationView = [[PSearchLocationViewController alloc]init];

        PSearchLocationView.delegate = self;
        
        [self.navigationController pushViewController:PSearchLocationView animated:YES];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0 && indexPath.row == 2) {
        return YES;
    }
    
    return NO;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0 && indexPath.row == 2) {
        return indexPath;
    }
    
    return nil;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeField = nil;
}

#pragma mark - UIActionSheetDelegate method

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex > 1) { return; }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    
    if (buttonIndex == 0) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else if (buttonIndex == 1) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])  {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@""
                                                                  message:@"Device has no camera"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
            
            [myAlertView show];
            
            return;
        }
    }
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate method

-(void)imagePickerController:(UIImagePickerController *)picker
      didFinishPickingImage : (UIImage *)image
                 editingInfo:(NSDictionary *)editingInfo
{
    
    if (_isUploadCoverPhoto) {
        self.coverImageView.image = image;
    }
    else {
        self.profileImageView.image = image;
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *) picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.genderArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return ((GenericObject *)[self.genderArray objectAtIndex:row]).text;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.genderTextField.text = ((GenericObject *)[self.genderArray objectAtIndex:row]).text;
}

#pragma mark - searchLocationDelegate method

- (void)DidSelectLocation:(NSDictionary *)locationData {
    
    if (!locationData) { return; }
    
    [self.locationDict removeAllObjects];
    
    self.locationDict = [[NSMutableDictionary alloc] initWithDictionary:locationData];
    
    UITextField *locationTextField = [self.textFields objectAtIndex:LocationField];
    
    locationTextField.text = self.locationDict[@"formatted_address"];
}

#pragma mark - keyboard notification event

//-(void)keyboardWillShow:(NSNotification*)aNotification {
//    
//    NSDictionary* info = [aNotification userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
//    self.tableView.contentInset = contentInsets;
//    self.tableView.scrollIndicatorInsets = contentInsets;
//    
//    CGRect firstResponderFrame = self.activeField.superview.superview.frame;
//    
//    if ([self.aboutTextView isFirstResponder]) {
//        firstResponderFrame = self.aboutTextView.superview.superview.frame;
//    }
//    
//    if ([self.tagControl.getCurrentTextField isFirstResponder]) {
//        firstResponderFrame = self.tagControl.getCurrentTextField.superview.superview.superview.frame;
//    }
//    
//    // If active text field is hidden by keyboard, scroll it so it's visible
//    // Your app might not need or want this behavior.
//    CGRect aRect = self.view.frame;
//    aRect.size.height -= kbSize.height;
//    if (!CGRectContainsPoint(aRect, firstResponderFrame.origin) ) {
//        [self.tableView scrollRectToVisible:firstResponderFrame animated:YES];
//    }
//}
//
//- (void)keyboardWillBeHidden:(NSNotification*)aNotification
//{
//    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
//    self.tableView.contentInset = contentInsets;
//    self.tableView.scrollIndicatorInsets = contentInsets;
//}

#pragma mark - Remove Observer

//- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

@end
