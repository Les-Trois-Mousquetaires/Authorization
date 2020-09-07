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
import Alamofire
import Photos
import UserNotifications
import Contacts
/// Siri权限
import Intents
/// 语音转文字权限
import Speech
/// 日历、提醒事项
import EventKit
/// Face、TouchID
import LocalAuthentication
import HealthKit
import HomeKit
/// 运动与健身权限
import CoreMotion
/// 防止获取无效 计步器
private let cmPedometer = CMPedometer()

typealias AuthClouser = ((Bool)->())

/// 定义私有全局变量,解决在iOS 13 定位权限弹框自动消失的问题
private let locationAuthManager = CLLocationManager()

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
public class SystemAuth {
    
    /**
     媒体资料库/Apple Music权限
     
     - parameters: action 权限结果闭包
     */
    class func authMediaPlayerService(clouser :@escaping AuthClouser) {
        let authStatus = MPMediaLibrary.authorizationStatus()
        switch authStatus {
        /// 未作出选择
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
        /// 用户明确拒绝此应用程序的授权，或在设置中禁用该服务。
        case .denied:
            clouser(false)
        /// 该应用程序未被授权使用该服务。由于用户无法改变对该服务的主动限制。此状态，并且个人可能没有拒绝授权。
        case .restricted:
            clouser(false)
        /// 已授权
        case .authorized:
            clouser(true)
        /// 扩展以后可能有的状态,做保护措施
        @unknown default:
            clouser(false)
        }
    }
    
    /**
     联网权限
     
     - parameters: action 权限结果闭包
     */
    class func authNetwork(clouser: @escaping AuthClouser) {
        
        let reachabilityManager = NetworkReachabilityManager(host: "www.baidu.com")
        switch reachabilityManager?.status {
        case .reachable(.cellular):
            clouser(true)
        case .reachable(.ethernetOrWiFi):
            clouser(true)
        case .none:
            clouser(false)
        case .notReachable:
            clouser(false)
            //            let status = reachabilityManager?.flags
            //            switch status {
            //            case .none:
            //                clouser(false)
            //            case .some(.connectionAutomatic):
            //                clouser(false)
            //            case .some(.connectionOnDemand):
            //                clouser(false)
            //            case .some(.connectionOnTraffic):
            //                clouser(false)
            //            case .some(.connectionRequired):
            //                clouser(false)
            //            case .some(.interventionRequired):
            //                clouser(false)
            //            case .some(.isDirect):
            //                clouser(false)
            //            case .some(.isLocalAddress):
            //                clouser(false)
            //            case .some(.isWWAN):
            //                clouser(false)
            //            case .some(.reachable):
            //                clouser(false)
            //            case .some(.transientConnection):
            //                clouser(false)
            //            case .init(rawValue: 0):
            //                clouser(false)
            //            case .some(_):
            //                clouser(false)
        //            }
        case .unknown:
            clouser(false)
        }
    }
    
