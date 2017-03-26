//
//  JZRankClass.swift
//  Calculator
//
//  Created by 杜晨光 on 16/3/10.
//  Copyright © 2016年 杜晨光. All rights reserved.
//

import UIKit

class JZRankClass: NSObject {
    fileprivate var matrix = Array<Array<FractionalClass>>()
    fileprivate let Hang:Int
    fileprivate let Lie:Int
    
    init(newMatrix: Array<UITextField>,Hang:Int,Lie:Int) {
        for i in 0 ..< Hang {
            matrix.append(Array<FractionalClass>())
            for j in 0 ..< Lie {
                matrix[i].append(FractionalClass.StringToFractional(newMatrix[i*Lie+j].text!))
            }
        }
        self.Hang = Hang
        self.Lie = Lie
    }
    func exchang_row(_ a:inout Array<FractionalClass>,b:inout Array<FractionalClass>){//交换a行和b行
        var t:FractionalClass
        for i in 0 ..< Lie {
            t = a[i]
            a[i] = b[i]
            b[i] = t
        }
    }
    
    func mul_row(_ a:inout Array<FractionalClass>,k:FractionalClass,n:Int){//将a行乘以k倍
        for i in n ..< a.count {
            a[i] = k*a[i]
        }

    }
    
    func add_row(_ a1:inout Array<FractionalClass>,a2:Array<FractionalClass>,k:FractionalClass,n:Int){//从下标第ci个开始，将a2乘以k倍加到a1行
        for i in n ..< a1.count{
            a1[i] = a1[i]+a2[i]*k
        }
    }

    func rank_matrix()->Int{
        var t:FractionalClass
        var ri = 0  //行标记
        //ci为列标记
        var f_z:Bool    //某行是否全为0的标志，为1表示全为false
        for ci in 0 ..< Lie{
            f_z=true
            for i in ri ..< Hang {
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
        for i in 0 ..< Hang{
            for j in i ..< Lie{
                if(matrix[i][j].getFenZi() != 0){
                    
                    mul_row(&matrix[i], k: FractionalClass(Zi: 1, Mu: 1)/matrix[i][j], n: j)
                    for k in 0 ..< i {
                        add_row(&matrix[k], a2: matrix[i], k: -matrix[k][j], n: j)
                    }
                    break
                }
                
                
            }
        }
    }
    
    func showResult()->Array<String>{
        var someInts = Array<String>()
        for i in 0 ..< Hang {
            for j in 0 ..< Lie {
                someInts.append(matrix[i][j].YueFen().toString())
            }
        }
        return someInts
    }
}
