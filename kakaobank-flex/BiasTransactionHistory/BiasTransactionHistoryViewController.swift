//
//  BiasTransactionHistoryViewController.swift
//  kakaobank-flex
//
//  Created by 김수아 on 2023/06/30.
//

import RIBs
import RxSwift
import UIKit

protocol BiasTransactionHistoryPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class BiasTransactionHistoryViewController: UIViewController, BiasTransactionHistoryPresentable, BiasTransactionHistoryViewControllable {
    

    weak var listener: BiasTransactionHistoryPresentableListener?
    
    override func loadView() {
        view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
    
    // MARK: FilePrivate
    
    fileprivate static let identifier = String(describing: UITableView.self)
    
    // MARK: Private
    
    private lazy var tableView = {
        let view = UITableView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: Self.identifier)
        return view
    }()
}

extension BiasTransactionHistoryViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.identifier) else{
            return UITableViewCell()
        }
        var config = cell.defaultContentConfiguration()
        config.text = "100000"
        cell.contentConfiguration = config
        return cell
    }
}
