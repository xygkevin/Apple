//
//  ViewController.swift
//  RACSwiftDemo
//
//  Created by uwei on 2021/1/12.
//

import UIKit
import SnapKit
import ReactiveCocoa
import ReactiveSwift
// 信号操作 https://juejin.cn/post/6844903524799610888#heading-23
// 信号的绑定等 https://juejin.cn/post/6844903525596528653#heading-9

class ViewController: UIViewController {

    private var textFiled:UITextField?
    private var button:UIButton?
    // 重要：如果是元组，每一个元变化，则数据回调都会被触发
    var datas:MutableProperty<(data:[[String]], action:Int)>!
    
    var data1 = [String]()
    var data2 = [String]()
    
    var action:Action<(),[String]?, Error>!
    
    var result:MutableProperty<Bool> = MutableProperty(false) {
        didSet {
            print("set")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        bind()
        
        datas = MutableProperty((data:[data1, data2], action:1))
        action = Action<(), [String]?, Error> (execute: {
            return self.createAction()
        })
        
        
        datas.signal.observeValues { (x) in
            print("action")
        }
        
        action.apply().start()
        action.apply().start()
        
//        createActionBySignalProducer()
        
        // Do any additional setup after loading the view.
        // not working for didSet
        result.value = false
        result.value = true
        // working for didSet , so we should use Action for combine
        result = MutableProperty(true)
    }
    
    func createAction() -> SignalProducer<[String]?, Error> {
        return SignalProducer<[String]?, Error> { (ob, li) in
            self.datas.value = ([["uwei"]], 1)
            ob.sendCompleted()
        }
    }
    
    func createActionBySignalProducer() -> Void {
        let spg:(Int) -> SignalProducer<Int, Error> = { timeInterval in
            return SignalProducer<Int, Error> { (observer, lifetime) in
                observer.send(value: timeInterval)
//                if timeInterval == 2 {
                    observer.sendCompleted()
//                }
                return
                let now = DispatchTime.now()
                print("start index")
                for index in 0..<10 {
                    let timeElapsed = index * timeInterval
                    DispatchQueue.main.asyncAfter(deadline: now + Double(timeElapsed)) {
                        guard !lifetime.hasEnded else {
                            observer.sendInterrupted()
                            return
                        }
                        observer.send(value: timeElapsed)
                        print("observer.send")
                        if index == 9 {
                            observer.sendCompleted()
                        }
                    }
                }
            }
        }
        
        let action = Action<(Int), Int, Error>(execute: spg)
        let action1 = Action<(Int), Int, Error>(execute: spg)
        
//        action.values.take(first: 2).observeResult({ value in
//            print("Time elapsed = \(value)")
//        })
        
//        action.values.combineLatest(with: action.values).observeValues { (arg0) in
//            let (v1, v2) = arg0
//            print("Time elapsed = \(v1)-----\(v2)")
//        }
//
//        action.values.observeCompleted {
//            print("completed!")
//        }
//        action.values.producer.startWithValues { (x) in
//            print("actions producer \(x)")
//        }
        action.values.signal.take(last: 1).observeValues { (x) in
            print("actions signal \(x)")
        }
        
        action.apply(1).start()
        action.apply(2).start()
//        action.apply(10).start()
    }
    
    
    func createMutableProperty() -> Void {
        let mp = MutableProperty(1)
        mp.signal.observeValues({value in
            print("mp = \(value)")
        })

        mp.value = 120000;
    }
    
    func cretaePropertyBySignalProducer() -> Void {
        // 信号生产者的回调，是发送数据的地方
        let sp:SignalProducer<Int, Never> = SignalProducer { (observer, l) in
            for i in 0..<10 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 *  Double(i)) {
                    guard !l.hasEnded else {
                        observer.sendInterrupted()
                        return
                    }
                    observer.send(value: i)
                    if i == 9 { //Mark completion on 9th iteration
                        observer.sendCompleted()
                    }
                }
            }
        }
        
