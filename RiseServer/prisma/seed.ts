//
//  seed.ts
//  RiseServer
//
//  Seed initial catalog with official Rise Packs, Affirmations, and rich Motivation Quotes with artwork assets
//

import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Starting rich Rise catalog seed with imagery...');

  // 1. Seed Official Rise Packs (Guide Section 5 & Appendix B)
  const packs = [
    {
      slug: 'morning-reset',
      title: 'Morning Reset',
      subtitle: 'Ignite clarity, purpose & high energy at sunrise',
      description:
        'A transformative 7-day morning routine pack designed to replace doom-scrolling with intentional motivation, mindful breathwork, and purposeful daily intentions.',
      heroArtwork: 'pack_morning_reset',
      theme: 'sunrise_gold',
      category: 'Morning',
      durationDays: 7,
      accessLevel: 'FREE',
      priceTier: 'Free',
      items: [
        { day: 1, title: 'Awakening With Intention', type: 'BOOST', content: 'You do not wake up to react; you wake up to create. Claim your first conscious breath today.', durationMinutes: 3, assetName: 'pack_morning_reset' },
        { day: 2, title: 'Release The Urge To Rush', type: 'AUDIO', content: 'Step out of the autopilot rush. Ground your feet into the earth and align with calm composure.', durationMinutes: 5, assetName: 'pack_morning_reset' },
        { day: 3, title: 'Setting Clean Boundaries', type: 'INTENTION', content: 'Today, I honor my mental energy by saying no to low-value noise and yes to purposeful depth.', durationMinutes: 4, assetName: 'pack_morning_reset' },
        { day: 4, title: 'The Power Of Gentle Momentum', type: 'BOOST', content: 'Great days are not built on monumental pressure, but on five small, steady victories executed with ease.', durationMinutes: 3, assetName: 'pack_morning_reset' },
        { day: 5, title: 'Solar Breathwork Awakening', type: 'CHALLENGE', content: 'Practice 3 minutes of deep box breathing before checking any digital message or inbox.', durationMinutes: 5, assetName: 'pack_morning_reset' },
        { day: 6, title: 'Unshakable Morning Presence', type: 'REFLECTION', content: 'How would your day feel if you moved through challenges with complete internal stillness?', durationMinutes: 4, assetName: 'pack_morning_reset' },
        { day: 7, title: 'Mastering The Sunrise Ritual', type: 'BOOST', content: 'You have established your foundation. Carry this calm, decisive momentum into every single morning.', durationMinutes: 5, assetName: 'pack_morning_reset' },
      ],
    },
    {
      slug: 'confidence',
      title: 'Unstoppable Confidence',
      subtitle: 'Overcome self-doubt and step boldly into your arena',
      description:
        'A 7-day courage curriculum delivering daily psychological reframings, self-trust affirmations, and courageous micro-challenges.',
      heroArtwork: 'pack_confidence',
      theme: 'warm_amber',
      category: 'Confidence',
      durationDays: 7,
      accessLevel: 'PRO',
      storeKitProductId: 'com.riseapp.pack.confidence',
      priceTier: '$2.99',
      items: [
        { day: 1, title: 'The Illusion of Perfection', type: 'BOOST', content: 'Confidence is not the absence of fear; it is the deep conviction that you can navigate whatever happens.', durationMinutes: 4, assetName: 'pack_confidence' },
        { day: 2, title: 'Trusting Your Instincts', type: 'INTENTION', content: 'I stand firmly in my capability. My past experiences have prepared me for this exact moment.', durationMinutes: 3, assetName: 'pack_confidence' },
        { day: 3, title: 'Speaking Without Apology', type: 'CHALLENGE', content: 'Speak up in your first conversation today clearly, calmly, and without unnecessary pre-apologies.', durationMinutes: 5, assetName: 'pack_confidence' },
        { day: 4, title: 'Reclaiming Your Inner Power', type: 'AUDIO', content: 'Harmonic solfeggio audio experience reinforcing self-worth and releasing comparison traps.', durationMinutes: 6, assetName: 'pack_confidence' },
        { day: 5, title: 'Reframing Disapproval', type: 'BOOST', content: 'Other people’s opinions are commentary on their own worldview, not a verdict on your potential.', durationMinutes: 4, assetName: 'pack_confidence' },
        { day: 6, title: 'Walking Tall and Grounded', type: 'INTENTION', content: 'I hold my posture high and carry myself with quiet, dignified certainty wherever I step.', durationMinutes: 3, assetName: 'pack_confidence' },
        { day: 7, title: 'The Fearless Mindset', type: 'REFLECTION', content: 'What bold move would you make today if you were guaranteed that your effort would lead to growth?', durationMinutes: 5, assetName: 'pack_confidence' },
      ],
    },
    {
      slug: 'deep-focus',
      title: 'Deep Focus & Flow',
      subtitle: 'Eliminate cognitive noise and master intense concentration',
      description:
        'Designed for students, creators, and high performers seeking to enter flow states on demand and protect mental bandwidth.',
      heroArtwork: 'pack_deep_focus',
      theme: 'indigo_depth',
      category: 'Focus',
      durationDays: 7,
      accessLevel: 'PRO',
      storeKitProductId: 'com.riseapp.pack.deepfocus',
      priceTier: '$2.99',
      items: [
        { day: 1, title: 'Entering The Sanctum of Focus', type: 'BOOST', content: 'Distraction is the thief of your potential. When you lock into one single task, magic happens.', durationMinutes: 4, assetName: 'pack_deep_focus' },
        { day: 2, title: 'The Single-Tasking Vow', type: 'INTENTION', content: 'Today, I complete one meaningful chapter of work before giving away my attention.', durationMinutes: 3, assetName: 'pack_deep_focus' },
        { day: 3, title: 'Alpha Wave Flow Immersion', type: 'AUDIO', content: 'Procedural 8Hz binaural soundscape optimized for deep cognitive endurance.', durationMinutes: 10, assetName: 'pack_deep_focus' },
        { day: 4, title: 'Resisting The Dopamine Hook', type: 'CHALLENGE', content: 'Place your phone in another room or out of arm reach during your main focus block.', durationMinutes: 5, assetName: 'pack_deep_focus' },
        { day: 5, title: 'The 25-Minute Sprint', type: 'BOOST', content: 'Do not measure the mountain. Measure the next 25 minutes of relentless, calm effort.', durationMinutes: 4, assetName: 'pack_deep_focus' },
        { day: 6, title: 'Protecting Mental Bandwidth', type: 'REFLECTION', content: 'What low-value task drained your cognitive battery this week, and how will you prune it?', durationMinutes: 4, assetName: 'pack_deep_focus' },
        { day: 7, title: 'The Architecture of Mastery', type: 'BOOST', content: 'Consistent depth separates the master from the amateur. You have the discipline to create great work.', durationMinutes: 5, assetName: 'pack_deep_focus' },
      ],
    },
    {
      slug: 'evening-reset',
      title: 'Evening Reset & Peaceful Sleep',
      subtitle: 'Unload the day’s weight and transition into restorative rest',
      description:
        'A soothing nightly wind-down ritual pairing gratitude, cognitive unburdening, and ambient sleep soundscapes.',
      heroArtwork: 'pack_evening_reset',
      theme: 'midnight_navy',
      category: 'Evening',
      durationDays: 7,
      accessLevel: 'FREE',
      priceTier: 'Free',
      items: [
        { day: 1, title: 'Dropping Today’s Armor', type: 'REFLECTION', content: 'Whatever happened today is done. Allow your shoulders to drop and exhale the day’s tension.', durationMinutes: 5, assetName: 'pack_evening_reset' },
        { day: 2, title: 'Three Moments of Quiet Wonder', type: 'INTENTION', content: 'I close this day grateful for the simple warmth, sustenance, and lessons received.', durationMinutes: 4, assetName: 'pack_evening_reset' },
        { day: 3, title: 'Deep Ocean Hush Sleep Session', type: 'AUDIO', content: 'Calming ocean surf ambient frequency gently lowering heart rate and soothing thoughts.', durationMinutes: 10, assetName: 'pack_evening_reset' },
        { day: 4, title: 'Forgiving The Unfinished', type: 'BOOST', content: 'Your worth is not measured by an empty to-do list. Rest is an essential part of the journey.', durationMinutes: 3, assetName: 'pack_evening_reset' },
        { day: 5, title: 'The 4-7-8 Somatic Exhale', type: 'CHALLENGE', content: 'Complete 4 cycles of 4-7-8 deep breathing lying on your back before sleep.', durationMinutes: 4, assetName: 'pack_evening_reset' },
        { day: 6, title: 'Releasing Control to the Night', type: 'REFLECTION', content: 'Write down one worry on paper, acknowledge it, and consciously leave it for tomorrow.', durationMinutes: 5, assetName: 'pack_evening_reset' },
        { day: 7, title: 'Complete Sanctuary of Rest', type: 'BOOST', content: 'Sleep deeply, knowing that tomorrow brings fresh vitality, clean slate, and boundless possibility.', durationMinutes: 4, assetName: 'pack_evening_reset' },
      ],
    },
    {
      slug: 'self-love',
      title: 'Radical Self-Love & Compassion',
      subtitle: 'Heal the inner critic and foster deep self-acceptance',
      description:
        'Cultivate genuine self-kindness, silence harsh internal narratives, and build an unshakable loving relationship with yourself.',
      heroArtwork: 'pack_self_love',
      theme: 'rose_gold',
      category: 'Self-Love',
      durationDays: 7,
      accessLevel: 'PRO',
      storeKitProductId: 'com.riseapp.pack.selflove',
      priceTier: '$2.99',
      items: [
        { day: 1, title: 'Softening The Inner Voice', type: 'BOOST', content: 'Talk to yourself the way you would talk to someone you love beyond measure.', durationMinutes: 4, assetName: 'pack_self_love' },
        { day: 2, title: 'Unconditional Worthiness', type: 'INTENTION', content: 'I do not need to perform or produce to earn my right to peace and belonging.', durationMinutes: 3, assetName: 'pack_self_love' },
        { day: 3, title: 'Heart Sanctuary Meditation', type: 'AUDIO', content: '528Hz Solfeggio frequency restoring emotional warmth and soothing inner anxiety.', durationMinutes: 7, assetName: 'pack_self_love' },
        { day: 4, title: 'Compassion Over Criticism', type: 'CHALLENGE', content: 'Catch your first self-critical thought today and deliberately reframe it with gentle patience.', durationMinutes: 4, assetName: 'pack_self_love' },
        { day: 5, title: 'Embracing Your Flaws As Art', type: 'BOOST', content: 'Kintsugi: your scars and imperfections are where the golden light enters your story.', durationMinutes: 4, assetName: 'pack_self_love' },
        { day: 6, title: 'Celebrating Your Survival', type: 'REFLECTION', content: 'Acknowledge all the difficult days you thought you could not survive, yet you conquered.', durationMinutes: 5, assetName: 'pack_self_love' },
        { day: 7, title: 'A Lifetime Alliance With Yourself', type: 'BOOST', content: 'When you are truly on your own team, no storm on earth can shake your center.', durationMinutes: 5, assetName: 'pack_self_love' },
      ],
    },
    {
      slug: 'discipline',
      title: 'Iron Discipline & Consistency',
      subtitle: 'Build unbreakable habits and execute every single day',
      description:
        'Bridge the gap between intention and execution through stoic accountability, identity shifts, and frictionless consistency.',
      heroArtwork: 'pack_discipline',
      theme: 'slate_steel',
      category: 'Discipline',
      durationDays: 7,
      accessLevel: 'PRO',
      storeKitProductId: 'com.riseapp.pack.discipline',
      priceTier: '$2.99',
      items: [
        { day: 1, title: 'Motivation Fades, Systems Remain', type: 'BOOST', content: 'Do not wait to feel like doing it. Action creates the emotion, not the other way around.', durationMinutes: 4, assetName: 'pack_discipline' },
        { day: 2, title: 'The 2-Minute Habit Rule', type: 'CHALLENGE', content: 'Complete your hardest habit for just 2 minutes without stopping today.', durationMinutes: 3, assetName: 'pack_discipline' },
        { day: 3, title: 'Quiet Relentless Execution', type: 'INTENTION', content: 'I show up for my promises today regardless of temporary moods or weather.', durationMinutes: 3, assetName: 'pack_discipline' },
        { day: 4, title: 'The Stoic Fortress of Mind', type: 'BOOST', content: 'You have power over your mind, not outside events. Realize this, and you will find strength.', durationMinutes: 4, assetName: 'pack_discipline' },
        { day: 5, title: 'Delaying Immediate Gratification', type: 'REFLECTION', content: 'Where in your life have you traded a lifetime of success for 10 minutes of cheap dopamine?', durationMinutes: 5, assetName: 'pack_discipline' },
        { day: 6, title: 'Consistency Over Intensity', type: 'BOOST', content: 'A dripping tap hollows out solid granite. One small disciplined act every day changes everything.', durationMinutes: 4, assetName: 'pack_discipline' },
        { day: 7, title: 'The Unstoppable Standard', type: 'BOOST', content: 'You have raised your baseline standard. Walk forward as someone who simply does what must be done.', durationMinutes: 5, assetName: 'pack_discipline' },
      ],
    },
    {
      slug: 'fresh-start',
      title: 'Fresh Start & New Beginnings',
      subtitle: 'Wipe the slate clean and reinvent your path with clarity',
      description:
        'A powerful reset framework for transitions, career pivots, and emotional breakthroughs.',
      heroArtwork: 'pack_fresh_start',
      theme: 'emerald_renewal',
      category: 'Fresh Starts',
      durationDays: 7,
      accessLevel: 'PRO',
      storeKitProductId: 'com.riseapp.pack.freshstart',
      priceTier: '$2.99',
      items: [
        { day: 1, title: 'The Power of the Blank Page', type: 'BOOST', content: 'Your past is just a story that brought you here. Today, you hold the pen to the next chapter.', durationMinutes: 4, assetName: 'pack_fresh_start' },
        { day: 2, title: 'Releasing What No Longer Serves', type: 'INTENTION', content: 'I willingly shed old baggage to create open space for fresh abundance and opportunity.', durationMinutes: 3, assetName: 'pack_fresh_start' },
        { day: 3, title: 'Breathe In The New Dawn', type: 'AUDIO', content: 'Forest Dawn morning soundscape with fresh breeze and singing birds.', durationMinutes: 6, assetName: 'pack_fresh_start' },
        { day: 4, title: 'Clarifying Your Core Vision', type: 'REFLECTION', content: 'If you were starting completely from zero today, what is the single goal you would chase?', durationMinutes: 5, assetName: 'pack_fresh_start' },
        { day: 5, title: 'Courage To Begin Again', type: 'BOOST', content: 'Starting over is not failure; it is wisdom discarding what didn’t work to build what will.', durationMinutes: 4, assetName: 'pack_fresh_start' },
        { day: 6, title: 'The Clean Slate Micro-Action', type: 'CHALLENGE', content: 'Clear and organize one physical space or desktop folder to symbolize mental renewal.', durationMinutes: 5, assetName: 'pack_fresh_start' },
        { day: 7, title: 'Stepping Into Your New Reality', type: 'BOOST', content: 'You are no longer who you were yesterday. Step boldly into the future you are crafting.', durationMinutes: 5, assetName: 'pack_fresh_start' },
      ],
    },
    {
      slug: 'exam-confidence',
      title: 'Exam Calm & Academic Mastery',
      subtitle: 'Dissolve test anxiety, sharpen retention & unlock peak recall',
      description:
        'Scientifically grounded cognitive calmness and focus protocols designed for students facing high-stakes exams.',
      heroArtwork: 'pack_exam_confidence',
      theme: 'sapphire_clarity',
      category: 'Student Life',
      durationDays: 7,
      accessLevel: 'PRO',
      storeKitProductId: 'com.riseapp.pack.examconfidence',
      priceTier: '$2.99',
      items: [
        { day: 1, title: 'Taming The Test Anxiety Wave', type: 'BOOST', content: 'Anxiety and excitement feel identical in the body. Tell yourself: I am prepared, and I am ready.', durationMinutes: 4, assetName: 'pack_exam_confidence' },
        { day: 2, title: 'Deep Retrieval Breathwork', type: 'AUDIO', content: 'Alpha Wave focus track relaxing the amygdala while maintaining razor-sharp alertness.', durationMinutes: 8, assetName: 'pack_exam_confidence' },
        { day: 3, title: 'Trusting What You Studied', type: 'INTENTION', content: 'My mind is clear, orderly, and capable of retrieving the right answers with calm composure.', durationMinutes: 3, assetName: 'pack_exam_confidence' },
        { day: 4, title: 'The 3-Second Exam Pause', type: 'CHALLENGE', content: 'Whenever you see a difficult problem, take 3 deep belly breaths before putting pen to paper.', durationMinutes: 4, assetName: 'pack_exam_confidence' },
        { day: 5, title: 'Perspective Beyond The Grade', type: 'BOOST', content: 'This test measures your preparation on a single day, not your worth or brilliance as a human.', durationMinutes: 4, assetName: 'pack_exam_confidence' },
        { day: 6, title: 'Peak Performance Visualisation', type: 'REFLECTION', content: 'Visualize yourself walking out of the exam room feeling proud of your calm execution.', durationMinutes: 5, assetName: 'pack_exam_confidence' },
        { day: 7, title: 'Mastery in Action', type: 'BOOST', content: 'You have done the work. Breathe easy, trust your preparation, and let your brilliance shine.', durationMinutes: 5, assetName: 'pack_exam_confidence' },
      ],
    },
  ];

  for (const pack of packs) {
    await prisma.risePack.upsert({
      where: { slug: pack.slug },
      update: pack,
      create: pack,
    });
  }
  console.log(`✅ Seeded ${packs.length} official Rise Packs.`);

  // 2. Seed Curated Affirmations Catalog with rich artwork
  const affirmations = [
    { text: 'I am grounded in this moment, and I have everything I need to begin.', category: 'Mindfulness', tags: ['mindfulness', 'calm', 'presence'], assetName: 'onboarding_motivation_bg' },
    { text: 'I release what I cannot control and invest my energy where it counts.', category: 'Mindfulness', tags: ['peace', 'control', 'clarity'], assetName: 'onboarding_focus_bg' },
    { text: 'My mind is a sanctuary of calm, clarity, and steady focus.', category: 'Focus', tags: ['focus', 'clarity', 'mind'], assetName: 'onboarding_improvements_bg' },
    { text: 'I give my full attention to what is in front of me right now.', category: 'Focus', tags: ['focus', 'presence', 'work'], assetName: 'onboarding_focus_bg' },
    { text: 'I trust my capabilities and welcome challenges with an open heart.', category: 'Confidence', tags: ['confidence', 'trust', 'courage'], assetName: 'splash_sunrise_scene' },
    { text: 'I do not seek outside validation; my worth is intrinsic and steady.', category: 'Confidence', tags: ['confidence', 'worth', 'strength'], assetName: 'onboarding_motivation_bg' },
    { text: 'I honor my commitments to myself with quiet, persistent excellence.', category: 'Discipline', tags: ['discipline', 'habits', 'action'], assetName: 'onboarding_focus_bg' },
    { text: 'Small, consistent steps taken daily create extraordinary outcomes.', category: 'Discipline', tags: ['habits', 'consistency', 'growth'], assetName: 'onboarding_improvements_bg' },
    { text: 'I treat myself with kindness, patience, and unwavering respect.', category: 'Self-Love', tags: ['self-love', 'kindness', 'peace'], assetName: 'onboarding_summary_bg' },
    { text: 'I am worthy of rest, healing, joy, and deep contentment.', category: 'Self-Love', tags: ['self-love', 'rest', 'healing'], assetName: 'splash_sunrise_scene' },
    { text: 'I am deeply grateful for the opportunities and blessings of this day.', category: 'Gratitude', tags: ['gratitude', 'blessings', 'abundance'], assetName: 'onboarding_motivation_bg' },
    { text: 'I choose to find wonder and beauty in the everyday details of life.', category: 'Gratitude', tags: ['gratitude', 'wonder', 'beauty'], assetName: 'onboarding_summary_bg' },
    { text: 'I bend with the wind of circumstance, but my roots remain unbreakable.', category: 'Resilience', tags: ['resilience', 'strength', 'grit'], assetName: 'onboarding_focus_bg' },
    { text: 'Every setback contains a lesson that accelerates my evolution.', category: 'Resilience', tags: ['growth', 'resilience', 'learning'], assetName: 'splash_sunrise_scene' },
    { text: 'I am constantly expanding my wisdom, understanding, and capability.', category: 'Growth', tags: ['growth', 'learning', 'mindset'], assetName: 'onboarding_summary_bg' },
    { text: 'Mistakes are simply proof that I am courageously exploring new terrain.', category: 'Growth', tags: ['growth', 'courage', 'learning'], assetName: 'onboarding_improvements_bg' },
    { text: 'I bring calm, constructive energy to all my relationships.', category: 'Relationships', tags: ['relationships', 'love', 'kindness'], assetName: 'onboarding_summary_bg' },
    { text: 'Today is a clean canvas, and I paint it with purposeful intention.', category: 'Fresh Starts', tags: ['fresh start', 'morning', 'renewal'], assetName: 'onboarding_motivation_bg' },
    { text: 'My mind effortlessly absorbs knowledge and retains what matters.', category: 'Student Life', tags: ['learning', 'study', 'focus'], assetName: 'onboarding_improvements_bg' },
    { text: 'I lead my professional work with integrity, depth, and composure.', category: 'Career', tags: ['career', 'work', 'leadership'], assetName: 'onboarding_focus_bg' },
  ];

  await prisma.affirmation.deleteMany({});
  for (let i = 0; i < affirmations.length; i++) {
    const item = affirmations[i];
    await prisma.affirmation.create({
      data: {
        text: item.text,
        category: item.category,
        tags: item.tags,
        accessLevel: i % 3 === 0 ? 'PRO' : 'FREE',
        dayOfYear: i + 1,
        assetName: item.assetName,
      },
    });
  }
  console.log(`✅ Seeded ${affirmations.length} curated Affirmations.`);

  // 3. Seed Motivation Quotes Catalog with rich artwork across all 5 Discover categories
  const quotes = [
    // Category: Motivation
    { quote: 'Small steps every day lead to big changes over time. Keep showing up.', author: 'Rise Motivation', category: 'Motivation', tags: ['motivation', 'daily-boost', 'consistency'], isFeatured: true, dayOfYear: 1, assetName: 'onboarding_motivation_bg' },
    { quote: 'Do what you have to do until you can do what you want to do.', author: 'Oprah Winfrey', category: 'Motivation', tags: ['motivation', 'grit', 'purpose'], isFeatured: false, dayOfYear: 2, assetName: 'onboarding_motivation_bg' },
    { quote: 'Energy flows where attention goes. Direct yours toward what elevates your spirit.', author: 'Tony Robbins', category: 'Motivation', tags: ['motivation', 'energy', 'focus'], isFeatured: false, dayOfYear: 3, assetName: 'onboarding_motivation_bg' },
    { quote: 'The future belongs to those who believe in the beauty of their dreams.', author: 'Eleanor Roosevelt', category: 'Motivation', tags: ['motivation', 'dreams', 'hope'], isFeatured: false, dayOfYear: 4, assetName: 'onboarding_motivation_bg' },
    { quote: 'Start where you are. Use what you have. Do what you can.', author: 'Arthur Ashe', category: 'Motivation', tags: ['motivation', 'action', 'simplicity'], isFeatured: true, dayOfYear: 5, assetName: 'onboarding_motivation_bg' },

    // Category: Mindset
    { quote: 'Your future is created by what you do today, not tomorrow.', author: 'Robert Kiyosaki', category: 'Mindset', tags: ['mindset', 'future', 'action'], isFeatured: true, dayOfYear: 6, assetName: 'splash_sunrise_scene' },
    { quote: 'You have power over your mind - not outside events. Realize this, and you will find strength.', author: 'Marcus Aurelius', category: 'Mindset', tags: ['mindset', 'stoicism', 'strength'], isFeatured: true, dayOfYear: 7, assetName: 'splash_sunrise_scene' },
    { quote: 'Whether you think you can or you think you can’t, you’re right.', author: 'Henry Ford', category: 'Mindset', tags: ['mindset', 'belief', 'confidence'], isFeatured: false, dayOfYear: 8, assetName: 'splash_sunrise_scene' },
    { quote: 'The mind is everything. What you think you become.', author: 'Buddha', category: 'Mindset', tags: ['mindset', 'wisdom', 'peace'], isFeatured: false, dayOfYear: 9, assetName: 'splash_sunrise_scene' },
    { quote: 'Change your thoughts and you change your world.', author: 'Norman Vincent Peale', category: 'Mindset', tags: ['mindset', 'transformation'], isFeatured: false, dayOfYear: 10, assetName: 'splash_sunrise_scene' },

    // Category: Discipline
    { quote: 'Discipline is choosing what you want most over what you want now.', author: 'Abraham Lincoln', category: 'Discipline', tags: ['discipline', 'habits', 'focus'], isFeatured: true, dayOfYear: 11, assetName: 'onboarding_focus_bg' },
    { quote: 'Action is the foundational key to all success.', author: 'Pablo Picasso', category: 'Discipline', tags: ['discipline', 'action', 'habits'], isFeatured: false, dayOfYear: 12, assetName: 'onboarding_focus_bg' },
    { quote: 'We are what we repeatedly do. Excellence, then, is not an act, but a habit.', author: 'Will Durant', category: 'Discipline', tags: ['discipline', 'excellence', 'routine'], isFeatured: true, dayOfYear: 13, assetName: 'onboarding_focus_bg' },
    { quote: 'Motivation gets you going, but discipline keeps you growing.', author: 'John C. Maxwell', category: 'Discipline', tags: ['discipline', 'growth', 'consistency'], isFeatured: false, dayOfYear: 14, assetName: 'onboarding_focus_bg' },
    { quote: 'Self-command is the greatest of all empires.', author: 'Seneca', category: 'Discipline', tags: ['discipline', 'stoicism', 'control'], isFeatured: false, dayOfYear: 15, assetName: 'onboarding_focus_bg' },

    // Category: Focus
    { quote: 'Give your complete presence to one important task at a time.', author: 'Rise Focus', category: 'Focus', tags: ['focus', 'presence', 'clarity'], isFeatured: false, dayOfYear: 16, assetName: 'onboarding_improvements_bg' },
    { quote: 'Simplicity is about subtracting the obvious and adding the meaningful.', author: 'John Maeda', category: 'Focus', tags: ['focus', 'simplicity', 'depth'], isFeatured: false, dayOfYear: 17, assetName: 'onboarding_improvements_bg' },
    { quote: 'Starve your distractions, feed your focus.', author: 'Anonymous', category: 'Focus', tags: ['focus', 'productivity', 'momentum'], isFeatured: true, dayOfYear: 18, assetName: 'onboarding_improvements_bg' },
    { quote: 'Concentrate all your thoughts upon the work in hand. The sun’s rays do not burn until brought to a focus.', author: 'Alexander Graham Bell', category: 'Focus', tags: ['focus', 'intensity'], isFeatured: false, dayOfYear: 19, assetName: 'onboarding_improvements_bg' },

    // Category: Self Growth
    { quote: 'The only person you should try to be better than is who you were yesterday.', author: 'Anonymous', category: 'Self Growth', tags: ['self-growth', 'improvement', 'evolution'], isFeatured: false, dayOfYear: 20, assetName: 'onboarding_summary_bg' },
    { quote: 'Growth is uncomfortable because you’ve never been this version of you before.', author: 'Rise Team', category: 'Self Growth', tags: ['self-growth', 'courage', 'transformation'], isFeatured: true, dayOfYear: 21, assetName: 'onboarding_summary_bg' },
    { quote: 'Invest in your mind, your peace, and your craft every single day.', author: 'Anonymous', category: 'Self Growth', tags: ['self-growth', 'investment', 'peace'], isFeatured: false, dayOfYear: 22, assetName: 'onboarding_summary_bg' },
    { quote: 'Be not afraid of going slowly, be afraid only of standing still.', author: 'Chinese Proverb', category: 'Self Growth', tags: ['self-growth', 'patience', 'progress'], isFeatured: false, dayOfYear: 23, assetName: 'onboarding_summary_bg' },
  ];

  await prisma.motivationQuote.deleteMany({});
  for (const q of quotes) {
    await prisma.motivationQuote.create({
      data: {
        quote: q.quote,
        author: q.author,
        category: q.category,
        tags: q.tags,
        isFeatured: q.isFeatured,
        dayOfYear: q.dayOfYear,
        assetName: q.assetName,
      },
    });
  }
  console.log(`✅ Seeded ${quotes.length} rich Motivation Quotes with artwork.`);
  console.log('🎉 Seed completed successfully!');
}

main()
  .catch((e) => {
    console.error('❌ Seed error:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
