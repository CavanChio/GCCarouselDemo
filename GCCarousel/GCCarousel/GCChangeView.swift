//
//  GCChangeView.swift
//  GCCarousel
//
//  Created by Cavan on 2017/2/14.
//  Copyright © 2017年 CavanZhao. All rights reserved.
//

import UIKit
import SDWebImage

class GCChangeView: UIView, UIScrollViewDelegate{

    var myScrollView: UIScrollView?
    var myPageControl: UIPageControl?
    var myImageUrlArray:NSMutableArray?
    var myTimer: Timer?
    var timerInterVal: TimeInterval?
    
    //封装轮播图需要的参数: 1.图片数组, 2.frame, 3.时间
     init(imageUrlArray:NSMutableArray, imageChangeTime:TimeInterval, frame:CGRect) {
        super.init(frame: frame)
        self.myImageUrlArray = imageUrlArray
        self.timerInterVal = imageChangeTime
        let tempArray = NSMutableArray()
        
        tempArray.add(imageUrlArray.lastObject as Any)
        for i in 0..<imageUrlArray.count {
            tempArray.add(imageUrlArray[i])
        }
        tempArray.add(imageUrlArray.firstObject as Any)
        self.initScrollViewWith(imageUrlDataSource: tempArray)
        self.initWithTimer()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initWithTimer(){
        self.myTimer = Timer(timeInterval: self.timerInterVal!, target: self, selector: #selector(timeAction), userInfo: nil, repeats: true)
        //假如runloop循环
        RunLoop.current.add(self.myTimer!, forMode: RunLoopMode.commonModes)
        //开启定时器
//        self.myTimer!.fireDate = Date.distantPast
        
    }
    
     func timeAction() {
        self.myScrollView?.setContentOffset(CGPoint(x: ((self.myScrollView?.contentOffset.x)! + (self.myScrollView?.bounds.size.width)!), y: 0), animated: true)
    }
    
    func initScrollViewWith(imageUrlDataSource:NSMutableArray) {
        self.myScrollView = UIScrollView.init(frame: self.bounds)
        self.myScrollView?.showsHorizontalScrollIndicator = false
        self.myScrollView?.contentSize = CGSize(width: CGFloat(imageUrlDataSource.count) * self.bounds.size.width, height: self.bounds.size.height)
        self.myScrollView?.contentOffset = CGPoint(x: (self.myScrollView?.frame.size.width)!, y: 0)
        self.myScrollView?.delegate = self
        self.myScrollView?.isPagingEnabled = true
        self.addSubview(self.myScrollView!)
        
        //add Image
        for index in 0 ..< imageUrlDataSource.count {
            let tempImageView = UIImageView(frame: CGRect(x: self.bounds.size.width * CGFloat(index), y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            print(tempImageView.frame)
            tempImageView.contentMode = UIViewContentMode.scaleToFill

            tempImageView.sd_setImage(with: URL(string:imageUrlDataSource[index] as! String))
            tempImageView.isUserInteractionEnabled = true
            self.myScrollView?.addSubview(tempImageView)
        }
        
        //add pageControl
        self.myPageControl = UIPageControl(frame: CGRect(x: self.bounds.size.width - 100, y: self.bounds.size.height - 30, width: 100, height: 30))
        self.myPageControl?.numberOfPages = (self.myImageUrlArray?.count)!
        self.myPageControl?.currentPage = 0
        self.addSubview(self.myPageControl!)
    }
    
    //代理方法
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let tempNum = (scrollView.contentOffset.x / scrollView.frame.size.width)
        self.myPageControl?.currentPage = NSInteger(tempNum) - 1
    }
    //将要开始拖拽, 将定时器暂停
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.myTimer?.fireDate = Date.distantFuture
    }
    //结束减速,开启定时器
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.headAndFoot()
        self.myTimer?.fireDate = Date.init(timeIntervalSinceNow: self.timerInterVal!)
    }
    //结束滚动的动画
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.headAndFoot()
    }
    //第一张和最后一张的的动画处理办法
    func headAndFoot() {
        //如果是第一张
        if self.myScrollView?.contentOffset.x == 0{
            self.myScrollView?.setContentOffset(CGPoint(x: CGFloat((self.myImageUrlArray?.count)!) * self.frame.size.width, y: 0), animated: false)
        } else if self.myScrollView?.contentOffset.x == (CGFloat((self.myImageUrlArray?.count)!) + 1) * self.frame.size.width {
            self.myScrollView?.setContentOffset(CGPoint(x: self.frame.size.width, y: 0), animated: false)
        }
    }
}
