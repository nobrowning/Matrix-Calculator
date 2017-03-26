//
//  JZRankClass.swift
//  Calculator
//
//  Created by 杜晨光 on 16/3/10.
//  Copyright © 2016年 杜晨光. All rights reserved.
//

import UIKit

class JZRankClass: NSObject {
    private var matrix = Array<Array<FractionalClass>>()
    private let Hang:Int
    private let Lie:Int
    
    init(newMatrix: Array<UITextField>,Hang:Int,Lie:Int) {
        for(var i = 0;i<Hang;i += 1){
            matrix.append(Array<FractionalClass>())
            for(var j = 0;j<Lie;j += 1){
                matrix[i].append(FractionalClass.StringToFractional(newMatrix[i*Lie+j].text!))
            }
        }
        self.Hang = Hang
        self.Lie = Lie
    }
    func exchang_row(inout a:Array<FractionalClass>,inout b:Array<FractionalClass>){//交换a行和b行
        var t:FractionalClass
        for(var i=0;i < Lie;i += 1){
            t = a[i]
            a[i] = b[i]
            b[i] = t
        }
    }
    
    func mul_row(inout a:Array<FractionalClass>,k:FractionalClass,n:Int){//将a行乘以k倍
        for(var i=n;i < a.count;i += 1){
            a[i] = k*a[i]
        }

    }
    
    func add_row(inout a1:Array<FractionalClass>,a2:Array<FractionalClass>,k:FractionalClass,n:Int){//从下标第ci个开始，将a2乘以k倍加到a1行
        for(var i=n;i<a1.count;i += 1){
            a1[i] = a1[i]+a2[i]*k
        }
    }

    func rank_matrix()->Int{
        var i:Int
        var t:FractionalClass
        var ri = 0  //行标记
        var ci = 0 //列标记
        var f_z:Bool    //某行是否全为0的标志，为1表示全为false
        for(;ci<Lie;ci += 1){
            f_z=true
            for(i=ri;i<Hang;i += 1){
                if(matrix[i][ci].getFenZi() != 0){
                    if(i != ri){
                        if(f_z){
                            exchang_row(&matrix[ri],b: &matrix[i])
                        }else{
                            t = matrix[i][ci]
                            mul_row(&matrix[i],k: matrix[ri][ci],n: ci)
                            add_row(&matrix[i],a2: matrix[ri],k: -t,n: ci)
                        }
                    }
                    f_z=false
                }
            }
            if(!f_z){
                ri += 1
            }
        }
        simpleRankMatrix()
        return ri
    }
    func simpleRankMatrix(){
        for(var i = 0;i<Hang;i += 1){
            for(var j = i;j<Lie;j += 1){
                if(matrix[i][j].getFenZi() != 0){
                    
                    mul_row(&matrix[i], k: FractionalClass(Zi: 1, Mu: 1)/matrix[i][j], n: j)
                    for(var k = 0;k<i;k += 1){
                        add_row(&matrix[k], a2: matrix[i], k: -matrix[k][j], n: j)
                    }
                    break
                }
                
                
            }
        }
    }
    
    func showResult()->Array<String>{
        var someInts = Array<String>()
        for(var i = 0;i < Hang;i += 1){
            for(var j = 0;j < Lie;j += 1){
                someInts.append(matrix[i][j].YueFen().toString())
            }
        }
        return someInts
    }
}
