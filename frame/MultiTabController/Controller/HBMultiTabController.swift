//
//  HBMultiTabController.swift
//  frame
//
//  Created by apple on 2021/5/7.
//  Copyright © 2021 yl. All rights reserved.
//

import Foundation

@objc protocol HBMultiTabDelegate: NSObjectProtocol {
    // 横向collectionView滑动
    func multiTabController(_ viewController: HBMultiTabController, pageScrollViewDidScroll scrollView: UIScrollView)
    func multiTabController(_ viewController: HBMultiTabController, pageScrollViewDidEndDecelerating scrollView: UIScrollView)
    func multiTabController(_ viewController: HBMultiTabController, pageScrolllViewDidEndScrollingAnimation scrollView: UIScrollView)
    // mainScrollView 滑动
    func multiTabController(_ viewController: HBMultiTabController, mainScrollViewDidScroll scrollView: UIScrollView)
    // 子列表将要显示
    @objc optional func multiTabController(_ viewController: HBMultiTabController, willDisplay index: Int)
    // 子列表显示
    @objc optional func multiTabController(_ viewController: HBMultiTabController, displaying index: Int)
    // 子列已经显示
    @objc optional func multiTabController(_ viewController: HBMultiTabController, didEndDisplaying index: Int)
}

@objc protocol HBMultiTabDataSource: NSObjectProtocol {
    // 向外部要头部View
    func headerViewForMultiTabController(_ viewController: HBMultiTabController) -> UIView?
    // 向外部要tab child vc 数量
    func numberOfChildViewController(_ viewController: HBMultiTabController) -> Int
    // 向外部要title数据
    func titleOfTabView(_ viewController: HBMultiTabController) -> String
    // 向外部要tab child vc
    func multiTabController(_ viewController: HBMultiTabController, childViewController index: Int) -> HBMultiTabChildController?
}

class HBMultiTabController: UIViewController {
    
    // MARK: - Public Preproty
    weak var delegate: HBMultiTabDelegate?
    weak var dataSource: HBMultiTabDataSource?
    
    // MARK: - Private Preproty
    private lazy var mainScrollView: HBCommonTabScrollView = {
        let mainScrollView = HBCommonTabScrollView()
        mainScrollView.delegate = self
        mainScrollView.bounces = true
        mainScrollView.showsVerticalScrollIndicator = false
        return mainScrollView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.register(HBCommonTabItemCell.self, forCellWithReuseIdentifier: NSStringFromClass(HBCommonTabItemCell.self))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    private lazy var tabView: HBMultiTabView = {
        let tabConfig = HBMultiTabViewConfig()
        let tabView = HBMultiTabView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: tabConfig.tabViewHeight), titles: ["热点", "推荐", "周边"], config: tabConfig)
        tabView.delegate = self
        return tabView
    }()
    
    private var headerView: UIView!
//    private var tabView: UIView!
    private var tabCount: Int = 0
    private var currentIndex: Int = 0
    private var titleBarHeight: CGFloat = 0.0
    private var isHiddenHeaderView: Bool = false
    //记录刚开始时的偏移量
    private var startOffsetX: CGFloat = 0
    // 缓存所有的子列表，避免重复向调用方去索要
    private var childVCDic: [Int: HBMultiTabChildController] = [:]
    // 判断是否点击title来滚动页面
    private var mIsClickTitle: Bool = false
    // 页面的高度偏移量
    private var offsetHeight: CGFloat = 0
    
    var isHeaderViewHidden: Bool = false {
        didSet {
            if isHeaderViewHidden {
                mainScrollView.contentOffset = CGPoint(x: 0, y: headerView.frame.height - titleBarHeight)
            }
        }
    }
    
    var isHorizontalScrollEnable: Bool = true {
        didSet {
            self.collectionView.isScrollEnabled = isHorizontalScrollEnable
        }
    }
    
    var isBounces: Bool = false {
        didSet {
            self.mainScrollView.bounces = isBounces
        }
    }
    
    init(config: HBMultiTabViewConfig, dataSource: HBMultiTabDataSource, delegate: HBMultiTabDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.dataSource = dataSource
        self.delegate = delegate
        
//        self.tabView
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        if #available(iOS 11.0, *) {
            mainScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    public func move(to: Int, animated: Bool) {
        self.currentIndex = to
        mIsClickTitle = true
        view.isUserInteractionEnabled = false
        collectionView.scrollToItem(at: IndexPath.init(row: to, section: 0), at: .centeredHorizontally, animated: false)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.view.isUserInteractionEnabled = true
        }
    }
    
    // 处理右滑退出手势冲突问题
    public func handlePopGestureRecognizer(navi: UINavigationController) {
        if let popGestureRecognizer = navi.interactivePopGestureRecognizer {
            collectionView.panGestureRecognizer.require(toFail: popGestureRecognizer)
        }
    }

    public func resetChildViewControllers(tabCount: Int) {
        // 清空原来的父控制器
        childVCDic.forEach { (dic: (key: Int, value: HBMultiTabChildController)) in
            dic.value.removeFromParent()
        }
        mainScrollView.scrollViewWhites?.removeAll()
        self.childVCDic.removeAll()
        self.tabCount = tabCount
        self.collectionView.reloadData()
    }

    private func configViews() {
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(headerView)
        mainScrollView.addSubview(tabView)
        mainScrollView.addSubview(collectionView)
        mainScrollView.frame = view.bounds
        mainScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - self.offsetHeight)
        mainScrollView.contentSize = CGSize(width: 0, height: mainScrollView.frame.height + headerView.frame.height)
        tabView.frame.origin.y = headerView.frame.maxY
        collectionView.frame.origin.y = tabView.frame.maxY
        collectionView.frame.size = CGSize(width: view.frame.width, height: mainScrollView.contentSize.height - tabView.frame.maxY)
        if self.isHiddenHeaderView {
            mainScrollView.contentOffset = CGPoint(x: 0, y: headerView.frame.height - titleBarHeight)
            self.isHiddenHeaderView = false
        }
    }

    // 预取，暂定预取前1和后1
    private func prefetchChildVC(currentIndex: Int) {
        let preIndex = max(0, currentIndex - 1)
        let afterIndex = min(tabCount - 1, currentIndex + 1)
        if self.childVCDic[preIndex] == nil {
            getChildVC(index: preIndex)
        }
        if self.childVCDic[afterIndex] == nil {
            getChildVC(index: afterIndex)
        }
    }
    
    private func getChildVC(index: Int) {
        if let childVC = dataSource?.multiTabController(self, childViewController: index) {
            self.addChild(childVC)
            childVC.scrollDelegate = self
            childVCDic[index] = childVC
            if let scrollView = childVC.getScrollView() {
                mainScrollView.scrollViewWhites?.insert(scrollView)
            }
        }
    }
}

