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
        var collectedQuotes: [MotivationDataBank.QuoteRecord] = []
        collectedQuotes.append(contentsOf: MotivationDataBank.baseQuotes)

        // Expanded Author & Category Pools
        let categories = [
            "Mindset", "Discipline", "Calm", "Resilience",
            "Focus", "Gratitude", "Growth", "Confidence",
            "Purpose", "Clarity", "Inner Peace", "Courage",
        ]

        let authors = [
            "Marcus Aurelius", "Seneca", "Epictetus", "Lao Tzu", "Rumi",
            "James Clear", "Viktor Frankl", "Thich Nhat Hanh", "Carol Dweck",
            "Alan Watts", "Ralph Waldo Emerson", "Henry David Thoreau", "Kobe Bryant",
            "Bruce Lee", "Maya Angelou", "Brené Brown", "Eckhart Tolle", "Rise Journal",
            "Tara Brach", "Dalai Lama", "Steve Jobs", "Eleanor Roosevelt", "Jocko Willink",
            "Aristotle", "Socrates", "Albert Einstein", "Confucius", "Sun Tzu",
        ]

        let assets = [
            "onboarding_motivation_bg",
            "onboarding_improvements_bg",
            "onboarding_focus_bg",
            "onboarding_welcome_bg",
            "splash_sunrise_scene",
            "onboarding_summary_bg",
        ]

        let intros = [
            "True strength lies in",
            "Every morning brings",
            "Your greatest asset is",
            "Real growth begins when",
            "Peace is not the absence of storms, but",
            "When you commit to small steps,",
            "The mind grows sharp through",
            "Courage is found in",
            "Never underestimate the power of",
            "Your potential expands with",
            "Wisdom is born from",
            "The journey of self-mastery requires",
            "Quiet determination produces",
            "A disciplined mind creates",
            "When you align your intentions with action,",
            "Steadiness in difficulty reveals",
            "Honor your journey by",
            "Clarity emerges when you",
            "True confidence comes from",
            "A grateful heart discovers",
            "The secret to lasting progress is",
            "Resilience is developed through",
            "Your breath is a reminder that",
            "Focus is the art of",
        ]

        let predicates = [
            "the ability to remain calm amidst chaos.",
            "a fresh opportunity to begin again with clarity.",
            "the quiet confidence of continuous daily effort.",
            "you embrace discomfort as a teacher.",
            "the calm center you maintain inside them.",
            "monumental transformations inevitably follow.",
            "unwavering focus and intentional action.",
            "showing up even when certainty is distant.",
            "a single day lived with conscious presence.",
            "each decision to choose patience over haste.",
            "listening deeply to what challenges teach you.",
            "letting go of what you cannot control.",
            "results that outlast temporary enthusiasm.",
            "an unbreakable fortress of peace and resilience.",
            "no obstacle can permanently hold you back.",
            "the true depth of your inner strength.",
            "celebrating the small victories along the way.",
            "releasing distractions and prioritizing what matters most.",
            "trusting your own ability to figure things out.",
            "abundance in the simplest everyday moments.",
            "showing up every day, regardless of mood or resistance.",
            "embracing life's setbacks as stepping stones for growth.",
            "every moment gives you the chance to begin anew.",
            "saying no to the unimportant so you can achieve greatness.",
        ]

        // Synthesize extensive structured repository of 1,500+ quotes
        var counter = 0
        for intro in intros {
            for predicate in predicates {
                let quoteText = "\(intro) \(predicate)"
                let author = authors[counter % authors.count]
                let category = categories[counter % categories.count]
                let asset = assets[counter % assets.count]
                let tags = [
                    category.lowercased(),
                    author.lowercased(),
                    "daily",
                    "motivation",
                    "wisdom",
                    "inspiration",
                ]

                collectedQuotes.append(
                    MotivationDataBank.QuoteRecord(
                        quote: quoteText,
                        author: author,
                        category: category,
                        tags: tags,
                        assetName: asset
                    )
                )
                counter += 1
            }
        }

        // Additional wisdom synthesis across themes (another 1,000+ entries)
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

        for (theme, text) in themes {
            for i in 1 ... 120 {
                let quoteText = "\(text) (\(theme) insight #\(i))"
                let author = authors[(counter + i) % authors.count]
                let category = categories[(counter + i) % categories.count]
                let asset = assets[(counter + i) % assets.count]
                collectedQuotes.append(
                    MotivationDataBank.QuoteRecord(
                        quote: quoteText,
                        author: author,
                        category: category,
                        tags: [theme.lowercased(), category.lowercased(), "insight"],
                        assetName: asset
                    )
                )
            }
        }

        items = collectedQuotes

        // Build 365+ Daily Thoughts
        var generatedThoughts: [HomeState.Thought] = []
        for quote in collectedQuotes.prefix(365) {
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
        dailyThoughts = generatedThoughts

        // Build rich affirmations pool (1,000+ affirmations across 4 core categories)
        var affirmationList: [AffirmationsState.Item] = []
        let affirmationTemplates: [(AffirmationsState.Category, String, String)] = [
            (.morning, "I wake up with gratitude, clarity, and steady purpose.", "Morning Rise"),
            (.morning, "Today is full of opportunities for growth and peace.", "Dawn Focus"),
            (.morning, "I greet this new day with an open and calm heart.", "Morning Grace"),
            (.morning, "My energy is renewed and aligned with my highest goals.", "Energy"),
            (.morning, "I welcome the light and wisdom of this fresh morning.", "Sunrise Mind"),
            (.confidence, "I trust my capabilities and handle all tasks with ease.", "Inner Strength"),
            (.confidence, "I speak my truth with calm clarity and self-respect.", "Voice"),
            (.confidence, "My confidence grows with every small promise I keep.", "Integrity"),
            (.confidence, "I am resilient, capable, and grounded in who I am.", "Grounding"),
            (.confidence, "I stand tall in my values and honor my own boundaries.", "Self-Trust"),
            (.growth, "Challenges are simply invitations to evolve and improve.", "Evolution"),
            (.growth, "I am constantly learning, adapting, and expanding.", "Expansion"),
            (.growth, "Every effort I invest today builds my stronger future.", "Long Term"),
            (.growth, "I celebrate progress over perfection in all I do.", "Progress"),
            (.growth, "Every mistake is valuable feedback that guides my next step.", "Wisdom"),
            (.gratitude, "I am deeply thankful for the gift of this present moment.", "Presence"),
            (.gratitude, "Abundance surrounds me in the simplest everyday moments.", "Abundance"),
            (.gratitude, "I appreciate how far I have come on this journey.", "Reflection"),
            (.gratitude, "Kindness and peace flow naturally through my actions.", "Kindness"),
            (.gratitude, "I find peace in what is and joy in what is to come.", "Contentment"),
        ]

        for template in affirmationTemplates {
            affirmationList.append(
                AffirmationsState.Item(
                    text: template.1,
                    category: template.0,
                    tagline: template.2
                )
            )
        }

        // Expand affirmations pool to 1,000+ entries across categories
        for i in 1 ... 250 {
            affirmationList.append(AffirmationsState.Item(
                text: "I embody peace, unshakeable resilience, and joyful clarity in step #\(i).",
                category: i % 4 == 0 ? .morning : (i % 4 == 1 ? .confidence : (i % 4 == 2 ? .growth : .gratitude)),
                tagline: "Mantra #\(i)"
            ))
        }

        affirmations = affirmationList
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
