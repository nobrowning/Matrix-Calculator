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
        let resourcesBundle = Bundle(for: ToolBarViewController.self)
        super.init(nibName: "ToolBarViewController", bundle: resourcesBundle)
        
    }
    
    internal func showInView(_ superview : UIView) {
        
        if self.view.superview == nil {
            superview.addSubview(self.view)
        }
        
        self.view.center = CGPoint(x: self.view.center.x, y: 900)
        self.view.frame = CGRect(x: self.view.frame.origin.x , y: self.view.frame.origin.y , width: superview.frame.size.width, height: self.view.frame.size.height)
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
            
            self.view.center =  CGPoint(x: superview.center.x,y: superview.frame.size.height-236)
//            superview.frame.size.height*0.65
            }, completion: nil)
    }
    
    
    internal func hideInView() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
            self.view.center =  CGPoint(x: self.view.center.x, y: 900)
            }, completion: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func BianHao(_ sender: AnyObject) {
        self.delegate?.FuShu()
    }

    @IBAction func Finish(_ sender: AnyObject) {
        self.delegate?.doFinish()
        hideInView()
    }
    @IBAction func Back(_ sender: AnyObject) {
        self.delegate?.backEidt()
    }
    @IBAction func Next(_ sender: AnyObject) {
        self.delegate?.nextEidt()
    }
    @IBAction func Divide(_ sender: AnyObject) {
        self.delegate?.divide()
    }


}
