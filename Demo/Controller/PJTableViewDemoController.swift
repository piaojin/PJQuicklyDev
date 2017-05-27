//
//  PJTableViewDemoController.swift
//  PJQuicklyDev
//
//  Created by 飘金 on 2017/4/13.
//  Copyright © 2017年 飘金. All rights reserved.
//

import UIKit

class PJTableViewDemoDataSource: PJBaseTableViewDataSourceAndDelegate{
    // MARK: /***********必须重写以告诉表格什么数据模型对应什么cell*************/
    override func tableView(tableView: UITableView, cellClassForObject object: AnyObject?) -> AnyClass {
        if let _ = object?.isKind(of: ExpressItemModel.classForCoder()){
            return ExpressTableViewCell.classForCoder()
        }
        return super.tableView(tableView: tableView, cellClassForObject: object)
    }
}

class PJTableViewDemoController: PJBaseTableViewController {

    lazy var pjTableViewDemoDataSource : PJTableViewDemoDataSource = {
        let tempDataSource = PJTableViewDemoDataSource(dataSourceWithItems: nil)
        // TODO: /*******cell点击事件*******/
        tempDataSource.cellClickClosure = {
            (tableView:UITableView,indexPath : IndexPath,cell : UITableViewCell,object : Any?) in
            PJSVProgressHUD.showSuccess(withStatus: "点击了cell")
        }
        
        // TODO: /************cell的子控件的点击事件************/
        tempDataSource.subVieClickClosure = {
            (sender:AnyObject?, object:AnyObject?) in
            
        }
        return tempDataSource
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: 第一步:/******发起网络请求,默认get请求******/
        self.doRequest()
    }
    
    override func initView() {
        self.title = "快递查询"
    }
}

/**
 *   子类重写
 */
extension PJTableViewDemoController{
    
    /**
     *   第二步:子类重写，网络请求完成
     */
    override func requestDidFinishLoad(success: AnyObject?, failure: AnyObject?) {
        if let response = success{
            let expressModel : ExpressModel = ExpressModel.mj_object(withKeyValues: response)
            self.updateView(expressModel: expressModel)
        }
    }
 
    // MARK: 第三步:
    func updateView(expressModel : ExpressModel){
        // TODO: - 注意此处添加网络返回的数据到表格代理数据源中
        self.pjTableViewDemoDataSource.addItems(items: expressModel.data)
        // TODO: - 更新表格显示self.createDataSource(),该调用会在父类进行,子类无需再次手动调用
    }
    
    /**
     *   子类重写，网络请求失败
     */
    override func requestDidFailLoadWithError(failure: AnyObject?) {
        
    }
    
    /**
     *   子类重写，以设置tableView数据源
     */
    override func createDataSource(){
        self.dataSourceAndDelegate = self.pjTableViewDemoDataSource
    }
    
    // MARK: 网络请求地址
    override func getRequestUrl() -> String{
        return "http://www.kuaidi100.com/query"
    }
    
    // MARK: 网络请求参数
    override func getParams() -> [String:Any]{
        return ["type":"shentong","postid":"3330209976637"]
    }
}
