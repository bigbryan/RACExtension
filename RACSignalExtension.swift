//
//  RACSignalExtension.swift
//  Waterfly
//
//  Created by Bryan Loon on 06.15.15.
//  Copyright © 2015 Loon. All rights reserved.
//


import ReactiveCocoa


extension RACSignal
{
    func flatMapError(catchBlock: (error: NSError) -> RACSignal) -> RACSignal
    {
        return RACSignal.createSignal { subscriber in
            let catchDisposable = RACSerialDisposable()
            
            let subscriptionDisposable = self.subscribeNext({ x in
                subscriber.sendNext(x)
            }, error: { error in
                let signal = catchBlock(error: error);
                catchDisposable.disposable = signal.subscribe(subscriber)
            }, completed: { _ in
                subscriber.sendCompleted()
            })
            
            return RACDisposable(block: { () -> Void in
                catchDisposable.dispose()
                subscriptionDisposable?.dispose()
            })
        }
    }
    
    func delayError( interval: NSTimeInterval) -> RACSignal
    {
        return self
        .flatMapError { error in
            return RACSignal.empty()
            .delay(interval)
            .concat(RACSignal.error(error))
        }
    }
    
    static func createSignalWithValue(value: AnyObject) -> RACSignal
    {
        return RACSignal.createSignal { subscriber in
            subscriber.sendNext(value)
            subscriber.sendCompleted()
            return nil
        }
    }
    
    static func createSignalWithBlock(block: () -> Void) -> RACSignal
    {
        return RACSignal.createSignal { subscriber in
            block()
            
            subscriber.sendNext(true)
            subscriber.sendCompleted()
            
            return nil
        }
    }
    
    func deliverOnBackgroundThread() -> RACSignal
    {
        return self.deliverOn(RACScheduler(priority: RACSchedulerPriorityDefault))
    }
}
