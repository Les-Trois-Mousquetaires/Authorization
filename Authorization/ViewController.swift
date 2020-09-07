//
//  ViewController.swift
//  Authorization
//
//  Created by 柯南 on 2020/9/4.
//  Copyright © 2020 LTM. All rights reserved.
//

import UIKit

import HomeKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        SystemAuth.authHealth { (result) in
//            if result{
//                print("权限开启")
//            }else{
//                print("权限未开启")
//            }
//        }
        
        let homeman = HMHomeManager.init()
        homeman.delegate = self
        
        if #available(iOS 13.0, *) {
            switch homeman.authorizationStatus {
            case .authorized:
                print("开启了")
            case .determined:
                print("拒绝")
            case .restricted:
                print("受限制的")
            default:
                break
            }
        } else {
            // Fallback on earlier versions
            let pri = homeman.primaryHome
            if (pri != nil) {
                print("数据获取")
            }else{
                print("未数据获取或者没有权限")
            }
        }
    }
    
    func authLocation(){
        
        SystemAuth.authLocation { (result, isFirst) in
            if result{
                print("权限开启")
            }else{
                print("权限未开启")
                if isFirst {
                    print("第一次请求定位,下次定位需要判断")
                }else {
                    print("不是第一次请求定位,权限拒绝")
                }
            }
        }
    }
}


extension ViewController: HMHomeDelegate, HMHomeManagerDelegate{
    
}
