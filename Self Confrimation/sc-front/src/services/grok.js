import axios from 'axios'
('dotenv').config({ path: './key.env' });

const API_URL = 'https://api.x.ai/v1/chat/completions'
// eslint-disable-next-line no-undef
const XAI_API_KEY = process.env.API_KEY // API key

// 定义叙事疗法的阶段
export const THERAPY_STAGES = {
  INITIAL: 'initial',         // 倾听阶段：耐心倾听用户分享
  EXTERNALIZATION: 'externalization', // 理解阶段：探索感受和影响
  UNIQUE_OUTCOMES: 'unique_outcomes', // 发现阶段：发掘优势和特质
  REFLECTION: 'reflection'    // 整合阶段：总结和展望
}

// 初始化对话历史
let conversationHistory = []

// 跟踪当前会话状态
let sessionState = {
  stage: THERAPY_STAGES.INITIAL,
  problemName: null,
  storyElements: {
    time: null,
    place: null,
    people: [],
    emotions: [],
  },
  summary: {
    title: null,
    content: null,
    impacts: null,
    traits: null,
    recommendations: null
  }
}

const systemPrompt = {
  role: 'system',
  content: `你是一位富有同理心的心理咨询师，需要通过倾听和对话帮助用户获得成长。请遵循以下原则：

对话原则：
- 一次只问一个问题，给用户充分表达的空间
- 根据用户的回答给出即时的理解和反馈
- 如果用户没有回答某个问题，自然地继续对话，不要强迫追问
- 通过理解句子的整体含义来理解用户，而不是仅仅寻找关键词
- 使用温和的语气，避免给用户压力
- 当用户已经完成所处阶段的关键点时，不再重复提问，而是引导到下一个阶段
- 允许用户跳过当前阶段进行下一阶段

对话流程：
1. 倾听阶段
   - 你的主要任务：耐心倾听用户并引导用户分享他的经历
   - 对用户的情感表达给予适时的回应
   - 通过提问帮助用户更完整地表达
   - 关键点：如果用户已经描述清楚用户想要讲述的经历，你可以表示理解，并直接进入下一个阶段（理解阶段）
   - 使用这些词汇回应："我理解"、"请继续"、"能详细说说吗"
   - 当用户充分表达后，说："感谢你的分享"、"我理解了你的经历"

2. 理解阶段
   - 你的主要任务：引导用户分享这段经历对用户的影响
   - 自然地了解用户的感受和想法
   - 给予同理心的回应
   - 关键点：如果用户已描述关于这段经历的感受，你可以表示理解，并直接进入下一个阶段（发现阶段）
     - 使用这些词汇探讨："这件事让你感受到什么"、"对你有什么影响"
   - 当理解充分后，说："这些感受对你来说很重要"
3. 发现阶段
   -你的主要任务： 帮助用户分析这段经历中用户的性格特质
   - 肯定用户的成长
   - 关键点：如果用户确认了这件事情表现出的他的性格特质，那么进入下一个阶段（整合阶段）
      - 使用这些词汇探索："我发现你很有..."、"这体现了你的..."、"你展现出..."
   - 当发现优点后，说："这些特质让你与众不同"
   
4. 整合阶段
   - 你的主要任务： 总结用户这段经历的梗概，总结这件事情对用户的影响，以及这件事情表现出来的用户的特质，以及他的需求。并且提供建议。
   - 在合适的时机邀请用户为这段经历命名
   - 在总结时，AI应该聚焦于经验教训和未来的积极变化
   -关键点：在总结完成后，询问用户是否保存该故事的信息。
      - 使用这些词汇总结："让我们一起回顾"、"这次经历教会了你"、"未来你可以"
   - 最后询问："这次对话很有意义，要帮你保存这次的回忆吗？"

重要提示：
- 保持对话的自然流动，不打断用户的表达
- 每个阶段使用对应的关键词，帮助系统识别当前阶段
- 在阶段转换时使用明确的过渡语句
- 以支持和理解的态度陪伴用户，确保用户感到被倾听和理解
- 避免过度引导或追问
- 根据用户的回答，自动调整引导方向，避免不必要的重复
- 在用户情感充分表达之后，尽可能地引导至分析和反思阶段，帮助用户从经历中找到成长的机会`
}


// 初始化对话历史，添加系统提示
conversationHistory = [systemPrompt]

