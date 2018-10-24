//
//  CanvasViewController.swift
//  CanvasFy
//
//  Created by Tommy Tran on 17/10/2018.
//  Copyright © 2018 Tommy Tran. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {

    @IBOutlet var trayView: UIView!
    
    @IBOutlet weak var canvasView: UIView!
    
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    var trayOriginalCenter: CGPoint!
    let trayDownOffset: CGFloat! = 160
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    override func viewDidLoad() {
        super.viewDidLoad()

        trayUp = canvasView.center // The initial position of the tray
        trayDown = CGPoint(x: canvasView.center.x ,y: canvasView.center.y + trayDownOffset) // The position of the tray transposed down
    }
    
    
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == .began {
            print("Gesture began")
            trayOriginalCenter = canvasView.center

        } else if sender.state == .changed {
            canvasView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            print("Gesture ended")
            if velocity.y > 0{
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.canvasView.center = self.trayDown
                }, completion: nil)
            }else{
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.canvasView.center = self.trayUp
                }, completion: nil)
            }

        }
    }
    
    @objc func doubleTap(sender: UITapGestureRecognizer){
        newlyCreatedFace = sender.view as? UIImageView
        newlyCreatedFace.removeFromSuperview()
    }
    
    @objc func panCurrFace(sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            print("Gesture began")
            newlyCreatedFace = sender.view as? UIImageView
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            UIView.animate(withDuration:0.1, animations: {
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 2, y: 2)
            },completion: nil)
        } else if sender.state == .changed {
            print("Gesture is changing")
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            print("Gesture ended")
            UIView.animate(withDuration:0.1, animations: {
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            },completion: nil)
        }
    }
    
    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
       let translation = sender.translation(in: view)

        if sender.state == .began{
            print("face start")
            let imageView = sender.view as! UIImageView
            newlyCreatedFace = UIImageView(image: imageView.image)
            view.addSubview(newlyCreatedFace)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += canvasView.frame.origin.y
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            newlyCreatedFace.isUserInteractionEnabled = true
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panCurrFace(sender:)))
            newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTap(sender:)))
            tapGestureRecognizer.numberOfTapsRequired = 2
            newlyCreatedFace.addGestureRecognizer(tapGestureRecognizer)
        }else if sender.state == .changed{
            print("face changed")
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        }else if sender.state == .ended{
            print("face ended")
        }
    }
    

    
}
