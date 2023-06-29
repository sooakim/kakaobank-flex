//
//  BiasTransactionHistoryInteractor.swift
//  kakaobank-flex
//
//  Created by 김수아 on 2023/06/30.
//

import RIBs
import RxSwift

protocol BiasTransactionHistoryRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol BiasTransactionHistoryPresentable: Presentable {
    var listener: BiasTransactionHistoryPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol BiasTransactionHistoryListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class BiasTransactionHistoryInteractor: PresentableInteractor<BiasTransactionHistoryPresentable>, BiasTransactionHistoryInteractable, BiasTransactionHistoryPresentableListener {

    weak var router: BiasTransactionHistoryRouting?
    weak var listener: BiasTransactionHistoryListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: BiasTransactionHistoryPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
