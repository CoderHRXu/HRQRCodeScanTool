//
//  String+QRCode.swift
//  HRScanToolDemo
//
//  Created by haoran on 2018/4/20.
//  Copyright © 2018年 haoran. All rights reserved.
//

import UIKit

extension String {
    
    /**
     1.生成二维码
     
     - returns: 黑白普通二维码
     */
    func generateQRCode() -> UIImage{
        return generateQRCodeWithSize(size: nil)
    }
    
    
    /**
     2.生成二维码
     
     - parameter size: 大小
     
     - returns: 生成带大小参数的黑白普通二维码
     */
    func generateQRCodeWithSize(size:CGFloat?) -> UIImage{
        return generateQRCode(size: size, logo: nil)
    }
    
    
    /**
     3.生成二维码
     
     - parameter logo: 图标
     
     - returns: 生成带Logo二维码(大小:300)
     */
    func generateQRCodeWithLogo(logo:UIImage?) -> UIImage{
        return generateQRCode(size: nil, logo: logo)
    }
    
    
    /**
     4.生成二维码
     
     - parameter size: 大小
     - parameter logo: 图标
     
     - returns: 生成大小和Logo的二维码
     */
    func generateQRCode(size:CGFloat?,logo:UIImage?) -> UIImage{
        
        let color                       = UIColor.black
        let bgColor                     = UIColor.white
        return generateQRCode(size: size, color: color, bgColor: bgColor, logo: logo)
        
    }
    
    
    /**
     5.生成二维码
     
     - parameter size:    大小
     - parameter color:   颜色
     - parameter bgColor: 背景颜色
     - parameter logo:    图标
     
     - returns: 带Logo、颜色二维码
     */
    func generateQRCode(size:CGFloat?,color:UIColor?,bgColor:UIColor?,logo:UIImage?) -> UIImage{
        
        let radius: CGFloat             = 5//圆角
        let borderLineWidth: CGFloat    = 1.5//线宽
        let borderLineColor             = UIColor.gray//线颜色
        let boderWidth: CGFloat         = 8//白带宽度
        let borderColor                 = UIColor.white//白带颜色
        
        return generateQRCode(size: size, color: color, bgColor: bgColor, logo: logo,radius:radius,borderLineWidth: borderLineWidth,borderLineColor: borderLineColor,boderWidth: boderWidth,borderColor: borderColor)
        
    }
    
    
    /**
     6.生成二维码
     
     - parameter size:            大小
     - parameter color:           颜色
     - parameter bgColor:         背景颜色
     - parameter logo:            图标
     - parameter radius:          圆角
     - parameter borderLineWidth: 线宽
     - parameter borderLineColor: 线颜色
     - parameter boderWidth:      带宽
     - parameter borderColor:     带颜色
     
     - returns: 自定义二维码
     */
    func generateQRCode(size: CGFloat?,
                        color: UIColor?,
                        bgColor: UIColor?,
                        logo :UIImage?,
                        radius :CGFloat,
                        borderLineWidth :CGFloat?,
                        borderLineColor: UIColor?,
                        boderWidth: CGFloat?,
                        borderColor: UIColor?) -> UIImage{
        
        let ciImage                         = generateCIImage(size: size, color: color, bgColor: bgColor)
        let image                           = UIImage(ciImage: ciImage)
        
        guard let QRCodeLogo = logo else {
            return image
        }
        
        
        let logoWidth                       = image.size.width / 4
        let logoFrame                       = CGRect(x: (image.size.width - logoWidth) /  2, y: (image.size.width - logoWidth) / 2, width: logoWidth, height: logoWidth)
        
        
        // 绘制logo
        UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.main.scale)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        //线框
        let logoBorderLineImagae            = QRCodeLogo.getRoundRectImage(size: logoWidth, radius: radius, borderWidth: borderLineWidth, borderColor: borderLineColor)
        //边框
        let logoBorderImagae                = logoBorderLineImagae.getRoundRectImage(size: logoWidth, radius: radius, borderWidth: boderWidth, borderColor: borderColor)
        
        logoBorderImagae.draw(in: logoFrame)
        let QRCodeImage                     = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return QRCodeImage!
        
    }
    
    
    /// 生成CIImage
    ///
    /// - Parameters:
    ///   - size: 大小
    ///   - color: 颜色
    ///   - bgColor: 背景颜色
    /// - Returns: CIImage
    func generateCIImage(size: CGFloat?,color:UIColor?,bgColor:UIColor?) -> CIImage{
        
        //1.默认值
        var QRCodeSize: CGFloat             = 300//默认300
        var QRCodeColor                     = UIColor.black//默认黑色二维码
        var QRCodeBgColor                   = UIColor.white//默认白色背景
        
        if let size = size {
            QRCodeSize = size
        }
        if let color = color {
            QRCodeColor = color
        }
        if let bgColor = bgColor {
            QRCodeBgColor = bgColor
        }
        
        
        //2.二维码滤镜
        let contentData                     = self.data(using: String.Encoding.utf8)
        let fileter                         = CIFilter(name: "CIQRCodeGenerator")
        
        fileter?.setValue(contentData, forKey: "inputMessage")
        fileter?.setValue("H", forKey: "inputCorrectionLevel")
        
        let ciImage                         = fileter?.outputImage
        
        
        //3.颜色滤镜
        let colorFilter                     = CIFilter(name: "CIFalseColor")
        
        colorFilter?.setValue(ciImage, forKey: "inputImage")
        colorFilter?.setValue(CIColor(cgColor: QRCodeColor.cgColor), forKey: "inputColor0")// 二维码颜色
        colorFilter?.setValue(CIColor(cgColor: QRCodeBgColor.cgColor), forKey: "inputColor1")// 背景色
        
        
        //4.生成处理
        
        let outImage                        = colorFilter!.outputImage
        let scale                           = QRCodeSize / outImage!.extent.size.width;
        
        
        let transform                       = CGAffineTransform(scaleX: scale, y: scale)
        let transformImage                  = colorFilter!.outputImage!.transformed(by: transform)
        
        return transformImage
        
    }
    
}
