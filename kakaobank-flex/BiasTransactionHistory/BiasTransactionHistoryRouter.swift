//
//  BiasTransactionHistoryRouter.swift
//  kakaobank-flex
//
//  Created by 김수아 on 2023/06/30.
//

import RIBs

protocol BiasTransactionHistoryInteractable: Interactable {
    var router: BiasTransactionHistoryRouting? { get set }
    var listener: BiasTransactionHistoryListener? { get set }
}

protocol BiasTransactionHistoryViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class BiasTransactionHistoryRouter: ViewableRouter<BiasTransactionHistoryInteractable, BiasTransactionHistoryViewControllable>, BiasTransactionHistoryRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: BiasTransactionHistoryInteractable, viewController: BiasTransactionHistoryViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
