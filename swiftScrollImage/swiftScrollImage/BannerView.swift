//
//  BannerView.swift
//  swiftScrollImage
//
//  Created by 李根 on 16/7/2.
//  Copyright © 2016年 ligen. All rights reserved.
//

import Foundation
import UIKit
/*
 滚动方向
 水平
 垂直
 */
enum BannerViewStyle : Int {
    case BannerView_Landscape
    case BannerView_Portait
}

/*
 pageControl显示位置
 不显示
 显示在右边
 显示在左边
 显示在中间
 */
enum PageStyle : Int {
    case PageStyle_None
    case PageStyle_Left
    case PageStyle_Right
    case PageStyle_Middle
}

protocol BannerViewDelegate {
    func bannerViewDidSelected(bannerView: BannerView, index: Int)
    func bannerViewDidClosed(bannerView: BannerView)
}

class BannerView: UIView, UIScrollViewDelegate {
    var delegate: BannerViewDelegate?
    var imageArr: NSArray?
    var scrollStyle: BannerViewStyle?
    var scrollTime: NSTimeInterval?
    private var totalCount: Int?
    private var pageController: UIPageControl?
    private var enableScroll: Bool?
    private var scrollView: UIScrollView?
    private var closeButton: UIButton?
    private var totalPage: Int?
    private var currentPage: Int?
    
    var normalColor: UIColor? {
        //  给normalColor赋值后进行
        didSet {
            pageController?.pageIndicatorTintColor = normalColor
        }
    }
    
    var selectedColor: UIColor? {
        didSet {
            pageController?.currentPageIndicatorTintColor = selectedColor
        }
    }
    
    //  designated初始化 (构造函数)
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    //  调用上面函数必须调用此函数
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //  反初始化 (析构函数)
    deinit {
        self.delegate = nil;
    }
    
