//
//  UIVerticalButton.swift
//  Waterfly
//
//  Created by Bryan Loon on 07.09.15.
//  Copyright © 2015 Loon. All rights reserved.
//


import Foundation


class UIVerticalButton: UIButton
{
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        let totalHeight = (self.imageView?.frame.height ?? 0) + (self.titleLabel?.frame.height ?? 0) + 5
        
        if let imageView = self.imageView {
            imageView.frame.origin.x = (self.bounds.size.width - imageView.frame.size.width) / 2.0
            imageView.frame.origin.y = self.bounds.size.height / 2.0 - totalHeight / 2.0
        }
        if let titleLabel = self.titleLabel {
            titleLabel.frame.origin.x = (self.bounds.size.width - titleLabel.frame.size.width) / 2.0
            titleLabel.frame.origin.y = self.bounds.size.height / 2.0 + totalHeight / 2.0 - titleLabel.frame.height
        }
    }
}
