//
//  ViewController.swift
//  MVVMPatternDemo
//
//  Created by uwei on 5/5/16.
//  Copyright © 2016 Tencent. All rights reserved.
//

import UIKit


@objc protocol ViewControllerDelegate:AnyObject {
    @objc var viewDidChange:((ViewControllerDelegate)->Void)?{get set}
    @objc func showView()
}


class ViewControllerModel:ViewControllerDelegate {
    var viewDidChange: ((ViewControllerDelegate) -> Void)?
    func showView() {
        self.viewDidChange!(self)
    }
}



class ViewController: UIViewController {

    private var button:UIButton = UIButton()
    private var vcModel:ViewControllerDelegate? {
        didSet {
            vcModel?.viewDidChange = { [unowned self] vcModel in
                let mvvmVC = self.storyboard?.instantiateViewController(withIdentifier: "MVVMViewController") as! MVVMViewController
                let model  = Person(name: "uwei", age: 27)
                let viewModel = ViewModel(person: model)
                mvvmVC.viewModel = viewModel
                self.present(mvvmVC, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        vcModel = ViewControllerModel()
        
        button.frame = CGRect(x: 100, y: 200, width: 44, height: 44)
        button.setTitle("click", for: UIControl.State.selected)
        button.backgroundColor = UIColor.black
        button.addTarget(vcModel!, action: #selector(vcModel!.showView), for: UIControl.Event.touchUpInside)
        self.view.addSubview(button)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func showView() -> Void {
        
    }

}

