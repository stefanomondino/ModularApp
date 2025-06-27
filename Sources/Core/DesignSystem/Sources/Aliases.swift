//
//  Aliases.swift
//  DesignSystem
//
//  Created by Stefano Mondino on 25/06/25.
//

#if os(macOS)
    import AppKit.NSColor
    import AppKit.NSFont
    import AppKit.NSImage

    public typealias Image = NSImage
    public typealias Color = NSColor
    public typealias Font = NSFont
    import AppKit.NSViewController

    public typealias ViewController = NSViewController
    public typealias EdgeInsets = NSEdgeInsets
    public extension EdgeInsets {
        static var zero: EdgeInsets {
            NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
#else
    import UIKit.UIColor
    import UIKit.UIFont
    import UIKit.UIImage

    public typealias Color = UIColor
    public typealias Image = UIImage
    public typealias Font = UIFont
    public typealias EdgeInsets = UIEdgeInsets
    #if os(watchOS)
        import WatchKit.WKController

        public typealias ViewController = WKController
    #else
        import UIKit.UIViewController

        public typealias ViewController = UIViewController
    #endif
#endif
