//
//  AppIntent.swift
//  AppStatsWidget
//
//  Created by Alfred Lieth Årøe on 02/01/2024.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    // An example configurable parameter.
    @Parameter(title: "Favorite Emoji", default: "😃")
    var favoriteEmoji: String
}

struct SubscriptionAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    // An example configurable parameter.
    @Parameter(title: "Favorite Emoji", default: "😃")
    var favoriteEmoji: String
    
    //var options: DynamicOptionsProvider = DynamicOptionsProvider(
    // @Parameter(title: "Subscription grouping", optionsProvider: <#T##DynamicOptionsProvider#>)
}
