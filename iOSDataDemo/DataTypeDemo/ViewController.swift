//
//  ViewController.swift
//  DataTypeDemo
//
//  Created by uwei on 7/29/16.
//  Copyright © 2016 Tencent. All rights reserved.
//

import UIKit
import CoreGraphics


class MyDrawView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let attributeString1 = NSAttributedString(string: "we all have a grate dream. then we should take much time to achieve it")
//        attributeString1.drawInRect(rect)
//        attributeString1.drawWithRect(rect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
        let templateImage = UIImage(named: "face0")
//        templateImage?.drawAsPatternInRect(rect)
    }
}



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let lable = UILabel(frame: CGRectMake(50, 50, 200, 20))
        lable.backgroundColor = UIColor.grayColor()
        view.addSubview(lable)
        
        
        
        let attributeString1 = NSAttributedString(string: "we all have a grate dream. then we should take much time to achieve it")
        lable.attributedText = attributeString1;
        
        
        
        let drawView = MyDrawView(frame: CGRectMake(50, 150, 200, self.view.bounds.size.height))
        
        self.view.addSubview(drawView)
        
        
//        let animationImages = UIImage.animatedImageNamed("face", duration: 5)
//        let animationImages = UIImage.animatedResizableImageNamed("face", capInsets: UIEdgeInsetsMake(10, 0, 0, 0), duration: 4)
        let animationImages = UIImage.animatedResizableImageNamed("face", capInsets: UIEdgeInsetsMake(50, 100, 0, 0), resizingMode:.Stretch, duration: 4)
//        let templateImage = UIImage(named: "face0")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        
        let cicolor = CIColor(red: 0.3, green: 0.5, blue: 0.3)
        let ciimage = CIImage(color: cicolor).imageByCroppingToRect(CGRectMake(0, 0, 100, 100))
        let image = UIImage(CIImage: ciimage)
        
        
        
        let animationImagesView = UIImageView(frame: CGRectMake(0, self.view.bounds.size.height - 355, 300, 150))
        animationImagesView.image = image
//        animationImagesView.contentMode = UIViewContentMode.ScaleAspectFit
//        animationImagesView.image = templateImage
        animationImagesView.layer.borderWidth = 2
        animationImagesView.layer.borderColor = UIColor.redColor().CGColor
//        animationImagesView.tintColor = UIColor.grayColor()
        self.view.addSubview(animationImagesView)
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        print(previousTraitCollection?.horizontalSizeClass.rawValue)
        print(previousTraitCollection?.verticalSizeClass.rawValue)
    }

    
    
}

