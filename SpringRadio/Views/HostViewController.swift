//
//  HostViewController.swift
//  SpringRadio
//
//  Created by jack on 2020/4/21.
//  Copyright © 2020 jack. All rights reserved.
//

import SwiftUI

class HostingViewController: UIHostingController<AnyView> {
    var statusBarHidden: Bool = false
    override init(rootView: AnyView) {
        super.init(rootView: rootView)
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "statueBarChanged"), object: nil, queue: .main, using: {[weak self] notification in
            let newValue = notification.userInfo?["hidden"] as! Bool
            self?.statusBarHidden = newValue
        })
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
}

//struct NavigationConfigurator: UIViewControllerRepresentable {
//    var configure: (UINavigationController) -> Void = { _ in }
//
//    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
//        UIViewController()
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
//        if let nc = uiViewController.navigationController {
//            self.configure(nc)
//        }
//    }
//}
//
//
//extension UINavigationController: UIGestureRecognizerDelegate {
//    private static var __viewControllersContext: UInt32 = 0
//    public static let viewControllersContext: UnsafeMutableRawPointer = UnsafeMutableRawPointer(&__viewControllersContext)
//
//    override open func viewDidLoad() {
//        super.viewDidLoad()
//        interactivePopGestureRecognizer?.delegate = self
//        self.delegate = self
//
//    }
//
//    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        return viewControllers.count > 1
//    }
//
//    open override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        self.navigationController?.hidesBarsOnSwipe = false
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
//    }
//
//   open override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        self.navigationController?.hidesBarsOnSwipe = true
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
//    }
//}
//
//extension UINavigationController: UINavigationControllerDelegate {
//
//
//    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
////        externalDelegate?.navigationController?(navigationController, didShow: viewController, animated: animated)
////        self.navigationBar.isHidden = viewControllers.count > 1
//        print("didShow  viewControllers.count:\(viewControllers.count)")
//    }
//
//    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        if let coordinator = navigationController.topViewController?.transitionCoordinator {
//            coordinator.notifyWhenInteractionChanges({ (context) in
//                print("context state changed  isCancelled?\(context.isCancelled) isAnimated?\(context.isAnimated) initiallyInteractive?\(context.initiallyInteractive)")
//                if context.isCancelled {
//                    self.navigationBar.isHidden = true
//                } else {
//                    self.navigationBar.isHidden = self.viewControllers.count > 1
//                }
//            })
//        }
//        print("willShow  viewControllers.count:\(viewControllers.count)")
//    }
//
//}
