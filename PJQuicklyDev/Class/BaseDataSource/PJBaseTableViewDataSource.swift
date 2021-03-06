//
//  PJBaseTableViewDataSource.swift
//  Swift3Learn
//
//  Created by 飘金 on 2017/4/12.
//  Copyright © 2017年 飘金. All rights reserved.
//

import UIKit

protocol  PJBaseTableViewDataSourceDelegate{
    
    /**
     * 子类必须实现协议,以告诉表格每个model所对应的cell是哪个
     */
    func tableView(tableView: UITableView, cellClassForObject object: AnyObject?) -> AnyClass
    
    /**
     *若为多组需要子类重写
     */
    func tableView(tableView: UITableView, indexPathForObject object: AnyObject) -> NSIndexPath?
    
    func tableView(tableView: UITableView, objectForRowAtIndexPath indexPath: IndexPath) -> AnyObject?
    
    /// MARK: 子类可以重写以获取到刚初始化的cell,可在此时做一些额外的操作
    func pj_tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, cell: UITableViewCell,object:AnyObject?)
}

/**
 * 表格的数据源和事件全部放在里面
 */
class PJBaseTableViewDataSourceAndDelegate: NSObject,UITableViewDataSource,UITableViewDelegate,PJBaseTableViewDataSourceDelegate {
    
    /**
     * 单组数据的数据源
     */
    lazy var items :[AnyObject]? = {
        return [AnyObject]()
    }()
    
    /**
     * 分组数据的数据源
     */
    lazy var sectionsItems :[AnyObject]? = {
        return [AnyObject]()
    }()
    
    /**
     * 计算cell高度的方式,自动计算(利用FDTemplateLayoutCell库)和手动frame计算,默认自动计算,如果是手动计算则cell子类需要重写class func tableView(tableView: UITableView, rowHeightForObject model: AnyObject?,indexPath:IndexPath) -> CGFloat
     */
    var isAutoCalculate : Bool = true
    
    /**
     * cell的点击事件回调闭包     */
    var cellClickClosure :((_ tableView:UITableView,_ indexPath : IndexPath,_ cell : UITableViewCell,_ object : Any?) -> Void)?
    
    /**
     cell子控件点击事件
     */
    var subVieClickClosure : ((_ sender:AnyObject?, _ object:AnyObject?) -> Void)?
    
    /**
     是否处理重用造成的数据重复显示问题
     */
    var isClearRepeat : Bool = false
    
    /**
     是否重用cell
     */
    var isRepeatCell : Bool = true
    
    /**
     * 只有单组数据
     */
    init(dataSourceWithItems items: [AnyObject]?) {
        super.init()
        if let tempItems = items {
            self.items? += tempItems
        }
    }
    
    /**
     * 分组数据
     */
    init(dataSourceWithSectionsItems items: [AnyObject]?) {
        super.init()
        if let tempSectionsItems = items {
            self.sectionsItems? += tempSectionsItems
        }
    }
    
    deinit{
        self.items = nil
        self.sectionsItems = nil
    }
}

/**
 * tableViewDataSource delegate数据源代理
 */
extension PJBaseTableViewDataSourceAndDelegate{
    
    /**
     * 是否是分组数据,默认否,默认单组,子类可以重写
     */
    func isSection() -> Bool{
        return false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.isSection(){
            if let tempSectionsItems = self.sectionsItems{
                if tempSectionsItems.count > 0{
                    return self.sectionsItems!.count
                }else{
                    return 1
                }
            }else{
                return 1;
            }
        }else{
            return 1
        }
    }
    
