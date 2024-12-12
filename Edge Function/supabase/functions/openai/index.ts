import OpenAI from 'https://deno.land/x/openai@v4.24.0/mod.ts'

console.log("Hello from Multi-Purpose Edge Function!")

Deno.serve(async (req) => {
  try {
    const { type, query, model } = await req.json()
    const apiKey = Deno.env.get('OPENAI_API_KEY')

    const openai = new OpenAI({ apiKey: apiKey })

    if (type === 'text') {
      // Génération de texte
      const chatCompletion = await openai.chat.completions.create({
        messages: [{ role: 'user', content: query }],
        model: model || 'gpt-3.5-turbo',
        stream: false,
      })

      const reply = chatCompletion.choices[0].message.content

      return new Response(JSON.stringify({ result: reply }), {
        headers: { 'Content-Type': 'application/json' },
      })

    } else if (type === 'image') {
      // Génération d'image
      const imageResponse = await openai.images.generate({
        prompt: query,
        model: 'dall-e-3',
        n: 1,
        size: '1024x1024',
      })

      const imageUrl = imageResponse.data[0].url

      return new Response(JSON.stringify({ imageUrl: imageUrl }), {
        headers: { 'Content-Type': 'application/json' },
      })

    } else {
      return new Response(JSON.stringify({ error: 'Type must be "text" or "image".' }), {
        headers: { 'Content-Type': 'application/json' },
        status: 400,
      })
    }
  } catch (error) {
    return new Response(JSON.stringify({ error: error }), {
      headers: { 'Content-Type': 'application/json' },
      status: 500,
    })
  }
})

