import { z } from 'genkit'
import { ai } from '../genkit'

export const streamObjectsFlow = ai.defineFlow(
  {
    name: `stream-objects`,
    inputSchema: z.object({
      prompt: z.string(),
    }),
    outputSchema: z.object({
      text: z.string(),
      summary: z.string(),
    }),
    streamSchema: z.object({
      text: z.string(),
      summary: z.string(),
    }),
  },
  async (input, streamingCallback) => {
    if (!streamingCallback) {
      throw new Error(`Streaming callback not provided for a streaming flow.`)
    }

    const { stream, response } = ai.generateStream({
      prompt: input.prompt,
    })

    let accumulatedText = ``

    for await (const chunk of stream) {
      if (chunk.text) {
        accumulatedText += chunk.text

        // Send streaming chunk matching StreamOutput schema
        const streamChunk = {
          text: chunk.text,
          summary: `Processing: ${accumulatedText.slice(0, 50)}...`,
        }

        streamingCallback(streamChunk)
      }
    }

    const finalResponse = await response
    const finalOutput = {
      text: finalResponse.text,
      summary: `Completed processing of: "${input.prompt}"`,
    }

    return finalOutput
  }
)
