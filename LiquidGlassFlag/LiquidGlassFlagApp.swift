//
//  LiquidGlassFlagApp.swift
//  LiquidGlassFlag
//
//  Created by Guilherme Rambo on 26/05/26.
//

import SwiftUI

nonisolated let kIgnoreDesignCompatibilityFlagUserDefaultsKey = "com.apple.SwiftUI.IgnoreSolariumOptOut"
nonisolated private let kRolledTheLiquidGlassDiceUserDefaultsKey = "codes.rambo.RolledTheLiquidGlassDice"

@main
struct LiquidGlassFlagApp: App {
    init() {
        Self.rollTheLiquidGlassDiceIfNeeded()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

    /**
     This is called on ``init()`` so that it runs before the app starts up,
     ensuring that the selected Liquid Glass state is persisted to user defaults
     before the system UI frameworks read it.
     */
    private static func rollTheLiquidGlassDiceIfNeeded() {
        guard !UserDefaults.standard.bool(forKey: kRolledTheLiquidGlassDiceUserDefaultsKey) else {
            print("🎲 Liquid Glass dice already rolled for this installation, skipping dice roll")
            return
        }
        UserDefaults.standard.set(true, forKey: kRolledTheLiquidGlassDiceUserDefaultsKey)

        let diceRoll = Int.random(in: 0...1024) % 2
        let enabledByDefault = diceRoll == 0

        print("🎲 Rolled the dice: this user will have Liquid Glass \(enabledByDefault ? "enabled" : "disabled") by default")

        UserDefaults.standard.set(enabledByDefault, forKey: kIgnoreDesignCompatibilityFlagUserDefaultsKey)
        UserDefaults.standard.synchronize()
    }
}
