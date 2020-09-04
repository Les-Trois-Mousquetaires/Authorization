//
//  ViewController.swift
//  Authorization
//
//  Created by 柯南 on 2020/9/4.
//  Copyright © 2020 LTM. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        network()
    }
    
    func mediaPlayerService() {
        SystemAuth.authMediaPlayerService { (result) in
            if result{
                print("权限开启")
            }else{
                print("权限未开启")
            }
        }
        
    }
    
    func network() {
        SystemAuth.authNetwork { (result) in
            if result{
                print("权限开启")
            }else{
                print("权限未开启")
            }
        }
    }
}

