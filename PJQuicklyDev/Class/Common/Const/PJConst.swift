//
//  PJConst.swift
//  Swift3Learn
//
//  Created by 飘金 on 2017/4/10.
//  Copyright © 2017年 飘金. All rights reserved.
//

import UIKit

let PJScreenSize = PJConst.PJScreenSize
let PJScreenWidth = PJConst.PJScreenWidth
let PJScreenHeight = PJConst.PJScreenHeight
let PJScreenBounds = PJConst.PJScreenBounds
let Scale = PJScreenHeight / 568.0 //屏幕比例用于布局适配不同大小屏幕
func PJScale(scale:CGFloat) -> CGFloat{
    return scale * Scale
}

struct PJConst {
    static var PJScreenSize = UIScreen.main.bounds.size
    static var PJScreenWidth  = UIScreen.main.bounds.size.width
    static var PJScreenHeight = UIScreen.main.bounds.size.height
    static var PJScreenBounds = UIScreen.main.bounds
}
