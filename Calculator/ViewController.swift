//
//  ViewController.swift
//  Calculator
//
//  Created by 杜晨光 on 16/2/24.
//  Copyright © 2016年 杜晨光. All rights reserved.
//

import UIKit
import PopControl

class ViewController: UIViewController,MyPickerViewControllerDelegate,DoubleViewControllerDelegate{
    var pickerViewController = MyPickerViewController()
    var doubleViewController = DoubleViewController()
    var Hang:Int!
    var Lie:Int!
    var MutiplyNumber:Int = 0
    
    var JZ = Array<Array<UITextField>>()
    //var a = UIView(frame: CGRectMake(30,100,200,200))
    var a = [UIView]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerViewController.delegate = self
        self.doubleViewController.delegate2 = self
}

    @IBAction func Claer(sender: AnyObject) {
        for (var i = a.count-1;i>=0; i--){
            a[i].removeFromSuperview()
            for view in a[i].subviews{
                view.removeFromSuperview()
            }
        }
        MutiplyNumber = 0
        JZ.removeAll()
        
    }
    @IBAction func Add(sender: AnyObject) {
        self.doubleViewController.showInView(self.view)
        MutiplyNumber += 1
    }
    @IBAction func Mutiplay(sender: AnyObject) {
        if(MutiplyNumber == 1){
            self.pickerViewController.showInView(self.view)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func doublePickViewClose(selected: Int, selected2: Int) {
        Hang = selected + 1
        Lie = selected2 + 1
        var someInts = Array<UITextField>()
        a.append(UIView(frame: CGRectMake(10,50,100,100)))
        for(var i = 0;i < Hang;i++){
            for(var j = 0;j < Lie;j++){
                someInts.append(UITextField(frame: CGRectMake(CGFloat(35*j),CGFloat(35*i),30,30)))
                someInts[someInts.count-1].borderStyle = UITextBorderStyle.RoundedRect
                a[a.count-1].addSubview(someInts[someInts.count-1])
            }
        }
        
        self.view.addSubview(a[a.count-1])
        someInts.append(UITextField(frame: CGRectMake(CGFloat(Hang),CGFloat(Lie),0,0)))
        JZ.append(someInts)
    }
    func myPickViewClose(selected: Int) {
        let HighNumber = Hang
        Hang = Lie
        Lie = selected + 1
        MutiplyNumber += 1
        var someInts = Array<UITextField>()
        
        if(Hang+Lie > 9){
            let High = a[a.count-1].frame.height + CGFloat(HighNumber * 30 )
            
            
            
            a.append(UIView(frame: CGRectMake(10,High,100,100)))
            for(var i = 0;i < Hang;i++){
                for(var j = 0;j < Lie;j++){
                    someInts.append(UITextField(frame: CGRectMake(CGFloat(35*j),CGFloat(35*i),30,30)))
                    someInts[someInts.count-1].borderStyle = UITextBorderStyle.RoundedRect
                    a[a.count-1].addSubview(someInts[someInts.count-1])
                }
            }
            self.view.addSubview(a[a.count-1])
            someInts.append(UITextField(frame: CGRectMake(CGFloat(Hang),CGFloat(Lie),0,0)))
            JZ.append(someInts)
        }else{
            let wide = Hang!*30 + (Hang!-1)*5 + 60
            a.append(UIView(frame: CGRectMake(CGFloat(wide),50,100,100)))
            for(var i = 0;i < Hang;i++){
                for(var j = 0;j < Lie;j++){
                    someInts.append(UITextField(frame: CGRectMake(CGFloat(35*j),CGFloat(35*i),30,30)))
                    someInts[someInts.count-1].borderStyle = UITextBorderStyle.RoundedRect
                    a[a.count-1].addSubview(someInts[someInts.count-1])
                }
            }
            self.view.addSubview(a[a.count-1])
            someInts.append(UITextField(frame: CGRectMake(CGFloat(Hang),CGFloat(Lie),0,0)))
            JZ.append(someInts)
            
        }
        
    }
    @IBAction func EqualButton(sender: AnyObject) {
    }

}

