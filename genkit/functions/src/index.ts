import { onCallGenkit } from 'firebase-functions/https'
import { googleAIapiKey } from './genkit'

import { processObjectFlow } from './flows/process-object-flow'
import { streamObjectsFlow } from './flows/stream-objects-flow'
import { simpleStringFlow } from './flows/simple-string-flow'

const opts = {
  secrets: [googleAIapiKey],
  region: `asia-northeast1`,
  cors: true,
  authPolicy: (auth: any) => {
    return auth?.token?.firebase?.sign_in_provider === `anonymous`
  },
}

export const simpleString = onCallGenkit(opts, simpleStringFlow)
export const processObject = onCallGenkit(opts, processObjectFlow)
export const streamObjects = onCallGenkit(opts, streamObjectsFlow)