    /**
     *若为多组需要子类重写
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSection(){
            if let tempSectionsItemsCount = self.sectionsItems?.count{
                /**
                 *因数据结构差异，需在子类重写
                 * eg:
                 var item:CategoryItem = self.sectionsItems[section]
                 return item.dataArray.count
                 */
                return tempSectionsItemsCount
            }else{
                return 0
            }
        }else{
            if let tempCount = self.items?.count{
                return tempCount
            }else{
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object:AnyObject? = self.tableView(tableView: tableView, objectForRowAtIndexPath: indexPath)
        
        /**
         *根据子类重写方法中返回的类型名来创建对应的cell
         */
        let cellClass:AnyClass = self.tableView(tableView: tableView, cellClassForObject: object)
        let className:String = NSStringFromClass(cellClass)
        //用类型名称做ID
        let identifier:String = "\(cellClass.self)"
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            //获取cell类型
            if let classType = NSClassFromString(className) as? PJBaseTableViewCell.Type {
                
                if classType.isLoadFromXIB {
                    /**
                     *  从xib加载初始化cell
                     *
                     */
                    cell = classType.cellWithTableView(tableview: tableView)
                }else{
                    if self.isRepeatCell {
                        //不重用cell
                        cell = classType.init(style: UITableViewCellStyle.default, reuseIdentifier: nil)
                    }else{
                        cell = classType.init(style: UITableViewCellStyle.default, reuseIdentifier: identifier)
                    }
                }
            }else{
                //创建PJBaseTableViewCell失败
                PJPrintLog("获取cell类型失败,创建PJBaseTableViewCell失败!")
                cell = PJBaseTableViewCell()
                cell?.textLabel?.text = "获取cell类型失败,创建PJBaseTableViewCell失败!"
            }
        }else{
            if self.isClearRepeat {
                //删除cell的所有子视图
                while cell?.contentView.subviews.last != nil {
                    cell?.contentView.subviews.last?.removeFromSuperview()
                }
            }
        }
        
        cell?.selectionStyle = self.getUITableViewCellSelectionStyle()
        if let pjBaseTableViewCell = cell as? PJBaseTableViewCell {
            pjBaseTableViewCell.clearData()
            //传递数据
            pjBaseTableViewCell.setModel(model: object)
            //设置子控件点击事件
            pjBaseTableViewCell.subVieClickClosure = self.subVieClickClosure
        }
        
        if object != nil{
            self.pj_tableView(tableView, cellForRowAt: indexPath, cell: cell!, object: object)
        }
        
        return cell!
    }
    
    /**
     计算cell高度的方式,自动计算(利用FDTemplateLayoutCell库)和手动frame计算,默认自动计算,如果是手动计算则cell子类需要重写class func tableView(tableView: UITableView, rowHeightForObject model: AnyObject?,indexPath:IndexPath) -> CGFloat
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //自动计算cell高度(带有缓存)
        if self.isAutoCalculate{
            return tableView.fd_heightForCell(withIdentifier: cellID, cacheBy: indexPath) { [weak self] (cell : Any?) in
                guard let tempCell = cell as? PJBaseTableViewCell else{
                    return
                }
                //自动计算cell高度
                tempCell.setModel(model: self?.tableView(tableView: tableView, objectForRowAtIndexPath: indexPath))
            }
        }else{
            return self.getHeightForRow(tableView: tableView, atIndexPath: indexPath)
        }
    }
    
    /**
     子类可以重写，以确定那些高度固定的cell
     */
    //    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        return self.getHeightForRow(tableView, atIndexPath: indexPath)
    //    }
    
    /**
     获取cell的高度
     */
    func getHeightForRow(tableView:UITableView, atIndexPath indexPath:IndexPath) -> CGFloat{
        let object = self.tableView(tableView: tableView, objectForRowAtIndexPath: indexPath)
        let cls : AnyClass = self.tableView(tableView: tableView, cellClassForObject: object)
        if let tempCls = cls as? PJBaseTableViewCell.Type{
            return tempCls.tableView(tableView: tableView, rowHeightForObject: object,indexPath:indexPath)
        }else{
            return 44.0;
        }
    }
    
    /**
     设置cell被选中时的样式
     */
    func getUITableViewCellSelectionStyle() -> UITableViewCellSelectionStyle {
        return UITableViewCellSelectionStyle.default
    }
}

/**
 * delegate表格点击事件代理
 */
extension PJBaseTableViewDataSourceAndDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        let object = self.tableView(tableView: tableView, objectForRowAtIndexPath: indexPath)
        self.cellClickClosure!(tableView,indexPath,cell!,object)
    }
}

extension PJBaseTableViewDataSourceAndDelegate{
    
    /**
     * 单组数据添加多个模型数据
     */
    func addItems(items : [AnyObject]?) {
        if let _ = items{
            self.items? += items!
        }
    }
    
    /**
     * 单组数据添加一个模型数据
     */
    func addItem(item : AnyObject?) {
        if let _ = item{
            self.items?.append(item!)
        }
    }
    
    /**
     * 分组数据添加多个模型数据
     */
    func addSectionItems(sectionItems : [AnyObject]?) {
        if let _ = sectionItems{
            self.sectionsItems? += sectionItems!
        }
    }
    
    /**
     * 分组数据添加一个模型数据
     */
    func addSectionItem(sectionItem : AnyObject?) {
        if let _ = sectionItem{
            self.sectionsItems?.append(sectionItem!)
        }
    }
}

extension PJBaseTableViewDataSourceAndDelegate{
    
    /// MARK: 子类可以重写以获取到刚初始化的cell,可在此时做一些额外的操作
    func pj_tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, cell: UITableViewCell,object:AnyObject?){
        
    }
    
    /**
     * 子类重写,以告诉表格每个model所对应的cell是哪个
     */
    func tableView(tableView: UITableView, cellClassForObject object: AnyObject?) -> AnyClass{
        return PJBaseTableViewCell.classForCoder()
    }
    
    /**
     *若为多组需要子类重写
     */
    func tableView(tableView: UITableView, indexPathForObject object: AnyObject) -> NSIndexPath? {
        var objectIndex:Int
        let tempItems = self.items! as NSArray
        objectIndex = tempItems.index(of: object)
        if objectIndex >= 0 {
            return  NSIndexPath(row: objectIndex, section: 0)
        }
        return nil
    }
    
    func tableView(tableView: UITableView, objectForRowAtIndexPath indexPath: IndexPath) -> AnyObject? {
        if self.isSection(){
            /**
             *因数据结构差异，需在子类重写
             * eg: id obj = [self.sectionsItems objectAtIndex:(NSUInteger) indexPath.section];
             if ([obj isKindOfClass:[CategoryItem class]]) {
             CategoryItem *item = (CategoryItem *)obj;
             if (indexPath.row < item.dataArray.count) {
             return [item.dataArray objectAtIndex:(NSUInteger) indexPath.row];
             }
             }
             */
            return nil
        }else{
            if let tempItems = self.items{
                if tempItems.count > 0 && indexPath.row < tempItems.count{
                    return self.items![indexPath.row]
                }else{
                    return nil
                }
            }else{
                return nil
            }
        }
    }
}
