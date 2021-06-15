#if !os(macOS)
import UIKit

extension UIControl {
    public func tap() -> Bool {
        if accessibilityActivate() {
            return true
        }

        var anyReturnValue: Any?
        
        // accessibilityActivate() wasn't possible so do it manually. We don't use the convenient
        // sendActions(for controlEvents: UIControl.Event) since that relies on UIApplication.shared
        // which may not be available if we're not running the test in a hosting app
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .touchUpInside)?.forEach { actionName in
                let returnValue = (target as NSObjectProtocol).perform(Selector(actionName), with: self)
                if anyReturnValue == nil {
                    anyReturnValue = returnValue
                }
            }
        }
        return anyReturnValue != nil
    }
}
#endif
