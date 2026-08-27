//
//  ProgressTabView.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI

/// Progress tab matching the approved Progress mockup.
/// Named `ProgressTabView` to avoid collision with SwiftUI's `ProgressView`.
public struct ProgressTabView: View {
    @Environment(AppRouter.self) private var appRouter
    @State private var state = ProgressState()

    public init() {}

    public var body: some View {
        ZStack {
            backgroundLayer

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: RiseSpacing.lg) {
                    header

                    // Leave room for the boy / lantern hero above the streak card.
                    Color.clear
                        .frame(height: 56)

                    journeyCard
                    growthGlanceSection
                    middleRow
                    growthChartCard
                    focusAreasSection
                    achievementBanner
                        .padding(.horizontal, -RiseSpacing.md)
                }
                .padding(.horizontal, RiseSpacing.md)
                .padding(.top, RiseSpacing.xs)
                .riseTabBarScrollClearance()
            }
            .onAppear {
                state.loadName()
                state.reloadFocusAreas()
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $state.didTapShare) {
            RiseShareSheet(items: ["I'm on a \(state.streakDays) day streak with Rise! 🌟\nTracking my growth and staying consistent."])
        }
    }

    private var backgroundLayer: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                RiseTabBar.ambientBottom

                Image("progress_tab_bg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .topTrailing)
                    .clipped()
                    .accessibilityHidden(true)

                VStack(spacing: 0) {
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.08),
                            Color.clear,
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 56)

                    Spacer(minLength: 0)

                    LinearGradient(
                        colors: [
                            Color.clear,
                            RiseTabBar.ambientBottom.opacity(0.22),
                            RiseTabBar.ambientBottom.opacity(0.70),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: geo.size.height * 0.32)
                }
                .allowsHitTesting(false)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .clipped()
        }
        .ignoresSafeArea()
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Progress")
                    .font(RiseTypography.display)
                    .foregroundStyle(RiseColors.textPrimary)
                Text("Small steps. Real change.")
                    .font(RiseTypography.body)
                    .foregroundStyle(RiseColors.textSecondary)
            }
            Spacer()
            RiseIconButton(iconName: "square.and.arrow.up", accessibilityLabel: "Share progress", size: RiseIconButtonMetrics.standard) {
                state.didTapShare = true
            }
        }
    }

    private var journeyCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .center, spacing: 12) {
                HStack(alignment: .center, spacing: 10) {
                    Image("onboarding_icon_fire")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .accessibilityHidden(true)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(state.streakDays) Day Streak")
                            .font(RiseTypography.title)
                            .foregroundStyle(RiseColors.textPrimary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.82)

                        Text("Keep it going!")
                            .font(RiseTypography.footnoteMedium)
                            .foregroundStyle(RiseColors.textSecondary)
                            .lineLimit(1)
                    }
                }
                .layoutPriority(1)

                Rectangle()
                    .fill(RiseColors.borderSoft)
                    .frame(width: 1)
                    .frame(maxHeight: .infinity)
                    .padding(.vertical, 2)

                HStack(spacing: 6) {
                    ForEach(Array(["M", "T", "W", "T", "F", "S", "S"].enumerated()), id: \.offset) { index, day in
                        VStack(spacing: 4) {
                            ZStack {
                                if index < state.weekCompleted {
                                    Circle()
                                        .fill(RiseColors.accentSecondary)
                                        .frame(width: 22, height: 22)
                                    Image(systemName: "checkmark")
                                        .font(RiseTypography.microBold)
                                        .foregroundStyle(RiseColors.textOnGold)
                                } else {
                                    Circle()
                                        .strokeBorder(style: StrokeStyle(lineWidth: 1.2, dash: [3]))
                                        .foregroundStyle(RiseColors.borderStrong)
                                        .frame(width: 22, height: 22)
                                }
                            }

                            Text(day)
                                .font(RiseTypography.microSemibold)
                                .foregroundStyle(RiseColors.textMuted)
                        }
                        .frame(width: 22)
                    }
                }
                .fixedSize(horizontal: true, vertical: false)
            }
            .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 4) {
                Spacer(minLength: 0)
                Image(systemName: "star.fill")
                    .font(RiseTypography.microBold)
                    .foregroundStyle(RiseColors.accentSecondary)
                Text("Longest streak: \(state.longestStreak) days")
                    .font(RiseTypography.captionSemibold)
                    .foregroundStyle(RiseColors.textSecondary)
            }
        }
        .padding(16)
        .riseRichGlass(cornerRadius: RiseRadius.cardLarge)
    }

    private var growthGlanceSection: some View {
        VStack(alignment: .leading, spacing: RiseSpacing.sm) {
            HStack {
                Text("Your Growth at a Glance")
                    .font(RiseTypography.headlineBold)
                    .foregroundStyle(RiseColors.textPrimary)
                Spacer()
                Menu {
                    Button("This Week") {
                        RiseHaptic.selection()
                        state.selectedPeriod = "This Week"
                    }
                    Button("This Month") {
                        RiseHaptic.selection()
                        state.selectedPeriod = "This Month"
                    }
                    Button("This Year") {
                        RiseHaptic.selection()
                        state.selectedPeriod = "This Year"
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(state.selectedPeriod)
                        Image(systemName: "chevron.down")
                            .font(RiseTypography.microSemibold)
                    }
                    .font(RiseTypography.footnoteSemibold)
                    .foregroundStyle(RiseColors.accentPrimary)
                }
            }

            HStack(alignment: .top, spacing: 0) {
                ForEach(Array(state.stats.enumerated()), id: \.element.id) { index, stat in
                    VStack(spacing: 8) {
                        Image(stat.iconAssetName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                            .accessibilityHidden(true)

                        Text(stat.value)
                            .font(RiseTypography.titleSmallBold)
                            .foregroundStyle(RiseColors.textPrimary)
                            .minimumScaleFactor(0.7)
                            .lineLimit(1)

                        Text(stat.title)
                            .font(RiseTypography.microSemibold)
                            .foregroundStyle(RiseColors.textPrimary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .minimumScaleFactor(0.8)

                        Text(stat.delta)
                            .font(RiseTypography.micro)
                            .foregroundStyle(RiseColors.textMuted)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .minimumScaleFactor(0.75)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)

                    if index < state.stats.count - 1 {
                        Rectangle()
                            .fill(RiseColors.borderSoft)
                            .frame(width: 1)
                            .padding(.vertical, 2)
                            .frame(maxHeight: .infinity)
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 14)
            .fixedSize(horizontal: false, vertical: true)
            .riseRichGlass(cornerRadius: RiseRadius.cardLarge)
        }
    }

    private var middleRow: some View {
        HStack(alignment: .top, spacing: 10) {
            consistencyCard
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

            // Narrower sibling so Consistency keeps more width for the heatmap.
            reflectionFrequencyCard
                .frame(width: 148)
                .frame(maxHeight: .infinity, alignment: .topLeading)
        }
    }

    private var consistencyCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Consistency")
                .font(RiseTypography.subheadlineBold)
                .foregroundStyle(RiseColors.textPrimary)
            Text("Your daily reflection streak")
                .font(RiseTypography.micro)
                .foregroundStyle(RiseColors.textSecondary)

            Grid(alignment: .leading, horizontalSpacing: 4, verticalSpacing: 4) {
                GridRow {
                    ForEach(Array(state.consistencyMonthLabels.enumerated()), id: \.offset) { _, month in
                        Text(month.title)
                            .font(RiseTypography.microSemibold)
                            .foregroundStyle(RiseColors.textMuted)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .gridCellColumns(month.columns)
                    }
                }

                ForEach(0 ..< 4, id: \.self) { row in
                    GridRow {
                        ForEach(0 ..< 11, id: \.self) { column in
                            let index = row * 11 + column
                            let value = state.consistencyCells.indices.contains(index)
                                ? state.consistencyCells[index]
                                : 0
                            RoundedRectangle(cornerRadius: 3, style: .continuous)
                                .fill(consistencyColor(value))
                                .aspectRatio(1, contentMode: .fit)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }

            Spacer(minLength: 0)

            HStack(spacing: 8) {
                legendDot("Great", color: RiseColors.success)
                legendDot("Good", color: RiseColors.accentSecondary)
                legendDot("Some", color: RiseColors.accentPrimary)
                legendDot("Missed", color: RiseColors.textMuted.opacity(0.55))
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .riseRichGlass(cornerRadius: RiseRadius.card)
    }

    private var reflectionFrequencyCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Reflection Frequency")
                .font(RiseTypography.calloutBold)
                .foregroundStyle(RiseColors.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.85)
            Text("Days you journaled")
                .font(RiseTypography.micro)
                .foregroundStyle(RiseColors.textSecondary)

            Spacer(minLength: 0)

            ZStack {
                Circle()
                    .stroke(RiseColors.accentPrimary.opacity(0.22), lineWidth: 10)
                    .frame(width: 88, height: 88)
                Circle()
                    .trim(from: 0, to: CGFloat(state.reflectionDays) / CGFloat(max(state.reflectionGoal, 1)))
                    .stroke(
                        RiseColors.accentPrimary,
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .frame(width: 88, height: 88)
                    .shadow(color: RiseColors.accentPrimary.opacity(0.35), radius: 6)

                VStack(spacing: 1) {
                    Text("\(state.reflectionDays)")
                        .font(RiseTypography.title)
                        .foregroundStyle(RiseColors.textPrimary)
                    Text("Days")
                        .font(RiseTypography.micro)
                        .foregroundStyle(RiseColors.textSecondary)
                }
            }
            .frame(maxWidth: .infinity)

            Spacer(minLength: 0)

            HStack(spacing: 4) {
                Text("Goal: \(state.reflectionGoal) days")
                    .font(RiseTypography.micro)
                    .foregroundStyle(RiseColors.textSecondary)
                Image(systemName: "pencil")
                    .font(RiseTypography.microSemibold)
                    .foregroundStyle(RiseColors.textSecondary)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .riseRichGlass(cornerRadius: RiseRadius.card)
    }

    private var growthChartCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Growth Over Time")
                        .font(RiseTypography.calloutBold)
                        .foregroundStyle(RiseColors.textPrimary)
                    Text("You're showing up more consistently.")
                        .font(RiseTypography.caption)
                        .foregroundStyle(RiseColors.textSecondary)
                }
                Spacer()
                Menu {
                    Button("Journal Entries") {
                        RiseHaptic.selection()
                        state.selectedChartMetric = "Journal Entries"
                    }
                    Button("Focus Minutes") {
                        RiseHaptic.selection()
                        state.selectedChartMetric = "Focus Minutes"
                    }
                    Button("Reflections") {
                        RiseHaptic.selection()
                        state.selectedChartMetric = "Reflections"
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(state.selectedChartMetric)
                        Image(systemName: "chevron.down")
                            .font(RiseTypography.microSemibold)
                    }
                    .font(RiseTypography.captionSemibold)
                    .foregroundStyle(RiseColors.accentPrimary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(RiseColors.accentPrimary.opacity(0.14))
                    .clipShape(Capsule())
                }
            }

            ProgressGrowthChart(points: state.chartPoints)
                .frame(height: 168)
        }
        .padding(14)
        .riseRichGlass(cornerRadius: RiseRadius.cardLarge)
    }

    private var focusAreasSection: some View {
        VStack(alignment: .leading, spacing: RiseSpacing.sm) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your Focus Areas")
                        .font(RiseTypography.headlineBold)
                        .foregroundStyle(RiseColors.textPrimary)
                    Text("Areas you're improving the most")
                        .font(RiseTypography.footnote)
                        .foregroundStyle(RiseColors.textSecondary)
                }
                Spacer()
                Button("Manage") {
                    appRouter.push(.manageFocusAreas, on: .progress)
                }
                .font(RiseTypography.calloutSemibold)
                .foregroundStyle(RiseColors.accentPrimary)
            }

            VStack(spacing: 12) {
                ForEach(state.focusAreas) { area in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            Image(area.iconAssetName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 22)
                            Text(area.title)
                                .font(RiseTypography.calloutSemibold)
                                .foregroundStyle(RiseColors.textPrimary)
                            Spacer()
                            Text("\(Int(area.percent * 100))%")
                                .font(RiseTypography.footnoteBold)
                                .foregroundStyle(Color(hex: area.accentHex))
                        }

                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(RiseColors.borderSubtle.opacity(0.8))
                                    .frame(height: 8)
                                Capsule()
                                    .fill(Color(hex: area.accentHex))
                                    .frame(width: geo.size.width * area.percent, height: 8)
                            }
                        }
                        .frame(height: 8)
                    }
                }
            }
            .padding(14)
            .riseRichGlass(cornerRadius: RiseRadius.card)
        }
    }

    private var achievementBanner: some View {
        Button {
            state.didTapAchievement = true
            appRouter.push(.morningBoost, on: .progress)
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "trophy.fill")
                    .font(RiseTypography.title)
                    .foregroundStyle(RiseColors.accentSecondary)

                Text("You're doing amazing, \(state.userFirstName)! Proud of your progress. Keep rising.")
                    .font(RiseTypography.footnoteSemibold)
                    .foregroundStyle(RiseColors.textPrimary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: "chevron.right")
                    .font(RiseTypography.calloutBold)
                    .foregroundStyle(RiseColors.accentSecondary)
            }
            .padding(.horizontal, RiseSpacing.md)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background {
                ZStack {
                    Image("onboarding_motivation_bg")
                        .resizable()
                        .scaledToFill()
                    LinearGradient(
                        colors: [
                            RiseColors.accentPrimary.opacity(0.55),
                            RiseColors.accentSecondary.opacity(0.45),
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                }
            }
            .clipped()
        }
        .buttonStyle(RisePressableButtonStyle())
    }

    private func consistencyColor(_ value: Int) -> Color {
        switch value {
        case 3: return RiseColors.success
        case 2: return RiseColors.accentSecondary
        case 1: return RiseColors.accentPrimary
        default: return RiseColors.textMuted.opacity(0.35)
        }
    }

    private func legendDot(_ title: String, color: Color) -> some View {
        HStack(spacing: 3) {
            Circle().fill(color).frame(width: 6, height: 6)
            Text(title)
                .font(RiseTypography.micro)
                .foregroundStyle(RiseColors.textMuted)
        }
    }
}

