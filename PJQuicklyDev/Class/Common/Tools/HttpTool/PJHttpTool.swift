//
//  PJHttpTool.swift
//  Swift3Learn
//
//  Created by 飘金 on 2017/4/10.
//  Copyright © 2017年 飘金. All rights reserved.
//
//网络请求类
import Foundation
import Alamofire

enum PJRequestType: String{
    case _get = "GET"
    case _post = "POST"
    case _uploadImage = "uploadImage"
}

enum PJResponseDataType : Int{
    case json = 0//服务返回的数据是json
    case string //服务器返回的数据是字符串
    case data//返回的是data
}

typealias PJSuccess = (_ response : Any?) -> Void?
typealias PJFaild = (_ error : Any?) -> Void?

class PJHttpTool: NSObject {

    /*****解析服务器返回的数据*****/
    class func responseHandle<T>(response : DataResponse<T>,responseDataType : PJResponseDataType = .json,success : @escaping PJSuccess,faild : @escaping PJFaild) {
        if response.result.isSuccess {
            
            switch responseDataType {
            case .json:
                if let JSON = response.result.value {
                    PJPrintLog("请求成功结果JSON: \(String(describing: String(cString: String(describing: JSON), encoding: String.Encoding.utf8)))")
                    success(JSON)
                }else{
                    PJPrintLog("请求成功结果\(String(describing: response.result.value))")
                    success(response.result.value)
                }
                break
            case .string:
                PJPrintLog("请求成功结果\(String(describing: response.result.value))")
                success(response.result.value)
                break
            case .data:
                success(response.data)
                break
            }
        }else{
            PJPrintLog("请求失败结果error = \(String(describing: response.result.error))")
            faild(response.result.error)
        }
    }
    
    /****默认服务器返回数据类型是json*****/
    class func pj_request(requestType : PJRequestType, params : [String:Any]?, url : String,responseDataType : PJResponseDataType = .json,success : @escaping PJSuccess,faild : @escaping PJFaild){
        
        PJPrintLog("请求url = \(url)")
        
        let response :DataRequest
        switch requestType {
        case ._get:
            response = Alamofire.request(url, method: HTTPMethod.get, parameters: params, encoding: URLEncoding.default, headers: nil)
            break
        case ._post:
            response = Alamofire.request(url, method: HTTPMethod.post, parameters: params, encoding: URLEncoding.default, headers: nil)
            break
        default:
            response = Alamofire.request(url, method: HTTPMethod.get, parameters: params, encoding: URLEncoding.default, headers: nil)
            break
        }
        
        switch responseDataType {
        case .json:
            response.responseJSON(completionHandler: { (response : DataResponse<Any>) in
                self.responseHandle(response: response, success: success, faild: faild)
            })
            break
        case .string:
            response.responseString(completionHandler: { (response : DataResponse<String>)  in
                self.responseHandle(response: response, success: success, faild: faild)
            })
            break
        case .data:
                response.responseData(completionHandler: { (response : DataResponse<Data>) in
                    self.responseHandle(response: response, success: success, faild: faild)
                })
            break
        }
    }
}
