//
//  BiasRootViewController.swift
//  kakaobank-flex
//
//  Created by 김수아 on 2023/06/29.
//

import RIBs
import RxSwift
import UIKit
import SDWebImage

protocol BiasRootPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class BiasRootViewController: UIViewController, BiasRootPresentable, BiasRootViewControllable {
    
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

import FlexLayout
import PinLayout

final class BiasRootView: UIView{
    var cornerRadius: CGFloat = 32{
        didSet{
            updateCornerRadius()
        }
    }
    var minStickyHeight: CGFloat = 300{
        didSet{
            updateMinStickyHeight()
        }
    }
    var panProgressDidChange: ((CGFloat) -> Void)? = nil
    
    private let topView = {
        let view = UIView()
        return view
    }()
    private let imageContainer = {
        let view = UIView()
        return view
    }()
    private let dimmedView = {
        let view = UIImageView()
        view.backgroundColor = .gray
        return view
    }()
    private let imageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.sd_setImage(with: URL(string: "https://picsum.photos/1440"))
        return view
    }()
    private let panContainer = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        return view
    }()
    
    private var maxStickyHeight: CGFloat{
        frame.height - safeAreaInsets.top - cornerRadius
    }
    private var stickyHeight: CGFloat = 0{
        didSet{
            setNeedsLayout()
        }
    }
    private var startHeight: CGFloat = 0
    private var panProgress: CGFloat = 0{
        didSet{
            updatePanProgress()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageContainer)
        imageContainer.addSubview(imageView)
        imageContainer.addSubview(dimmedView)
        addSubview(panContainer)
        addSubview(topView)
        
        updateMinStickyHeight()
        updateCornerRadius()
        updatePanProgress()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        panContainer.addGestureRecognizer(panGestureRecognizer)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("sdsd")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topView.pin.top()
            .horizontally(0)
            .height(safeAreaInsets.top)
        
        imageContainer.pin.top()
            .horizontally()
            .bottom(stickyHeight)
        
        imageView.pin.all()
        
        dimmedView.pin.all()
        
        panContainer.pin.below(of: imageView)
            .marginTop(-cornerRadius)
            .horizontally()
            .bottom()
    }
    
    @objc private func panGesture(_ recognizer: UIPanGestureRecognizer){
        let translation = recognizer.translation(in: self)
        
        switch recognizer.state{
        case .began:
            startHeight = stickyHeight
        case .changed:
            stickyHeight = startHeight - translation.y
            
            notifyPanProgress()
        case .cancelled, .ended:
            snapPanContainer(animated: true)
        default:
            break
        }
    }
    
    private func updateMinStickyHeight(){
        stickyHeight = minStickyHeight
        startHeight = minStickyHeight
        setNeedsLayout()
    }
    
    private func updateCornerRadius(){
        panContainer.layer.cornerRadius = cornerRadius
        setNeedsLayout()
    }
    
    private func updatePanProgress(){
        self.dimmedView.alpha = panProgress * 0.4
    }
    
    private func snapPanContainer(animated: Bool){
        let snap = {
            self.stickyHeight = max(self.minStickyHeight, min(self.maxStickyHeight, self.stickyHeight))
        }
        
        if animated{
            UIView.animate(
                withDuration: 0.2,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.2
            ) {
                snap()
                self.layoutIfNeeded()
            }
        }else{
            snap()
        }
    }
    
    private func notifyPanProgress(){
        var panProgress = (stickyHeight - minStickyHeight) / abs(maxStickyHeight - minStickyHeight)
        panProgress = max(0, min(1, panProgress))
        self.panProgress = panProgress

        panProgressDidChange?(panProgress)
    }
}