        let p = Property(initial: 0, then: sp)
        p.producer.startWithValues({ value in
            print("[Observing SignalProducer] Time elapsed = \(value)")
        })
        p.signal.observeValues({ value in
            print("[Observing SignalProducer] Time elapsed = \(value)")
        })
    }
    
    func createSignalProducerWithParams() -> Void {
        let spg:(Int) -> SignalProducer<Int, Error> = { timeInterval in
            return SignalProducer<Int, Error> { (observer, lifetime) in
                let now = DispatchTime.now()
                for index in 0..<10 {
                    let timeElapsed = index * timeInterval
                    DispatchQueue.main.asyncAfter(deadline: now + Double(timeElapsed)) {
                        guard !lifetime.hasEnded else {
                            observer.sendInterrupted()
                            return
                        }
                        observer.send(value: timeElapsed)
                        if index == 9 {
                            observer.sendCompleted()
                        }
                    }
                }
            }
        }
        
        
        let spg1 = spg(1)
        let spg2 = spg(2)
        
        spg1.startWithResult({ value in
            print("value from signalProducer1 = \(value)")
        })
        spg1.startWithCompleted {
            print("signalProducer1 end")
        }
        spg1.startWithFailed { (err) in
            print(err)
        }
        spg1.startWithInterrupted {
            print("interrupt")
        }
        
        spg2.startWithResult({ value in
            print("value from signalProducer2 = \(value)")
        })
    }
    
    func createSingalBySignalProducer() -> Void {
        // 信号生产者的回调，是发送数据的地方
        let sp:SignalProducer<Int, Never> = SignalProducer { (observer, l) in
            for i in 0..<10 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 *  Double(i)) {
                    guard !l.hasEnded else {
                        observer.sendInterrupted()
                        return
                    }
                    observer.send(value: i)
                    if i == 9 { //Mark completion on 9th iteration
                        observer.sendCompleted()
                    }
                }
            }
        }
        
        let o = Signal<Int, Never>.Observer(value: {
            value in
            print("\(value)")
        }, failed: nil, completed: {
            print("completed")
        }, interrupted: {
            print("interrupted")
        })
        
        //  此处的disposable可以用来在其他时机取消任务
        let disposable = sp.start(o)
        
    }
    
    
    func createSignalBySignal() -> Void {
        // 管道创建signal和observer
        let (output, input) = Signal<Int, Error>.pipe()
        let o = Signal<Int, Error>.Observer(value: {
            value in
            print("\(value)")
        }, failed: nil, completed: {
            print("completed")
        }, interrupted: {
            print("interrupted")
        })
    
        let disposable = output.observe(o)
        // 此处资源管理会导致回调不会被调用
//        disposable?.dispose()
        
        // Operation 001，参看连接
        let transformedSignal = output.map { (value) -> Bool in
            value > 2
        }
        
        let ob = Signal<Bool, Error>.Observer { (result) in
            print(result)
        } failed: { (err) in
            
        } completed: {
            
        } interrupted: {
            
        }
        let disp2 = transformedSignal.observe(ob)
        
        for i in 0..<10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 * Double(i)) {
//                input.send(value: i)
                input.send(Signal<Int, Error>.Event.value(i))
            }
        }
    }
    
    
    
    
    func bind() -> Void {
        let signal = textFiled?.reactive.continuousTextValues
        let transformedSignal = signal?.map{ (text) -> String in
            text
        }.map{(text) in
            text.count > 10
        }
        let observer = Signal<Bool, Never>.Observer(value: {value in
                                                        self.button!.isEnabled = value
            
        }, failed: nil, completed: nil, interrupted: nil)
        let disposable = transformedSignal?.observe(observer)
        disposable?.dispose()
    }
    
    
    func initUI() -> Void {
        textFiled = UITextField()
        textFiled?.placeholder = "x"
        textFiled?.layer.borderWidth = 1
        self.view.addSubview(textFiled!)
        
        button = UIButton(type: .custom)
        button?.backgroundColor = .brown
        button?.setTitle("Click", for: .normal)
        self.view.addSubview(button!)
        
        textFiled?.snp.makeConstraints({ (make) in
            make.height.equalTo(self.view).dividedBy(10)
            make.width.equalTo(200)
            make.center.equalTo(self.view)
        });
        
        button?.snp.makeConstraints({ (make) in
            make.top.equalTo(textFiled!.snp.bottom).offset(50)
            make.centerX.equalTo(textFiled!)
            make.width.height.equalTo(80)
        })
    }
    
}