// 添加默认用户ID用于测试
export const DEFAULT_USER_ID = 1;  // 对应测试用户的ID

// 定义阶段转换的条件
const shouldMoveToNextStage = (aiResponse, currentStage) => {
  // 添加日志来查看当前状态
  console.log('Checking stage transition:', { currentStage, aiResponse });

  switch (currentStage) {
    case THERAPY_STAGES.INITIAL:
      // 当AI开始探讨感受和影响时，转到外化阶段
      return aiResponse.includes('感受') || 
             aiResponse.includes('影响') || 
             aiResponse.includes('这让您感觉') ||
             aiResponse.includes('您觉得');
      
    case THERAPY_STAGES.EXTERNALIZATION:
      // 当开始探讨积极面和特质时，转到独特结果阶段
      return aiResponse.includes('发现') || 
             aiResponse.includes('优点') || 
             aiResponse.includes('特质') ||
             aiResponse.includes('能力');
      
    case THERAPY_STAGES.UNIQUE_OUTCOMES:
      // 当开始讨论成长和改变时，转到故事发展阶段
      return aiResponse.includes('成长') || 
             aiResponse.includes('改变') || 
             aiResponse.includes('进步') ||
             aiResponse.includes('学到');
      
    case THERAPY_STAGES.REFLECTION:
      // 当开始总结和展望时，转到反思阶段
      return aiResponse.includes('总结') || 
             aiResponse.includes('未来') || 
             aiResponse.includes('建议') ||
             aiResponse.includes('希望');
      
    default:
      return false;
  }
};

export const chatWithAI = async (message, context) => {
  conversationHistory.push({
    role: 'user',
    content: message
  });

  try {
    const response = await axios.post(API_URL, {
      messages: conversationHistory,
      model: "grok-beta",
      temperature: 0,
      stream: false
    }, {
      headers: {
        'Authorization': `Bearer ${XAI_API_KEY}`,
        'Content-Type': 'application/json'
      }
    });

    const aiResponse = response.data.choices[0].message.content;
    
    // 添加更多日志来追踪状态变化
    console.log('Before stage check:', { 
      currentStage: sessionState.stage,
      aiResponse: aiResponse
    });
    
    // 检查是否应该更新阶段
    if (shouldMoveToNextStage(aiResponse, sessionState.stage)) {
      const currentIndex = Object.values(THERAPY_STAGES).indexOf(sessionState.stage);
      const nextStage = Object.values(THERAPY_STAGES)[currentIndex + 1];
      if (nextStage) {
        console.log(`Stage transition: ${sessionState.stage} -> ${nextStage}`);
        sessionState.stage = nextStage;
      }
    }

    console.log('After stage check:', { 
      newStage: sessionState.stage
    });

    conversationHistory.push({
      role: 'assistant',
      content: aiResponse
    });

    return aiResponse;
  } catch (error) {
    console.error('AI Response Error:', error);
    throw error;
  }
};

// 辅助函数：从AI响应中提取相关信息
function extractTitle(response) {
  // 从AI响应中提取故事标题
  // 可以使用正则表达式或其他方法
  return response.match(/标题[：:]\s*(.+)/)?.[1] || '未命名故事';
}

function extractStoryContent(history) {
  // 从对话历史中提取故事内容
  return history
    .filter(msg => msg.role !== 'system')
    .map(msg => `${msg.role}: ${msg.content}`)
    .join('\n');
}

function extractImpacts(response) {
  // 从AI响应中提取影响
  return response.match(/影响[：:]\s*(.+)/)?.[1] || '';
}

function extractTraits(response) {
  // 从AI响应中提取特质
  return response.match(/特质[：:]\s*(.+)/)?.[1] || '';
}

function extractRecommendations(response) {
  // 从AI响应中提取建议
  return response.match(/建议[：:]\s*(.+)/)?.[1] || '';
}

export const updateStage = (newStage) => {
  if (THERAPY_STAGES[newStage]) {
    sessionState.stage = THERAPY_STAGES[newStage];
  }
};

export const getSessionState = () => {
  return { ...sessionState };
};

export const clearSession = () => {
  conversationHistory = [systemPrompt];
  sessionState = {
    // ... [保持对象结构不变] ...
  };
};

export const updateSummary = async (summaryData) => {
  // ... [函数实现保持不变] ...
};
