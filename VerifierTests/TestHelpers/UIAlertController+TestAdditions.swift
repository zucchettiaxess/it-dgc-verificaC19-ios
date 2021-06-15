#if !os(macOS)
import UIKit

extension UIAlertController {
    typealias AlertHandler = @convention(block) (UIAlertAction) -> Void
    
    public func tapButton(atIndex index: Int) {
        if let block = actions[index].value(forKey: "handler") {
            let handler = unsafeBitCast(block as AnyObject, to: AlertHandler.self)
            handler(actions[index])
        }
    }
    
}
#endif
