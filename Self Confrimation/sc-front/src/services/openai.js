import OpenAI from 'openai'

const openai = new OpenAI({
  apiKey: 'sk-xxxxx', // 替换为你的 OpenAI API key
  dangerouslyAllowBrowser: true, // 开发环境临时使用，生产环境建议使用后端
})

// 保存对话历史
let conversationHistory = [
  {
    role: 'system',
    content: `你是一位专业的心理咨询师和人生导师。你的任务是：
    1. 倾听用户分享的经历
    2. 帮助用户探索内心的欲望和潜在的情感创伤
    3. 以同理心和专业的方式回应
    4. 引导用户进行自我反思
    5. 提供建设性的建议
    请用温和、专业的语气与用户交流，避免生硬的说教。`,
  },
]

export const chatWithAI = async (userMessage) => {
  try {
    // 添加用户消息到历史记录
    conversationHistory.push({
      role: 'user',
      content: userMessage,
    })

    // 调用 OpenAI API
    const completion = await openai.chat.completions.create({
      model: 'gpt-3.5-turbo',
      messages: conversationHistory,
      temperature: 0.7,
      max_tokens: 1000,
    })

    // 获取 AI 响应
    const aiResponse = completion.choices[0].message.content

    // 添加 AI 响应到历史记录
    conversationHistory.push({
      role: 'assistant',
      content: aiResponse,
    })

    return aiResponse
  } catch (error) {
    console.error('OpenAI API error:', error)
    throw error
  }
}

// 清除对话历史
export const clearConversation = () => {
  conversationHistory = [conversationHistory[0]] // 只保留 system 提示
}
