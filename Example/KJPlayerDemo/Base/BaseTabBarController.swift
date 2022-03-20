//
//  BaseTabBarController.swift
//  KJPlayerDemo
//
//  Created by 77。 on 2022/3/19.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

private extension BaseTabBarController {
    func initUI() {
        view.backgroundColor = .white
        //UITabBar.appearance().unselectedItemTintColor = UIColor.white
        //UITabBar.appearance().tintColor = UIColor.blue
    }
}

extension BaseTabBarController {
    // 是否支持自动转屏
    override var shouldAutorotate: Bool {
        guard let navigationController = selectedViewController as? UINavigationController else {
            return selectedViewController?.shouldAutorotate ?? false
        }
        return navigationController.topViewController?.shouldAutorotate ?? false
    }
    
    // 支持哪些屏幕方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        guard let navigationController = selectedViewController as? UINavigationController else {
            return selectedViewController?.supportedInterfaceOrientations ?? .portrait
        }
        return navigationController.topViewController?.supportedInterfaceOrientations ?? .portrait
    }
    
    // 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        guard let navigationController = selectedViewController as? UINavigationController else {
            return selectedViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
        }
        return navigationController.topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
    
    /// 状态栏样式
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let navigationController = selectedViewController as? UINavigationController else {
            return selectedViewController?.preferredStatusBarStyle ?? .default
        }
        return navigationController.topViewController?.preferredStatusBarStyle ?? .default
    }
    
    /// 是否隐藏状态栏
    override var prefersStatusBarHidden: Bool {
        guard let navigationController = selectedViewController as? UINavigationController else {
            return selectedViewController?.prefersStatusBarHidden ?? false
        }
        return navigationController.topViewController?.prefersStatusBarHidden ?? false
    }
}
