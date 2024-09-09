//
// Project:
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SwiftUI
import OSLog

#Preview("LogListScreen: Full") {
    let logs = MockOSLogEntryLog.mockDataFull.map { LogEntryWrapper.mock($0) }
    return NavigationStack {
        LogListScreen(logs: logs)
    }
}
#Preview("LogListScreen: Empty") {
    let logs = MockOSLogEntryLog.mockDataEmpty.map { LogEntryWrapper.mock($0) }
    return NavigationStack {
        LogListScreen(logs: logs)
    }
}

import SwiftUI

public struct LogListScreen: View {
    @State private var searchText: String = ""
    @State private var logs: [LogEntryWrapper]
    @State private var selectedCategories: Set<String> = []
    @State private var selectedLevels: Set<OSLogEntryLog.Level> = []
    @State private var isFilterSheetPresented: Bool = false

    // Extracts unique categories from logs for the filter dropdown
    private var categories: [String] {
        Array(Set(logs.map { $0.category })).sorted()
    }

    // Extracts unique levels from logs for the filter picker
    private var levels: [OSLogEntryLog.Level] {
        Array(Set(logs.map { $0.level })).sorted { $0.rawValue < $1.rawValue }
    }

    // Filters logs based on search text, selected categories, and levels
    private var filteredLogs: [LogEntryWrapper] {
        logs.filter { log in
            (searchText.isEmpty || log.composedMessage.localizedCaseInsensitiveContains(searchText)) &&
            (selectedCategories.isEmpty || selectedCategories.contains(log.category)) &&
            (selectedLevels.isEmpty || selectedLevels.contains(log.level))
        }
    }

    internal init(logs: [LogEntryWrapper]) {
        self.logs = logs
    }

    public var body: some View {
        VStack {
            List(filteredLogs, id: \.id) { log in
                LogCell(for: log)
            }
            .navigationTitle("View Logs")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isFilterSheetPresented.toggle()
                    }) {
                        Image(systemName: "slider.horizontal.3")
                    }
                    .opacity(logs.count < 1 ? 0 : 1)
                }
            }
            .overlay {
                if filteredLogs.isEmpty {
                    VStack {
                        Text("No log entries found")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                }
            }
        }
        // Sheet with filter options
        .sheet(isPresented: $isFilterSheetPresented) {
            FilterSheet(
                selectedCategories: $selectedCategories,
                selectedLevels: $selectedLevels,
                categories: categories,
                levels: levels
            )
            .presentationDetents([.height(200)])
            .presentationDragIndicator(.visible)
        }
    }
}

// Filter Sheet for Category and Level Selection
struct FilterSheet: View {
    @Binding var selectedCategories: Set<String>
    @Binding var selectedLevels: Set<OSLogEntryLog.Level>
    let categories: [String]
    let levels: [OSLogEntryLog.Level]

    var body: some View {
        NavigationStack {
            Form {
                MultiSelectPicker(title: "Categories", options: categories, selectedOptions: $selectedCategories)

                    MultiSelectPicker(title: "Levels", options: levels, selectedOptions: $selectedLevels)
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// A reusable multi-select picker for filtering options
struct MultiSelectPicker<T: Hashable & CustomStringConvertible>: View {
    let title: String
    let options: [T]
    @Binding var selectedOptions: Set<T>

    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    if selectedOptions.contains(option) {
                        selectedOptions.remove(option)
                    } else {
                        selectedOptions.insert(option)
                    }
                }) {
                    Label(option.description,
                          systemImage: selectedOptions.contains(option) ? "checkmark" : "")
                }
            }
        } label: {
            HStack {
                Text(title)
                Spacer()
                Text(selectedOptions.isEmpty ? "None" : "\(selectedOptions.count) selected")
                    .foregroundColor(.gray)
            }
        }
    }
}

fileprivate struct LogCell: View {
    private let log: LogEntryWrapper

    init(for log: LogEntryWrapper) {
        self.log = log
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(log.level.color)
                        .frame(width: 24, height: 24)
                    Image(systemName: log.level.sfSymbol)
                        .frame(width: 22, height: 22)
                        .foregroundStyle(.white)
                }
                Text(log.date.formatted(date: .long, time: .standard))
                    .font(.system(.footnote, design: .monospaced))
            }

            Divider().background(log.level.color)

            Group {
                LabeledContent("Subsystem", value: log.subsystem)
                LabeledContent("Category", value: log.category)
                LabeledContent("Level", value: log.level.description)
                LabeledContent("Message", value: log.composedMessage)
            }
            .labeledContentStyle(.vertical)
        }
        .font(.footnote)
        .listRowBackground(log.level.color.opacity(0.1))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
