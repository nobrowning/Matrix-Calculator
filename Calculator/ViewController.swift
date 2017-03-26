//
//  ViewController.swift
//  Calculator
//
//  Created by 杜晨光 on 16/2/24.
//  Copyright © 2016年 杜晨光. All rights reserved.
//

import UIKit

class ViewController: UIViewController,MyPickerViewControllerDelegate,DoubleViewControllerDelegate,UITextFieldDelegate,ToolBarViewControllerDelegate{
    var pickerViewController = MyPickerViewController() //创建了一个滚轮类，在做乘法计算的时候弹出的滚轮视图进行处理和控制，由于是乘法，只需提供列数
    var doubleViewController = DoubleViewController() //同上，也是滚轮类，这个为初始时，新建第一个矩阵时用到的，需要提供行数和列数
    var toolBar = ToolBarViewController()           //新建键盘顶部工具栏的类
    var Hang:Int!                                                    //初始化矩阵时用到的行数和列数
    var Lie:Int!
    var HighNumber=0                                             // 这个单词为记录乘法时第一个矩阵的行数
    var ToolBarNumber:Bool = false                               //判断屏幕上是否已存在ToolBar的变量。false表示屏幕当前无工具栏
    var touchFunc:Bool = false                                   //这个变量控制touchesBegan方法，该方法使用户点击空白处可结束输入false表示屏幕上目前没有键盘，不需要执行touchesBegan方法
    var i = 0                                                 //判断键盘输入是在第一个矩阵还是第二个矩阵的变量0为第一个，1位第二个
    var Scale:Float!                                            //用于布局控制屏幕上空间缩放比例的变量
    var Scale2:Float!                                           //同上，这个两个变量一个控制长度缩放，一个控制宽度缩放
    
