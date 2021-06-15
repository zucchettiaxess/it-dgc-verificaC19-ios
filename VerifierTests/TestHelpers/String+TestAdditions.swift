import Foundation
#if !os(macOS)
import UIKit

extension String {
    public func isInDescendantOf(_ view: UIView) -> Bool {
        return view.findAccessibilityDescendant { $0.accessibilityLabel == self || $0.accessibilityValue == self } != nil
    }
    
    public func isAbsentIn(_ view: UIView) -> Bool {
        return !isInDescendantOf(view)
    }
}

#endif
