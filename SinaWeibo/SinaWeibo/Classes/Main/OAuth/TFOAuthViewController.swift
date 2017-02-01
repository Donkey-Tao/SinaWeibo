//
//  TFOAuthViewController.swift
//  SinaWeibo
//
//  Created by Donkey-Tao on 2017/2/1.
//  Copyright © 2017年 http://taofei.me. All rights reserved.
//

import UIKit
import SVProgressHUD

class TFOAuthViewController: UIViewController {
    
    //MARK:- 属性
    @IBOutlet weak var OAuthLoginWebView: UIWebView!
    
    
    //MARK:- 系统回调函数

    override func viewDidLoad() {
        super.viewDidLoad()

        //1.设置导航栏的内容
        setupNavigationBar()
        //2.加载网页
        loadOAuthWebView()
    }

}



//MARK:- 设置UI界面
extension TFOAuthViewController{

    ///设置导航条
    func setupNavigationBar(){
        //1.设置左边的Item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(TFOAuthViewController.closeItemClick))
        
        //2.设置右边的Item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .plain, target: self, action: #selector(TFOAuthViewController.fillItemClick))
        
        //3.设置标题
        title = "登录页面"
    }
    
    
    ///加载授权登录页面
    func loadOAuthWebView(){
        //1.获取登录页面的URLString
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_uri)"
        TFLog(urlString)
        //2.创建对应的NSURL
        guard let url = NSURL(string: urlString)else{
            return
        }
        
        //3.创建NSURLRequest对象
        let request = NSURLRequest(url: url as URL)
        
        //4.加载request对象
        OAuthLoginWebView.loadRequest(request as URLRequest)
    }
}


//MARK:- 事件监听
extension TFOAuthViewController{

    ///关闭
    @objc func closeItemClick(){
    
        dismiss(animated: true, completion: nil)
    }
    
    ///填充
    @objc func fillItemClick(){
        //1.书写JavaScript代码
        let jsCode = "document.getElementById('userId').value='745838164@qq.com';document.getElementById('passwd').value='feit0610weibo16'"
        //2.执行JavaScript代码
        OAuthLoginWebView.stringByEvaluatingJavaScript(from: jsCode)
    }
}


//MARK:- webView的代理方法
extension TFOAuthViewController : UIWebViewDelegate{

    ///开始加载webView网页
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    ///结束加载webView网页
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    ///网页加载失败
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
    }
    ///当准备加载某一个页面时会执行该方法，其返回值时Bool类型；true,继续加载，false,不会继续加载
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        //1.获取加载网页的URL
        guard let url = request.url else{
            return true
        }
        //2.获取url中的字符串
        let urlString = url.absoluteString
        //3.判断该字符串中是否包含code
        guard urlString.contains("code=") else{
            return true
        }
        //4.将code截取出来
        let code = urlString.components(separatedBy: "code=").last!
        //5.请求AccessToken
        getAccessToken(code: code)
        return false
    }
}

//MARK:- 请求数据
extension TFOAuthViewController{

    ///请求AccessToken
    @objc func getAccessToken(code : String){
        
        TFNetworkTools.shareInstance.getAccessToken(code: code) { (result, error) in
            //1.错误校验
            if error != nil{
                TFLog(error)
                return
            }
            //2.拿到结果
            print(result!)
        }
    
    }
    

}

