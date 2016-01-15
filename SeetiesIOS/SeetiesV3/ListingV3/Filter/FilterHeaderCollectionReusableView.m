//
//  FilterHeaderCollectionReusableView.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 12/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "FilterHeaderCollectionReusableView.h"

@interface FilterHeaderCollectionReusableView()
@property (weak, nonatomic) IBOutlet UILabel *ibHeaderLbl;
@property (weak, nonatomic) IBOutlet UIButton *ibCheckbox;

@end

@implementation FilterHeaderCollectionReusableView

- (void)awakeFromNib {
    // Initialization code
}

-(void)setHeaderText:(NSString*)text{
    self.ibHeaderLbl.text = text;
}

@end
