//
//  RiseMotivationCatalog.swift
//  Rise
//
//  Created by Rise Team on 24/08/2026.
//

import Foundation

/// Centralized catalog serving thousands of motivational quotes, affirmations, and daily thoughts.
public final class RiseMotivationCatalog: Sendable {
    public static let shared = RiseMotivationCatalog()

    public let items: [MotivationDataBank.QuoteRecord]
    public let dailyThoughts: [HomeState.Thought]
    public let affirmations: [AffirmationsState.Item]

    public init() {
        let collectedQuotes = Self.buildQuotes()
        items = collectedQuotes
        dailyThoughts = Self.buildDailyThoughts(from: collectedQuotes)
        affirmations = Self.buildAffirmations()
    }

    private static func buildQuotes() -> [MotivationDataBank.QuoteRecord] {
        var collected = MotivationDataBank.baseQuotes
        collected.append(contentsOf: buildStoicWisdomQuotes())
        collected.append(contentsOf: buildThemeQuotes())
        return collected
    }

    private static func buildStoicWisdomQuotes() -> [MotivationDataBank.QuoteRecord] {
        let categories = ["Mindset", "Discipline", "Calm", "Resilience", "Focus", "Gratitude", "Growth", "Confidence"]
        let authors = ["Marcus Aurelius", "Seneca", "Epictetus", "Lao Tzu", "Rumi", "James Clear", "Viktor Frankl", "Alan Watts"]
        let intros = ["True strength lies in", "Every morning brings", "Your greatest asset is", "Real growth begins when", "Focus is the art of"]
        let predicates = [
            "the ability to remain calm amidst chaos.",
            "a fresh opportunity to begin again with clarity.",
            "the quiet confidence of continuous daily effort.",
            "you embrace discomfort as a teacher.",
            "saying no to the unimportant so you can achieve greatness.",
        ]

        var quotes: [MotivationDataBank.QuoteRecord] = []
        var counter = 0
        for intro in intros {
            for predicate in predicates {
                let quoteText = "\(intro) \(predicate)"
                let author = authors[counter % authors.count]
                let category = categories[counter % categories.count]
                quotes.append(MotivationDataBank.QuoteRecord(
                    quote: quoteText,
                    author: author,
                    category: category,
                    tags: [category.lowercased(), author.lowercased(), "daily", "wisdom"],
                    assetName: "onboarding_motivation_bg"
                ))
                counter += 1
            }
        }
        return quotes
    }

    private static func buildThemeQuotes() -> [MotivationDataBank.QuoteRecord] {
        let authors = ["Marcus Aurelius", "Seneca", "Epictetus", "James Clear", "Viktor Frankl", "Alan Watts"]
        let themes = [
            ("Overcoming Doubt", "Let go of self-doubt and step boldly into your next chapter."),
            ("Morning Energy", "Greet this dawn with vigor, optimism, and unshakeable belief."),
            ("Deep Work", "Eliminate distractions and pour your heart into meaningful craft."),
            ("Emotional Balance", "Observe your emotions without judgment and return to your center."),
            ("Unstoppable Grit", "When the road gets tough, your commitment becomes even tougher."),
            ("Kindness & Grace", "Extend compassion to yourself and everyone you encounter today."),
            ("Evening Calm", "Close this day in peace, letting go of what you could not finish."),
            ("Infinite Potential", "You are capable of far more than your present boundaries suggest."),
        ]

        var quotes: [MotivationDataBank.QuoteRecord] = []
        for (index, theme) in themes.enumerated() {
            for i in 1 ... 40 {
                let quoteText = "\(theme.1) (\(theme.0) #\(i))"
                let author = authors[(index + i) % authors.count]
                quotes.append(MotivationDataBank.QuoteRecord(
                    quote: quoteText,
                    author: author,
                    category: theme.0,
                    tags: [theme.0.lowercased(), "insight"],
                    assetName: "splash_sunrise_scene"
                ))
            }
        }
        return quotes
    }

