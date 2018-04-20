//
//  UIImage+QRCode.swift
//  HRScanToolDemo
//
//  Created by haoran on 2018/4/20.
//  Copyright © 2018年 haoran. All rights reserved.
//

import UIKit
import CoreImage

extension UIImage {
    
    
    /// 二维码识别
    ///
    /// - Returns: 二维码内容
    func recognizeQRCode() -> String? {
        
        let detector            = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy : CIDetectorAccuracyHigh])
        let features            = detector?.features(in: CIImage.init(image: self)!)
        guard (features?.count)! > 0 else {
            return nil
        }
        let feature             = features?.first as? CIQRCodeFeature
        return feature?.messageString
    }
    
    
    /// 获取圆角图片
    ///
    /// - Parameters:
    ///   - size: 大小
    ///   - radius: 半径
    /// - Returns: 圆角图片
    func getRoundRectImage(size:CGFloat,radius:CGFloat) -> UIImage{
        return getRoundRectImage(size: size, radius: radius, borderWidth: nil, borderColor: nil)
        
    }
    
    /// 获取圆角图片(带边框)
    ///
    /// - Parameters:
    ///   - size: 大小
    ///   - radius: 半径
    ///   - borderWidth: 边框粗细
    ///   - borderColor: 边框颜色
    /// - Returns: 圆角图片
    func getRoundRectImage(size:CGFloat,radius:CGFloat,borderWidth:CGFloat?,borderColor:UIColor?) -> UIImage{
        
        let scale                           = self.size.width / size ;
        
        //初始值
        var defaultBorderWidth: CGFloat     = 0
        var defaultBorderColor              = UIColor.clear
        
        if let borderWidth = borderWidth {
            defaultBorderWidth              = borderWidth * scale
        }
        if let borderColor = borderColor {
            defaultBorderColor              = borderColor
        }
        
        let radius                          = radius * scale
        let react                           = CGRect(x: defaultBorderWidth, y: defaultBorderWidth, width: self.size.width - 2 * defaultBorderWidth, height: self.size.height - 2 * defaultBorderWidth)
        
        //绘制图片设置
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        let path = UIBezierPath(roundedRect:react , cornerRadius: radius)
        
        //绘制边框
        path.lineWidth                      = defaultBorderWidth
        defaultBorderColor.setStroke()
        path.stroke()
        path.addClip()
        
        //画图片
        draw(in: react)
        let newImage                        = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!;
        
    }
}
