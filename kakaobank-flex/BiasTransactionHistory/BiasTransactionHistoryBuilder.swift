//
//  BiasTransactionHistoryBuilder.swift
//  kakaobank-flex
//
//  Created by 김수아 on 2023/06/30.
//

import RIBs

protocol BiasTransactionHistoryDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class BiasTransactionHistoryComponent: Component<BiasTransactionHistoryDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol BiasTransactionHistoryBuildable: Buildable {
    func build(withListener listener: BiasTransactionHistoryListener) -> BiasTransactionHistoryRouting
}

final class BiasTransactionHistoryBuilder: Builder<BiasTransactionHistoryDependency>, BiasTransactionHistoryBuildable {

    override init(dependency: BiasTransactionHistoryDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: BiasTransactionHistoryListener) -> BiasTransactionHistoryRouting {
        let component = BiasTransactionHistoryComponent(dependency: dependency)
        let viewController = BiasTransactionHistoryViewController()
        let interactor = BiasTransactionHistoryInteractor(presenter: viewController)
        interactor.listener = listener
        return BiasTransactionHistoryRouter(interactor: interactor, viewController: viewController)
    }
}
