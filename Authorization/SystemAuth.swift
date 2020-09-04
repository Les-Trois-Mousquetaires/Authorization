//
//  SystemAuth.swift
//  Authorization
//
//  Created by 柯南 on 2020/9/4.
//  Copyright © 2020 LTM. All rights reserved.
//

import UIKit

/// 媒体资料库/Apple Music
import MediaPlayer

import CoreTelephony

/**
 escaping 逃逸闭包的生命周期：
 
 1，闭包作为参数传递给函数；
 
 2，退出函数；
 
 3，闭包被调用，闭包生命周期结束
 即逃逸闭包的生命周期长于函数，函数退出的时候，逃逸闭包的引用仍被其他对象持有，不会在函数结束时释放
 经常使用逃逸闭包的2个场景：
 异步调用: 如果需要调度队列中异步调用闭包，比如网络请求成功的回调和失败的回调，这个队列会持有闭包的引用，至于什么时候调用闭包，或闭包什么时候运行结束都是不确定，上边的例子。
 存储: 需要存储闭包作为属性，全局变量或其他类型做稍后使用，例子待补充
 */

typealias AuthClouser = ((Bool)->())

public class SystemAuth: NSObject {
    
    /**
     媒体资料库/Apple Music权限
     
     - parameters: action 权限结果闭包
     */
    class func authMediaPlayerService(clouser :@escaping AuthClouser) {
        let authStatus = MPMediaLibrary.authorizationStatus()
        switch authStatus {
        case .notDetermined:
            MPMediaLibrary.requestAuthorization { (status) in
                if status == .authorized{
                    DispatchQueue.main.async {
                        clouser(true)
                    }
                }else{
                    DispatchQueue.main.async {
                        clouser(false)
                    }
                }
            }
        case .denied:
            clouser(false)
        case .restricted:
            clouser(false)
        case .authorized:
            clouser(true)
        @unknown default:
            clouser(false)
        }
    }
    
    /**
     联网权限
     
     - parameters: action 权限结果闭包
     */
    class func authNetwork(clouser: @escaping AuthClouser) {
        let cellularData = CTCellularData()
        
        switch cellularData.restrictedState {
        case .restrictedStateUnknown:
            switch cellularData.cellularDataRestrictionDidUpdateNotifier {
            case .none:
                 clouser(false)
            case .some(_):
                 clouser(true)
            }
        case .restricted:
            clouser(true)
        case .notRestricted:
            clouser(false)
        @unknown default:
            clouser(false)
        }
//        cellularData.cellularDataRestrictionDidUpdateNotifier = { (state) in
//            if state == CTCellularDataRestrictedState.restrictedStateUnknown ||  state == CTCellularDataRestrictedState.notRestricted {
//                clouser(false)
//            } else {
//                clouser(true)
//            }
//        }
//        let state = cellularData.restrictedState
//        if state == CTCellularDataRestrictedState.restrictedStateUnknown ||  state == CTCellularDataRestrictedState.notRestricted {
//            clouser(false)
//        } else {
//            clouser(true)
//        }
    }
    
    class func authCamera(clouser: @escaping AuthClouser) {
        let authStatus = MPMediaLibrary.authorizationStatus()
        switch authStatus {
        case .notDetermined:
            MPMediaLibrary.requestAuthorization { (status) in
                if status == .authorized{
                    DispatchQueue.main.async {
                        clouser(true)
                    }
                }else{
                    DispatchQueue.main.async {
                        clouser(false)
                    }
                }
            }
        case .denied:
            clouser(false)
        case .restricted:
            clouser(false)
        case .authorized:
            clouser(true)
        @unknown default:
            clouser(false)
        }
    }
    
}
