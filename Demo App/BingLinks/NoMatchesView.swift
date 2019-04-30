//
//  NoMatchesView.swift
//  Swollmeights
//
//  Created by Matthew Reid on 4/13/18.
//  Copyright © 2018 Matthew Reid. All rights reserved.
//

import UIKit

class NoMatchesView: UIView {
    var view : UIView!
    
    @IBOutlet weak var changeLocation: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        view = loadNib()
        
            addSubview(view)
            view.frame = self.bounds
            self.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}

extension UIView {
    
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "FindView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}
