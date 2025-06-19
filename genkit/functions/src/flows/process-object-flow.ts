import { z } from 'zod'
import { ai } from '../genkit'

export const processObjectFlow = ai.defineFlow(
  {
    name: `process-object`,
    inputSchema: z.object({
      message: z.string(),
      count: z.number(),
    }),
    outputSchema: z.object({
      reply: z.string(),
      newCount: z.number(),
    }),
  },
  async (input) => {
    const response = await ai.generate({
      prompt: input.message,
    })

    const newCount = input.count * 2

    return {
      reply: response.text,
      newCount,
    }
  }
)
