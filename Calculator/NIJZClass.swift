//
//  NIJZClass.swift
//  矩阵处理
//
//  Created by 杜晨光 on 16/3/12.
//  Copyright © 2016年 杜晨光. All rights reserved.
//

import UIKit

class NIJZClass: NSObject {
    private let N:Int!
    private var a = Array<Array<FractionalClass>>()
    private var b = Array<Array<FractionalClass>>()
    private var c = Array<Array<FractionalClass>>()
    init(a:Array<UITextField>,n:Int) {
        self.N = n
        for(var i = 0;i<self.N;i += 1){
            var temp = Array<FractionalClass>()
            for(var j = 0;j<self.N;j += 1){
                temp.append(FractionalClass.StringToFractional(a[i*self.N+j].text!))
            }
            self.a.append(temp)
        }
    }
    func run(){
        var i:Int
        var j:Int
        var m:Int
        var t:FractionalClass
        for(i = 0;i<self.N;i += 1){
            var temp = Array<FractionalClass>()
            for(var j = 0;j<self.N*2;j += 1){
                temp.append(FractionalClass(Zi: 0, Mu: 1))
            }
            b.append(temp)
        }
        for (i = 0; i < N; i += 1){
            for (j = 0; j < N; j += 1){
                b[i][j] = a[i][j]
            }
        }
        
        
        for (i = 0; i < self.N; i += 1){
            b[i][N + i] = FractionalClass(Zi: 1, Mu: 1)
        }
        for (m = 0; m < N; m += 1){
            t = b[m][m]
            i = m
            while (b[m][m] == 0) {
                b[m][m] = b[i + 1][m]
                i += 1
            }
            if (i > m) {
                b[i][m] = t
                for (j = 0; j < m; j += 1) {
                    t = b[m][j]
                    b[m][j] = b[i][j]
                    b[i][j] = t
                }
                for (j = m + 1; j < 2 * N; j += 1) {
                    t = b[m][j]
                    b[m][j] = b[i][j]
                    b[i][j] = t
                }
            }
            for (i = m + 1; i < N; i += 1){
                for (j = 2 * N - 1; j >= m; j -= 1){
                    b[i][j] = b[i][j]-b[i][m] * b[m][j] / b[m][m]
                }
            }
            for (j = 2 * N - 1; j >= m; j -= 1){
                b[m][j] = b[m][j]/b[m][m]
            }
            
        }
        m = N - 1
        while (m > 0) {
            for (i = 0; i < m; i += 1){
                for (j = 2 * N - 1; j >= m; j -= 1){
                    b[i][j] = b[i][j]-b[i][m] * b[m][j]
                }
            }
            m -= 1
        }
        for(i = 0;i<self.N;i += 1){
            var temp = Array<FractionalClass>()
            for(var j = 0;j<self.N;j += 1){
                temp.append(b[i][N + j])
            }
            c.append(temp)
        }
    }
    func getNiJZ()->Array<Array<FractionalClass>>{
        run()
        return c
    }
}
