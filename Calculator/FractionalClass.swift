//
//  FractionalClass.swift
//  矩阵处理
//
//  Created by 杜晨光 on 16/3/15.
//  Copyright © 2016年 杜晨光. All rights reserved.
//

import UIKit

class FractionalClass: NSObject {
    fileprivate var FenMu:Int
    fileprivate var FenZi:Int
    init(Zi:Int,Mu:Int) {
        self.FenMu = Mu
        self.FenZi = Zi
    }
    func toString()->String{
        if(self.FenMu == 1){
            return "\(self.FenZi)"
        }else if(self.FenZi == 0){
            return "0"
        }else{
            return "\(self.FenZi)/\(self.FenMu)"
        }
    }
    static func StringToFractional(_ str:String)->FractionalClass{
        var index = -1
        var a:String = ""
        var b:String = ""
        if(str.isEmpty){
            return FractionalClass(Zi: 0, Mu: 1)
        }else{
            for char in str.characters{
                index += 1
                if(char == "/" || char == "."){
                    break
                }
                a.append(char)
            }
            
            if((str as NSString).substring(with: NSMakeRange(index, 1)) == "/"){
                b = (str as NSString).substring(from: index+1)
                return FractionalClass(Zi: Int(a)!, Mu: Int(b)!).YueFen()
            }else{
                let zi = (str as NSString).substring(from: index+1)
                var mu = 1
                if(zi.isEmpty){
                    return FractionalClass(Zi: Int(str)!, Mu: 1)
                }else{
                    for _ in 0 ..< zi.characters.count {
                        mu*=10
                    }
                    return FractionalClass(Zi: Int(zi)!+Int(a)!*Int(mu), Mu: Int(mu)).YueFen()
                }
                
            }
 
        }
    }
    static func DoubleToFractional(_ number:Double)->FractionalClass{
        let str = String(number)
        var index = 0
        var mu = 1.0
        for char in str.characters{
            index += 1
            if(char == "."){
                break
            }
        }
        let zi = (str as NSString).substring(from: index)
        if(zi.isEmpty){
            return FractionalClass(Zi: Int(number), Mu: 1)
        }else{
            for _ in 0 ..< zi.characters.count {
                mu*=10
            }
            return FractionalClass(Zi: Int(zi)!+Int(number)*Int(mu), Mu: Int(mu)).YueFen()
        }
        
    }
    func YueFen()->FractionalClass{
        var F1 = 1
        var F2 = 1
        if(self.FenZi<0){
            F1 = -1
            self.FenZi = -self.FenZi
        }
        if(self.FenMu<0){
            F2 = -1
            self.FenMu = -self.FenMu
        }
        if(self.FenMu == self.FenZi){
            self.FenZi = 1
            self.FenMu = 1
        }else{
            let Yue = MaxGongYueShu(self.FenMu, y: self.FenZi)
            self.FenZi = self.FenZi/Yue
            self.FenMu = self.FenMu/Yue
        }
        self.FenZi = self.FenZi*F1*F2
        return self
    }

    func getFenZi()->Int{
        return self.FenZi
    }
    
}

func MaxGongYueShu( _ x:Int, y:Int)->Int{
    var a = x
    var b = y
    var temp:Int
    if(x < y)
    {
        a = y
        b = x
    }
    while(b != 0)
    {
        temp = a % b
        a = b
        b = temp
    }
    return a
}

func * (a:FractionalClass,b:FractionalClass)->FractionalClass{
    
    let res = FractionalClass(Zi: 1, Mu: 1)
    var aFenZi = a.FenZi
    var aFenMu = a.FenMu
    var bFenZi = b.FenZi
    var bFenMu = b.FenMu
    if(aFenZi*bFenZi == 0){
        res.FenZi = 0
        return res
    }else{
        let yue1 = MaxGongYueShu(b.FenMu, y: a.FenZi)
        aFenZi/=yue1
        bFenMu/=yue1
        let yue2 = MaxGongYueShu(a.FenMu, y: b.FenZi)
        aFenMu/=yue2
        bFenZi/=yue2
        res.FenMu = aFenMu*bFenMu
        res.FenZi = aFenZi*bFenZi
        return res
    }
    
}


func + (a:FractionalClass,b:FractionalClass)->FractionalClass{
    let res = FractionalClass(Zi: 1, Mu: 1)
    if(a.FenMu == b.FenMu){
        res.FenZi = a.FenZi+b.FenZi
        res.FenMu = a.FenMu
    }else{
        let yue = MaxGongYueShu(a.FenMu, y: b.FenMu)
        res.FenMu = a.FenMu*b.FenMu/yue
        if(yue != 1){
            res.FenZi = a.FenZi*res.FenMu/a.FenMu+b.FenZi*res.FenMu/b.FenMu
        }else{
            res.FenZi = a.FenZi*b.FenMu+b.FenZi*a.FenMu
        }
    }
    if(res.FenZi == 0){
        res.FenMu = 1
    }
    return res.YueFen()
    
}

func - (a:FractionalClass,b:FractionalClass)->FractionalClass{
    let res = FractionalClass(Zi: 1, Mu: 1)
    if(a.FenMu == b.FenMu){
        res.FenZi = a.FenZi-b.FenZi
        res.FenMu = a.FenMu
    }else{
        let yue = MaxGongYueShu(a.FenMu, y: b.FenMu)
        let b1 = b.FenMu/yue
        res.FenMu = a.FenMu*b1
        if(yue != 1){
            let a1 = res.FenMu/a.FenMu
            let a2 = res.FenMu/b.FenMu
            res.FenZi = a.FenZi*a1-b.FenZi*a2
        }else{
            res.FenZi = a.FenZi*b.FenMu-b.FenZi*a.FenMu
        }
    }
    if(res.FenZi == 0){
        res.FenMu = 1
    }
    return res.YueFen()
}


prefix func - (a:FractionalClass)->FractionalClass{
    let b = FractionalClass(Zi: -a.FenZi, Mu: a.FenMu)
    return b
}

func / (a:FractionalClass,b:FractionalClass)->FractionalClass{
    let b1 = FractionalClass(Zi: b.FenZi, Mu: b.FenMu)
    let temp = b1.FenMu
    b1.FenMu = b1.FenZi
    b1.FenZi = temp
    return a*b1
}


postfix func ++ (a:inout FractionalClass){
    let b = FractionalClass(Zi: 1, Mu: 1)
    a = a+b
}
postfix func -- (a:inout FractionalClass){
    let b = FractionalClass(Zi: 1, Mu: 1)
    a = a-b
}

func >(a:FractionalClass,b:FractionalClass)->Bool{
    let aVaule:Float
    let bVaule:Float
    aVaule = Float(a.FenZi)/Float(a.FenMu)
    bVaule = Float(b.FenZi)/Float(b.FenMu)
    return aVaule > bVaule ? true : false
}
func <(a:FractionalClass,b:FractionalClass)->Bool{
    let aVaule:Float
    let bVaule:Float
    aVaule = Float(a.FenZi)/Float(a.FenMu)
    bVaule = Float(b.FenZi)/Float(b.FenMu)
    return aVaule > bVaule ? false : true
}



