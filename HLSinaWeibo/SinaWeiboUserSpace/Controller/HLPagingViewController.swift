//
//  HLPagingTableViewController.swift
//  HLSinaWeibo
//
//  Created by jsbios on 2018/3/8.
//  Copyright © 2018年 Dianzhi. All rights reserved.
//

import UIKit

let CYTStatusBarHeight = UIApplication.shared.statusBarFrame.height
let CYTNavigationBarHeightForSwi : CGFloat = 44.0
let CYTTabBarHeight : CGFloat = 49.0

let ScreenW = UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height ? UIScreen.main.bounds.size.height : UIScreen.main.bounds.size.width
let ScreenH = UIScreen.main.bounds.size.height > UIScreen.main.bounds.size.width ? UIScreen.main.bounds.size.height : UIScreen.main.bounds.size.width

class HLPagingViewController: UIViewController,UITableViewDelegate,HLPagingHeaderViewDelegate {

    // MARK: - var set -
    //    头部视图初始总高度
    public var headerHeight:CGFloat = 0
    //    菜单栏的高度
    public var switchMenuHeight:CGFloat = 0
    //    菜单栏与下面tableView的黑色分割线高度（要添加到tableView的头部高度中）
    public var seperatorLineHeight:CGFloat = 0

//  header覆盖在tableView上的区域的高度
    var cacu_coverHeight:CGFloat {
        get{
            return headerHeight - (CYTStatusBarHeight + CYTNavigationBarHeightForSwi)
        }
    }
//    记录当前拖动的scrollView
    var dragScrollView:UIScrollView?

    //tableView的容器，水平方向滚动
    lazy var containScrollView:UIScrollView = {
        let scrollView = UIScrollView.init()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        }else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        return scrollView
    }()
    
    //头部视图headerView
    lazy var headerView : HLPagingHeaderView = {
       let header = HLPagingHeaderView.init()
        header.backgroundColor = UIColor.red
        header.menuHeight = switchMenuHeight
        header.insetsLayoutMarginsFromSafeArea = false
        header.delegate = self
        return header
    }()
    
//    导航栏标题label
    lazy var titleLabel : UILabel = {
        let label = UILabel.init()
        label.backgroundColor = UIColor.clear
        label.text = "HL微博"
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.init(white: 1, alpha: 0)
        
        return label
    }()
    
    
    // MARK: - viewController lifeCycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSubviews()
        self.setupBar()
    }
    
    func setupBar() {
        self.navigationItem.titleView = titleLabel
//        titleLabel.alpha = 0通过设置titleLabel来设置透明不好使，必须要在viewDidAppear之后设置才有用，在之前设置无效；
        
        //isTranslucent = true之后，即使背景图是不透明的，alpha = 1.也会带一点透明效果（系统强制设定）；
        //但是如果isTranslucent = false,即使背景图是透明的，alpha = 0.系统也会强制设置为完全不透明的；
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(self.imageWithColor(color: UIColor.init(white: 1, alpha: 0)), for: UIBarMetrics.default)

        //设置extendedLayoutIncludesOpaqueBars为true之后，self.view默认坐标原点扩展到不透明的bar的上面/当然透明的本身就会；系统默认为false，此时self.view默认坐标原点只会扩展到透明的bar的上面
        self.extendedLayoutIncludesOpaqueBars = true
//      隐藏tabBar
        self.hidesBottomBarWhenPushed = true
    }
    
    func setupSubviews() {
        self.view.insetsLayoutMarginsFromSafeArea = true
        
        headerHeight = 240
        switchMenuHeight = 50
        seperatorLineHeight = 8
        
        view.addSubview(containScrollView)
        
//        第1个tableView
        let firstVC = HLProfileTableViewController.init(style: UITableViewStyle.grouped)
        firstVC.coverHeight = cacu_coverHeight + seperatorLineHeight
        containScrollView.addSubview(firstVC.view)
        self.addChildViewController(firstVC)
        
        //        第2个tableView
        let secondVC = HLWeiboTableViewController.init(style: UITableViewStyle.grouped)
        secondVC.coverHeight = cacu_coverHeight + seperatorLineHeight
        containScrollView.addSubview(secondVC.view)
        self.addChildViewController(secondVC)
        
        //        第3个tableView
        let thirdVC = HLNewsTableViewController.init(style: UITableViewStyle.grouped)
        thirdVC.coverHeight = cacu_coverHeight + seperatorLineHeight
        containScrollView.addSubview(thirdVC.view)
        self.addChildViewController(thirdVC)
        
        view.addSubview(headerView)
        headerView.frame = CGRect.init(x: 0, y: 0, width: ScreenW, height: headerHeight)
    }

    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        containScrollView.frame = CGRect.init(x: 0, y: CYTStatusBarHeight + CYTNavigationBarHeightForSwi, width:ScreenW , height: ScreenH - (CYTStatusBarHeight + CYTNavigationBarHeightForSwi))
        containScrollView.contentSize = CGSize.init(width: containScrollView.bounds.width * CGFloat(childViewControllers.count), height: containScrollView.bounds.height)
        
        for vc in childViewControllers {
            guard vc.isKind(of: UITableViewController.self) else { return }
            
            let tableVC = (vc as! UITableViewController)
            var frame = containScrollView.bounds
            frame.origin.x = containScrollView.frame.width * CGFloat(childViewControllers.index(of: vc)!)
            tableVC.view.frame = frame
            tableVC.view.backgroundColor = UIColor.gray
            tableVC.tableView.delegate = self
            }
    }
    
    //    MARK: - scrollVIew delegate -
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        跟踪当前由用户拖动的tableView（避免其他的tableView、scrollView在后面的代理方法中的干扰）
        guard scrollView.isKind(of: UITableView.self) else {
            return
        }
        dragScrollView = scrollView
        print("scrollViewWillBeginDragging,scrollView = \(scrollView)")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //只跟踪当前滚动的tableView的滚动
        guard scrollView == dragScrollView else {
            return
        }
        print(scrollView.contentOffset)

        var transform_y = scrollView.contentOffset.y
       
        //tableView同步的滚动极限
        let scrollLimit = cacu_coverHeight - switchMenuHeight + seperatorLineHeight
        
        if transform_y >  scrollLimit {
            transform_y = scrollLimit
            navigationController?.navigationBar.isTranslucent = false
        }else{
            navigationController?.navigationBar.isTranslucent = true
        }
        navigationController?.navigationBar.setBackgroundImage(self.imageWithColor(color: UIColor.init(white:1 , alpha: transform_y/scrollLimit)), for: UIBarMetrics.default)
        
        titleLabel.textColor = UIColor.init(white:0 , alpha: transform_y/scrollLimit)
        
