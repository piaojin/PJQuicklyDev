//
//  ExpressTableViewCell.swift
//  PJQuicklyDev
//
//  Created by 飘金 on 2017/4/13.
//  Copyright © 2017年 飘金. All rights reserved.
//

import UIKit

class ExpressTableViewCell: PJBaseTableViewCell{

    var expressItemModel : ExpressItemModel?
    //节点圆点
    lazy var nodePointView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.colorWithRGB(red: 219, green: 219, blue: 219)
        return view
    }()
    
    //当前快递到达地址
    let currentArriveAddress : UILabel = {
    let view = UILabel()
    view.backgroundColor = UIColor.colorWithRGB(red: 219, green: 219, blue: 219)
        view.font = UIFont.systemFont(ofSize: 17.0)
        view.numberOfLines = 0
    return view
    }()
    
    //时间
    let timeLabel : UILabel = {
    let view = UILabel()
    view.textColor = UIColor.colorWithRGB(red: 219, green: 219, blue: 219)
        view.font = UIFont.systemFont(ofSize: 15.0)
    return view
    }()
    
    //垂直分割线
    let driverV : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.colorWithRGB(red: 219, green: 219, blue: 219)
        return view
    }()

    //底部水平分割线
    let driverH : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.colorWithRGB(red: 219, green: 219, blue: 219)
        return view
    }()
    
    override func initView() {
        self.contentView.addSubview(self.nodePointView)
        self.nodePointView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(23)
            make.size.equalTo(CGSize(width: 7, height: 7))
            make.top.equalTo(self.contentView).offset(9)
        }
        
        self.contentView.addSubview(self.driverV)
        self.driverV.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self.contentView).offset(0)
            make.width.equalTo(3)
            make.height.equalTo(self.contentView)
            make.centerX.equalTo(self.nodePointView)
        }
        
        self.contentView.addSubview(self.currentArriveAddress)
        self.currentArriveAddress.snp.makeConstraints { (make) in
            make.left.equalTo(self.driverV).offset(15)
            make.top.equalTo(self.contentView).offset(12.0)
            make.right.equalTo(self.contentView).offset(-15)
        }
        
        self.contentView.addSubview(self.timeLabel)
//        self.timeLabel.backgroundColor = UIColor.orange
        self.timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.currentArriveAddress.snp.bottom).offset(7)
            make.left.equalTo(self.currentArriveAddress)
            make.height.equalTo(15.0)
        }
        
        self.contentView.addSubview(self.driverH)
        self.driverH.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.contentView).offset(0)
            make.height.equalTo(1)
            make.left.equalTo(self.currentArriveAddress)
            make.right.equalTo(-11)
        }
        
//        self.backgroundColor = UIColor.PJRandomColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.nodePointView.pj_setCircle()
    }
    
    /**
     cell的高度
     */
    override class func tableView(tableView: UITableView, rowHeightForObject model: AnyObject?,indexPath:IndexPath) -> CGFloat{
        if let tempExpressItemModel = model as? ExpressItemModel{
            let contextSize : CGSize? = tempExpressItemModel.context?.boundingRect(with: CGSize(width: PJScale(scale:287.5), height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17.0)] , context: nil).size
            
            var rowH : CGFloat
            if let contextH = contextSize?.height{
                PJPrintLog("\(PJScale(scale: 46.0)) : \(contextH)")
                rowH = contextH + PJScale(scale: 46.0)
            }else{
                rowH = PJScale(scale: 46.0)
            }
            return rowH;
        }else{
            return 44.0;
        }
    }
    
    /**
     设置数据
     */
    override func setModel(model: AnyObject?) {
        self.expressItemModel = model as? ExpressItemModel
        self.currentArriveAddress.text = self.expressItemModel?.context
        self.timeLabel.text = self.expressItemModel?.ftime
    }
}

extension ExpressTableViewCell{
    
}
