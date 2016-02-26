//
//  ExpiryDateModel.h
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 25/02/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DealExpiryDateModel : NSObject

@property(nonatomic, strong) NSString *expiryDate;
@property(nonatomic, strong) NSMutableArray<DealModel*> *dealModelArray;

@end