private struct ProgressGrowthChart: View {
    let points: [CGFloat]

    @State private var selectedIndex: Int = 0

    private let yLabels: [CGFloat] = [30, 20, 10, 0]
    private let xLabels = ["May", "Jun", "Jul"]

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            VStack(alignment: .trailing, spacing: 0) {
                ForEach(Array(yLabels.enumerated()), id: \.offset) { index, value in
                    Text("\(Int(value))")
                        .font(RiseTypography.micro)
                        .foregroundStyle(RiseColors.textMuted)
                    if index < yLabels.count - 1 {
                        Spacer(minLength: 0)
                    }
                }
            }
            .frame(width: 22)
            .frame(height: 132)
            .padding(.top, 4)

            VStack(spacing: 8) {
                GeometryReader { geo in
                    let chart = chartGeometry(in: geo.size)
                    let activeIndex = min(max(selectedIndex, 0), max(points.count - 1, 0))

                    ZStack(alignment: .topLeading) {
                        // Soft horizontal grid
                        ForEach(Array(yLabels.enumerated()), id: \.offset) { _, value in
                            let y = chart.y(value)
                            Path { path in
                                path.move(to: CGPoint(x: 0, y: y))
                                path.addLine(to: CGPoint(x: geo.size.width, y: y))
                            }
                            .stroke(RiseColors.borderSubtle.opacity(0.35), lineWidth: 0.8)
                        }

                        // Soft vertical guides under May / Jun / Jul
                        ForEach([0, max(points.count / 2, 0), max(points.count - 1, 0)], id: \.self) { index in
                            if chart.plotPoints.indices.contains(index) {
                                let x = chart.plotPoints[index].x
                                Path { path in
                                    path.move(to: CGPoint(x: x, y: 0))
                                    path.addLine(to: CGPoint(x: x, y: geo.size.height))
                                }
                                .stroke(RiseColors.borderSubtle.opacity(0.18), lineWidth: 0.8)
                            }
                        }

                        // Soft area fill under the curve
                        chart.areaPath
                            .fill(
                                LinearGradient(
                                    colors: [
                                        RiseColors.accentPrimary.opacity(0.22),
                                        RiseColors.accentPrimary.opacity(0.05),
                                        Color.clear,
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )

                        // Crisp stroke — no heavy glow/shadow
                        chart.linePath
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        RiseColors.accentPrimary.opacity(0.85),
                                        RiseColors.accentPrimary,
                                        Color(hex: "#A78BFA"),
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round)
                            )

                        // Point markers — tap to move the pill
                        ForEach(Array(chart.plotPoints.enumerated()), id: \.offset) { index, point in
                            let isSelected = index == activeIndex
                            Button {
                                withAnimation(.easeInOut(duration: 0.18)) {
                                    selectedIndex = index
                                }
                            } label: {
                                ZStack {
                                    if isSelected {
                                        Circle()
                                            .stroke(Color.white.opacity(0.92), lineWidth: 2)
                                            .frame(width: 14, height: 14)
                                        Circle()
                                            .fill(RiseColors.accentPrimary)
                                            .frame(width: 7, height: 7)
                                    } else {
                                        Circle()
                                            .fill(Color.white.opacity(0.92))
                                            .frame(width: 7, height: 7)
                                    }
                                }
                                .frame(width: 28, height: 28)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            .position(point)
                        }

                        // Pill follows the selected point
                        if chart.plotPoints.indices.contains(activeIndex) {
                            let activePoint = chart.plotPoints[activeIndex]
                            let value = points[activeIndex]

                            VStack(spacing: 0) {
                                Text("\(Int(value)) entries")
                                    .font(RiseTypography.microBold)
                                    .foregroundStyle(RiseColors.accentPrimary)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(RiseColors.backgroundAmbient.opacity(0.92))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .stroke(RiseColors.accentPrimary.opacity(0.65), lineWidth: 1)
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                                Triangle()
                                    .fill(RiseColors.accentPrimary.opacity(0.65))
                                    .frame(width: 10, height: 6)
                                    .offset(y: -1)
                            }
                            .position(
                                x: min(max(activePoint.x, 46), geo.size.width - 46),
                                y: max(activePoint.y - 28, 22)
                            )
                            .allowsHitTesting(false)
                        }
                    }
                    .animation(RiseAnimations.modalSpring, value: points)
                    .animation(RiseAnimations.interactiveSpring, value: selectedIndex)
                }
                .frame(height: 132)
                .onAppear {
                    selectedIndex = max(points.count - 1, 0)
                }
                .onChange(of: points.count) { _, _ in
                    selectedIndex = max(points.count - 1, 0)
                }

                HStack {
                    ForEach(xLabels, id: \.self) { label in
                        Text(label)
                            .font(RiseTypography.micro)
                            .foregroundStyle(RiseColors.textMuted)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }

    private func chartGeometry(in size: CGSize) -> ChartGeometry {
        let maxY = max(yLabels.first ?? 30, points.max() ?? 1, 1)
        let minY: CGFloat = 0
        let stepX = size.width / CGFloat(max(points.count - 1, 1))

        func y(for value: CGFloat) -> CGFloat {
            let normalized = (value - minY) / (maxY - minY)
            return size.height - normalized * size.height
        }

        func x(for index: CGFloat) -> CGFloat {
            index * stepX
        }

        let plotPoints: [CGPoint] = points.enumerated().map { index, value in
            CGPoint(x: x(for: CGFloat(index)), y: y(for: value))
        }

        return ChartGeometry(
            plotPoints: plotPoints,
            linePath: smoothPath(through: plotPoints),
            areaPath: {
                var path = smoothPath(through: plotPoints)
                guard let first = plotPoints.first, let last = plotPoints.last else { return path }
                path.addLine(to: CGPoint(x: last.x, y: size.height))
                path.addLine(to: CGPoint(x: first.x, y: size.height))
                path.closeSubpath()
                return path
            }(),
            y: y
        )
    }

    /// Quadratic mid-point smoothing — curved enough to feel neon, not over-spline-y.
    private func smoothPath(through points: [CGPoint]) -> Path {
        var path = Path()
        guard let first = points.first else { return path }
        path.move(to: first)
        guard points.count > 1 else { return path }

        if points.count == 2 {
            path.addLine(to: points[1])
            return path
        }

        for index in 0 ..< (points.count - 1) {
            let current = points[index]
            let next = points[index + 1]
            let mid = CGPoint(
                x: (current.x + next.x) / 2,
                y: (current.y + next.y) / 2
            )
            if index == 0 {
                path.addLine(to: mid)
            } else {
                path.addQuadCurve(to: mid, control: current)
            }
        }
        if let last = points.last {
            path.addQuadCurve(to: last, control: points[points.count - 2])
        }
        return path
    }
}

private struct ChartGeometry {
    let plotPoints: [CGPoint]
    let linePath: Path
    let areaPath: Path
    let y: (CGFloat) -> CGFloat
}

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

#Preview("ProgressTabView") {
    ProgressTabView()
}
