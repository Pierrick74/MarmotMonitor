//
//  MarmotMonitorWidget.swift
//  MarmotMonitorWidget
//
//  Created by pierrick viret on 29/01/2025.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), data: [.diaper: .now, .sleep: .now])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), data: [.diaper: Date(timeIntervalSinceNow: -3600), .sleep: .now])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let currentDate = Date()
        let entry = SimpleEntry(date: currentDate, data: getLatestActivityText())

        // Mise à jour à la minute suivante
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        WidgetCenter.shared.reloadTimelines(ofKind: "MarmotMonitorWidget")
        completion(timeline)
    }

    private func getLatestActivityText() -> [ActivityCategory: Date] {
        let sharedDefaults = UserDefaults(suiteName: "group.marmotmonitor")
        let decoder = JSONDecoder()

        if let savedData = sharedDefaults?.data(forKey: "widgetActivities"),
           let decoded = try? decoder.decode([ActivityCategory: Date].self, from: savedData) {
            return decoded
        }
        return [:]
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let data: [ActivityCategory: Date]
}

struct MarmotMonitorWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        Text("Dernière activité:")
        Spacer(minLength: 20)
        HStack(spacing: 20) {
            SimpleWidget(date: entry.data[.sleep], type: .sleep)
            SimpleWidget(date: entry.data[.food], type: .food)
            SimpleWidget(date: entry.data[.diaper], type: .diaper)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct MarmotMonitorWidget: Widget {
    let kind: String = "MarmotMonitorWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MarmotMonitorWidgetEntryView(entry: entry)
                .containerBackground(.fill.secondary, for: .widget)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemSmall) {
    MarmotMonitorWidget()
} timeline: {
    SimpleEntry(date: Date(), data: [.diaper: .now])

}
