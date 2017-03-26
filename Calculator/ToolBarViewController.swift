//
//  ToolBarViewController.swift
//  Calculator
//
//  Created by 杜晨光 on 16/3/6.
//  Copyright © 2016年 杜晨光. All rights reserved.
//

import UIKit

public protocol ToolBarViewControllerDelegate{
    func FuShu()
    func doFinish()
    func nextEidt()
    func backEidt()
    func divide()
}


class ToolBarViewController: UIViewController {
    
    internal var delegate:ToolBarViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    internal init(){
        let resourcesBundle = NSBundle(forClass: ToolBarViewController.self)
        super.init(nibName: "ToolBarViewController", bundle: resourcesBundle)
        
    }
    
    internal func showInView(superview : UIView) {
        
        if self.view.superview == nil {
            superview.addSubview(self.view)
        }
        
        self.view.center = CGPointMake(self.view.center.x, 900)
        self.view.frame = CGRectMake(self.view.frame.origin.x , self.view.frame.origin.y , superview.frame.size.width, self.view.frame.size.height)
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            self.view.center =  CGPointMake(superview.center.x,superview.frame.size.height-236)
//            superview.frame.size.height*0.65
            }, completion: nil)
    }
    
    
    internal func hideInView() {
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.view.center =  CGPointMake(self.view.center.x, 900)
            }, completion: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func BianHao(sender: AnyObject) {
        self.delegate?.FuShu()
    }

    @IBAction func Finish(sender: AnyObject) {
        self.delegate?.doFinish()
        hideInView()
    }
    @IBAction func Back(sender: AnyObject) {
        self.delegate?.backEidt()
    }
    @IBAction func Next(sender: AnyObject) {
        self.delegate?.nextEidt()
    }
    @IBAction func Divide(sender: AnyObject) {
        self.delegate?.divide()
    }


}
