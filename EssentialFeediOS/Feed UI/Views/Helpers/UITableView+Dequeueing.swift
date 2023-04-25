//
//  UITableView+Dequeueing.swift
//  EssentialFeediOS
//
//  Created by Khushnidjon on 25/03/23.
//

import UIKit

extension UITableView {
     func dequeueReusableCell<T: UITableViewCell>() -> T {
         let identifier = String(describing: T.self)
         return dequeueReusableCell(withIdentifier: identifier) as! T
     }
 }
