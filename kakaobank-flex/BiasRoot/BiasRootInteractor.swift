//
//  BiasRootInteractor.swift
//  kakaobank-flex
//
//  Created by 김수아 on 2023/06/29.
//

import RIBs
import RxSwift

protocol BiasRootRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol BiasRootPresentable: Presentable {
    var listener: BiasRootPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol BiasRootListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class BiasRootInteractor: PresentableInteractor<BiasRootPresentable>, BiasRootInteractable, BiasRootPresentableListener {

    weak var router: BiasRootRouting?
    weak var listener: BiasRootListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: BiasRootPresentable) {
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
