//
//  ViewController.swift
//  Authorization
//
//  Created by 柯南 on 2020/9/4.
//  Copyright © 2020 LTM. All rights reserved.
//

import UIKit

import Contacts

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        SystemAuth.authSpeechRecognition { (result) in
            if result{
                print("权限开启")
            }else{
                print("权限未开启")
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
