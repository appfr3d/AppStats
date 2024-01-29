import WidgetKit
import SwiftUI

struct SubscriptionProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SubscriptionEntry {
        SubscriptionEntry(date: Date(), model: AppStatsModel(), grouping: .none)
    }

    func snapshot(for configuration: SubscriptionAppIntent, in context: Context) async -> SubscriptionEntry {
        SubscriptionEntry(date: Date(), model: AppStatsModel(), grouping: .none)
    }
    
    func timeline(for configuration: SubscriptionAppIntent, in context: Context) async -> Timeline<SubscriptionEntry> {
        // TODO: Fetch reports
        let model = AppStatsModel()
        do {
            try await model.initiateAppStatsModel()
        } catch let error {
            print("Error in timeline: \(error)")
        }
        
        let entryDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        return Timeline(entries: [SubscriptionEntry(date: entryDate, model: model, grouping: configuration.grouping)], policy: .atEnd)
    }
}

struct SubscriptionEntry: TimelineEntry {
    let date: Date
    let model: AppStatsModel
    let grouping: SubscriptionGroup
}

struct SubscriptionWidgetEntryView : View {
    var entry: SubscriptionProvider.Entry
    @State var grouping: SubscriptionGroup

    init(entry: SubscriptionProvider.Entry) {
        self.entry = entry
        _grouping = State(initialValue: entry.grouping)
    }
    
    var body: some View {
        VStack {
            switch entry.model.state {
            case .success(let subscriberModelData):
                SubscriptionChartView(grouping: $grouping).environmentObject(subscriberModelData)
            case .authServiceError(let error):
                switch error {
                case .notInitialized:
                    Text("Auth not initialized")
                default:
                    Text("Auth error: \(error.localizedDescription)")
                }
            case .salesServiceError(let error):
                SalesServiceErrorView(error: error)
            case .notInitialized:
                Text("Not initialized")
            case .loading:
                LoadingDataView()
            }
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


#Preview("Small .none", as: .systemSmall) {
    SubscriptionWidget()
} timeline: {
    SubscriptionEntry(date: .now, model: AppStatsModel(), grouping: .none)
}


