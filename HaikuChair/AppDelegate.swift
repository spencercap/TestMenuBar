//
//  AppDelegate.swift
//  Haiku Chair
//
//  Created by Spencer Cappiello on 03/21/20
//  Copyright (c) 2020 Spencer Cappiello. All rights reserved.
//

import Cocoa

private let kAppleInterfaceThemeChangedNotification = "AppleInterfaceThemeChangedNotification"
private let kAppleInterfaceStyle = "AppleInterfaceStyle"
private let kAppleInterfaceStyleSwitchesAutomatically = "AppleInterfaceStyleSwitchesAutomatically"

enum OSAppearance: Int {
    case light
    case dark
}

//@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var osAppearance: OSAppearance = .light
    
    //strong reference to retain the status bar item object
	var statusItem: NSStatusItem?
    
    @IBOutlet weak var appMenu: NSMenu!
    
    @objc func displayMenu() {
        guard let button = statusItem?.button else { return }
        let x = button.frame.origin.x
        let y = button.frame.origin.y - 5
        let location = button.superview!.convert(NSMakePoint(x, y), to: nil)
        let w = button.window!
        let event = NSEvent.mouseEvent(with: .leftMouseUp,
                                       location: location,
                                       modifierFlags: NSEvent.ModifierFlags(rawValue: 0),
                                       timestamp: 0,
                                       windowNumber: w.windowNumber,
                                       context: w.graphicsContext,
                                       eventNumber: 0,
                                       clickCount: 1,
                                       pressure: 0)!
        NSMenu.popUpContextMenu(appMenu, with: event, for: button)
    }
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {

        
    
        
        /* statusItem icon as string / emoji */
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.button?.title = "💭" //ops: ✨ 🔮

        
//        /* statusItem icon as PNG */
//        statusItem = NSStatusBar.system.statusItem(withLength: -1)
//
        guard let button = statusItem?.button else {
            print("status bar item failed. Try removing some menu bar item.")
            NSApp.terminate(nil)
            return
        }
//        button.image = NSImage(named: NSImage.Name(rawValue: "MenuBarButton"))
        button.target = self
        button.action = #selector(displayMenu)
        
//
//
//        /* menubar icon appearance change listener */
//        DistributedNotificationCenter.default().addObserver(
//            self,
//            selector: #selector(self.appleInterfaceThemeChangedNotification(notification:)),
//            name: NSNotification.Name(rawValue: kAppleInterfaceThemeChangedNotification),
//            object: nil
//        )
//
//        /* init menubar icon appearance */
//        getAppearance()
        
        
          /* statusItem icon as custom view */
//        let DEFAULT_W = 28
//        let DEFAULT_H = 22
//        let txt = NSTextField(frame: NSMakeRect(0, 0, CGFloat(DEFAULT_W), CGFloat(DEFAULT_H)))
//        txt.stringValue = "🙃"
//        let mStatusBackgroundView = NSView(frame: NSMakeRect(0, 0, CGFloat(DEFAULT_W), CGFloat(DEFAULT_H)))
//        mStatusBackgroundView.addSubview(txt)
//        statusItem = NSStatusBar.system.statusItem(withLength: CGFloat(DEFAULT_W))
//        statusItem?.view = mStatusBackgroundView;

    }
    
    @objc func appleInterfaceThemeChangedNotification(notification: Notification) {
        getAppearance()
    }
    
    func getAppearance() {
        self.osAppearance = .light
        if #available(OSX 10.15, *) {
            let appearanceDescription = NSApplication.shared.effectiveAppearance.debugDescription.lowercased()
            if appearanceDescription.contains("dark") {
                self.osAppearance = .dark
            }
        } else if #available(OSX 10.14, *) {
            if let appleInterfaceStyle = UserDefaults.standard.object(forKey: kAppleInterfaceStyle) as? String {
                if appleInterfaceStyle.lowercased().contains("dark") {
                    self.osAppearance = .dark
                }
            }
        }
        updateAppearance()
    }
    
    func updateAppearance() {
        
        guard let button = statusItem?.button else {
            print("status bar item failed. Try removing some menu bar item.")
            NSApp.terminate(nil)
            return
        }
        
        DispatchQueue.main.async {
            switch self.osAppearance {
            case .light:
                print("is now Light");
                button.image = NSImage(named: NSImage.Name(rawValue: "MenuBarButton"))
            case .dark:
                print("is now Dark");
                button.image = NSImage(named: NSImage.Name(rawValue: "MenuBarButtonDark"))
            }
        }
    }
	
    @IBAction func openHaikuGirl(_ sender: Any) {
        if let localHref = URL(string: "https://www.instagram.com/haiku_girl/") {
            NSWorkspace.shared.open(localHref)
        }
    }
}

