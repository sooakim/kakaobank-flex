//
//  BiasRootViewController.swift
//  kakaobank-flex
//
//  Created by 김수아 on 2023/06/29.
//

import RIBs
import RxSwift
import UIKit

protocol BiasRootPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class BiasRootViewController: UIViewController, BiasRootPresentable {
    
    weak var listener: BiasRootPresentableListener?
    
    override func loadView() {
        view = biasRootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .close)
        navigationItem.title = "최애적금"
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(systemItem: .bookmarks),
            UIBarButtonItem(systemItem: .play)
        ]
        
        view.backgroundColor = .white
        
        biasRootView.panProgressDidChange = { [weak self] progress in
            self?.updateTitleColor(progress: progress)
        }
        self.updateTitleColor(progress: 0)
    }
    
    // MARK: Private
    
    private lazy var biasRootView = BiasRootView()
    
    private func updateTitleColor(progress: CGFloat){
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black.withAlphaComponent(progress)
        ]
    }
}

extension BiasRootViewController: BiasRootViewControllable{
    func attachChild(viewController: ViewControllable) {
        addChild(viewController.uiviewController)
        biasRootView.childView = viewController.uiviewController.view
    }
    
    func detachChild(viewController: ViewControllable) {
        biasRootView.childView = nil
        viewController.uiviewController.removeFromParent()
    }
}

