//
//  ErrorView.swift
//  EssentialFeediOS
//
//  Created by Khushnidjon on 25/04/23.
//

import UIKit

public final class ErrorView: UIView {
    @IBOutlet private var label: UILabel!
    
    public var message: String? {
        get { return alpha > 0 ? label.text : nil }
        set { setMessageAnimated(newValue) }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        label.text = nil
        alpha = 0
    }
    
    private func setMessageAnimated(_ message: String?) {
        guard let message else { return hideMessageAnimated() }
        label.text = message
        
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
    
    @IBAction private func hideMessageAnimated() {
        UIView.animate(withDuration: 0.25, animations: { self.alpha = 0 }, completion: { done in
            guard done else { return }
            self.label.text = nil
        })
    }
}
