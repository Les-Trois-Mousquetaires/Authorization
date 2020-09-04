//
//  ViewController.swift
//  Authorization
//
//  Created by 柯南 on 2020/9/4.
//  Copyright © 2020 LTM. All rights reserved.
//

import UIKit

import Moya

import Alamofire

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        SystemAuth.authMicrophone { (result) in
            if result{
                print("权限开启")
            }else{
                print("权限未开启")
            }
        }
    }

}

