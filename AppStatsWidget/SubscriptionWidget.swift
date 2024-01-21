import WidgetKit
import SwiftUI

struct SubscriptionProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SubscriptionEntry {
        SubscriptionEntry(date: Date(), model: AppStatsModel())
    }

    func snapshot(for configuration: SubscriptionAppIntent, in context: Context) async -> SubscriptionEntry {
        SubscriptionEntry(date: Date(), model: AppStatsModel())
    }
    
    func timeline(for configuration: SubscriptionAppIntent, in context: Context) async -> Timeline<SubscriptionEntry> {
        // TODO: Fetch reports
        

        let entryDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        return Timeline(entries: [SubscriptionEntry(date: entryDate, model: AppStatsModel())], policy: .atEnd)
    }
}

struct SubscriptionEntry: TimelineEntry {
    let date: Date
    let model: AppStatsModel
}

struct SubscriptionWidgetEntryView : View {
    var entry: SubscriptionProvider.Entry

    var body: some View {
        VStack {
            switch entry.model.state {
            case .success(let subscriberModelData):
                Text("Success! Subs: \(subscriberModelData.currentTotal)")
            case .authServiceError(let error):
                switch error {
                case .notInitialized:
                    Text("Auth not initialized")
                default:
                    Text("Auth error: \(error.localizedDescription)")
                }
            case .salesServiceError(let error):
                Text("Sales service error: \(error.localizedDescription)")
            case .notInitialized:
                Text("Not initialized")
            case .loading:
                LoadingDataView()
            }
        }
        .onAppear {
            entry.model.checkKeychainStatus()
        }
    }
}

struct SubscriptionWidget: Widget {
    let kind: String = "SubscriptionWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: SubscriptionAppIntent.self, provider: SubscriptionProvider()) { entry in
            SubscriptionWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}


#Preview(as: .systemSmall) {
    AppStatsWidget()
} timeline: {
    SubscriptionEntry(date: .now, model: AppStatsModel())
}
