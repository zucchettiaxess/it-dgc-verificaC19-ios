import Foundation
#if !os(macOS)
import UIKit

extension UIView {
    /// Find an object of the generic class for which the test returns true
    /// - Parameter test: Closure that should return true if this is a matching object. Defaults to returning true, so you'd get any object of the generic class.
    public func findAccessibilityDescendant<UITextView>(matching test: (UITextView) -> Bool = { _ in true }) -> UITextView? {
        guard !isHidden else { return nil }
        
        if let testObject = self as? UITextView, test(testObject) == true {
            return testObject
        }

        for subview in subviews.compactMap({ $0 as? UITextView }) {
            if test(subview) == true {
                return subview
            }
        }
        
        for subview in subviews {
            if let foundObject = subview.findAccessibilityDescendant(matching: test) {
                return foundObject
            }
        }
        
        return nil
    }
    
    public func findParent<T: NSObject>(matching test: (T) -> Bool = { _ in true }) -> T? {
        guard !isHidden else { return nil }
        
        if let testObject = self as? T, test(testObject) == true {
            return testObject
        }
        
        if let foundObject = superview?.findParent(matching: test) {
            return foundObject
        }
        
        return nil
    }
}
#endif
