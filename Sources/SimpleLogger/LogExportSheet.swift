//
// Project:
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SwiftUI

#Preview {
    NavigationStack {
        LogExportSheet(vm: LogExportManager())
            .accentColor(.black)
    }
}

public struct LogExportSheet: View {

    @StateObject private var vm: LogExportManager
    private let navigationTitle: String
    private let navigationBarTitleDisplayMode: NavigationBarItem.TitleDisplayMode

    public init(
        vm: LogExportManager,
        navigationTitle: String = "Export Logs",
        navigationBarTitleDisplayMode: NavigationBarItem.TitleDisplayMode = .large
    ) {
        self._vm = StateObject(wrappedValue: vm)
        self.navigationTitle = navigationTitle
        self.navigationBarTitleDisplayMode = navigationBarTitleDisplayMode
    }

    public var body: some View {
        Form {
            filterTypeSection

            filterOptions

            actionButtonsSection

            NavigationLink {
                LogListScreen(logs: vm.logs.map { LogEntryWrapper.real($0) })
            } label: {
                Label("View logs", systemImage: "doc.plaintext")
            }
        }

        // Modifiers: navigation
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(navigationBarTitleDisplayMode)

        // Modifiers: ui
        .interactiveDismissDisabled()
        .opacity(vm.isExporting ? 0.6 : 1)
        .disabled(vm.isExporting)
        .overlay(overlayProgress)

        // Modifiers: fetching
        .task { vm.gatherLogs() }
        .onChange(of: vm.excludeSystemLogs) { _ in vm.gatherLogs() }
    }
}

extension LogExportSheet {

    private var overlayProgress: some View {
        ZStack(alignment: .center) {
            Color(.lightGray).opacity(0.2)
            ProgressView()
                .frame(width: 120, height: 120)
                .background {
                    Rectangle()
                        .fill(Color(.systemBackground))
                        .clipShape(.rect(cornerRadius: 16))
                        .shadow(radius: 2)
                }
        }
        .ignoresSafeArea()
        .opacity(vm.isExporting ? 1 : 0)
    }

    private var filterTypeSection: some View {
        Section {
            Picker("Filter by", selection: $vm.filterType) {
                ForEach(LogExportManager.FilterType.allCases, id: \.self) { type in
                    Text(type.description)
                        .tag(type)
                }
            }
            filterBySegments
        } header: {
            Text("Filter")
        } footer: {
            Text(filterFooterText)
        }
    }

    private var actionButtonsSection: some View {
        Section {

            ActionButton("Copy to clipboard",
                         imageName: "doc.on.doc",
                         action: vm.copyToClipboardAction)

            ActionButton("Export log file",
                         imageName: "square.and.arrow.down",
                         action: vm.exportLogFileAction)

            ActionButton("Share log file",
                         imageName: "square.and.arrow.up",
                         action: vm.shareLogFileAction)
        }
    }

    private var filterOptions: some View {
        Section {
            Toggle("Exclude system logs", isOn: $vm.excludeSystemLogs)
        } header: {
            Text("Options")
        } footer: {
            Text("If you activate **Exclude system logs** then only entries linked to this app's identifier will be extracted.")
        }
    }

    @ViewBuilder
    private var filterBySegments: some View {
        switch vm.filterType {
            case .specificDate: specificDateSegment
            case .dateRange: dateRangeSegment
            case .hourRange: hourRangeSegment
            case .preset: presetSegment
        }
    }

    private var specificDateSegment: some View {
        DatePicker(
            "Specific date",
            selection: $vm.specificDate,
            in: ...Date.now,
            displayedComponents: .date
        )
    }

    private var dateRangeSegment: some View {
        Group {
            DatePicker(
                "Start date",
                selection: $vm.dateRangeStart,
                in: ...vm.dateRangeFinish,
                displayedComponents: .date
            )
            DatePicker(
                "Finish date",
                selection: $vm.dateRangeFinish,
                in: vm.dateRangeStart...,
                displayedComponents: .date
            )
        }
    }

    private var hourRangeSegment: some View {
        Group {
            DatePicker(
                "Specific date",
                selection: $vm.specificDate,
                in: ...Date.now,
                displayedComponents: .date
            )
            DatePicker(
                "Start time",
                selection: $vm.hourRangeStart,
                in: ...vm.hourRangeFinish,
                displayedComponents: .hourAndMinute
            )
            DatePicker(
                "Finish time",
                selection: $vm.hourRangeFinish,
                in: vm.hourRangeStart...,
                displayedComponents: .hourAndMinute
            )
        }
    }

    private var presetSegment: some View {
        Picker("Preset option", selection: $vm.selectedPreset) {
            ForEach(LogExportManager.Preset.allCases, id: \.self) { preset in
                Text(preset.description)
                    .id(preset)
            }
        }
    }

    private var filterFooterText: String {
        switch vm.filterType {
            case .specificDate:
                return "Select a specific date to filter logs from that day only. All times are considered within the selected date."
            case .dateRange:
                return "Choose a start and end date to filter logs within a specific date range. Logs from both dates will be included."
            case .hourRange:
                return "Set a specific date and a range of hours to narrow down logs to a precise time window within the chosen day."
            case .preset:
                return "Select a preset option to quickly apply common date and time filters without manual adjustments."
        }
    }
}

@MainActor
fileprivate struct ActionButton: View {
    private let title: String
    private let imageName: String
    private let action: () -> Void

    init(
        _ title: String,
        imageName: String,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.imageName = imageName
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: imageName)
        }
    }
}
