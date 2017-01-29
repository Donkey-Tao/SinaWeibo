//
//  TFPopoverAnimator.swift
//  SinaWeibo
//
//  Created by Donkey-Tao on 2017/1/29.
//  Copyright © 2017年 taofei.me. All rights reserved.
//

import UIKit

class TFPopoverAnimator: NSObject {
    
    //MARK:- 是否为弹出动画
    var isPresented : Bool = false

}

//MARK:- 自定义转场动画代理方法的实现
extension TFPopoverAnimator : UIViewControllerTransitioningDelegate{
    
    //目的：改变frame
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return TFPopPresentationController(presentedViewController: presented, presenting: presenting)
    }
    //目的：自定义弹出动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    //目的：自定义消失动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}


//MARK:- 弹出或者消失动画代理方法的实现
extension TFPopoverAnimator : UIViewControllerAnimatedTransitioning{
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    
    //获取转场的上下文:可以通过上下文获取弹出的View和消失的View
    //UITransitionContextViewKey.from:获取消失的View
    //UITransitionContextViewKey.to:获取弹出的View
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        isPresented ? animationForPresentedView(using: transitionContext) : animationForDismissedView(using: transitionContext)
    }
    
    ///弹出动画
    func animationForPresentedView(using transitionContext: UIViewControllerContextTransitioning){
        //1.获取弹出的View
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        //2.自定义转场:将弹出的View添加到ContainerView中;
        transitionContext.containerView.addSubview(presentedView)
        //3.执行动画
        //设置锚点
        presentedView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        presentedView.transform = CGAffineTransform(scaleX: 1.0 , y: 0.0)
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            
            presentedView.transform = CGAffineTransform.identity
        }) { (_) in
            //必须告诉上下文已经完成了动画
            transitionContext.completeTransition(true)
        }
    }
    
    ///消失动画
    func animationForDismissedView(using transitionContext: UIViewControllerContextTransitioning){
        
        //1.获取消失的View
        let dismissedView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        
        //2.执行动画
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            
            dismissedView.transform = CGAffineTransform(scaleX: 1.0 , y: 0.0001)
        }) { (_) in
            dismissedView.removeFromSuperview()
            //必须告诉上下文已经完成了动画
            transitionContext.completeTransition(true)
        }
    }
}