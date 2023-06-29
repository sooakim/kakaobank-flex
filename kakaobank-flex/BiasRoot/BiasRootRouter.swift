//
//  BiasRootRouter.swift
//  kakaobank-flex
//
//  Created by 김수아 on 2023/06/29.
//

import RIBs

protocol BiasRootInteractable: Interactable {
    var router: BiasRootRouting? { get set }
    var listener: BiasRootListener? { get set }
}

protocol BiasRootViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class BiasRootRouter: ViewableRouter<BiasRootInteractable, BiasRootViewControllable>, BiasRootRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: BiasRootInteractable, viewController: BiasRootViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
