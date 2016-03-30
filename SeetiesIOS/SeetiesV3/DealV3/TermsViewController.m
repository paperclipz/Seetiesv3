//
//  TermsViewController.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 09/03/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "TermsViewController.h"

@interface TermsViewController ()
@property (weak, nonatomic) IBOutlet UIView *ibContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibContentViewHeightConstraint;
@property (nonatomic) NSArray *termsArray;
@end

@implementation TermsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData:(NSArray*)terms{
    _termsArray = terms;
}

-(void)viewDidAppear:(BOOL)animated{
    float yOrigin = 0;
    float fontSize = 15.0f;
    self.ibContentViewHeightConstraint.constant = 0;
    NSDictionary *attr = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    for (NSString *term in self.termsArray) {
        
        UILabel *bulletPoint = [[UILabel alloc] initWithFrame:CGRectMake(0, yOrigin+3, 16, 7)];
        bulletPoint.font = [UIFont systemFontOfSize:fontSize];
        bulletPoint.textColor = [UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1];
        bulletPoint.text = [NSString stringWithFormat:@"\u2022"];
        
        NSString *formattedTerm = [NSString stringWithFormat:@"%@", term];
        CGRect rect = [formattedTerm boundingRectWithSize:CGSizeMake(self.ibContentView.frame.size.width-bulletPoint.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil];
        UILabel *tncLbl = [[UILabel alloc]initWithFrame:CGRectMake(bulletPoint.frame.size.width, yOrigin, ceilf(rect.size.width), ceilf(rect.size.height))];
        tncLbl.font = [UIFont systemFontOfSize:fontSize];
        tncLbl.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
        tncLbl.numberOfLines = 0;
        tncLbl.text = formattedTerm;
        
        [self.ibContentView addSubview:bulletPoint];
        [self.ibContentView addSubview:tncLbl];
        yOrigin += tncLbl.frame.size.height + 10;
    }
    self.ibContentViewHeightConstraint.constant = yOrigin;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
