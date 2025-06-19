import { genkit } from 'genkit'
import { googleAI } from '@genkit-ai/googleai'
import { defineSecret } from 'firebase-functions/params'
import { logger } from 'genkit/logging'

logger.setLogLevel(`debug`)

export const googleAIapiKey = defineSecret(`GOOGLE_GENAI_API_KEY`)

export const ai = genkit({
  plugins: [googleAI()],
  model: googleAI.model(`gemini-2.5-flash-preview-05-20`),
})
