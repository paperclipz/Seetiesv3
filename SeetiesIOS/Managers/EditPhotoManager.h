//
//  EditPhotoManager.h
//  SeetiesIOS
//
//  Created by Evan Beh on 9/2/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ImageBlock)(UIImage* image);

@interface EditPhotoManager : NSObject<AFPhotoEditorControllerDelegate>
@property (nonatomic, strong) NSMutableArray * sessions;
@property (nonatomic, copy) ImageBlock processImageBlock;

- (void) launchPhotoEditorWithImage:(UIImage *)editingResImage highResolutionImage:(UIImage *)highResImage viewController:(id)vc completionBlock:(ImageBlock)completionBlock;

@end
