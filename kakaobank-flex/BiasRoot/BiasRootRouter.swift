//
//  BiasRootRouter.swift
//  kakaobank-flex
//
//  Created by 김수아 on 2023/06/29.
//

import RIBs

protocol BiasRootInteractable: Interactable, BiasTransactionHistoryListener{
    var router: BiasRootRouting? { get set }
    var listener: BiasRootListener? { get set }
}

protocol BiasRootViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func attachChild(viewController: ViewControllable)
    
    func detachChild(viewController: ViewControllable)
}

final class BiasRootRouter: ViewableRouter<BiasRootInteractable, BiasRootViewControllable>, BiasRootRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: BiasRootInteractable,
        viewController: BiasRootViewControllable,
        transactionHistoryBuilder: BiasTransactionHistoryBuilder
    ) {
        self.transactionHistoryBuilder = transactionHistoryBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    override func didLoad() {
        super.didLoad()
        routeToTransactionHistory()
    }
    
    // MARK: Private
    
    private let transactionHistoryBuilder: BiasTransactionHistoryBuildable
    
    private var transactionHistoryRouter: BiasTransactionHistoryRouting?
    
    private func routeToTransactionHistory(){
        guard transactionHistoryRouter == nil else{ return }
        let router = transactionHistoryBuilder.build(withListener: interactor)
        transactionHistoryRouter = router
        
        attachChild(router)
        viewController.attachChild(viewController: router.viewControllable)
    }
}
