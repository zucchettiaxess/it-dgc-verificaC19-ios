import Foundation
#if !os(macOS)
import UIKit

extension String {
    public func isInDescendantOf(_ view: UIView) -> Bool {
        return view.findAccessibilityDescendant { (view: UIView) in
            return ((view as? UITextView)?.text == self || (view as? UILabel)?.text == self) } != nil
    }
    
    public func isAbsentIn(_ view: UIView) -> Bool {
        return !isInDescendantOf(view)
    }
}

#endif