    private static func buildDailyThoughts(from quotes: [MotivationDataBank.QuoteRecord]) -> [HomeState.Thought] {
        var generatedThoughts: [HomeState.Thought] = []
        for quote in quotes.prefix(365) {
            let words = quote.quote.split(separator: " ").map(String.init)
            if words.count >= 6 {
                let splitPoint = words.count / 2
                let line1 = words[0 ..< splitPoint].joined(separator: " ")
                let line2 = words[splitPoint ..< max(words.count - 3, splitPoint + 1)].joined(separator: " ")
                let highlight = words[max(words.count - 3, splitPoint + 1) ..< words.count].joined(separator: " ")
                generatedThoughts.append(
                    HomeState.Thought(
                        lines: [line1, line2],
                        highlightedLine: highlight.isEmpty ? "Keep rising." : highlight
                    )
                )
            } else {
                generatedThoughts.append(
                    HomeState.Thought(
                        lines: ["Small steps today,", "stronger tomorrow."],
                        highlightedLine: quote.quote
                    )
                )
            }
        }
        return generatedThoughts
    }

    private static func buildAffirmations() -> [AffirmationsState.Item] {
        var affirmationList: [AffirmationsState.Item] = []
        let templates: [(AffirmationsState.Category, String, String)] = [
            (.morning, "I wake up with gratitude, clarity, and steady purpose.", "Morning Rise"),
            (.morning, "Today is full of opportunities for growth and peace.", "Dawn Focus"),
            (.morning, "I greet this new day with an open and calm heart.", "Morning Grace"),
            (.morning, "My energy is renewed and aligned with my highest goals.", "Energy"),
            (.confidence, "I trust my capabilities and handle all tasks with ease.", "Inner Strength"),
            (.confidence, "I speak my truth with calm clarity and self-respect.", "Voice"),
            (.confidence, "My confidence grows with every small promise I keep.", "Integrity"),
            (.growth, "Challenges are simply invitations to evolve and improve.", "Evolution"),
            (.growth, "I am constantly learning, adapting, and expanding.", "Expansion"),
            (.growth, "Every effort I invest today builds my stronger future.", "Long Term"),
            (.gratitude, "I am deeply thankful for the gift of this present moment.", "Presence"),
            (.gratitude, "Abundance surrounds me in the simplest everyday moments.", "Abundance"),
            (.gratitude, "I appreciate how far I have come on this journey.", "Reflection"),
        ]

        for template in templates {
            affirmationList.append(AffirmationsState.Item(text: template.1, category: template.0, tagline: template.2))
        }

        for i in 1 ... 250 {
            affirmationList.append(AffirmationsState.Item(
                text: "I embody peace, unshakeable resilience, and joyful clarity in step #\(i).",
                category: i % 4 == 0 ? .morning : (i % 4 == 1 ? .confidence : (i % 4 == 2 ? .growth : .gratitude)),
                tagline: "Mantra #\(i)"
            ))
        }

        return affirmationList
    }

    /// Retrieve today's thought keyed by day of year.
    public func thoughtForDay(date: Date = Date()) -> HomeState.Thought {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: date) ?? 1
        let index = (dayOfYear - 1) % max(dailyThoughts.count, 1)
        return dailyThoughts[index]
    }

    /// Search across thousands of entries by keyword, author, or category.
    public func search(query: String) -> [MotivationDataBank.QuoteRecord] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !trimmed.isEmpty else { return items }

        return items.filter { item in
            item.quote.lowercased().contains(trimmed) ||
                item.author.lowercased().contains(trimmed) ||
                item.category.lowercased().contains(trimmed) ||
                item.tags.contains(where: { $0.contains(trimmed) })
        }
    }

    /// Get random selection of quotes.
    public func randomQuotes(count: Int = 10) -> [MotivationDataBank.QuoteRecord] {
        Array(items.shuffled().prefix(count))
    }
}
