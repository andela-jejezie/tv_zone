//
//  Utility.swift
//  jtv
//
//  Created by Johnson Ejezie on 18/12/2016.
//  Copyright © 2016 johnsonejezie. All rights reserved.
//

import UIKit

extension UIView {
    func constrain(toMarginOf view:UIView) {
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func constrainToSuperview(_ top:CGFloat, trailing:CGFloat, bottom:CGFloat, leading:CGFloat) {
        guard let view = self.superview else {
            return
        }
        self.topAnchor.constraint(equalTo: view.topAnchor, constant: top).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:bottom).isActive = true
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:leading).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:trailing).isActive = true
    }
    
    func constrainToView(_ view:UIView, top:CGFloat?, trailing:CGFloat?, bottom:CGFloat?, leading:CGFloat?) {
        
        if let top = top {
           self.topAnchor.constraint(equalTo: view.topAnchor, constant: top).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:bottom).isActive = true
        }
        if let leading = leading {
           self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:leading).isActive = true
        }
        if let trailing = trailing {
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:trailing).isActive = true
        }
    }
    
    func center(toView view:UIView) {
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

extension String {
    func removeHTMLTags()->String {
        let htmlTag:String = "<[^>]+>"
        return self.replacingOccurrences(of: htmlTag, with: "", options: .regularExpression, range: Range(uncheckedBounds: (self.startIndex, self.endIndex)))

    }
}

extension UIImage {
    func imageWithImage(scaledToMaxWidth width:CGFloat, maxHeight height:CGFloat) -> UIImage {
        let oldWidth = self.size.width
        let oldHeight = self.size.height
        let scaleFactor = oldWidth > oldHeight ? width/oldWidth : height/oldHeight
        
        let newHeight = oldHeight * scaleFactor
        let newWidth = oldWidth * scaleFactor
        let newSize = CGSize(width: newWidth, height: newHeight)
        return self.imageWithImage(self, scaledToSize: newSize)
    }
    
    fileprivate func imageWithImage(_ image:UIImage, scaledToSize size:CGSize) -> UIImage {
        
        if UIScreen.main.responds(to: #selector(NSDecimalNumberBehaviors.scale)) {
            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        }else {
            UIGraphicsBeginImageContext(size)
        }
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
