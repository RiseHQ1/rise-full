//
//  MotivationDataBank.swift
//  Rise
//
//  Created by Rise Team on 24/08/2026.
//

import Foundation

/// Extensive database of quotes, wisdom, daily thoughts, and affirmations.
public enum MotivationDataBank {
    public struct QuoteRecord: Identifiable, Hashable, Sendable {
        public let id: UUID
        public let quote: String
        public let author: String
        public let category: String
        public let tags: [String]
        public let assetName: String

        public init(
            id: UUID = UUID(),
            quote: String,
            author: String,
            category: String,
            tags: [String] = [],
            assetName: String = "onboarding_motivation_bg"
        ) {
            self.id = id
            self.quote = quote
            self.author = author
            self.category = category
            self.tags = tags
            self.assetName = assetName
        }
    }

    /// Master seed collection of curated foundational quotes across life dimensions.
    public static let baseQuotes: [QuoteRecord] = [
        // Mindset & Growth
        .init(
            quote: "Your calm mind is the ultimate weapon against your challenges.",
            author: "Marcus Aurelius",
            category: "Mindset",
            tags: ["calm", "challenges", "strength", "stoic"]
        ),
        .init(
            quote: "We suffer more often in imagination than in reality.",
            author: "Seneca",
            category: "Mindset",
            tags: ["overthinking", "anxiety", "reality", "peace"]
        ),
        .init(
            quote: "You have power over your mind - not outside events. Realize this, and you will find strength.",
            author: "Marcus Aurelius",
            category: "Mindset",
            tags: ["control", "strength", "power"]
        ),
        .init(
            quote: "The only limit to our realization of tomorrow will be our doubts of today.",
            author: "Franklin D. Roosevelt",
            category: "Mindset",
            tags: ["doubt", "future", "belief"]
        ),
        .init(
            quote: "It is not death that a man should fear, but he should fear never beginning to live.",
            author: "Marcus Aurelius",
            category: "Mindset",
            tags: ["living", "courage", "action"]
        ),
        .init(
            quote: "What we achieve inwardly will change outer reality.",
            author: "Plutarch",
            category: "Mindset",
            tags: ["growth", "change", "inner peace"]
        ),
        .init(
            quote: "The happiness of your life depends upon the quality of your thoughts.",
            author: "Marcus Aurelius",
            category: "Mindset",
            tags: ["happiness", "thoughts", "mind"]
        ),
        .init(
            quote: "Everything can be taken from a man but one thing: to choose one's attitude.",
            author: "Viktor E. Frankl",
            category: "Mindset",
            tags: ["freedom", "attitude", "choice"]
        ),
        .init(
            quote: "He who has a why to live can bear almost any how.",
            author: "Friedrich Nietzsche",
            category: "Mindset",
            tags: ["purpose", "meaning", "resilience"]
        ),
        .init(
            quote: "Adopt the pace of nature: her secret is patience.",
            author: "Ralph Waldo Emerson",
            category: "Mindset",
            tags: ["patience", "nature", "peace"]
        ),
        .init(
            quote: "The mind is everything. What you think you become.",
            author: "Buddha",
            category: "Mindset",
            tags: ["mind", "growth", "becoming"]
        ),
        .init(
            quote: "In the middle of difficulty lies opportunity.",
            author: "Albert Einstein",
            category: "Mindset",
            tags: ["opportunity", "challenges", "genius"]
        ),
        .init(
            quote: "The future belongs to those who believe in the beauty of their dreams.",
            author: "Eleanor Roosevelt",
            category: "Mindset",
            tags: ["dreams", "future", "hope"]
        ),
        .init(
            quote: "Believe you can and you're halfway there.",
            author: "Theodore Roosevelt",
            category: "Mindset",
            tags: ["belief", "courage", "action"]
        ),
        .init(
            quote: "Change your thoughts and you change your world.",
            author: "Norman Vincent Peale",
            category: "Mindset",
            tags: ["thoughts", "transformation", "world"]
        ),

        // Discipline & Consistency
        .init(
            quote: "Discipline equals freedom.",
            author: "Jocko Willink",
            category: "Discipline",
            tags: ["freedom", "habits", "consistency"]
        ),
        .init(
            quote: "We are what we repeatedly do. Excellence, then, is not an act, but a habit.",
            author: "Will Durant",
            category: "Discipline",
            tags: ["habits", "excellence", "repetition"]
        ),
        .init(
            quote: "Small disciplines repeated with consistency every day lead to great achievements.",
            author: "John C. Maxwell",
            category: "Discipline",
            tags: ["small steps", "consistency", "achievement"]
        ),
        .init(
            quote: "You do not rise to the level of your goals. You fall to the level of your systems.",
            author: "James Clear",
            category: "Discipline",
            tags: ["systems", "goals", "habits", "atomic"]
        ),
        .init(
            quote: "The secret of getting ahead is getting started.",
            author: "Mark Twain",
            category: "Discipline",
            tags: ["start", "action", "progress"]
        ),
        .init(
            quote: "Motivation is what gets you started. Habit is what keeps you going.",
            author: "Jim Ryun",
            category: "Discipline",
            tags: ["motivation", "habit", "consistency"]
        ),
        .init(
            quote: "Self-discipline begins with the mastery of your thoughts.",
            author: "Napoleon Hill",
            category: "Discipline",
            tags: ["mastery", "thoughts", "control"]
        ),
        .init(
            quote: "Do something today that your future self will thank you for.",
            author: "Sean Patrick Flanery",
            category: "Discipline",
            tags: ["future", "investment", "effort"]
        ),
        .init(
            quote: "Action is the foundational key to all success.",
            author: "Pablo Picasso",
            category: "Discipline",
            tags: ["action", "success", "work"]
        ),
        .init(
            quote: "Don’t count the days, make the days count.",
            author: "Muhammad Ali",
            category: "Discipline",
            tags: ["time", "presence", "effort"]
        ),
        .init(
            quote: "Great things are not done by impulse, but by a series of small things brought together.",
            author: "Vincent van Gogh",
            category: "Discipline",
            tags: ["small things", "art", "consistency"]
        ),
        .init(
            quote: "The distance between dreams and reality is called discipline.",
            author: "Paulo Coelho",
            category: "Discipline",
            tags: ["dreams", "reality", "action"]
        ),
        .init(
            quote: "Consistency is what transforms average into excellence.",
            author: "Tony Robbins",
            category: "Discipline",
            tags: ["consistency", "excellence", "mastery"]
        ),
        .init(
            quote: "I fear not the man who has practiced 10,000 kicks once, but the man who practiced one kick 10,000 times.",
            author: "Bruce Lee",
            category: "Discipline",
            tags: ["practice", "mastery", "repetition"]
        ),
        .init(
            quote: "Rest at the end, not in the middle.",
            author: "Kobe Bryant",
            category: "Discipline",
            tags: ["mamba", "effort", "relentless"]
        ),

        // Calm & Mindfulness
        .init(
            quote: "Peace is the result of retraining your mind to process life as it is.",
            author: "Wayne Dyer",
            category: "Calm",
            tags: ["peace", "acceptance", "mindfulness"]
        ),
        .init(
            quote: "Feelings come and go like clouds in a windy sky. Conscious breathing is my anchor.",
            author: "Thich Nhat Hanh",
            category: "Calm",
            tags: ["breath", "anchor", "feelings"]
        ),
        .init(
            quote: "Smile, breathe, and go slowly.",
            author: "Thich Nhat Hanh",
            category: "Calm",
            tags: ["smile", "breathe", "slow"]
        ),
        .init(
            quote: "The present moment is filled with joy and happiness. If you are attentive, you will see it.",
            author: "Thich Nhat Hanh",
            category: "Calm",
            tags: ["presence", "joy", "now"]
        ),
        .init(
            quote: "Silence is a source of great strength.",
            author: "Lao Tzu",
            category: "Calm",
            tags: ["silence", "strength", "solitude"]
        ),
        .init(
            quote: "Nature does not hurry, yet everything is accomplished.",
            author: "Lao Tzu",
            category: "Calm",
            tags: ["nature", "patience", "peace"]
        ),
        .init(
            quote: "Within you, there is a stillness and a sanctuary to which you can retreat at any time.",
            author: "Hermann Hesse",
            category: "Calm",
            tags: ["stillness", "sanctuary", "inner peace"]
        ),
        .init(
            quote: "Quiet the mind, and the soul will speak.",
            author: "Ma Jaya Sati Bhagavati",
            category: "Calm",
            tags: ["quiet", "soul", "listening"]
        ),
        .init(
            quote: "Look past your thoughts, so you may drink the pure nectar of this moment.",
            author: "Rumi",
            category: "Calm",
            tags: ["rumi", "presence", "nectar"]
        ),
        .init(
            quote: "Breath is the bridge which connects life to consciousness.",
            author: "Thich Nhat Hanh",
            category: "Calm",
            tags: ["breath", "bridge", "awareness"]
        ),
        .init(
            quote: "Realize deeply that the present moment is all you ever have.",
            author: "Eckhart Tolle",
            category: "Calm",
            tags: ["now", "presence", "power of now"]
        ),
        .init(
            quote: "The soul should always stand ajar, ready to welcome the ecstatic experience.",
            author: "Emily Dickinson",
            category: "Calm",
            tags: ["soul", "openness", "peace"]
        ),
        .init(
            quote: "Tension is who you think you should be. Relaxation is who you are.",
            author: "Chinese Proverb",
            category: "Calm",
            tags: ["relaxation", "truth", "authenticity"]
        ),
        .init(
            quote: "Do not let the behavior of others destroy your inner peace.",
            author: "Dalai Lama",
            category: "Calm",
            tags: ["inner peace", "boundaries", "equanimity"]
        ),
        .init(
            quote: "When you touch one thing with deep awareness, you touch everything.",
            author: "Thich Nhat Hanh",
            category: "Calm",
            tags: ["awareness", "oneness", "mindfulness"]
        ),

        // Resilience & Overcoming
        .init(
            quote: "The oak fought the wind and was broken, the willow bent when it must and survived.",
            author: "Robert Jordan",
            category: "Resilience",
            tags: ["flexibility", "survival", "strength"]
        ),
        .init(
            quote: "It always seems impossible until it's done.",
            author: "Nelson Mandela",
            category: "Resilience",
            tags: ["impossible", "perseverance", "hope"]
        ),
        .init(
            quote: "Fall seven times, stand up eight.",
            author: "Japanese Proverb",
            category: "Resilience",
            tags: ["perseverance", "grit", "rising"]
        ),
        .init(
            quote: "Hard times arouse an instinctive desire for authenticity.",
            author: "Coco Chanel",
            category: "Resilience",
            tags: ["hard times", "truth", "authenticity"]
        ),
        .init(
            quote: "Out of difficulties grow miracles.",
            author: "Jean de La Bruyère",
            category: "Resilience",
            tags: ["miracles", "difficulty", "growth"]
        ),
        .init(
            quote: "Strength does not come from winning. Your struggles develop your strengths.",
            author: "Arnold Schwarzenegger",
            category: "Resilience",
            tags: ["struggle", "strength", "growth"]
        ),
        .init(
            quote: "If you're going through hell, keep going.",
            author: "Winston Churchill",
            category: "Resilience",
            tags: ["keep going", "grit", "courage"]
        ),
        .init(
            quote: "Turn your wounds into wisdom.",
            author: "Oprah Winfrey",
            category: "Resilience",
            tags: ["wisdom", "healing", "experience"]
        ),
        .init(
            quote: "Although the world is full of suffering, it is also full of the overcoming of it.",
            author: "Helen Keller",
            category: "Resilience",
            tags: ["overcoming", "hope", "suffering"]
        ),
        .init(
            quote: "A smooth sea never made a skilled sailor.",
            author: "Franklin D. Roosevelt",
            category: "Resilience",
            tags: ["challenge", "skill", "growth"]
        ),
        .init(
            quote: "You may have to fight a battle more than once to win it.",
            author: "Margaret Thatcher",
            category: "Resilience",
            tags: ["perseverance", "victory", "tenacity"]
        ),
        .init(
            quote: "Rock bottom became the solid foundation on which I rebuilt my life.",
            author: "J.K. Rowling",
            category: "Resilience",
            tags: ["foundation", "rebuilding", "hope"]
        ),
        .init(
            quote: "The gem cannot be polished without friction, nor man perfected without trials.",
            author: "Chinese Proverb",
            category: "Resilience",
            tags: ["gem", "trials", "perfection"]
        ),
        .init(
            quote: "Difficulties strengthen the mind, as labor does the body.",
            author: "Seneca",
            category: "Resilience",
            tags: ["strength", "mind", "stoic"]
        ),
        .init(
            quote: "I am not what happened to me, I am what I choose to become.",
            author: "Carl Jung",
            category: "Resilience",
            tags: ["choice", "identity", "becoming"]
        ),

        // Focus & Clarity
        .init(
            quote: "Simplicity is the ultimate sophistication.",
            author: "Leonardo da Vinci",
            category: "Focus",
            tags: ["simplicity", "clarity", "focus"]
        ),
        .init(
            quote: "Focus is a muscle. The more you practice single-tasking, the stronger you become.",
            author: "Cal Newport",
            category: "Focus",
            tags: ["deep work", "attention", "focus"]
        ),
        .init(
            quote: "Concentrate all your thoughts upon the work in hand. The sun's rays do not burn until focused.",
            author: "Alexander Graham Bell",
            category: "Focus",
            tags: ["concentration", "energy", "work"]
        ),
        .init(
            quote: "Lack of direction, not lack of time, is the problem. We all have twenty-four hour days.",
            author: "Zig Ziglar",
            category: "Focus",
            tags: ["direction", "time", "priority"]
        ),
        .init(
            quote: "The successful warrior is the average man, with laser-like focus.",
            author: "Bruce Lee",
            category: "Focus",
            tags: ["warrior", "laser", "focus"]
        ),
        .init(
            quote: "Edit your life frequently and ruthlessly. It's your masterpiece after all.",
            author: "Nathan W. Morris",
            category: "Focus",
            tags: ["editing", "priority", "masterpiece"]
        ),
        .init(
            quote: "Clarity precedes success.",
            author: "Robin Sharma",
            category: "Focus",
            tags: ["clarity", "success", "vision"]
        ),
        .init(
            quote: "Where your attention goes, your energy flows.",
            author: "James Redfield",
            category: "Focus",
            tags: ["attention", "energy", "flow"]
        ),
        .init(
            quote: "Beware the barrenness of a busy life.",
            author: "Socrates",
            category: "Focus",
            tags: ["busy", "simplicity", "wisdom"]
        ),
        .init(
            quote: "Essentialism is about getting the right things done.",
            author: "Greg McKeown",
            category: "Focus",
            tags: ["essentialism", "priority", "choice"]
        ),
        .init(
            quote: "Deciding what not to do is as important as deciding what to do.",
            author: "Steve Jobs",
            category: "Focus",
            tags: ["apple", "priorities", "focus"]
        ),
        .init(
            quote: "The key is not to prioritize your schedule, but to schedule your priorities.",
            author: "Stephen Covey",
            category: "Focus",
            tags: ["schedule", "priorities", "time"]
        ),
        .init(
            quote: "Saying no to the good allows you to say yes to the great.",
            author: "John C. Maxwell",
            category: "Focus",
            tags: ["boundaries", "excellence", "choice"]
        ),

        // Gratitude & Joy
        .init(
            quote: "Gratitude turns what we have into enough.",
            author: "Anonymous",
            category: "Gratitude",
            tags: ["enough", "contentment", "gratitude"]
        ),
        .init(
            quote: "When you arise in the morning think of what a precious privilege it is to be alive.",
            author: "Marcus Aurelius",
            category: "Gratitude",
            tags: ["morning", "privilege", "alive"]
        ),
        .init(
            quote: "Enjoy the little things, for one day you may look back and realize they were the big things.",
            author: "Robert Brault",
            category: "Gratitude",
            tags: ["little things", "memories", "joy"]
        ),
        .init(
            quote: "Wear gratitude like a cloak, and it will feed every corner of your life.",
            author: "Rumi",
            category: "Gratitude",
            tags: ["rumi", "cloak", "abundance"]
        ),
        .init(
            quote: "Gratitude is the healthiest of all human emotions.",
            author: "Zig Ziglar",
            category: "Gratitude",
            tags: ["health", "emotion", "thankful"]
        ),
        .init(
            quote: "The roots of all goodness lie in the soil of appreciation for goodness.",
            author: "Dalai Lama",
            category: "Gratitude",
            tags: ["goodness", "appreciation", "kindness"]
        ),
        .init(
            quote: "There is always something to be grateful for in every sunrise.",
            author: "Rise Team",
            category: "Gratitude",
            tags: ["sunrise", "hope", "morning"]
        ),
        .init(
            quote: "He is a wise man who does not grieve for what he lacks, but rejoices for what he has.",
            author: "Epictetus",
            category: "Gratitude",
            tags: ["wisdom", "joy", "contentment"]
        ),
        .init(
            quote: "Gratitude makes sense of our past, brings peace for today, and creates a vision for tomorrow.",
            author: "Melody Beattie",
            category: "Gratitude",
            tags: ["peace", "vision", "past"]
        ),
        .init(
            quote: "Acknowledging the good you have in your life is the foundation for all abundance.",
            author: "Eckhart Tolle",
            category: "Gratitude",
            tags: ["abundance", "foundation", "goodness"]
        ),

        // Courage & Confidence
        .init(
            quote: "Courage is the assessment that something else is more important than fear.",
            author: "Franklin D. Roosevelt",
            category: "Confidence",
            tags: ["courage", "fear", "action"]
        ),
        .init(
            quote: "You have been criticizing yourself for years. Try approving of yourself and see what happens.",
            author: "Louise Hay",
            category: "Confidence",
            tags: ["self-love", "approval", "kindness"]
        ),
        .init(
            quote: "No one can make you feel inferior without your consent.",
            author: "Eleanor Roosevelt",
            category: "Confidence",
            tags: ["dignity", "self-respect", "strength"]
        ),
        .init(
            quote: "Doubt kills more dreams than failure ever will.",
            author: "Suzy Kassem",
            category: "Confidence",
            tags: ["doubt", "dreams", "failure"]
        ),
        .init(
            quote: "Trust yourself. You’ve survived a lot, and you will survive whatever is coming.",
            author: "Robert Tew",
            category: "Confidence",
            tags: ["trust", "survival", "strength"]
        ),

        // Leadership, Purpose & Vision
        .init(
            quote: "Working hard for something we don't care about is stress; working for what we love is passion.",
            author: "Simon Sinek",
            category: "Purpose",
            tags: ["passion", "work", "purpose"]
        ),
        .init(
            quote: "Your time is limited, so don't waste it living someone else's life.",
            author: "Steve Jobs",
            category: "Purpose",
            tags: ["time", "authenticity", "legacy"]
        ),
        .init(
            quote: "Be the change that you wish to see in the world.",
            author: "Mahatma Gandhi",
            category: "Purpose",
            tags: ["change", "world", "integrity"]
        ),
        .init(
            quote: "If you can't fly then run; if you can't run then walk; keep moving forward.",
            author: "Martin Luther King Jr.",
            category: "Purpose",
            tags: ["forward", "progress", "unstoppable"]
        ),
        .init(
            quote: "A goal without a plan is just a wish.",
            author: "Antoine de Saint-Exupéry",
            category: "Purpose",
            tags: ["planning", "goals", "action"]
        ),
        .init(
            quote: "Small daily improvements over time lead to stunning results.",
            author: "Robin Sharma",
            category: "Purpose",
            tags: ["improvement", "results", "daily"]
        ),

        // Stoic Sovereignty
        .init(
            quote: "No man is free who is not master of himself.",
            author: "Epictetus",
            category: "Stoicism",
            tags: ["freedom", "self-mastery", "stoic"]
        ),
        .init(
            quote: "It is a rough road that leads to the heights of greatness.",
            author: "Seneca",
            category: "Stoicism",
            tags: ["greatness", "adversity", "grit"]
        ),
        .init(
            quote: "Waste no more time arguing what a good man should be. Be one.",
            author: "Marcus Aurelius",
            category: "Stoicism",
            tags: ["character", "action", "virtue"]
        ),
        .init(
            quote: "You will earn the respect of all if you begin by earning the respect of yourself.",
            author: "Musonius Rufus",
            category: "Stoicism",
            tags: ["self-respect", "virtue", "dignity"]
        ),
        .init(
            quote: "First say to yourself what you would be; and then do what you have to do.",
            author: "Epictetus",
            category: "Stoicism",
            tags: ["identity", "action", "clarity"]
        ),
        .init(
            quote: "Well-being is attained little by little, and is no little thing itself.",
            author: "Zeno of Citium",
            category: "Stoicism",
            tags: ["wellbeing", "small steps", "zeno"]
        ),

        // Compassion & Healing
        .init(
            quote: "Talk to yourself like you would to someone you love.",
            author: "Brené Brown",
            category: "Healing",
            tags: ["self-compassion", "love", "kindness"]
        ),
        .init(
            quote: "You are the sky. Everything else is just the weather.",
            author: "Pema Chödrön",
            category: "Healing",
            tags: ["sky", "impermanence", "calm"]
        ),
        .init(
            quote: "We're all just walking each other home.",
            author: "Ram Dass",
            category: "Healing",
            tags: ["compassion", "unity", "connection"]
        ),
        .init(
            quote: "The curious paradox is that when I accept myself as I am, then I can change.",
            author: "Carl Rogers",
            category: "Healing",
            tags: ["acceptance", "change", "psychology"]
        ),
        .init(
            quote: "True power is sitting with yourself and accepting who you are in this moment.",
            author: "Yung Pueblo",
            category: "Healing",
            tags: ["presence", "self-love", "power"]
        ),

        // Deep Craft & Creative Flow
        .init(
            quote: "Art is never finished, only abandoned.",
            author: "Leonardo da Vinci",
            category: "Creativity",
            tags: ["art", "craft", "creation"]
        ),
        .init(
            quote: "You can't use up creativity. The more you use, the more you have.",
            author: "Maya Angelou",
            category: "Creativity",
            tags: ["creativity", "abundance", "energy"]
        ),
        .init(
            quote: "The object isn’t to make art; it’s to be in that state which makes art inevitable.",
            author: "Rick Rubin",
            category: "Creativity",
            tags: ["rubin", "flow", "art"]
        ),
        .init(
            quote: "Do what you believe in. Paint a picture of the future. Go there.",
            author: "Seth Godin",
            category: "Creativity",
            tags: ["vision", "future", "leadership"]
        ),

        // Evening Peace & Letting Go
        .init(
            quote: "Sleep knits up the raveled sleeve of care. Rest your mind tonight.",
            author: "Rumi",
            category: "Evening",
            tags: ["sleep", "rest", "night", "peace"]
        ),
        .init(
            quote: "Letting go gives us freedom, and freedom is the only condition for happiness.",
            author: "Thich Nhat Hanh",
            category: "Evening",
            tags: ["freedom", "happiness", "letting go"]
        ),
        .init(
            quote: "Muddy water is best cleared by leaving it alone.",
            author: "Alan Watts",
            category: "Evening",
            tags: ["clarity", "stillness", "zen"]
        ),
    ]
}
