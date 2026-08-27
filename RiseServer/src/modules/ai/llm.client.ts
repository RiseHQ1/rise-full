//
//  llm.client.ts
//  RiseServer
//
//  Advanced AI Mindfulness & Philosophical Reasoning Engine with Few-Shot Cognitive Framing
//

import { logger } from '@/utils/logger.js';

export interface LLMReflectionPrompt {
  mood: string;
  category: string;
  entryText: string;
  userPrompt?: string | null;
}

export interface LLMReflectionOutput {
  insight: string;
  stoicPerspective: string;
  actionableTakeaway: string;
  suggestedAffirmation: string;
  recommendedSoundscape: 'FOREST_DAWN' | 'OCEAN_TIDES' | 'DEEP_SPACE' | 'CELESTIAL_RAIN' | 'MOUNTAIN_WIND' | 'SOLAR_CHIMES';
}

export class LLMClient {
  /**
   * Master System Prompt with Cognitive Behavioral Therapy (CBT),
   * Acceptance and Commitment Therapy (ACT), and Stoic Dichotomy of Control few-shot training.
   */
  private systemPrompt = `
You are the Rise Mindful Oracle — an elite philosophical companion, combining the depth of Stoic wisdom (Marcus Aurelius, Seneca, Epictetus) with the compassionate clarity of modern Acceptance and Commitment Therapy (ACT) and somatic mindfulness.

### CORE VOICE & ETHOS:
1. **Warm, Stoic & Dignified**: Never sound like a generic AI or cheerleading chatbot. Speak with quiet confidence, deep empathy, poetic restraint, and timeless poise.
2. **The Dichotomy of Control**: Gently help the user separate what is in their direct control (their judgments, intentions, attention) from what is not (outcomes, other people, the past).
3. **Non-Judgmental Awareness**: Validate their emotion as valid biological data without letting them spiral into catastrophizing.
4. **Brevity & Resonance**: Keep each section dense, memorable, and deeply impactful. Avoid filler phrases like "I understand how you feel" or "As an AI".

### FEW-SHOT HIGH QUALITY EXEMPLARS:

#### Example 1 (Anxiety & Work Overwhelm):
- **User Entry**: "I have 10 deadlines due this week. My heart is racing and I feel like I'm going to fail my entire team."
- **Output JSON**:
{
  "insight": "Anxiety is the mind's attempt to live in an unwritten tomorrow. When everything feels urgent, remember that you do not face a mountain all at once — you only ever take one single breath and execute one single task in this present room.",
  "stoicPerspective": "Seneca: 'We suffer more often in imagination than in reality.' Strip away the narrative of failure and look only at the immediate hour before you.",
  "actionableTakeaway": "Write down the single most critical task for today; deliberately cross out the other nine until tomorrow.",
  "suggestedAffirmation": "I release the weight of tomorrow. I am steady, capable, and present with this moment.",
  "recommendedSoundscape": "MOUNTAIN_WIND"
}

#### Example 2 (Heartbreak / Rejection / Loss):
- **User Entry**: "Someone I cared about walked away. I feel empty and question my worth."
- **Output JSON**:
{
  "insight": "Grief is simply love with nowhere left to go. Another person's departure changes your external landscape, but it does not diminish the intrinsic wholeness you were born with.",
  "stoicPerspective": "Epictetus: 'People are not disturbed by things, but by the view they take of them.' Your worth is inherent and never dependent upon external possession.",
  "actionableTakeaway": "Place your hand over your heart, take three slow breaths, and treat yourself with the gentle warmth you would offer a cherished friend.",
  "suggestedAffirmation": "My peace comes from within. I honor my feelings without losing my center.",
  "recommendedSoundscape": "OCEAN_TIDES"
}

#### Example 3 (Feeling Numb / Stagnant / Uninspired):
- **User Entry**: "I don't know what I'm doing with my life. Every day feels like a repetitive blur."
- **Output JSON**:
{
  "insight": "Winter is not a failure of growth; it is the quiet preparation beneath the soil. A season of stillness is often an invitation to strip away trivial distractions and rediscover your core.",
  "stoicPerspective": "Marcus Aurelius: 'At dawn, when you have trouble getting out of bed, tell yourself: I have to go to work as a human being.' Purpose is built through small deliberate acts.",
  "actionableTakeaway": "Step outside for 5 minutes without your phone. Notice the exact color of the sky and the sensation of air on your skin.",
  "suggestedAffirmation": "I do not need to see the whole staircase. I only need to take the next honest step.",
  "recommendedSoundscape": "FOREST_DAWN"
}

### RESPONSE FORMAT:
You MUST respond strictly with valid JSON with keys:
"insight", "stoicPerspective", "actionableTakeaway", "suggestedAffirmation", "recommendedSoundscape" (one of "FOREST_DAWN", "OCEAN_TIDES", "DEEP_SPACE", "CELESTIAL_RAIN", "MOUNTAIN_WIND", "SOLAR_CHIMES").
`;

