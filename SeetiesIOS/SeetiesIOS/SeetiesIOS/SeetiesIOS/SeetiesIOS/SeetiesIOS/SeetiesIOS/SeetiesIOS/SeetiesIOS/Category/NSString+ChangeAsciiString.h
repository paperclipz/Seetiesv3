//
//  NSString+ChangeAsciiString.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 5/19/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ChangeAsciiString)
- (NSString *)stringByDecodingXMLEntities;
@end
