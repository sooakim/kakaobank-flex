//
//  BiasRootBuilder.swift
//  kakaobank-flex
//
//  Created by 김수아 on 2023/06/29.
//

import RIBs

protocol BiasRootDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class BiasRootComponent: Component<BiasRootDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol BiasRootBuildable: Buildable {
    func build(withListener listener: BiasRootListener) -> BiasRootRouting
}

final class BiasRootBuilder: Builder<BiasRootDependency>, BiasRootBuildable {

    override init(dependency: BiasRootDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: BiasRootListener) -> BiasRootRouting {
        let component = BiasRootComponent(dependency: dependency)
        let viewController = BiasRootViewController()
        let interactor = BiasRootInteractor(presenter: viewController)
        interactor.listener = listener
        
        let transactionHistoryBuilder = BiasTransactionHistoryBuilder(dependency: component)
        return BiasRootRouter(
            interactor: interactor,
            viewController: viewController,
            transactionHistoryBuilder: transactionHistoryBuilder
        )
    }
}