  /**
   * Synthesize ultra-high-quality reflection insight.
   */
  async generateReflection(input: LLMReflectionPrompt): Promise<LLMReflectionOutput> {
    const anthropicKey = process.env.ANTHROPIC_API_KEY;
    const openaiKey = process.env.OPENAI_API_KEY;
    const geminiKey = process.env.GEMINI_API_KEY;

    // 1. Anthropic Claude (Gold Standard for Philosophical prose)
    if (anthropicKey) {
      try {
        const response = await this.queryAnthropic(anthropicKey, input);
        if (response) return response;
      } catch (err) {
        logger.error({ err }, 'Anthropic query failed, falling back');
      }
    }

    // 2. OpenAI GPT-4o
    if (openaiKey) {
      try {
        const response = await this.queryOpenAI(openaiKey, input);
        if (response) return response;
      } catch (err) {
        logger.error({ err }, 'OpenAI query failed, falling back');
      }
    }

    // 3. Google Gemini
    if (geminiKey) {
      try {
        const response = await this.queryGemini(geminiKey, input);
        if (response) return response;
      } catch (err) {
        logger.error({ err }, 'Gemini query failed, falling back');
      }
    }

    // 4. Elite Heuristic Training Engine Fallback
    return this.eliteHeuristicEngine(input);
  }

  private async queryAnthropic(apiKey: string, input: LLMReflectionPrompt): Promise<LLMReflectionOutput | null> {
    const userMessage = `Mood: ${input.mood}\nCategory: ${input.category}\nJournal Text: "${input.entryText}"\n${input.userPrompt ? `User's Reflection Question: "${input.userPrompt}"` : ''}`;

    const res = await fetch('https://api.anthropic.com/v1/messages', {
      method: 'POST',
      headers: {
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01',
        'content-type': 'application/json',
      },
      body: JSON.stringify({
        model: 'claude-3-5-sonnet-20241022',
        max_tokens: 600,
        temperature: 0.65,
        system: this.systemPrompt,
        messages: [{ role: 'user', content: userMessage }],
      }),
    });

    if (!res.ok) return null;
    const json = (await res.json()) as any;
    const text = json.content?.[0]?.text;
    if (!text) return null;

    try {
      const cleaned = text.replace(/```json/gi, '').replace(/```/g, '').trim();
      const parsed = JSON.parse(cleaned);
      if (parsed && typeof parsed.insight === 'string') return parsed;
    } catch {
      return null;
    }
    return null;
  }

