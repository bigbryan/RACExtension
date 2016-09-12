//
//  RACProperty.swift
//  Waterfly
//
//  Created by Bryan Loon on 05.11.15.
//  Copyright © 2015 Loon. All rights reserved.
//


import ReactiveCocoa


class RACProperty<T: Equatable>
{
    private var changeProducer = RACSubject()
    
    
    var changeSignal: RACSignal
    var value: T {
        didSet {
            if value != oldValue {
                let object = ObjectWrapper(initialValue: value)
                changeProducer.sendNext(object)
            }
        }
    }
    
    init(initialValue: T)
    {
        value = initialValue
        
        changeSignal = changeProducer.replayLast()
        
        changeProducer.sendNext(ObjectWrapper(initialValue: value))
    }
    
    deinit
    {
        changeProducer.sendCompleted()
    }
}
