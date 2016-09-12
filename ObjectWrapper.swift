//
//  ObjectWrapper.swift
//  Waterfly
//
//  Created by Bryan Loon on 05.11.15.
//  Copyright © 2015 Loon. All rights reserved.
//


import ReactiveCocoa


class ObjectWrapper<T>
{
    var value:T
    
    init(initialValue: T)
    {
        value = initialValue
    }
}


prefix operator ~ {}

prefix func ~<T> (object: AnyObject) -> T?
{
    var value: T?
    if let object = object as? ObjectWrapper<T> {
        value = object.value
    }

    return value
}

