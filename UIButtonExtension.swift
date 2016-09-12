//
//  UIButtonExtension.swift
//  Waterfly
//
//  Created by Bryan Loon on 01.18.15.
//  Copyright © 2015 Loon. All rights reserved.
//


import Foundation
import ReactiveCocoa


class ActionWrapper
{
    typealias Action = (AnyObject) -> RACSignal
    
    
    private let block: Action
    private var canExecute = true
    
    
    init(block: Action)
    {
        self.block = block
    }
    
    func execute(parameter: AnyObject) -> RACSignal?
    {
        var signal: RACSignal?
        
        if canExecute {
            canExecute = false
            signal = block(parameter)
            signal!.subscribeError( { _ in
                self.canExecute = true
            }, completed: { () -> Void in
                self.canExecute = true
            })
        }
        
        return signal
    }
}


extension UIButton
{
    private struct Keys
    {
        static var SlotSelectionSignal = "RACSelectionSignal"
        static var SlotSelectionDisposable = "RACSelectionDisposable"
        static var SlotAction = "SlotAction"
    }
    
    
    var slotSelection: RACSignal? {
        get {
            return objc_getAssociatedObject(self, &Keys.SlotSelectionSignal) as? RACSignal
        } set {
            if let disposable = objc_getAssociatedObject(self, &Keys.SlotSelectionDisposable) as? RACDisposable {
                disposable.dispose()
            }
            
            let disposable = newValue?.subscribeNext { [weak self] value in
                let selected: Bool = (~value) ?? false
                self?.selected = selected
            }

            objc_setAssociatedObject(self, &Keys.SlotSelectionSignal, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            objc_setAssociatedObject(self, &Keys.SlotSelectionDisposable, disposable, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var slotAction: ActionWrapper? {
        get {
            return objc_getAssociatedObject(self, &Keys.SlotAction) as? ActionWrapper
        } set {
            objc_setAssociatedObject(self, &Keys.SlotAction, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            addActionAndTargetIfNeeded()
        }
    }
    
    private func addActionAndTargetIfNeeded()
    {
        for selector in actionsForTarget(self, forControlEvent: UIControlEvents.TouchUpInside) ?? [] {
            if (selector == "slotActionPerformAction:") {
                return
            }
        }
        
        addTarget(self, action: "slotActionPerformAction:", forControlEvents: UIControlEvents.TouchUpInside)
    }
        
    func slotActionPerformAction(sender: AnyObject!)
    {
        slotAction?.execute(sender)
    }

}