extension HBMultiTabController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var resultCell = UICollectionViewCell()
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(HBCommonTabItemCell.self), for: indexPath) as? HBCommonTabItemCell {
            if let childVC = self.childVCDic[indexPath.row] {
                cell.configView(view: childVC.view)
                resultCell = cell
            } else {
                if let vc = dataSource?.multiTabController(self, childViewController: indexPath.row) {
                    self.addChild(vc)
                    vc.scrollDelegate = self
                    childVCDic[indexPath.row] = vc
                    if let scview = vc.getScrollView() {
                        mainScrollView.scrollViewWhites?.insert(scview)
                    }
                    cell.configView(view: vc.view)
                    resultCell = cell
                }
            }
            
        }
        if indexPath.row < tabCount {
            delegate?.multiTabController?(self, displaying: indexPath.row)
        }
        return resultCell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row < tabCount {
            delegate?.multiTabController?(self, willDisplay: indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row < tabCount {
            delegate?.multiTabController?(self, didEndDisplaying: indexPath.row)
        }
    }
}

extension HBMultiTabController: HBMultiTabChildDelegate {
    func tabChildController(_ viewController: HBMultiTabChildController, scrollViewDidScroll scrollView: UIScrollView) {
        
        if mainScrollView.contentOffset.y < (headerView.frame.height - titleBarHeight) {
            let child = childVCDic[currentIndex]
            child?.offsetY = 0
        }
    }
}

extension HBMultiTabController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.mIsClickTitle = false
        self.startOffsetX = scrollView.contentOffset.x
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        mainScrollView.isScrollEnabled = true
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        mainScrollView.isScrollEnabled = true
        currentIndex = collectionView.indexPathsForVisibleItems.first?.row ?? 0
        if scrollView == collectionView {
            delegate?.multiTabController(self, pageScrollViewDidEndDecelerating: scrollView)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        mainScrollView.isScrollEnabled = true
        if scrollView == collectionView {
            delegate?.multiTabController(self, pageScrolllViewDidEndScrollingAnimation: scrollView)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == mainScrollView {
            mainScrollView.isScrollEnabled = true
            if currentIndex < tabCount {
                if let child = childVCDic[currentIndex] {
                    if child.offsetY > 0 || scrollView.contentOffset.y >= headerView.frame.height - titleBarHeight {
                        scrollView.contentOffset = CGPoint(x: 0, y: headerView.frame.height - titleBarHeight)
                    } else {
                        childVCDic.forEach { (dic: (key: Int, value: HBMultiTabChildController)) in
                            dic.value.offsetY = 0
                        }
                    }
                }
            }
            delegate?.multiTabController(self, mainScrollViewDidScroll: mainScrollView)
        } else if scrollView == collectionView {
            if !mIsClickTitle {
                delegate?.multiTabController(self, pageScrollViewDidScroll: scrollView)
            }
        }
    }
}

extension HBMultiTabController: HBMultiTabViewDelegate, HBMultiTabViewDataSource {
    func multipleTabView(multiTabView: HBMultiTabView, didSelectedIndex index: Int) {
        self.move(to: index, animated: false)
    }
    
    func numeberOfTab(multiTabView: HBMultiTabView) -> Int {
        return dataSource?.numberOfChildViewController(self) ?? 0
    }
    
    func multipleTabView(multiTabView: HBMultiTabView, titleForIndex index: Int) -> String {
        return dataSource?.titleOfTabView(self) ?? ""
    }
}
