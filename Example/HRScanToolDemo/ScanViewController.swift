//
//  ScanViewController.swift
//  HRScanToolDemo
//
//  Created by haoran on 2018/4/19.
//  Copyright © 2018年 haoran. All rights reserved.
//

import UIKit

class ScanViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupScanConfig()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        HRQRCodeScanTool.shared.stopScan()
    }
    
    func setupScanConfig() {

        #if TARGET_IPHONE_SIMULATOR
        print("请用真机调试")
        return
        #endif
        
        let width: CGFloat                     = 300
        HRQRCodeScanTool.shared.isDrawQRCodeRect   = true
        HRQRCodeScanTool.shared.drawRectColor      = UIColor.purple
        HRQRCodeScanTool.shared.drawRectLineWith   = 5
        HRQRCodeScanTool.shared.setInterestRect(originRect: CGRect(x:(view.frame.size.width - width) * 0.5, y: (view.frame.size.height - width) * 0.5, width: width, height: width))
        HRQRCodeScanTool.shared.delegate           = self
        HRQRCodeScanTool.shared.centerHeight       = 200
        HRQRCodeScanTool.shared.centerWidth        = 300
        HRQRCodeScanTool.shared.isShowMask         = true
        HRQRCodeScanTool.shared.maskColor          = UIColor.init(white: 0, alpha: 0.2)
        HRQRCodeScanTool.shared.beginScanInView(view: view)
    }
}

extension ScanViewController: HRQRCodeScanToolDelegate {
    
    func scanQRCodeFaild(error: HRQRCodeTooError) {
        
        switch error {
            
        case .SimulatorError:
            
            print("请使用真机")
            let action = UIAlertAction(title: "好的，我知道了", style: .default, handler: {(_ action: UIAlertAction) in
            })
            let alertVC = UIAlertController(title: "错误" , message: "请使用真机调试", preferredStyle: .alert)
            alertVC.addAction(action)
            self.present(alertVC, animated: true, completion: nil)
            
        case .CamaraAuthorityError:
            
            let action = UIAlertAction(title: "确定", style: .default, handler: {(_ action: UIAlertAction) in
                
                let url = URL(string: UIApplication.openSettingsURLString)
                UIApplication.shared.openURL(url!)
            })
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: {(_ action: UIAlertAction) in
                
            })
            let alertVC = UIAlertController(title: "提示", message: "请在设置中打开摄像头权限", preferredStyle: .alert)
            alertVC.addAction(action)
            alertVC.addAction(cancelAction)
            self.present(alertVC, animated: true, completion: nil)
            
        case .OtherError:
            print("其他错误")
            
            
        }
    }
    
    func scanQRCodeSuccess(resultStrs: [String]){
       
        print("扫码成功 + \(resultStrs.first ?? "")")
    }
}