    var JZ = Array<Array<UITextField>>()                           //数据结构为以TextField数组为元素的二维数组，起名为JZ（矩阵）
    var a = [UIView]()                                             //每个矩阵存放在一个新的UIView中，a为UIView的数组
    var addButton:UIButton!//开始按钮
    var multiplyButton:UIButton!//乘法按钮
    var clearButton:UIButton!//清除按钮
    var hanglieButton:UIButton!//计算行列式的按钮
    var rankButton:UIButton!//计算秩的按钮
    var oppositeButton:UIButton!//计算逆矩阵的按钮
    var DoMutiplyButton:UIButton!//计算乘法是的处理按钮
    var returnButton:UIButton!//返回按钮
    func setButton(button:UIButton,label:String,funcs:String){//此方法用于初始化App中所有的按钮
        button.setTitle(label, forState: UIControlState.Normal) //设置按钮上的文字
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)//设置按钮正常状态是的颜色
        button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)//设置按钮被点击时的颜色
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(CGFloat(16*Scale))//设置按钮上文字的字体大小
        button.layer.borderColor = UIColor.whiteColor().CGColor//设置按钮边框颜色
        button.layer.borderWidth = CGFloat(1.5*Scale)//设置按钮边框宽度
        button.layer.cornerRadius = CGFloat(10*Scale)//设置按钮边框圆角的弧度
        self.view.addSubview(button)//将按钮添加到屏幕上
        button.addTarget(self, action: Selector(funcs), forControlEvents: UIControlEvents.TouchUpInside)//为按钮添加处理事件的方法

    }
    
    func setLayout(){//此方法用于设置Sacle和Scale2这两个控制屏幕布局的值
        let DeviceHeight = UIScreen.mainScreen().bounds.height//获取当前设备的屏幕的的高度，通过不同的高度判断不同的设备
        if(DeviceHeight==568){//iPhone5/5s的情况
            Scale = 568/667
            Scale2 = 568/667
        }else if(DeviceHeight == 667){//iPhone6/6s的情况(由于此程序原本都是按照iPhone6的屏幕进行设计的，所以这里设缩放的变量都是1)
            Scale = 1.0
            Scale2 = 1.0
        }else if(DeviceHeight == 736){//iPhone6p／6sp的情况
            Scale = 736/667
            Scale2 = 736/667
        }else{//iPhone4s的情况，注意iPhone4s屏幕比例为3:2最为特殊，因此Scale和Scale2的值是不一样的，也就是说在长和宽方向上的缩放比例不同。其他设备都是16:9的，所以Scale和Scale2的值一样。这里也可以看出，Scale2这个值其实就是专门为iPhone4s设置的
            Scale2 = 480/667
            Scale = 568/667
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        NSThread.sleepForTimeInterval(1)//使启动界面停留1秒
        //以下这一段用来初始化屏幕中所有的按钮，除了开始按钮以外，其他按钮初始时都在屏幕外下方
        addButton = UIButton(frame: CGRectMake(0,0,CGFloat(130*Scale),CGFloat(130*Scale)))
        multiplyButton = UIButton(frame: CGRectMake(CGFloat(158*Scale),900,CGFloat(60*Scale),CGFloat(35*Scale)))
        clearButton = UIButton(frame: CGRectMake(CGFloat(158*Scale),900,CGFloat(60*Scale),CGFloat(35*Scale)))
        hanglieButton = UIButton(frame: CGRectMake(CGFloat(158*Scale),900,CGFloat(60*Scale),CGFloat(35*Scale)))
        rankButton = UIButton(frame: CGRectMake(CGFloat(158*Scale),900,CGFloat(60*Scale),CGFloat(35*Scale)))
        oppositeButton = UIButton(frame: CGRectMake(CGFloat(158*Scale),900,CGFloat(60*Scale),CGFloat(35*Scale)))
        DoMutiplyButton = UIButton(frame: CGRectMake(CGFloat(158*Scale),900,CGFloat(60*Scale),CGFloat(35*Scale)))
        returnButton = UIButton(frame: CGRectMake(CGFloat(158*Scale),900,CGFloat(60*Scale),CGFloat(35*Scale)))
        //以下这段用来设置按钮的各种属性，此时也为各个按钮连接上了各自的事件处理方法
        setButton(addButton, label: "开始", funcs: "Add")
        setButton(multiplyButton, label: "乘", funcs: "Mutiplay")
        setButton(clearButton, label: "清除", funcs: "Claer")
        setButton(hanglieButton, label: "行列式", funcs: "HangLieFunc")
        setButton(rankButton, label: "秩", funcs: "Rank")
        setButton(oppositeButton, label: "逆矩阵", funcs: "Opposite")
        setButton(DoMutiplyButton, label: "计算", funcs: "DoMutiply")
        setButton(returnButton, label: "返回", funcs: "returnFunc")
        //下面的三段单独设置开始按钮的位置，字体大小和边框圆角弧度
        addButton.center = self.view.center//将开始按钮设置在屏幕的正中间
        addButton.titleLabel?.font = UIFont.boldSystemFontOfSize(CGFloat(30*Scale))
        addButton.layer.cornerRadius = CGFloat(65*Scale)//因为要求开始按钮为圆形，因此次按钮的边框弧度为边框长度(或者宽度)的一半
        
        
        self.pickerViewController.delegate = self                 //对算乘法时第二个矩阵的列数选择pickerview的托管
        self.doubleViewController.delegate2 = self                //对第一个矩阵初始化时行数与列数pickerview的托管
        self.toolBar.delegate = self                              //对键盘上方工具栏的托管
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"iPhone 6")!)
        _ = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(ViewController.addButtonAnimate), userInfo: nil, repeats: true)                                       //新建一个计时器，每三秒钟动一次，它来提示addButtonAnimate方法运行，来使开始按钮实现跳动效果
    }

    func addButtonAnimate(){//此方法使开始按钮实现跳动(放大和缩小)
        UIView.animateWithDuration(0.2, delay: 0,options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.addButton.transform = CGAffineTransformScale(self.addButton.transform, 1.25, 1.25)
            }, completion:{(finished)-> Void in
                UIView.animateWithDuration(0.2, delay: 0,options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    self.addButton.transform = CGAffineTransformScale(self.addButton.transform, 0.8, 0.8)
                    }, completion:nil)
    })
    }
    func Claer() {                   //清除按钮

        for (var i = a.count-1;i>=0; i -= 1){
            
            for view in a[i].subviews{                          //将存放UITextField的子试图中所有的UITextField移除
                view.removeFromSuperview()
            }
            a[i].removeFromSuperview()                          //将存放UITextField的子视图从上级的UIView中移除

        }
        ToolBarNumber = false                                   //使所有变量都回到初始时状态
        Hang = 0
        touchFunc = false
        Lie = 0
        HighNumber = 0
        i = 0
        a.removeAll()                                           //清空存放视图的数组
        JZ.removeAll()                                          //清空存放矩阵的二维数组
        addButton.enabled = true
        
        //下面这段动画使所有的按钮回归到最初刚打开App时的位置和状态
        UIView.animateWithDuration(1, delay: 0,options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.addButton.alpha = 1
            self.multiplyButton.center.y = 900
            self.clearButton.center.y = 900
            self.hanglieButton.center.y = 900
            self.rankButton.center.y = 900
            self.oppositeButton.center.y = 900
            self.DoMutiplyButton.center.y = 900
            self.returnButton.center.y = 900
            self.multiplyButton.center.x = UIScreen.mainScreen().bounds.width/2
            self.clearButton.center.x = UIScreen.mainScreen().bounds.width/2
            self.hanglieButton.center.x = UIScreen.mainScreen().bounds.width/2
            self.rankButton.center.x = UIScreen.mainScreen().bounds.width/2
            self.oppositeButton.center.x = UIScreen.mainScreen().bounds.width/2
            self.DoMutiplyButton.center.x = UIScreen.mainScreen().bounds.width/2
            self.returnButton.center.x = UIScreen.mainScreen().bounds.width/2
            }, completion:nil)
        addButton.alpha = 1
        multiplyButton.enabled = true
        hanglieButton.enabled = true
        rankButton.enabled = true
        oppositeButton.enabled = true
        DoMutiplyButton.enabled = true
    }
    func Add(){//点击开始按钮时触发的事件
        self.doubleViewController.showInView(self.view)//打开行数列数的选择器
        UIView.animateWithDuration(1, delay: 0.5,options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.addButton.alpha = 0            //使开始按钮透透明度为0，淡出
            }, completion:nil)
        addButton.enabled = false               //禁用开始按钮，使其点击时无任何反应(因为按钮透明度为0时依然存在，依然可以被点击到)
    }
    func doubleCancles(){   //行数列数选择器的取消按钮的触发事件，此方法为实现了doublePickerView接口的虚方法
        UIView.animateWithDuration(1, delay: 0,options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.addButton.alpha = 1
            }, completion:nil)
        addButton.enabled = true
        
        }
    
    func Mutiplay() {//点击“乘”这个按钮以后触发的事件
        multiplyButton.enabled = false
        self.pickerViewController.showInView(self.view)//使列数选择器出现屏幕上
    }
    func singleCancle(){//列数选择器的取消按钮触发事件
        multiplyButton.enabled = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func doublePickViewClose(selected: Int, selected2: Int) {   //新建第一个矩阵，选择行数与列数

        Hang = selected + 1                                     //因为selected是从0开始计数的，所以要＋1
        Lie = selected2 + 1
        var someInts = Array<UITextField>()                     //局部变量，此数组临时存放一个矩阵中所有的TextField
        a.append(UIView(frame: CGRectMake(CGFloat(10.0*Scale),CGFloat(20.0*Scale2),CGFloat(Scale*Float(55*Lie)),CGFloat(Float(55*Hang)*Scale2))))      //新增一个UIView放到a数组中，此UIView用于盛放同一矩阵中所有的TextField
        for _ in 0...Hang{//用循环建立一个Hang个行，Lie个列的TextField矩阵
            for _ in 0...Lie{
                let newTextField = UITextField(frame: CGRectMake(0,0,0,0))
                newTextField.borderStyle = UITextBorderStyle.RoundedRect//设置TextField为圆角矩形的
                newTextField.adjustsFontSizeToFitWidth=true
                newTextField.textAlignment = .Center //水平居中对齐
                newTextField.placeholder = "0"
                newTextField.alpha = 0.7
                newTextField.keyboardType = UIKeyboardType.DecimalPad
                newTextField.delegate = self
                someInts.append(newTextField)
                
                a[a.count-1].addSubview(someInts[someInts.count-1])   //将新建的TextField放入UIView容器中
            }
        }
        self.view.addSubview(a[a.count-1])
        a[a.count-1].alpha = 0          //初始透明度为0，用于一会儿的淡入动画
        JZ.append(someInts)             //将新建的矩阵存放到JZ这个数组中
        
        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in                                                   //设置动画淡入效果
            self.a[self.a.count-1].alpha = 1
            for(var i = 0;i < self.Hang;i++){
                for(var j = 0;j < self.Lie;j++){
                    someInts[i*self.Lie+j].frame = CGRectMake(CGFloat(Float(55*j)*self.Scale),CGFloat(Float(55*i)*self.Scale2),CGFloat(50.0*self.Scale),CGFloat(50.0*self.Scale2))
                }
            }
            }, completion: nil)
        JZ[0][0].becomeFirstResponder()         //设置屏幕上第一行第一列的文本框为键盘第一响应者，调出键盘
        touchFunc = true                        //因为上一步已经调用出了键盘，所以这时设置那个点击空白处关闭键盘的方法有效
    }
    func myPickViewClose(selected: Int) {//新建第二个矩阵，选择列数
        HighNumber = Hang
        Hang = Lie
        Lie = selected + 1
        var someInts = Array<UITextField>()
        
        if(Hang+Lie > 6){                                   //如果两个矩阵的列数大于6，则第二个矩阵换行显示
            let High = CGFloat(Float(HighNumber * 55+50)*Scale2 )
            
            a.append(UIView(frame: CGRectMake(CGFloat(10.0*Scale),High,CGFloat(Scale*Float(55*Lie)),CGFloat(Float(55*Hang)*Scale2))))
        }else{
            let wide = Float(Hang!*55 + 40)*Scale
            a.append(UIView(frame: CGRectMake(CGFloat(wide),CGFloat(20.0*Scale2),CGFloat(Float(55*Lie)*Scale),CGFloat(Float(55*Hang)*Scale2))))
        }
            for(var i = 0;i < Hang;i++){
                for(var j = 0;j < Lie;j++){
                    let newTextField = UITextField(frame: CGRectMake(CGFloat(Scale*Float(55*j)),CGFloat(Scale2*Float(55*i)),0,0))
                    newTextField.borderStyle = UITextBorderStyle.RoundedRect
                    newTextField.adjustsFontSizeToFitWidth = true
                    newTextField.minimumFontSize = 0.3
                    newTextField.keyboardType = UIKeyboardType.DecimalPad
                    newTextField.textAlignment = .Center
                    newTextField.placeholder = "0"
                    newTextField.alpha = 0.7
                    newTextField.delegate = self
                    someInts.append(newTextField)
                    a[a.count-1].addSubview(someInts[someInts.count-1])
                }
            }
            a[a.count-1].alpha = 0
            self.view.addSubview(a[a.count-1])
            self.view.sendSubviewToBack(a[a.count-1]) //设置第二个矩阵的视图位于最底层，这样防止其遮挡键盘上方的工具栏
            JZ.append(someInts)
            
            UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in                                                   //设置动画淡入效果
                self.a[self.a.count-1].alpha = 1
                for(var i = 0;i < self.Hang;i++){
                    for(var j = 0;j < self.Lie;j++){
                        someInts[i*self.Lie+j].frame = CGRectMake(CGFloat(Float(55*j)*self.Scale),CGFloat(Float(55*i)*self.Scale2),CGFloat(50.0*self.Scale),CGFloat(50.0*self.Scale2))
                    }
                }
                }, completion: nil)

        JZ[1][0].becomeFirstResponder()
        touchFunc = true
    }
    func HangLieFunc() {//"行列式"按钮的事件处理方法
        hanglieButton.enabled = false
        let HangLieShi = HangLieShiClass(newMatrix: JZ[0], Hang: Hang)
        let res = HangLieShi.showResult()
        showLabel("行列式＝", Value: res.toString())
    }
    func showLabel(text:String,Value:String){//显示行列式结果和秩结果Label的方法
        a.append(UIView(frame: CGRectMake(CGFloat(10*Scale),CGFloat(50*Scale2),CGFloat(100*Scale),CGFloat(100*Scale2))))
        let someInts = UILabel(frame: CGRectMake(0,0,0,0))
        someInts.font = UIFont.boldSystemFontOfSize(CGFloat(40*Scale2))
        someInts.alpha = 0
        someInts.textColor = UIColor.whiteColor()
        someInts.adjustsFontSizeToFitWidth = true
        
        a[a.count-1].addSubview(someInts)
        self.view.addSubview(a[a.count-1])
        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in                                                 //设置运算结果出现的动画
            someInts.alpha = 0.8
            someInts.frame = CGRectMake(0,CGFloat(Float(55*self.Hang)*self.Scale2), CGFloat(300*self.Scale), CGFloat(60*self.Scale2))
            }, completion: nil)
        UIView.animateWithDuration(1, delay: 0.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.multiplyButton.center.y = 900
            self.hanglieButton.center.y = 900
            self.oppositeButton.center.y = 900
            self.rankButton.center.y = 900
            self.returnButton.center.y = CGFloat(630*self.Scale2)
            self.returnButton.center.x = CGFloat(281*self.Scale)
            self.clearButton.center.x = CGFloat(94*self.Scale)
            }, completion: nil)
        
        someInts.text = text+Value
        touchFunc = false

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //注册键盘出现通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        //注册键盘隐藏通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //解除键盘出现通知
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        //解除键盘隐藏通知
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
    }
    
    func keyboardDidShow(notification: NSNotification) {                //键盘打开
        
        if(ToolBarNumber == false){
            self.toolBar.showInView(self.view)
            ToolBarNumber = true
            var j:Int
            for(i=0;i<JZ.count;self.i++){
                for (j = 0;j<JZ[i].count;j++){
                    if (JZ[i][j].editing == true){
                        break
                    }
                }
                if(j != JZ[i].count){
                    break
                }
            }

            if(JZ.count==2 && a[0].frame.height+a[1].frame.height>UIScreen.mainScreen().bounds.height-236 && i == 1 && Hang+Lie>6){
                //let moveSize =
                UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in                                      //此动画将画面中所有的矩阵都移动到（30，30）的位置
                    for view in self.a{
                        view.frame = CGRectMake(view.frame.minX, view.frame.minY-self.a[1].frame.minY+20, view.frame.width, view.frame.height)
                    }
                    }, completion: nil)
            }
        }
    }
    
    func keyboardDidHide(notification: NSNotification) {               //键盘关闭
        if(JZ.count==2 && a[0].frame.height+a[1].frame.height>UIScreen.mainScreen().bounds.height-236 && i == 1 && Hang+Lie>6){
            let moveSize = CGFloat(20*Scale) - a[0].frame.minY
            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in                                      //此动画将画面中所有的矩阵都移动到（30，30）的位置
                for view in self.a{
                    view.frame = CGRectMake(view.frame.minX, view.frame.minY+moveSize, view.frame.width, view.frame.height)
                }
                }, completion: nil)
        }
    }
    func FuShu() {//键盘上方变号按钮的处理方法，其为实现了ToolBar接口的方法。将TextField上数字的正负变号
        for(var i = 0;i<JZ.count;i++){
            for UITextField in JZ[i]{
                if UITextField.editing == true{
                    let str = UITextField.text
                    if !str!.isEmpty{
                        var flag = false
                        for char in (str?.characters)!{
                            if char == "-"{
                                flag = true
                                break
                            }
                        }
                        if(!flag){
                            UITextField.text = "-\(UITextField.text!)"
                        }else{
                            
                            let a = FractionalClass.StringToFractional(UITextField.text!)
                            UITextField.text! = (-a).toString()
                        }
                    }else{
                        UITextField.text = "-0"
                    }
                }
            }
        }
    }
    
    func divide() {
        for(var i = 0;i<JZ.count;i++){
            for UITextField in JZ[i]{
                if UITextField.editing == true{
                    let str = UITextField.text
                    if !str!.isEmpty{
                        var flag = false
                        for char in (str?.characters)!{
                            if char == "/"{
                                flag = true
                                break
                            }
                        }
                        if(!flag){
                            UITextField.text = "\(UITextField.text!)/"
                        }
                    }
                }
            }
        }

    }
    func doFinish(){                    //键盘顶部工具栏完成按钮
        for(var i = 0;i<JZ.count;i++){
            for UITextField in JZ[i]{
                if UITextField.editing == true{
                    UITextField.resignFirstResponder()
                    ToolBarNumber = false
                    break
                }
            }
        }
        if(JZ.count == 1 && Hang == Lie){//此为用户输入一个矩阵，而且为方阵的情况
            UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.multiplyButton.center.y = CGFloat(630*self.Scale2)
                self.clearButton.center.y = CGFloat(630*self.Scale2)
                self.multiplyButton.center.x = CGFloat(94*self.Scale)
                self.clearButton.center.x = UIScreen.mainScreen().bounds.width/2//CGFloat(187.5*self.Scale)
                self.rankButton.center.x = CGFloat(281*self.Scale)
                self.rankButton.center.y = CGFloat(630*self.Scale2)
                }, completion: nil)
            UIView.animateWithDuration(1, delay: 0.3, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.hanglieButton.center.y = CGFloat(585*self.Scale2)
                self.hanglieButton.center.x = CGFloat(234*self.Scale)
                self.oppositeButton.center.x = CGFloat(141*self.Scale)
                self.oppositeButton.center.y = CGFloat(585*self.Scale2)
                }, completion: nil)

        }else if(JZ.count == 2){//此为用户输入两个矩阵后点击完成按钮的处理
            UIView.animateWithDuration(1, delay: 0.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.multiplyButton.center.y = 900
                self.hanglieButton.center.y = 900
                self.multiplyButton.center.x = CGFloat(94*self.Scale)
                self.clearButton.center.x = CGFloat(94*self.Scale)
                self.hanglieButton.center.x = CGFloat(281*self.Scale)
                self.DoMutiplyButton.center.x = UIScreen.mainScreen().bounds.width/2
                self.DoMutiplyButton.center.y = CGFloat(630*self.Scale2)
                self.rankButton.center.x = CGFloat(281*self.Scale)
                self.rankButton.center.y = 900
                self.oppositeButton.center.x = CGFloat(141*self.Scale)
                self.oppositeButton.center.y = 900
                self.returnButton.center.x = CGFloat(281*self.Scale)
                self.returnButton.center.y = CGFloat(630*self.Scale2)
                
                }, completion: nil)
        }else{//此为输入了一个矩阵，且不是方阵的情况
            UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.multiplyButton.center.y = CGFloat(630*self.Scale2)
                self.clearButton.center.y = CGFloat(630*self.Scale2)
                self.multiplyButton.center.x = CGFloat(94*self.Scale)
                self.clearButton.center.x = CGFloat(187.5*self.Scale)
                self.rankButton.center.x = CGFloat(281*self.Scale)
                self.rankButton.center.y = CGFloat(630*self.Scale2)
                }, completion: nil)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {//此方法是重写了TextFieldDelegate的方法，使用户点击键盘以外的区域可以关闭键盘
        if(touchFunc == true){
            self.toolBar.hideInView()
            doFinish()
        }else if(oppositeButton.enabled == false || rankButton.enabled == false || DoMutiplyButton.enabled == false){
            let width = UIScreen.mainScreen().bounds.width
            let a = Float(Float(width)/Float(Lie))-9.0
            let a1 = a+5.0
            var s = 1
            HighNumber = Hang
            if(DoMutiplyButton.enabled == false){
                s = 2
            }
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                for(var i = 0;i < self.HighNumber;i++){
                    for(var j = 0;j < self.Lie;j++){
                        self.JZ[s][i*self.Lie+j].frame = CGRectMake(CGFloat(a1*Float(j)*self.Scale),CGFloat(Float(55*i)*self.Scale2),CGFloat(a*self.Scale),CGFloat(50*self.Scale2))
                    }
                }
                }, completion:{ (finished)-> Void in
                    if(self.Lie>4){
                        for(var i = 0;i < self.HighNumber;i++){
                            for(var j = 0;j < self.Lie;j++){
                                self.JZ[s][i*self.Lie+j].font = UIFont.systemFontOfSize(CGFloat(14*self.Scale2))
                                    //÷.boldSystemFontOfSize(CGFloat(40*Scale2))
                            }
                        }
 
                    }
                })

            
        }
        
    }

    
    func nextEidt(){//键盘上方“下一项”按钮的实现方法
        for(var i = 0;i<JZ.count;i++){
            for (var j = 0;j<JZ[i].count;j++){
                if (JZ[i][j].editing == true && j+1<JZ[i].count){
                    JZ[i][j+1].becomeFirstResponder()
                    break
                }
            }
        }

    }
    func backEidt(){//键盘上方“上一项”按钮的实现方法
        for(var i = 0;i<JZ.count;i++){
            for (var j = 0;j<JZ[i].count;j++){
                if (JZ[i][j].editing == true && j-1>=0){
                    JZ[i][j-1].becomeFirstResponder()
                    break
                }
            }
        }
    }
    func Rank(){//按钮“秩”的实现方法
        rankButton.enabled = false
        a[0].alpha = 0
        let doRank = JZRankClass(newMatrix: JZ[0], Hang: Hang, Lie: Lie)
        let rankValue = doRank.rank_matrix()
        var resultMat = doRank.showResult()
        var someInts = Array<UITextField>()                     //局部变量，此数组临时存放一个矩阵中所有的TextField
        a.append(UIView(frame: CGRectMake(CGFloat(10*Scale),CGFloat(20*Scale2),CGFloat(Scale*Float(55*Lie)),CGFloat(Float(55*Hang)*Scale2))))      //新增一个UIView放到a数组中，此UIView用于盛放同一矩阵中所有的TextField
        for(var i = 0;i < Hang;i++){                            //用循环建立一个Hang个行，Lie个列的TextField矩阵
            for(var j = 0;j < Lie;j++){
                let newTextField = UITextField(frame: CGRectMake(CGFloat(Float(55*j)*self.Scale),CGFloat(Float(55*i)*self.Scale2),CGFloat(50.0*self.Scale),CGFloat(50.0*self.Scale2)))
                newTextField.borderStyle = UITextBorderStyle.RoundedRect//设置TextField为圆角矩形的
                newTextField.adjustsFontSizeToFitWidth=true
                newTextField.textAlignment = .Center //水平居中对齐
                newTextField.enabled = false
                newTextField.placeholder = "0"
                newTextField.alpha = 0.7
                newTextField.text = resultMat[i*Lie+j]
                
                someInts.append(newTextField)
                a[a.count-1].addSubview(someInts[someInts.count-1])   //将新建的TextField放入UIView容器中
            }
        }
        self.view.addSubview(a[a.count-1])
        JZ.append(someInts)
        playAnimation(someInts)
        showLabel("秩＝", Value: "\(rankValue)")
    }
    
    func Opposite(){//按钮“逆矩阵”的实现方法
        oppositeButton.enabled = false
        let HL = HangLieShiClass(newMatrix: JZ[0], Hang: Hang)
        if(HL.showResult().toString() == "0"){//如果行列式为0，则弹出警告，不进行计算
            let myAlert2 = UIAlertController(title: "警告", message: "行列式为0，不可计算", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction2 = UIAlertAction(title: "好的", style: .Default, handler: nil)
            myAlert2.addAction(okAction2)
            self.presentViewController(myAlert2, animated: true, completion: nil)
            oppositeButton.enabled = true
        }else{
            touchFunc = false
            a[0].alpha = 0
            let Oppo = NIJZClass(a: JZ[0], n: Hang)
            let res = Oppo.getNiJZ()
            
            var someInts = Array<UITextField>()                     //局部变量，此数组临时存放一个矩阵中所有的TextField
            a.append(UIView(frame: CGRectMake(CGFloat(10*Scale),CGFloat(20*Scale2),CGFloat(Scale*Float(55*Lie)),CGFloat(Float(55*Hang)*Scale2))))      //新增一个UIView放到a数组中，此UIView用于盛放同一矩阵中所有的TextField
            for(var i = 0;i < Hang;i++){                            //用循环建立一个Hang个行，Lie个列的TextField矩阵
                for(var j = 0;j < Lie;j++){
                    let newTextField = UITextField(frame: CGRectMake(CGFloat(Float(55*j)*self.Scale),CGFloat(Float(55*i)*self.Scale2),CGFloat(50.0*self.Scale),CGFloat(50.0*self.Scale2)))
                    newTextField.borderStyle = UITextBorderStyle.RoundedRect//设置TextField为圆角矩形的
                    newTextField.adjustsFontSizeToFitWidth=true
                    newTextField.textAlignment = .Center //水平居中对齐
                    newTextField.enabled = false
                    newTextField.placeholder = "0"
                    newTextField.alpha = 0.7
                    newTextField.text = res[i][j].YueFen().toString()
                    
                    someInts.append(newTextField)
                    a[a.count-1].addSubview(someInts[someInts.count-1])   //将新建的TextField放入UIView容器中
                }
            }
            self.view.addSubview(a[a.count-1])
            JZ.append(someInts)
            playAnimation(someInts)
            UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.multiplyButton.center.y = 900
                self.hanglieButton.center.y = 900
                self.oppositeButton.center.y = 900
                self.rankButton.center.y = 900
                self.returnButton.center.y = CGFloat(630*self.Scale2)
                self.returnButton.center.x = CGFloat(281*self.Scale)
                self.clearButton.center.x = CGFloat(94*self.Scale)
                }, completion: nil)
        }
        
    }
    
    func DoMutiply(){//输入两个矩阵后出现的“计算”按钮的实现方法（计算矩阵乘法）
        DoMutiplyButton.enabled = false
        multiplyButton.enabled = true
        touchFunc = false
        UIView.animateWithDuration(0.7, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in                                                       //此动画将画面中所有的矩阵都移动到（30，30）的位置
            for view in self.a{
                view.frame = CGRectMake(CGFloat(10*self.Scale), CGFloat(20*self.Scale2), 0, 0)
            }
            }, completion: nil)
        UIView.animateWithDuration(1, animations: { () -> Void in   //此动画设置画面中所有矩阵的淡出效果
            for view in self.a{
                view.alpha = 0
            }
            }, completion: nil)
        
        
        a.append(UIView(frame: CGRectMake(CGFloat(10*Scale),CGFloat(20*Scale2),CGFloat(Float(Lie*65)*Scale),CGFloat(Float(HighNumber*65)*Scale2))))
        a[a.count-1].alpha = 0                                  //这是新矩阵的透明度为0，一会儿设置淡入动画
        var someInts = Array<UITextField>()
        for(var i = 0;i < HighNumber;i++){                      //新建矩阵
            for(var j = 0;j < Lie;j++){
                let newTextField = UITextField(frame: CGRectMake(0,0,0,0))
                
                newTextField.borderStyle = UITextBorderStyle.RoundedRect
                newTextField.delegate = self
                newTextField.enabled = false
                newTextField.adjustsFontSizeToFitWidth=true
                newTextField.minimumFontSize=1
                newTextField.alpha = 0.7
                newTextField.textAlignment = .Center
                someInts.append(newTextField)
                a[a.count-1].addSubview(someInts[someInts.count-1])
            }
        }
        self.view.addSubview(a[a.count-1])
        JZ.append(someInts)
        UIView.animateWithDuration(1, delay: 0.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in                                                   //设置动画淡入效果
            self.a[self.a.count-1].alpha = 1
            for(var i = 0;i < self.HighNumber;i++){
                for(var j = 0;j < self.Lie;j++){
                    someInts[i*self.Lie+j].frame = CGRectMake(CGFloat(Float(65*j)*self.Scale),CGFloat(Float(65*i)*self.Scale2),CGFloat(60*self.Scale),CGFloat(60*self.Scale2))
                }
            }
            }, completion: nil)
        
        
        for (var p = 0; p < HighNumber; ++p)                //计算矩阵乘法的算法
        {
            for (var q = 0; q < Lie; ++q)
            {
                var res0 = FractionalClass(Zi: 0, Mu: 1)
                for (var k = 0; k < Hang; ++k){
                    let res1 = FractionalClass.StringToFractional(JZ[0][p*Hang+k].text!)
                    let res2 = FractionalClass.StringToFractional(JZ[1][k*Lie+q].text!)
                    res0 = res0 + res1*res2
                }
                someInts[p*Lie+q].text =  res0.YueFen().toString()
            }
        }
        UIView.animateWithDuration(1, delay: 0.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.DoMutiplyButton.center.y = 900
            self.returnButton.center.y = CGFloat(630*self.Scale2)
            self.returnButton.center.x = CGFloat(281*self.Scale)
            }, completion: nil)
    }
    
    func returnFunc(){//返回按钮的实现方法
        touchFunc = true//不管什么情况的返回，返回之后用户都有可能调出键盘，所以这个触摸空白处关闭键盘的功能要打开
        if(oppositeButton.enabled == false || hanglieButton.enabled == false){   //这里是处理《方阵》计算行列式和逆矩阵的返回情况
            
            a[0].alpha = 1
            UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in//设置“乘”，“清除按钮”，“秩”按钮出现在屏幕上
                self.multiplyButton.center.y = CGFloat(630*self.Scale2)
                self.clearButton.center.y = CGFloat(630*self.Scale2)
                self.multiplyButton.center.x = CGFloat(94*self.Scale)
                self.clearButton.center.x = CGFloat(187.5*self.Scale)
                self.rankButton.center.x = CGFloat(281*self.Scale)
                self.rankButton.center.y = CGFloat(630*self.Scale2)
                self.returnButton.center.y = 900
                self.a[1].alpha = 0
                if(self.a.count == 3){
                    self.a[2].alpha = 0
                }
                }, completion: {(finished)->Void in//此动画结束时要清空a这个视图数组中除原来用户输入的数组外所有的视图
                    self.a[1].removeFromSuperview()
                    self.a.removeAtIndex(1)
            })
            if(oppositeButton.enabled == false){
                JZ.removeAtIndex(1)
            }
            UIView.animateWithDuration(1, delay: 0.3, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in//设置“行列式”，“逆矩阵”出现在屏幕上，比上一个动画延时0.3秒开始
                self.hanglieButton.center.y = CGFloat(585*self.Scale2)
                self.hanglieButton.center.x = CGFloat(234*self.Scale)
                self.oppositeButton.center.x = CGFloat(141*self.Scale)
                self.oppositeButton.center.y = CGFloat(585*self.Scale2)
                self.returnButton.center.y = 900
                }, completion: nil)
            oppositeButton.enabled = true
            hanglieButton.enabled = true
            
        }
        if(multiplyButton.enabled == false){//这时为用户已输入了两个矩阵，但还没有做乘法运算，界面中显示两个矩阵。这时的返回要删除第二个矩阵，回到只有一个矩阵的界面状态
                multiplyButton.enabled = true
                UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    self.a[1].alpha = 0
                    self.returnButton.center.y = 900
                    self.DoMutiplyButton.center.y = 900
                    }, completion: {(finished)->Void in
                        self.a[1].removeFromSuperview()
                        self.a.removeAtIndex(1)
                        self.JZ.removeAtIndex(1)
                        self.Lie = self.Hang
                        self.Hang = self.HighNumber
                        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                            self.multiplyButton.center.y = CGFloat(630*self.Scale2)
                            self.clearButton.center.y = CGFloat(630*self.Scale2)
                            self.multiplyButton.center.x = CGFloat(94*self.Scale)
                            self.clearButton.center.x = UIScreen.mainScreen().bounds.width/2//CGFloat(187.5*self.Scale)
                            self.rankButton.center.x = CGFloat(281*self.Scale)
                            self.rankButton.center.y = CGFloat(630*self.Scale2)
                            }, completion: nil)
                        if(self.Hang == self.Lie){//若用户输入的第一个矩阵为方阵，则返回时，要比非方阵多出现“行列式”和“逆矩阵”按钮
                            UIView.animateWithDuration(1, delay: 0.3, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                                self.hanglieButton.center.y = CGFloat(585*self.Scale2)
                                self.hanglieButton.center.x = CGFloat(234*self.Scale)
                                self.oppositeButton.center.x = CGFloat(141*self.Scale)
                                self.oppositeButton.center.y = CGFloat(585*self.Scale2)
                                }, completion: nil)
                        }
                })
        }
        if(DoMutiplyButton.enabled == false){//说明此时在乘法结果显示的界面,这时返回要将乘法结果视图删除，使用户输入的两个矩阵视图回到界面中
            DoMutiplyButton.enabled = true
            multiplyButton.enabled = false
            JZ.removeAtIndex(2)
            UIView.animateWithDuration(0.7, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                
                self.DoMutiplyButton.center.y = CGFloat(630*self.Scale2)
                self.DoMutiplyButton.center.x = UIScreen.mainScreen().bounds.width/2
                self.a[2].alpha = 0
                self.a[1].alpha = 1
                self.a[0].alpha = 1
                self.a[0].frame = CGRectMake(CGFloat(10.0*self.Scale),CGFloat(20.0*self.Scale2),CGFloat(self.Scale*Float(55*self.Hang)),CGFloat(Float(55*self.HighNumber)*self.Scale2))
                if(self.Hang+self.Lie > 6){                                   //如果两个矩阵的列数大于6，则第二个矩阵换行显示
                    let High = CGFloat(Float(self.HighNumber * 55+50)*self.Scale2 )
                    
                    self.a[1].frame = CGRectMake(CGFloat(10.0*self.Scale),High,CGFloat(self.Scale*Float(55*self.Lie)),CGFloat(Float(55*self.Hang)*self.Scale2))
                }else{
                    let wide = Float(self.Hang!*55 + 40)*self.Scale
                    self.a[1].frame = CGRectMake(CGFloat(wide),CGFloat(20.0*self.Scale2),CGFloat(Float(55*self.Lie)*self.Scale),CGFloat(Float(55*self.Hang)*self.Scale2))
                }
                
                }, completion: {(finished)->Void in
                    self.a[2].removeFromSuperview()
                    self.a.removeAtIndex(2)
            })
        }
        

        if(rankButton.enabled == false){//这个分支是处理《非方阵》计算秩以后的返回操作
            JZ.removeAtIndex(1)
            rankButton.enabled = true
            UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.multiplyButton.center.y = CGFloat(630*self.Scale2)
                self.clearButton.center.y = CGFloat(630*self.Scale2)
                self.multiplyButton.center.x = CGFloat(94*self.Scale)
                self.clearButton.center.x = CGFloat(187.5*self.Scale)
                self.rankButton.center.x = CGFloat(281*self.Scale)
                self.rankButton.center.y = CGFloat(630*self.Scale2)
                self.returnButton.center.y = 900
                if(self.Hang == self.Lie){
                    self.hanglieButton.center.y = CGFloat(585*self.Scale2)
                    self.hanglieButton.center.x = CGFloat(234*self.Scale)
                    self.oppositeButton.center.x = CGFloat(141*self.Scale)
                    self.oppositeButton.center.y = CGFloat(585*self.Scale2)
                }
                

                self.a[1].alpha = 0
                self.a[2].alpha = 0
                self.a[0].alpha = 1
                }, completion: {(finished)->Void in
                    self.a[2].removeFromSuperview()
                    self.a.removeAtIndex(2)
                    self.a[1].removeFromSuperview()
                    self.a.removeAtIndex(1)
            })
        }
    }
    
    func playAnimation(a:Array<UITextField>)//矩阵出现时的动画的播放，用于计算逆矩阵和矩阵的秩时的动画
    {
        
        for tile in a{
        //将数字块大小置为原始尺寸的 1/10
        tile.layer.setAffineTransform(CGAffineTransformMakeScale(0.1,0.1))
        tile.alpha = 0
        //设置动画效果，动画时间长度 1 秒。
        UIView.animateWithDuration(0.25, delay:0.01,
            options:UIViewAnimationOptions.TransitionNone, animations:
            {
                ()-> Void in
                //在动画中，数字块有一个角度的旋转。
                tile.layer.setAffineTransform(CGAffineTransformMakeRotation(45))
                tile.alpha = 0.7
            },
            completion:{
                (finished:Bool) -> Void in
                UIView.animateWithDuration(0.5, animations:{
                    ()-> Void in
                    //完成动画时，数字块复原
                    tile.layer.setAffineTransform(CGAffineTransformIdentity)
                })
                
        })
        }
    }
}