    /**
     相机权限
     
     - parameters: action 权限结果闭包
     */
    class func authCamera(clouser: @escaping AuthClouser) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (result) in
                if result{
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
     相册权限
     
     - parameters: action 权限结果闭包
     */
    class func authPhotoLib(clouser: @escaping AuthClouser) {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        switch authStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
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
     麦克风权限
     
     - parameters: action 权限结果闭包
     */
    class func authMicrophone(clouser: @escaping AuthClouser) {
        let authStatus = AVAudioSession.sharedInstance().recordPermission
        switch authStatus {
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { (result) in
                if result{
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
        case .granted:
            clouser(true)
        @unknown default:
            clouser(false)
        }
    }
    
    /**
     定位权限
     
     - parameters: action 权限结果闭包(有无权限,是否第一次请求权限)
     */
    class func authLocation(clouser: @escaping ((Bool,Bool)->())) {
        let authStatus = CLLocationManager.authorizationStatus()
        switch authStatus {
        case .notDetermined:
            //由于IOS8中定位的授权机制改变 需要进行手动授权
            locationAuthManager.requestAlwaysAuthorization()
            locationAuthManager.requestWhenInUseAuthorization()
            let status = CLLocationManager.authorizationStatus()
            if  status == .authorizedAlways || status == .authorizedWhenInUse {
                DispatchQueue.main.async {
                    clouser(true && CLLocationManager.locationServicesEnabled(), true)
                }
            }else{
                DispatchQueue.main.async {
                    clouser(false, true)
                }
            }
        case .restricted:
            clouser(false, false)
        case .denied:
            clouser(false, false)
        case .authorizedAlways:
            clouser(true && CLLocationManager.locationServicesEnabled(), false)
        case .authorizedWhenInUse:
            clouser(true && CLLocationManager.locationServicesEnabled(), false)
        @unknown default:
            clouser(false, false)
        }
    }
    
    /**
     通知权限
     
     - parameters: action 权限结果闭包
     */
    class func authNotification(clouser: @escaping AuthClouser){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .carPlay, .sound]) { (result, error) in
            if result{
                DispatchQueue.main.async {
                    clouser(true)
                }
            }else{
                DispatchQueue.main.async {
                    clouser(false)
                }
            }
        }
    }
    
    /**
     运动与健身
     
     - parameters: action 权限结果闭包
     */
    class func authCMPedometer(clouser: @escaping AuthClouser){
        cmPedometer.queryPedometerData(from: Date(), to: Date()) { (pedometerData, error) in
            if pedometerData?.numberOfSteps != nil{
                DispatchQueue.main.async {
                    clouser(true)
                }
            }else{
                DispatchQueue.main.async {
                    clouser(false)
                }
            }
        }
    }
    
    /**
     通讯录权限
     
     - parameters: action 权限结果闭包
     */
    class func authContacts(clouser: @escaping AuthClouser){
        let authStatus = CNContactStore.authorizationStatus(for: .contacts)
        switch authStatus {
        case .notDetermined:
            CNContactStore().requestAccess(for: .contacts) { (result, error) in
                if result{
                    DispatchQueue.main.async {
                        clouser(true)
                    }
                }else{
                    DispatchQueue.main.async {
                        clouser(false)
                    }
                }
            }
        case .restricted:
            clouser(false)
        case .denied:
            clouser(false)
        case .authorized:
            clouser(true)
        @unknown default:
            clouser(false)
        }
    }
    
    /**
     Siri 权限
     
     - parameters: action 权限结果闭包
     */
    class func authSiri(clouser: @escaping AuthClouser){
        let authStatus = INPreferences.siriAuthorizationStatus()
        switch authStatus {
        case .notDetermined:
            INPreferences.requestSiriAuthorization { (status) in
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
        case .restricted:
            clouser(false)
        case .denied:
            clouser(false)
        case .authorized:
            clouser(true)
        @unknown default:
            clouser(false)
        }
    }
    
    /**
     语音转文字权限
     
     - parameters: action 权限结果闭包
     */
    class func authSpeechRecognition(clouser: @escaping AuthClouser){
        let authStatus = SFSpeechRecognizer.authorizationStatus()
        switch authStatus {
        case .notDetermined:
            SFSpeechRecognizer.requestAuthorization { (status) in
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
        case .restricted:
            clouser(false)
        case .denied:
            clouser(false)
        case .authorized:
            clouser(true)
        @unknown default:
            clouser(false)
        }
    }
    
    /**
     提醒事项
     
     - parameters: action 权限结果闭包
     */
    class func authRreminder(clouser: @escaping AuthClouser){
        let authStatus = EKEventStore.authorizationStatus(for: .reminder)
        switch authStatus {
        case .notDetermined:
            EKEventStore().requestAccess(to: .reminder) { (result, error) in
                if result{
                    DispatchQueue.main.async {
                        clouser(true)
                    }
                }else{
                    DispatchQueue.main.async {
                        clouser(false)
                    }
                }
            }
        case .restricted:
            clouser(false)
        case .denied:
            clouser(false)
        case .authorized:
            clouser(true)
        @unknown default:
            clouser(false)
        }
    }
    
    /**
     日历
     
     - parameters: action 权限结果闭包
     */
    class func authEvent(clouser: @escaping AuthClouser){
        let authStatus = EKEventStore.authorizationStatus(for: .event)
        switch authStatus {
        case .notDetermined:
            EKEventStore().requestAccess(to: .event) { (result, error) in
                if result{
                    DispatchQueue.main.async {
                        clouser(true)
                    }
                }else{
                    DispatchQueue.main.async {
                        clouser(false)
                    }
                }
            }
        case .restricted:
            clouser(false)
        case .denied:
            clouser(false)
        case .authorized:
            clouser(true)
        @unknown default:
            clouser(false)
        }
    }
    
    /**
     FaceID或者TouchID 认证
     
     - parameters: action 权限结果闭包
     */
    class func authFaceOrTouchID(clouser: @escaping ((Bool,Error)->())) {
        let context = LAContext()
        var error: NSError?
        let result = context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
        if result {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "认证") { (success, authError) in
                if success{
                    print("成功")
                }else{
                    print("失败")
                }
            }
        }else{
            /**
             #define kLAErrorAuthenticationFailed                       -1
             #define kLAErrorUserCancel                                 -2
             #define kLAErrorUserFallback                               -3
             #define kLAErrorSystemCancel                               -4
             #define kLAErrorPasscodeNotSet                             -5
             #define kLAErrorTouchIDNotAvailable                        -6
             #define kLAErrorTouchIDNotEnrolled                         -7
             #define kLAErrorTouchIDLockout                             -8
             #define kLAErrorAppCancel                                  -9
             #define kLAErrorInvalidContext                            -10
             #define kLAErrorNotInteractive                          -1004
             
             #define kLAErrorBiometryNotAvailable              kLAErrorTouchIDNotAvailable
             #define kLAErrorBiometryNotEnrolled               kLAErrorTouchIDNotEnrolled
             
             */
            print("不可以使用")
        }
    }
    
    /**
     健康  (写:体能训练、iOS13 听力图 读: 健身记录、体能训练、iOS13 听力图)
     
     - parameters: action 权限结果闭包
     */
    class func authHealth(clouser: @escaping AuthClouser){
        if HKHealthStore.isHealthDataAvailable(){
            let authStatus = HKHealthStore().authorizationStatus(for: .workoutType())
            switch authStatus {
            case .notDetermined:
                if #available(iOS 13.0, *) {
                    HKHealthStore().requestAuthorization(toShare: [.audiogramSampleType(), .workoutType()], read: [.activitySummaryType(), .workoutType(), .audiogramSampleType()]) { (result, error) in
                        if result{
                            clouser(true)
                        }else{
                            clouser(false)
                        }
                    }
                } else {
                    HKHealthStore().requestAuthorization(toShare: [.workoutType()], read: [.activitySummaryType(), .workoutType()]) { (result, error) in
                        if result{
                            clouser(true)
                        }else{
                            clouser(false)
                        }
                    }
                }
            case .sharingDenied:
                clouser(false)
            case .sharingAuthorized:
                clouser(true)
            @unknown default:
                clouser(false)
            }
        }else{
            clouser(false)
        }
    }
    
    /**
     家庭、住宅数据
     
     - parameters: action 权限结果闭包
     */
    class func authHomeKit(clouser: @escaping AuthClouser) {
        if #available(iOS 13.0, *) {
            switch HMHomeManager().authorizationStatus {
            case .authorized:
                clouser(true)
            case .determined:
                clouser(false)
            case .restricted:
                clouser(false)
            default:
                clouser(false)
            }
        } else {
            if (HMHomeManager().primaryHome != nil) {
                clouser(true)
            }else{
                clouser(false)
            }
        }
    }
}
