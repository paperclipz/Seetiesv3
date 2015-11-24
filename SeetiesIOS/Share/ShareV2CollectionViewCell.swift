//
//  ShareV2CollectionViewCell.swift
//  SeetiesIOS
//
//  Created by Evan Beh on 11/24/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

import UIKit

class ShareV2CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ibImageView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */


    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}



//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
//        
//        for (id currentObject in objects ){
//            if ([currentObject isKindOfClass:[self class]]) {
//                [currentObject initSelfView];
//                return currentObject;
//            }
//        }
//        return nil;
//    }
//    
//    return self;
//}