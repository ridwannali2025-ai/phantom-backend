# Vercel Deployment Checklist

## Pre-Deployment Setup

### ✅ 1. GitHub Repository
- [x] Repository created: `https://github.com/ridwannali2025-ai/phantom-backend.git`
- [x] Code pushed to `main` branch
- [x] Repository is clean and up to date

### ✅ 2. Backend Files Verified
- [x] `package.json` exists with `"type": "module"`
- [x] `api/generate-program.ts` exists (Vercel serverless function)
- [x] `README.md` exists with documentation
- [x] `.vercelignore` created to exclude iOS files

### ✅ 3. Code Verification
- [x] OpenAI SDK uses `process.env.OPENAI_API_KEY` (not hardcoded)
- [x] Function uses `export const config = { runtime: "edge" }`
- [x] Error handling implemented
- [x] JSON response format validated

---

## Vercel Deployment Steps

### Step 1: Connect Repository to Vercel
1. Go to [vercel.com](https://vercel.com) and sign in
2. Click **"Add New Project"**
3. Import the repository: `ridwannali2025-ai/phantom-backend`
4. Vercel will auto-detect the project settings

### Step 2: Configure Project Settings
- **Framework Preset:** Other (or leave as auto-detected)
- **Root Directory:** `./` (root of repository)
- **Build Command:** Leave empty (serverless functions don't need build)
- **Output Directory:** Leave empty
- **Install Command:** `npm install` (auto-detected)

### Step 3: Add Environment Variables
1. In Vercel project settings, go to **"Environment Variables"**
2. Add the following:
   - **Name:** `OPENAI_API_KEY`
   - **Value:** Your OpenAI API key (starts with `sk-...`)
   - **Environment:** Production, Preview, Development (select all)
3. Click **"Save"**

### Step 4: Deploy
1. Click **"Deploy"**
2. Wait for deployment to complete (usually 1-2 minutes)
3. Vercel will provide a deployment URL like: `https://phantom-backend-xxx.vercel.app`

### Step 5: Test the Endpoint
```bash
curl -X POST https://your-app.vercel.app/api/generate-program \
  -H "Content-Type: application/json" \
  -d '{
    "goal": "lose_fat",
    "timelineMonths": 6,
    "heightCm": 175,
    "weightKg": 80,
    "age": 30,
    "sex": "male",
    "activityLevel": "moderate",
    "daysPerWeek": 4,
    "experience": "intermediate"
  }'
```

Expected: JSON response with `summary`, `nutrition`, and `training` objects.

---

## iOS App Integration

### Step 1: Update ProgramEngineService.swift
1. Open `phantomAI/Core/Services/ProgramEngineService.swift`
2. Update `baseURLString` to your Vercel deployment URL:
   ```swift
   private let baseURLString = "https://your-app.vercel.app/api/generate-program"
   ```

### Step 2: Verify Request Format
- Ensure `ProgramRequest` struct matches the backend interface
- All required fields are included
- Optional fields are properly handled

### Step 3: Update Response Parsing
- The backend now returns a more detailed structure:
  - `summary.headline` and `summary.whyThisPlanWillWork`
  - `nutrition` with calories and macros
  - `training` with `splitTitle`, `schedule[]`, and `globalNotes`
- Update `GeneratedPlan` or create a new model to match this structure

### Step 4: Test End-to-End
1. Complete onboarding flow in iOS app
2. Complete paywall purchase
3. Verify AI generation is triggered
4. Check that the response is parsed correctly
5. Verify the plan is displayed in the app

---

## Post-Deployment Verification

### ✅ Backend Health Checks
- [ ] Endpoint responds to POST requests
- [ ] Returns 405 for non-POST methods
- [ ] Returns 400 for invalid JSON
- [ ] Returns 500 for OpenAI errors (gracefully)
- [ ] Returns 200 with valid JSON for valid requests

### ✅ Environment Variables
- [ ] `OPENAI_API_KEY` is set in Vercel
- [ ] Key is valid and has sufficient credits
- [ ] Key is accessible in all environments (prod/preview/dev)

### ✅ iOS Integration
- [ ] `ProgramEngineService` uses correct Vercel URL
- [ ] Request format matches backend expectations
- [ ] Response parsing handles new structure
- [ ] Error handling works correctly
- [ ] User sees generated plan after paywall

---

## Troubleshooting

### Common Issues

**1. "Invalid JSON from model" error**
- Check OpenAI API key is valid
- Verify model `gpt-4o-mini` is available
- Check API credits/usage limits

**2. CORS errors from iOS app**
- Vercel handles CORS automatically for serverless functions
- If issues persist, add CORS headers in the function

**3. Function timeout**
- Edge functions have execution time limits
- Consider optimizing the prompt or using a faster model

**4. Environment variable not found**
- Verify `OPENAI_API_KEY` is set in Vercel dashboard
- Ensure it's enabled for the correct environment
- Redeploy after adding environment variables

---

## Next Steps

1. **Monitor Usage**
   - Check Vercel function logs for errors
   - Monitor OpenAI API usage and costs
   - Set up alerts for high error rates

2. **Optimize**
   - Fine-tune prompts for better responses
   - Add caching for similar requests
   - Consider rate limiting

3. **Scale**
   - Monitor function execution times
   - Consider upgrading Vercel plan if needed
   - Add more endpoints as needed

---

## Quick Reference

**Backend URL:** `https://your-app.vercel.app`  
**Endpoint:** `POST /api/generate-program`  
**Environment Variable:** `OPENAI_API_KEY`  
**GitHub Repo:** `https://github.com/ridwannali2025-ai/phantom-backend.git`

