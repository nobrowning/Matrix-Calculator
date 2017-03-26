//
//  NIJZClass.swift
//  矩阵处理
//
//  Created by 杜晨光 on 16/3/12.
//  Copyright © 2016年 杜晨光. All rights reserved.
//

import UIKit

class NIJZClass: NSObject {
    fileprivate let N:Int!
    fileprivate var a = Array<Array<FractionalClass>>()
    fileprivate var b = Array<Array<FractionalClass>>()
    fileprivate var c = Array<Array<FractionalClass>>()
    init(a:Array<UITextField>,n:Int) {
        self.N = n
        for i in 0 ..< self.N {
            var temp = Array<FractionalClass>()
            for j in 0 ..< self.N {
                temp.append(FractionalClass.StringToFractional(a[i*self.N+j].text!))
            }
            self.a.append(temp)
        }
    }
    func run(){
//        var i:Int
//        var j:Int
//        var m:Int
        var t:FractionalClass
        
        for _ in 0 ..< self.N{
            //(i = 0;i<self.N;i += 1)
            var temp = Array<FractionalClass>()
            for _ in 0 ..< self.N*2 {
                temp.append(FractionalClass(Zi: 0, Mu: 1))
            }
            b.append(temp)
        }
        
        
        for i in 0 ..< N {
            for j in 0 ..< N{
                b[i][j] = a[i][j]
            }
        }
        
        for i in 0 ..< self.N{
            b[i][N + i] = FractionalClass(Zi: 1, Mu: 1)
        }
        
        for m in 0 ..< N{
            t = b[m][m]
            var i = m
            while (b[m][m] == FractionalClass(Zi: 0,Mu: 1)) {
                b[m][m] = b[i + 1][m]
                i += 1
            }
            if (i > m) {
                b[i][m] = t
                for j in 0 ..< m {
                    t = b[m][j]
                    b[m][j] = b[i][j]
                    b[i][j] = t
                }
                for j in m + 1 ..< 2 * N {
                    t = b[m][j]
                    b[m][j] = b[i][j]
                    b[i][j] = t
                }
            }
            for i in m + 1 ..< N{
                var j = 2 * N - 1
                while j >= m{
                    //for( j = 2 * N - 1; j >= m; j -= 1)
                    b[i][j] = b[i][j]-b[i][m] * b[m][j] / b[m][m]
                    j -= 1
                }
            }
            
            var j = 2*N-1
            while j>=m{
                //for (j = 2 * N - 1; j >= m; j -= 1)
                b[m][j] = b[m][j]/b[m][m]
                j -= 1
            }
            
        }
        var m = N - 1
        while (m > 0) {
            for i in 0 ..< m{
                var j = 2 * N - 1
                while j>=m{
                    //for (j = 2 * N - 1; j >= m; j -= 1)
                    b[i][j] = b[i][j]-b[i][m] * b[m][j]
                    j-=1
                }
            }
            m -= 1
        }
        for i in 0 ..< self.N{
            var temp = Array<FractionalClass>()
            for j in 0 ..< self.N {
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
