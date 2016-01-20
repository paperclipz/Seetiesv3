//
//  ShareV2ViewController.swift
//  SeetiesIOS
//
//  Created by Evan Beh on 11/24/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

import UIKit
//protocol ShareV2ViewController {
//    
//    func share(postID:String, message:String,title:String, imagURL:String, shareType:ShareType, userID:String)
//}

class ShareV2ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate{
    @IBOutlet weak var ibCollectionView: UICollectionView!
    @IBOutlet weak var ShareFrenView: UIView!
    
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    var viewController = UIViewController()

    var shareToFrenVC = ShareToFrenViewController()
    var arrImages = Array<String>()
    var arrTitles = Array<String>()
    var arrIndex = [Int]()
    var postMessage: String = ""
    var postTitle: String = ""
    var imageURL: String = ""
    var postURL: String = ""
    var shareID: String = ""
    var userID: String = ""
    var postID: String = ""

    var shareType:ShareType?
    var shareManager:ShareManager?

    // MARK: - IBACTION

    @IBAction func btnShareToFriendClicked(sender: AnyObject) {
        
      //  shareToFrenVC = ShareV2ViewController.init(nibName: "ShareToFrenViewController", bundle: nil)
      //  self.navigationController!.pushViewController(shareToFrenVC, animated: true)
        self.shareToFrenVC = ShareToFrenViewController(nibName: "ShareToFrenViewController", bundle: nil)
        
        self.shareToFrenVC.GetID(self.shareID, getUserID: userID, getType: self.shareType!, getPostID: self.postID)
        

        
        self.presentViewController(self.shareToFrenVC, animated: true, completion: nil)
       // self.navigationController!.pushViewController(self.shareToFrenVC, animated: true)

    }
    
    @IBAction func btnBackClicked(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSelfView()
        initShareFrenView()
        shareManager = ShareManager()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initSelfView()
    {
        self.lblTitle.text = LanguageManager.sharedLanguageManager().getTranslationForKey("Send to friends in Seeties");
        self.lblDesc.text = LanguageManager.sharedLanguageManager().getTranslationForKey("Your friend will receive in notification.");
        
        self.view.bounds = CGRectMake(0, 0, Utils.getDeviceScreenSize().size.width, Utils.getDeviceScreenSize().size.height)
        self.view.setNeedsLayout()
        initCollectionView()
        
        if(self.shareType == ShareTypePost)
        {
            arrImages = ["ShareFBIcon.png","ShareIGIcon.png","ShareLineIcon.png","ShareMessangerIcon.png","ShareWhatsappIcon.png","ShareCopyLinkIcon.png","ShareEmailIcon.png"]
            arrTitles   = ["Facebook","Instagram","LINE","Messenger","Whatsapp","Copy Link","Email"]
            arrIndex = [0,1,2,3,4,5,6]
        }
        else
        {
            arrImages = ["ShareFBIcon.png","ShareLineIcon.png","ShareMessangerIcon.png","ShareWhatsappIcon.png","ShareCopyLinkIcon.png","ShareEmailIcon.png"]
            arrTitles = ["Facebook","LINE","Messenger","Whatsapp","Copy Link","Email"]
            arrIndex = [0,2,3,4,5,6]

        }
      
    }
    
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK: - CollectionView Delegate
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrImages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell:ShareV2CollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("ShareV2CollectionViewCell", forIndexPath: indexPath) as! ShareV2CollectionViewCell

        cell.ibImageView.image = UIImage(named: arrImages[indexPath.row])
        cell.lblTitle.text = arrTitles[indexPath.row];
        
        return cell
    }
    func collectionView(collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize
    {
        
        let cellDefaultWidth:CGFloat = 100
        let cellDefaultHeight:CGFloat = 110

        let screenFrame:CGRect = Utils.getDeviceScreenSize()
        let cellWidth:CGFloat = ((screenFrame.size.width/3) - 15)
        let cellSize = CGSizeMake(cellWidth,cellDefaultWidth/cellWidth*cellDefaultHeight)
        return cellSize
    }
    
    func initShareFrenView()
    {
        if(self.shareType == ShareTypePostUser){
            self.ShareFrenView.hidden = true
        }
    }
    
    func initCollectionView()
    {
       //ibCollectionView.delegate = self;
        //self.ibCollectionView.dataSource = self;
        self.ibCollectionView.registerNib(UINib(nibName: "ShareV2CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ShareV2CollectionViewCell")
    }
    
    func share(message:String,title:String, imagURL:String, shareType:ShareType, shareID:String, userID:String)
    {
        self.postMessage = message
        self.postTitle = title
        self.imageURL = imagURL
        self.shareType = shareType
        self.shareID = shareID
        self.userID = userID;
        self.viewController = self;
        
    }
    
    func share(message:String,title:String, imagURL:String, shareType:ShareType, shareID:String, userID:String, postID:String)
    {
        self.postMessage = message
        self.postTitle = title
        self.imageURL = imagURL
        self.shareType = shareType
        self.shareID = shareID
        self.userID = userID;
        self.viewController = self;
        self.postID = postID;
        
    }

    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        
        let index = indexPath.row
        
        switch (arrIndex[index])
        {
            case 0: shareFacebook()
            case 1: shareInstagram()
            case 2: shareLine()
            case 3: shareMessanger()
            case 4: shareWhatsapp()
            case 5: shareCopyLink()
            case 6: shareEmail()

            default: break
        }
    }
    
    func shareFacebook()
    {
       // shareManager?.shareFacebook(self.postTitle, message: self.postMessage, shareType: ShareTypeFacebookPost, userID: self.userID, delegate: self)
        shareManager?.shareFacebook(self.postTitle, message: self.postMessage, imageURL: self.imageURL, shareType: self.shareType!, shareID: self.shareID,postID:self.postID, delegate: viewController)
        //param.link = NSURL(string:postURL as String)
    }
    
    func shareInstagram()
    {
        shareManager?.shareOnInstagram(self.imageURL, delegate: viewController)
    }
    
    func shareLine()
    {
        shareManager?.shareOnLINE(self.postTitle, message: self.postMessage, imageURL: self.imageURL, shareType: self.shareType!, shareID: self.shareID,postID:self.postID, delegate: viewController)
    }
    
    func shareMessanger()
    {
        shareManager?.shareOnMessanger(self.postTitle, message: self.postMessage, imageURL: self.imageURL, shareType: self.shareType!, shareID:self.shareID,postID:self.postID, delegate: viewController);
    }
    
    func shareWhatsapp()
    {
        shareManager?.shareOnWhatsapp(self.postTitle, message: self.postMessage, imageURL: self.imageURL, shareType: self.shareType!, shareID: self.shareID,postID:self.postID, delegate: viewController)
    }
    
    func shareCopyLink()
    {
        shareManager?.shareWithCopyLink(self.shareType!, shareID: self.shareID,postID:self.postID, delegate: viewController)
    
    }
    
    func shareEmail()
    {
        shareManager?.shareOnEmail(self.shareType!, viewController: self.viewController,shareID: self.shareID,  postID:self.postID)
    }

}


