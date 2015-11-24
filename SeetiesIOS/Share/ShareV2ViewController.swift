//
//  ShareV2ViewController.swift
//  SeetiesIOS
//
//  Created by Evan Beh on 11/24/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

import UIKit

class ShareV2ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate{
    @IBOutlet weak var ibCollectionView: UICollectionView!
    
    var shareToFrenVC = ShareToFrenViewController()
    var Images = Array<String>()
    var Titles = Array<String>()
    
    var postID: NSString = ""
    var postMessage: NSString = ""
    var postTitle: NSString = ""
    var imageURL: NSString = ""

    // MARK: - IBACTION

    @IBAction func btnShareToFriendClicked(sender: AnyObject) {
        
        self.navigationController!.pushViewController(shareToFrenVC, animated: true)
    }
    
    @IBAction func btnBackClicked(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSelfView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initSelfView()
    {
        initCollectionView()
        Images = ["ShareFBIcon.png","ShareIGIcon.png","ShareLineIcon.png","ShareMessangerIcon.png","ShareWhatsappIcon.png","ShareCopyLinkIcon.png","ShareEmailIcon.png"]
        Titles = ["Facebook","Instagram","LINE","Messenger","Whatsapp","Copy Link","Email"]
    }
    

  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return Images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell:ShareV2CollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("ShareV2CollectionViewCell", forIndexPath: indexPath) as! ShareV2CollectionViewCell

        cell.ibImageView.image = UIImage(named: Images[indexPath.row])
        cell.lblTitle.text = Titles[indexPath.row];
        
        return cell
    }
    
    func initCollectionView()
    {
        ibCollectionView.delegate = self;
        ibCollectionView.dataSource = self;
        ibCollectionView!.registerNib(UINib(nibName: "ShareV2CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ShareV2CollectionViewCell")
    }
    
    internal func share(postID:NSString, message:NSString,title:NSString, imagURL:NSString)
    {
        self.postID = postID
        self.postMessage = message
        self.postTitle = title
        self.imageURL = imagURL
    
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        switch (indexPath.row)
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
    
    }
    
    func shareInstagram()
    {
    
    }
    
    func shareLine()
    {
    
    }
    
    func shareMessanger()
    {
    
    }
    
    func shareWhatsapp()
    {
    
    }
    
    func shareCopyLink()
    {
    
    }
    
    func shareEmail()
    {
        
    }

}


