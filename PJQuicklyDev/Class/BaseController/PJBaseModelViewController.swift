//
//  PJBaseModelViewController.swift
//  Swift3Learn
//
//  Created by 飘金 on 2017/4/11.
//  Copyright © 2017年 飘金. All rights reserved.
//

import UIKit

//刷新类型
enum PullLoadType: Int {
    case pullDefault = 0
    case pullDownRefresh //下拉
    case pullUpLoadMore  //上拉
}

class PJBaseModelViewController: PJBaseViewController {
    
    //返回模型的类型
    var returnClassName: String?
    //数据源
    lazy var items: [AnyObject]? =  {
        return [AnyObject]()
    }()
    
    /**
     *  请求参数,子类重写以设置请求参数(重写params的get)
     */
    var params:[String:Any]?
    //网络请求方式(GET,POST)
    var requestWay: PJRequestType = ._get
    /**
     *  请求地址，需要子类重写
     */
    var requestUrl: String!
    //每次网络请求返回的新的数据量
    var newItemsCount: Int = 0
    //是否正在上拉刷新
    var isPullingUp: Bool = false
    //是否正在加载
    var isLoading = false
    
    //初始化网络请求数据
    func initData() {
        self.requestUrl = self.getRequestUrl()
        self.params = self.getParams()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initData()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension PJBaseModelViewController{
    
    /**
     *  发起请求数据
     */
    func doRequest(requestWay: PJRequestType = ._get){
        PJPrintLog("网络请求的参数params: = \(String(describing: self.params))")
        self.beforeDoRequest()
        self.requestWay = requestWay
        if self.requestUrl != nil {
            /**
             *   开始网络请求，设置默认参数
             */
            PJHttpTool.pj_request(requestType: self.requestWay, params: self.params, url: self.requestUrl, success: { [unowned self](response : Any?) -> Void?
                in
                self.didFinishLoad(success: response as AnyObject, failure: nil)
            }, faild: { [unowned self](error : Any?) -> Void?
                in
                self.didFailLoadWithError(failure: error as AnyObject)
            })
            
        }else{
            PJPrintLog("requestUrl不能为空!")
        }
        self.requestDidStartLoad()
    }
    
    /**
     在网络请求之前可以做的处理
     */
    func beforeDoRequest(){
        
    }
    
    /**
     *  开始请求
     */
    func requestDidStartLoad() {
        //不是在下拉刷新
        if !self.isPullingUp {
            self.showLoading(show:true)
        }else{
            DispatchQueue.global().async {
                //如果现在加载中而且不是在下拉刷新
                DispatchQueue.main.async {
                    if self.isLoading && !self.isPullingUp {
                        self.showLoading(show:true)
                    }
                }
            }
        }
        self.showError(show:false)
        self.isLoading = true
    }
    
    /**
     *  请求完成
     */
    func didFinishLoad(success: AnyObject?, failure: AnyObject?){
        self.requestDidFinishLoad(success: success, failure: failure)
        self.onDataUpdated()
    }
    
    /**
     *  请求失败
     */
    func didFailLoadWithError(failure: AnyObject?) {
        self.requestDidFailLoadWithError(failure: failure)
        self.onLoadFailed()
    }
    
    /**
     *  请求完成后数据传递给子类，子类需要重写
     */
    func requestDidFinishLoad(success: AnyObject?, failure: AnyObject?){
        
    }
    
    /**
     *  请求失败后数据传递给子类，子类需要重写
     */
    func requestDidFailLoadWithError(failure: AnyObject?) {
        
    }
    
    /**
     *  数据开始更新
     */
    func onDataUpdated() {
        self.showLoading(show:false)
        self.showError(show:false)
        self.isLoading = false
    }
    
    /**
     *  加载失败
     */
    func onLoadFailed() {
        self.showLoading(show:false)
        self.showError(show:true)
        self.isLoading = false
    }
    
    /**
     *   添加数据，每次请求完数据调用,item中的数据即是一个个model
     *
     */
    func addItems(items: [AnyObject]?){
        if let tempItem = items{
            self.items? += items!
            self.newItemsCount = tempItem.count
        }else{
            self.newItemsCount = 0
        }
    }
    
    //添加数据，每次请求完数据调用,item即是一个model
    func addItem(item: AnyObject?){
        if let _ = item{
            self.items?.append(item!)
            self.newItemsCount = 1;
        }else{
            self.newItemsCount = 0;
        }
    }
}

/********子类需要重写的方法*********/
extension PJBaseModelViewController{
    //网络请求地址
    func getRequestUrl() -> String{
        PJPrintLog("------->子类需要重写getRequestUrl<-------")
        return "url"
    }
    
    //网络请求参数
    func getParams() -> [String:Any]{
        PJPrintLog("------->子类需要重写getParams<-------")
        return ["key":"value"]
    }
}

