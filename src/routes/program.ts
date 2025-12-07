import { Router } from "express";
import OpenAI from "openai";

const router = Router();
const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY! });

type ProgramRequest = {
  goal: string;
  timelineMonths: number;
  heightCm: number;
  weightKg: number;
  age: number;
  sex: string;
  activityLevel: string;
  daysPerWeek: number;
  experience: string;
  equipment?: string;
  hasInjuries?: boolean;
  injuryDetails?: string | null;
  dietaryRestrictions?: string[] | null;
  avoidFoods?: string[] | null;
  pastBlockers?: string[] | null;
  hasWorkedWithCoach?: boolean | null;
  hasUsedOtherApps?: boolean | null;
};

type ProgramResponse = {
  caloriesPerDay: number;
  proteinGrams: number;
  carbsGrams: number;
  fatsGrams: number;
  trainingSplitTitle: string;
  trainingSplitSubtitle: string;
};

router.post("/program", async (req, res) => {
  const body = req.body as ProgramRequest;

  try {
    const systemPrompt = `
You are an elite online fitness coach and nutritionist.
Given the user's stats and goals, return ONLY JSON for calorie target,
macros, and a short training split description. No prose.

The JSON MUST match this TypeScript type exactly:

type ProgramResponse = {
  caloriesPerDay: number;
  proteinGrams: number;
  carbsGrams: number;
  fatsGrams: number;
  trainingSplitTitle: string;        // e.g. "Push / Pull / Legs (5x / week)"
  trainingSplitSubtitle: string;     // e.g. "Strength-focused split tuned for fat loss"
};
`;

    const userPrompt = JSON.stringify(body);

    const completion = await openai.chat.completions.create({
      model: "gpt-4o-mini",
      temperature: 0.6,
      messages: [
        { role: "system", content: systemPrompt },
        { role: "user", content: userPrompt }
      ]
    });

    const raw = completion.choices[0]?.message?.content ?? "{}";
    const parsed = JSON.parse(raw) as ProgramResponse;

    return res.json(parsed);
  } catch (err) {
    console.error("program error", err);
    return res.status(500).json({ error: "program_generation_failed" });
  }
});

export default router;

