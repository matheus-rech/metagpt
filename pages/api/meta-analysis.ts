import { Anthropic } from '@anthropic-ai/sdk'
import type { NextApiRequest, NextApiResponse } from 'next'

const anthropic = new Anthropic(process.env.ANTHROPIC_API_KEY || '')

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method === 'POST') {
    try {
      const { message } = req.body

      // Process with Anthropic API
      const completion = await anthropic.completions.create({
        model: "claude-2",
        prompt: `Human: ${message}\nAssistant:`,
        max_tokens_to_sample: 300,
      })

      // Forward to R backend
      const rResponse = await fetch('http://localhost:8000/meta-analysis', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ query: completion.completion }),
      })

      const result = await rResponse.json()
      res.status(200).json(result)
    } catch (error) {
      res.status(500).json({ error: 'An error occurred' })
    }
  } else {
    res.setHeader('Allow', ['POST'])
    res.status(405).end(`Method ${req.method} Not Allowed`)
  }
}