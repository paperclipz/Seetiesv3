//
//  PromoOutletCell.h
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 28/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    SelectionOutletCellType,
    NonSelectionOutletCellType
} PromoOutletCellType;

@interface PromoOutletCell : CommonTableViewCell
-(void)setOutletImage:(UIImage*)image;
-(void)setOutletTitle:(NSString*)title;
-(void)setOutletAddress:(NSString*)address;
-(void)setOutletIsChecked:(BOOL)isChecked;
-(void)setOutletCellType:(PromoOutletCellType)cellType;
@end
