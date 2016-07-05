//
//  ViewController.swift
//  swiftScrollImage
//
//  Created by 李根 on 16/7/2.
//  Copyright © 2016年 ligen. All rights reserved.
//

import UIKit

class ViewController: UIViewController,BannerViewDelegate {
    
    var bannerView: BannerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let images = ["1p.jpg", "2p.jpg", "3p.jpg", "4p.jpg", "5p.jpg"]
        bannerView = BannerView.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 200), direction: BannerViewStyle.BannerView_Landscape, images: images)
        bannerView?.backgroundColor = UIColor.redColor()
        bannerView!.scrollTime = 2.0
        bannerView!.delegate = self
        bannerView!.normalColor = UIColor.redColor()
        bannerView!.selectedColor = UIColor.blueColor()
        bannerView!.setSquare(5)
        bannerView!.setPageControlStyle(PageStyle.PageStyle_Middle)
        self.view.addSubview(bannerView!)
        bannerView!.startScrolling()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func bannerViewDidClosed(bannerView: BannerView) {
        
    }
    
    func bannerViewDidSelected(bannerView: BannerView, index: Int) {
        print("selected\(String(index))")
    }
    
    
    
    
    
    
    
    
    
    
    
    

}

