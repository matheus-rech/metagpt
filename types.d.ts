declare module 'lucide-react' {
  export const Send: React.ComponentType<React.SVGProps<SVGSVGElement>>
}

declare module '@anthropic-ai/sdk' {
  export class Anthropic {
    constructor(apiKey: string)
    completions: {
      create(params: {
        model: string
        prompt: string
        max_tokens_to_sample: number
      }): Promise<{ completion: string }>
    }
  }
}