    //  补充初始化 (并不能被子类super)
    convenience init(frame: CGRect, direction: BannerViewStyle, images: NSArray) {
        //  必须调用构造函数
        self.init(frame: frame)
        self.clipsToBounds = true
        self.imageArr = images
        self.scrollStyle = direction
        self.totalPage = images.count
        self.totalCount = images.count
        self.currentPage = 1
        self.scrollView = UIScrollView(frame: self.bounds)
        self.scrollView!.backgroundColor = UIColor.clearColor()
        self.scrollView!.showsHorizontalScrollIndicator = false
        self.scrollView!.showsVerticalScrollIndicator = false
        self.scrollView!.pagingEnabled = true
        self.scrollView!.delegate = self
        self.addSubview(self.scrollView!)
        
        if scrollStyle == BannerViewStyle.BannerView_Landscape {
            self.scrollView!.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height)
        }
        else if scrollStyle == BannerViewStyle.BannerView_Portait {
            self.scrollView!.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height * 3)
        }
        
        for i in 0 ..< 3 {
            let imageView = UIImageView(frame: self.bounds)
            imageView.userInteractionEnabled = true
            imageView.tag = 100 + i
            let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
            imageView.addGestureRecognizer(singleTap)
            if scrollStyle == BannerViewStyle.BannerView_Landscape {
                imageView.frame = CGRectOffset(imageView.frame, self.bounds.size.width * CGFloat (i), 0)
            }
            else if scrollStyle == BannerViewStyle.BannerView_Portait {
                imageView.frame = CGRectOffset(imageView.frame, 0, self.bounds.size.height * CGFloat(i))
            }
            self.scrollView!.addSubview(imageView)
            if images.count >= 3 {
                imageView.image = UIImage(named: images[i] as! String)
            }
            
        }
        
        self.pageController = UIPageControl(frame: CGRectMake(5, frame.size.height - 15, 60, 15))
        self.pageController!.numberOfPages = images.count
        self.addSubview(self.pageController!)
        self.pageController?.currentPage = 0
        print(enableScroll)
        
    }
    
    //  tap点击事件
    func tapAction(tap: UITapGestureRecognizer) {
        self.delegate?.bannerViewDidSelected(self, index: self.currentPage! - 1)
    }
    func startScrolling() {
        if self.imageArr!.count == 1 {
            return
        }
        self.stopScrolling()
        self.enableScroll = true
        self.performSelector(#selector(self.scrollingAction), withObject: nil, afterDelay: self.scrollTime!)
        
    }
    
    func stopScrolling() {
        self.enableScroll = false
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(self.scrollingAction), object: nil)
    }
    
    private func getPageIndex(index: Int) -> Int {
        var pageIndex: Int = index
        if index == 0 {
            pageIndex = self.totalPage!
        }
        if index == self.totalPage! + 1 {
            pageIndex = 1
        }
        return pageIndex
    }
    
    private func refreshScrollView() {
        let images = self.getImagesWithPageIndex(self.currentPage!)
        for i in 0 ..< 3 {
            let imageView = self.scrollView!.viewWithTag(100 + i) as! UIImageView
            let imageName = images[i] as! String
            imageView.image = UIImage(named: imageName)
        }
        
        if scrollStyle == BannerViewStyle.BannerView_Landscape {
            self.scrollView!.contentOffset = CGPointMake(self.bounds.size.width, 0)
        }
        else if scrollStyle == BannerViewStyle.BannerView_Portait {
            self.scrollView!.contentOffset = CGPointMake(0, self.bounds.size.height)
        }
        self.pageController!.currentPage = self.currentPage! - 1
    }
    
    private func getImagesWithPageIndex(pageIndex: Int) -> NSArray {
        let pre: Int = self.getPageIndex(self.currentPage! - 1)
        let last: Int = self.getPageIndex(self.currentPage! + 1)
        let images = NSMutableArray.init(capacity: 0)
        images.addObject(self.imageArr![pre - 1])
        images.addObject(self.imageArr![self.currentPage! - 1])
        images.addObject(self.imageArr![last - 1])
        return images
    }
    
    func scrollingAction() {
        UIView.animateWithDuration(0.25, animations: { 
            if self.scrollStyle == BannerViewStyle.BannerView_Landscape {
                self.scrollView!.contentOffset = CGPointMake(self.bounds.size.width * 1.99, 0)
            }
            else if self.scrollStyle == BannerViewStyle.BannerView_Portait {
                self.scrollView!.contentOffset = CGPointMake(0, 1.99 * self.bounds.size.height)
            }
            
        }) { (finished: Bool) in
            if finished {
                self.currentPage = self.getPageIndex(self.currentPage! + 1)
                self.refreshScrollView()
                if self.enableScroll != nil {
                    NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(self.scrollingAction), object: nil)
                    self.performSelector(#selector(self.scrollingAction), withObject: nil, afterDelay: self.scrollTime!, inModes: [NSRunLoopCommonModes])
                }
            }
        }
    }
    
    func setSquare(asquare: CGFloat) {
        if self.scrollView != nil {
            self.scrollView!.layer.cornerRadius = asquare
            if asquare == 0 {
                self.scrollView!.layer.masksToBounds = false
            }
            else {
                self.scrollView!.layer.masksToBounds = true
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let y = scrollView.contentOffset.y
        if self.enableScroll != nil {
            NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(self.scrollingAction), object: nil)
        }
        if scrollStyle == BannerViewStyle.BannerView_Landscape {
            if x >= self.bounds.size.width * 2 {
                currentPage = self.getPageIndex(self.currentPage! + 1)
                self.refreshScrollView()
            }
            if x <= 0 {
                currentPage = self.getPageIndex(self.currentPage! - 1)
                self.refreshScrollView()
            }
        }
        else if scrollStyle == BannerViewStyle.BannerView_Portait {
            if y >= self.bounds.size.height * 2 {
                currentPage = self.getPageIndex(self.currentPage! + 1)
                self.refreshScrollView()
            }
            else if y <= 0 {
                currentPage = self.getPageIndex(self.currentPage! - 1)
                self.refreshScrollView()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollStyle == BannerViewStyle.BannerView_Landscape {
            scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0)
        }
        else if scrollStyle == BannerViewStyle.BannerView_Portait {
            scrollView.contentOffset = CGPointMake(0, self.bounds.size.height)
        }
        
        if self.enableScroll != nil {
            NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(self.scrollingAction), object: nil)
            self.performSelector(#selector(self.scrollingAction), withObject: nil, afterDelay: self.scrollTime!, inModes: [NSRunLoopCommonModes])
        }
    }

    func setPageControlStyle(pageStyle: PageStyle) {
        if pageStyle == PageStyle.PageStyle_Left {
            self.pageController!.frame = CGRectMake(5, self.bounds.size.height - 15, 60, 15)
        }
        else if pageStyle == PageStyle.PageStyle_Right {
            self.pageController!.frame = CGRectMake(self.bounds.size.width - 60, self.bounds.size.height - 15, 60, 15)
        }
        else if pageStyle == PageStyle.PageStyle_Middle {
            self.pageController!.frame = CGRectMake((self.bounds.size.width - 60) / 2, self.bounds.size.height - 15, 60, 15)
        }
        else if pageStyle == PageStyle.PageStyle_None {
            self.pageController!.hidden = true
        }
    }
}




























