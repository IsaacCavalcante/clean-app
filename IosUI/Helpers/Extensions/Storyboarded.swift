import Foundation
import UIKit

public protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    public static func instantiate() -> Self {
        let vcName = String(describing: self)
        let storyBoardName = vcName.components(separatedBy: "ViewController")[0] + "Storyboard"
        let bundle = Bundle(for: Self.self)
        let sb = UIStoryboard(name: storyBoardName, bundle: bundle)
        
        return sb.instantiateViewController(identifier: vcName) as! Self
    }
}
