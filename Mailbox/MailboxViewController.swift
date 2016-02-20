//
//  MailboxViewController.swift
//  Mailbox
//
//  Created by Madelyn Lee on 2/18/16.
//  Copyright © 2016 Madelyn Lee. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var deleteIcon: UIImageView!
    @IBOutlet weak var laterIcon: UIImageView!
    @IBOutlet weak var archiveIcon: UIImageView!
    @IBOutlet weak var listIcon: UIImageView!
    @IBOutlet weak var message: UIImageView!
    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var rescheduleImage: UIImageView!
    
    
    var messageOriginalCenter: CGPoint!
    var messageOffset: CGFloat!
    var messageLeft: CGPoint!
    var messageRight: CGPoint!
    
    var grey = UIColor(hue: 225/355, saturation: 2/100, brightness: 90/100, alpha: 1)
    var green = UIColor(hue: 105/355, saturation: 100/100, brightness: 80/100, alpha: 1)
    var red = UIColor(hue: 1, saturation: 1, brightness: 1, alpha: 1)
    var yellow = UIColor(hue: 50/355, saturation: 1, brightness: 1, alpha: 1)
    var brown = UIColor(hue: 35/355, saturation: 15/100, brightness: 65/100, alpha: 1)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        messageOffset = 320
        messageLeft = CGPoint(x: message.center.x - messageOffset ,y: message.center.y)
        messageRight = CGPoint(x: message.center.x + messageOffset ,y: message.center.y)
        
        
        scrollView.contentSize = CGSize(width: 320, height: 1430)
        scrollView.frame.size = CGSize(width: 320, height: 568)
        
        
        archiveIcon.hidden = true
        laterIcon.hidden = true
        deleteIcon.hidden = true
        listIcon.hidden = true
        rescheduleImage.hidden = true
        archiveIcon.alpha = 0
        laterIcon.alpha = 0
        deleteIcon.alpha = 0
        listIcon.alpha = 0
        rescheduleImage.alpha = 0


        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "didPanMessage:")
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "scheduleDidTap:")
        
        messageView.userInteractionEnabled = true
        messageView.addGestureRecognizer(panGestureRecognizer)
        
        rescheduleImage.userInteractionEnabled = true
        rescheduleImage.addGestureRecognizer(tapGestureRecognizer)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    @IBAction func didPanMessage(sender: UIPanGestureRecognizer) {
      
        let translation = (sender.translationInView(view))
        
        message.frame.origin.x = translation.x
      
        
        
        if sender.state == UIGestureRecognizerState.Began {
            
            messageOriginalCenter = message.center
            
            archiveIcon.hidden = true
            laterIcon.hidden = true
            deleteIcon.hidden = true
            listIcon.hidden = true
            archiveIcon.alpha = 0
            laterIcon.alpha = 0
            deleteIcon.alpha = 0
            listIcon.alpha = 0
           
    
        } else if sender.state == UIGestureRecognizerState.Changed {
            
            message.center = CGPoint(x: messageOriginalCenter.x + translation.x, y: messageOriginalCenter.y)

            if translation.x > 60{
                messageView.backgroundColor = green
                archiveIcon.alpha = 1
                archiveIcon.hidden = false
                deleteIcon.alpha = 0
                archiveIcon.center = CGPoint(x: messageOriginalCenter.x + translation.x - 190, y: messageOriginalCenter.y)
            
                if translation.x > 260{
                    messageView.backgroundColor = red
                    archiveIcon.alpha = 0
                    deleteIcon.alpha = 1
                    deleteIcon.hidden = false
                    deleteIcon.center = CGPoint(x: messageOriginalCenter.x + translation.x - 190, y: messageOriginalCenter.y)
                }
            } else if translation.x < -60{
                messageView.backgroundColor = yellow
                archiveIcon.alpha = 0
                laterIcon.alpha = 1
                laterIcon.hidden = false
                laterIcon.center = CGPoint(x: messageOriginalCenter.x + translation.x + 190, y: messageOriginalCenter.y)
                
                if translation.x < -260{
                    messageView.backgroundColor = brown
                    laterIcon.alpha = 0
                    listIcon.alpha = 1
                    listIcon.hidden = false
                    listIcon.center = CGPoint(x: messageOriginalCenter.x + translation.x + 190, y: messageOriginalCenter.y)
                }
                
            } else {
                messageView.backgroundColor = grey

                
            }
            
            
        } else if sender.state == UIGestureRecognizerState.Ended {

            if translation.x > 260 {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.message.center = self.messageRight
                    self.deleteIcon.center = CGPoint(x: self.message.center.x - 190, y: self.message.center.y)
                })
                
                delay(0.3, closure: { () -> () in
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.messageView.frame.size.height = 0
                        self.feedImage.transform = CGAffineTransformMakeTranslation(0, -86)
                    })
                })
            } else if translation.x > 60 {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.message.center = self.messageRight
                    self.archiveIcon.center = CGPoint(x: self.message.center.x - 190, y: self.message.center.y)
                })
                delay(0.3, closure: { () -> () in
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.messageView.frame.size.height = 0
                        self.feedImage.transform = CGAffineTransformMakeTranslation(0, -86)
                    })
                })
            } else if translation.x < -260 {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.message.center = self.messageLeft
//                    self.rescheduleImage.alpha = 1
                })
            } else if translation.x < -60 {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.message.center = self.messageLeft
                    self.rescheduleImage.alpha = 1
                    self.rescheduleImage.hidden = false
                })
            } else {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.message.center = self.messageOriginalCenter
                })
            }
            
            
        }
    }
    
    


    @IBAction func scheduleDidTap(sender: UITapGestureRecognizer) {

        listIcon.hidden = true
        laterIcon.hidden = true
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.rescheduleImage.alpha = 0
            self.rescheduleImage.hidden = true
            self.messageView.frame.size.height = 0
            self.feedImage.transform = CGAffineTransformMakeTranslation(0, -86)
        })
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
