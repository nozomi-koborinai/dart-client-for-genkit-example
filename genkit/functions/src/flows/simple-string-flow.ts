import { z } from 'zod'
import { ai } from '../genkit'

export const simpleStringFlow = ai.defineFlow(
  {
    name: `simple-string`,
    inputSchema: z.string(),
    outputSchema: z.string(),
  },
  async (input) => {
    const response = await ai.generate({ prompt: input })
    return response.text
  }
)