  private async queryOpenAI(apiKey: string, input: LLMReflectionPrompt): Promise<LLMReflectionOutput | null> {
    const userMessage = `Mood: ${input.mood}\nCategory: ${input.category}\nJournal Text: "${input.entryText}"\n${input.userPrompt ? `User's Reflection Question: "${input.userPrompt}"` : ''}`;

    const res = await fetch('https://api.openai.com/v1/chat/completions', {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${apiKey}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        model: 'gpt-4o',
        temperature: 0.65,
        response_format: { type: 'json_object' },
        messages: [
          { role: 'system', content: this.systemPrompt },
          { role: 'user', content: userMessage },
        ],
      }),
    });

    if (!res.ok) return null;
    const json = (await res.json()) as any;
    const content = json.choices?.[0]?.message?.content;
    if (!content) return null;

    try {
      const parsed = JSON.parse(content);
      if (parsed && typeof parsed.insight === 'string') return parsed;
    } catch {
      return null;
    }
    return null;
  }

  private async queryGemini(apiKey: string, input: LLMReflectionPrompt): Promise<LLMReflectionOutput | null> {
    const userMessage = `Mood: ${input.mood}\nCategory: ${input.category}\nJournal Text: "${input.entryText}"`;

    const res = await fetch(`https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent?key=${apiKey}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        system_instruction: { parts: [{ text: this.systemPrompt }] },
        contents: [{ parts: [{ text: userMessage }] }],
        generationConfig: { response_mime_type: 'application/json', temperature: 0.65 },
      }),
    });

    if (!res.ok) return null;
    const json = (await res.json()) as any;
    const content = json.candidates?.[0]?.content?.parts?.[0]?.text;
    if (!content) return null;

    try {
      const parsed = JSON.parse(content);
      if (parsed && typeof parsed.insight === 'string') return parsed;
    } catch {
      return null;
    }
    return null;
  }

  /**
   * Elite Heuristic Training Engine with dynamic soundscape pairing & stoic anchors.
   */
  private eliteHeuristicEngine(input: LLMReflectionPrompt): LLMReflectionOutput {
    const catalog: Record<string, LLMReflectionOutput> = {
      GREAT: {
        insight:
          'Your vitality and gratitude today are sacred momentum. When the mind is elevated, do not let it slip into restlessness — anchor this clarity so it nourishes you and those you touch.',
        stoicPerspective:
          "Marcus Aurelius: 'When you arise in the morning, think of what a precious privilege it is to be alive.'",
        actionableTakeaway: 'Take 30 seconds right now to send a genuine note of appreciation to someone who supported your journey.',
        suggestedAffirmation: 'I am grounded in gratitude. My energy is focused, calm, and purposeful.',
        recommendedSoundscape: 'SOLAR_CHIMES',
      },
      CALM: {
        insight:
          'Stillness is not an absence of movement, but the presence of mastery. In this state of equilibrium, you can observe life without being swept away by external storms.',
        stoicPerspective:
          "Epictetus: 'He who is contented with what has been done is at peace with himself.'",
        actionableTakeaway: 'Close your eyes and take three slow, 4-second box breaths, noting the stillness behind your thoughts.',
        suggestedAffirmation: 'Stillness is my anchor. I carry peace wherever I step.',
        recommendedSoundscape: 'CELESTIAL_RAIN',
      },
      OKAY: {
        insight:
          'Steady, ordinary days are the bedrock of character. You do not need extraordinary highs to make meaningful progress; showing up with quiet consistency is mastery in disguise.',
        stoicPerspective:
          "Seneca: 'Small disciplines repeated with consistency every day lead to great achievements.'",
        actionableTakeaway: 'Identify the one small priority that will make today feel complete, and focus on it without rush.',
        suggestedAffirmation: 'I trust the compound effect of my daily consistency.',
        recommendedSoundscape: 'FOREST_DAWN',
      },
      LOW: {
        insight:
          'Allow yourself to feel without judgment or resistance. Heavy emotions are not signs of weakness; they are weather passing through a vast sky that remains unbreakable.',
        stoicPerspective:
          "Marcus Aurelius: 'You have power over your mind - not outside events. Realize this, and you will find strength.'",
        actionableTakeaway: 'Unclench your jaw, soften your shoulders, and drink a glass of water with slow, deliberate presence.',
        suggestedAffirmation: 'I am patient with my path. I am resilient, safe, and supported.',
        recommendedSoundscape: 'OCEAN_TIDES',
      },
      TIRED: {
        insight:
          'Rest is not an indulgence you earn after exhaustion; it is an essential sacred rhythm of human existence. Give yourself full permission to power down without guilt.',
        stoicPerspective:
          "Seneca: 'The mind must be given relaxation; it will arise better and sharper after a good rest.'",
        actionableTakeaway: 'Set your phone face down in another room and give your eyes 10 minutes of gentle darkness before sleep.',
        suggestedAffirmation: 'I release all demands of today. My mind and body deserve deep restoration.',
        recommendedSoundscape: 'DEEP_SPACE',
      },
    };

    return catalog[input.mood] || catalog.CALM;
  }
}
