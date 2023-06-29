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
    var accountAliasName: String = "마카오적금"{
        didSet{
            updateAccountAliasName()
        }
    }
    var balance: String = "99999원"{
        didSet{
            updateBalance()
        }
    }
    var panProgressDidChange: ((CGFloat) -> Void)? = nil
    var childView: View? = nil{
        didSet{
            otherGestureRecognizer = nil
            
            if let oldValue{
                oldValue.removeFromSuperview()
            }
            if let childView{
                self.panContainer.addSubview(childView)
            }
            setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageContainer)
        imageContainer.addSubview(imageView)
        imageContainer.addSubview(dimmedView)
        
        imageContainer.addSubview(textContainer)
        textContainer.addSubview(titleLabel)
        textContainer.addSubview(balanceLabel)
        
        addSubview(panContainer)
        addSubview(topView)
        
        updateMinStickyHeight()
        updateCornerRadius()
        updatePanProgress()
        updateAccountAliasName()
        updateBalance()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        panGestureRecognizer.delegate = self
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
        
        textContainer.pin
            .horizontally(safeAreaInsets)
        
        balanceLabel.pin.bottom()
            .horizontally()
            .sizeToFit(.widthFlexible)
            .justify(.center)
        
        titleLabel.pin.above(of: balanceLabel)
            .sizeToFit(.widthFlexible)
            .horizontally()
            .marginBottom(8)
            .justify(.center)
        
        textContainer.pin.bottom()
            .horizontally(safeAreaInsets)
            .wrapContent()
            .marginBottom(cornerRadius + 16)
            .justify(.center)
        
        imageView.pin.all()
        
        dimmedView.pin.all()
        
        panContainer.pin.below(of: imageView)
            .marginTop(-cornerRadius)
            .horizontally()
            .bottom()
        
        childView?.pin
            .all()
    }
    
    // MARK: Private
    
    fileprivate var otherGestureRecognizer: UIGestureRecognizer? = nil{
        didSet{
            guard otherGestureRecognizer !== oldValue else{ return }
            
            if let otherGestureRecognizer, let scrollView = otherGestureRecognizer.view as? UIScrollView{
                contentOffsetObservation = scrollView.observe(\.contentOffset, options: [.new, .old]) { [weak self] view, changed in
                    guard let self = self else{ return }
                    guard let oldValue = changed.oldValue, let newValue = changed.newValue else{ return }
                    guard oldValue.y != newValue.y else{ return }
                    if newValue.y < .zero {
                        self.isScrolling = false
                        return
                    }
                    
                    var isScrolling = self.panProgress == 1
                    if !isScrolling{
                        view.contentOffset = .zero
                    }
                    self.isScrolling = isScrolling
                }
            }else{
                contentOffsetObservation = nil
            }
        }
    }
    private var contentOffsetObservation: NSKeyValueObservation? = nil
    
    fileprivate var maxStickyHeight: CGFloat{
        frame.height - safeAreaInsets.top - cornerRadius
    }
    fileprivate var stickyHeight: CGFloat = 0{
        didSet{
            updateStickyHeight()
        }
    }
    private var panProgress: CGFloat = 0{
        didSet{
            updatePanProgress()
        }
    }
    private var isScrolling: Bool = false
    
    private let topView = {
        let view = UIView()
        return view
    }()
    private let imageContainer = {
        let view = UIView()
        return view
    }()
    private let textContainer = {
        let view = UIView()
        return view
    }()
    private let titleLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16, weight: .regular)
        view.textColor = .white
        return view
    }()
    private let balanceLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 32, weight: .medium)
        view.textColor = .white
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
    
    @objc private func panGesture(_ recognizer: UIPanGestureRecognizer){
        if isScrolling{
            makeStickyHeightInRange()
            recognizer.setTranslation(.zero, in: self)
            return
        }
        
        let translation = recognizer.translation(in: self)
        defer{ recognizer.setTranslation(.zero, in: self) }
        
        switch recognizer.state{
        case .began, .changed:
            stickyHeight -= translation.y
        case .cancelled, .ended:
            snapPanContainer(animated: true)
        default:
            break
        }
    }
    
    private func updateMinStickyHeight(){
        stickyHeight = minStickyHeight
        setNeedsLayout()
    }
    
    private func updateCornerRadius(){
        panContainer.layer.cornerRadius = cornerRadius
        setNeedsLayout()
    }
    
    private func updateAccountAliasName(){
        titleLabel.text = accountAliasName
        setNeedsLayout()
    }
    
    private func updateBalance(){
        balanceLabel.text = balance
        setNeedsLayout()
    }
    
    private func updatePanProgress(){
        self.dimmedView.alpha = panProgress * 0.4
    }
    
    private func updateStickyHeight(){
        if stickyHeight > minStickyHeight{
            let translationY = (stickyHeight - minStickyHeight) / 2
            textContainer.transform = CGAffineTransform(translationX: 0, y: translationY)
        }else{
            textContainer.transform = CGAffineTransform(translationX: 0, y: 0)
        }
        
        setNeedsLayout()
        notifyPanProgress()
    }
    
    private func makeStickyHeightInRange(){
        stickyHeight = max(minStickyHeight, min(maxStickyHeight, stickyHeight))
    }
    
    private func snapPanContainer(animated: Bool){
        let snap = {
            self.makeStickyHeightInRange()
            
            if self.panProgress > 0.4{
                self.stickyHeight = self.maxStickyHeight
            }else{
                self.stickyHeight = self.minStickyHeight
            }
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

extension BiasRootView: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let scrollView = otherGestureRecognizer.view as? UIScrollView, scrollView.panGestureRecognizer === otherGestureRecognizer{
            self.otherGestureRecognizer = otherGestureRecognizer
        }
        return true
    }
}
