//
//  ViewController.swift
//  Authorization
//
//  Created by 柯南 on 2020/9/4.
//  Copyright © 2020 LTM. All rights reserved.
//

import UIKit

import CoreBluetooth

class ViewController: UIViewController {
    let mana = CBCentralManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIViewController.authCamera { (result) in
            if result{
                print("权限开启")
            }else{
                print("权限未开启")
            }
        }
        
        //        bluetooth()
        
    }
    
    func bluetooth() {
        mana.delegate = self
        switch mana.state {
        case .unknown:
            print("unknown")
        case .resetting:
            print("resetting")
        case .unsupported:
            print("unsupported")
        case .unauthorized:
            print("unauthorized")
        case .poweredOff:
            print("poweredOff")
        case .poweredOn:
            print("poweredOn")
        @unknown default:
            break
        }
    }
    
    func authLocation(){
        
        ViewController.authLocation { (result, isFirst) in
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

extension ViewController: CBCentralManagerDelegate{
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("unknown")
        case .resetting:
            print("resetting")
        case .unsupported:
            print("unsupported")
        case .unauthorized:
            print("unauthorized")
        case .poweredOff:
            print("poweredOff")
        case .poweredOn:
            print("poweredOn")
        @unknown default:
            break
        }
    }
    
}