//        因为有个seperatorLine，所有scrollView的滚动范围有可能小于带上switchMenuHeight的总高度，
        if headerHeight - transform_y < switchMenuHeight + CYTStatusBarHeight + CYTNavigationBarHeightForSwi {
//            如果滚到范围到了小于switchMenuHeight高度的时候，headerView高度保持不变
            headerView.frame = CGRect.init(x: 0, y: 0, width: ScreenW, height: switchMenuHeight + CYTStatusBarHeight + CYTNavigationBarHeightForSwi)
        }else{
            headerView.frame = CGRect.init(x: 0, y: 0, width: ScreenW, height: headerHeight - transform_y)
        }
       
        for vc in childViewControllers {
            guard vc.isKind(of: UITableViewController.self) else { return }
            let tableVC = (vc as! UITableViewController)
            
//            print(tableVC.tableView)
            
            if !(tableVC.tableView == dragScrollView) {
                //对于不是用户拖动的tableView，设置他们与拖动的tableView的contentOffset同步
                
                if transform_y == scrollLimit {
                    //headerView悬停之后，几个tableView的滚动就不用处理
                    if tableVC.tableView.contentOffset.y < scrollLimit {
                        tableVC.tableView.contentOffset = CGPoint.init(x: 0, y: scrollLimit)
                    }
                    
//                    print("scrollLimit = \(scrollLimit)")
                }else{
                    //headerView处于悬停状态前，滚动的时候保持几个tableView的滚动contentOffset一致
                    tableVC.tableView.contentOffset = scrollView.contentOffset
                    print("")
                }
            }
            
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == containScrollView else {
            return
        }
        //跟踪containScrollView的滚动，设置菜单栏的标题颜色
        headerView.setButtonSelected(index:NSInteger(scrollView.contentOffset.x/CGFloat(scrollView.frame.width)))
//        print("scrollViewDidEndDecelerating,offset = \(scrollView.contentOffset)")
    }
    
    //    MARK: - headerView delegate -
    func pagingHeaderViewButtonIsTapped(_ view: HLPagingHeaderView, atIndex index: NSInteger) {
        containScrollView.setContentOffset(CGPoint.init(x: CGFloat(index) * containScrollView.frame.width, y: 0), animated: true)
    }
    
    
    func imageWithColor(color:UIColor) -> UIImage?{
        
        let rect:CGRect    = CGRect.init(x: 0, y: 0, width: 10, height: 10)
        
        UIGraphicsBeginImageContext(rect.size)
        
        let ref:CGContext? = UIGraphicsGetCurrentContext()
        
        ref?.setFillColor(color.cgColor)
        
        ref?.fill(rect)
        
        let returnImage:UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return returnImage
    }
    
}
