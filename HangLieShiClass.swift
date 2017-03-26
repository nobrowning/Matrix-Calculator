//
//  HangLieShiClass.swift
//  矩阵处理
//
//  Created by 杜晨光 on 16/3/12.
//  Copyright © 2016年 杜晨光. All rights reserved.
//

import UIKit

class HangLieShiClass: NSObject {
    fileprivate var Matrix = Array<UITextField>()
    fileprivate let Hang:Int!
    init(newMatrix: Array<UITextField>,Hang:Int) {
        self.Hang = Hang
        self.Matrix = newMatrix
    }
    func hanglieshi(_ a:[UITextField],n:Int)->FractionalClass{
        var s = FractionalClass(Zi: 0, Mu: 1)
        if (n == 1){
            s = FractionalClass.StringToFractional(a[0].text!)
        }
        else{
            for j in 0 ..< n {
                if ((j%2) == 0){
                    s = s + FractionalClass.StringToFractional(a[j].text!)*yuzishi(j,b: a,y: n)
                }
                else{
                    s = s - FractionalClass.StringToFractional(a[j].text!)*yuzishi(j,b: a,y: n)
                }
            }
        }
        return s.YueFen()
    }
    func yuzishi(_ x:Int,b:[UITextField],y:Int)->FractionalClass{
        var q = FractionalClass(Zi: 0, Mu: 1)
        var c = [UITextField]()
        for m in y ..< y*y {
            if(m%y == x){
                continue
            }
            c.append(b[m])
        }
        q = hanglieshi(c,n:y-1)
        c = []
        return q.YueFen()
    }
    func showResult()->FractionalClass{
        return hanglieshi(self.Matrix, n: self.Hang).YueFen()
    }

}
