<template>
  <div class="chat-container">
    <!-- 添加导航栏 -->
    <div class="header">
      <div class="logo">
        <img src="@/assets/home.png" class="home-icon" @click="goBack" />
      </div>
      <div class="user-icons">
        <i class="icon-bell"></i>
        <div class="avatar"></div>
      </div>
    </div>

    <!-- 消息列表 -->
    <div class="message-list" ref="messageList">
      <div v-for="(message, index) in messages" :key="index" :class="['message', message.role]">
        <div class="avatar">
          <el-icon v-if="message.role === 'assistant'"><Service /></el-icon>
          <el-icon v-else><UserFilled /></el-icon>
        </div>
        <div class="content">{{ message.content }}</div>
      </div>
    </div>

    <!-- 输入区域 -->
    <div class="input-area">
      <el-input
        v-model="inputMessage"
        type="textarea"
        :rows="1"
        placeholder="请输入消息..."
        @keyup.enter.ctrl="sendMessage"
      />
      <el-button type="primary" :loading="loading" @click="sendMessage">发送</el-button>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { UserFilled, Service } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { chatWithAI, getSessionState, THERAPY_STAGES, DEFAULT_USER_ID } from '../services/grok'
import { saveStory } from '../services/api'

const route = useRoute()
const router = useRouter()
const messages = ref([])
const inputMessage = ref('')
const messageList = ref(null)
const loading = ref(false)
const sessionState = ref(getSessionState())
const shouldSave = ref(false)

// 完全重写打字机效果函数
const typeMessage = async (text) => {
  // 先创建一个新的消息数组
  const newMessages = [...messages.value]
  const message = {
    role: 'assistant',
    content: '',
    timestamp: Date.now()
  }
  newMessages.push(message)
  
  // 更新整个消息数组
  messages.value = newMessages

  // 逐字显示
  for (let char of text) {
    message.content += char
    // 强制更新整个消息数组
    messages.value = [...newMessages]
    await new Promise(resolve => setTimeout(resolve, 50))
  }
}

const goBack = () => {
  router.push('/past')
}

onMounted(async () => {
  const initialMessage = route.path === '/chat-past'
    ? '你好！我是来自过去的AI咨询师。让我们开始对话吧！'
    : '你好！我是来自未来的AI咨询师。让我们开始对话吧！'
  
  await typeMessage(initialMessage)
})

const sendMessage = async () => {
  if (!inputMessage.value.trim()) return;
  
  const userMessage = inputMessage.value;
  inputMessage.value = '';
  
  messages.value.push({
    role: 'user',
    content: userMessage,
    timestamp: Date.now()
  });
  
  loading.value = true;

  try {
    console.log('Current state before processing:', {
      stage: sessionState.value.stage,
      shouldSave: shouldSave.value,
      userMessage
    });

    // 如果上一条是询问保存的消息，且用户回答肯定
    if (shouldSave.value && isPositiveResponse(userMessage)) {
      console.log('Attempting to save story...'); // 添加日志
      await saveStoryToDatabase();
      shouldSave.value = false;
      return;
    }

    const aiResponse = await chatWithAI(userMessage);
    
    // 修改这里：使用导入的 THERAPY_STAGES
    if ((sessionState.value.stage === THERAPY_STAGES.REFLECTION || 
         sessionState.value.stage === THERAPY_STAGES.UNIQUE_OUTCOMES) && 
        !shouldSave.value) {
      console.log('Final stage reached, preparing to save...'); 
      await typeMessage(aiResponse);
      await typeMessage("这次对话很有意义。您希望我帮您保存这次的回忆吗？");
      shouldSave.value = true;
    } else {
      await typeMessage(aiResponse);
      shouldSave.value = false;
    }
    
    sessionState.value = getSessionState();
    
  } catch (error) {
    console.error('Error in sendMessage:', error);
    ElMessage.error('发送消息失败，请重试');
  } finally {
    loading.value = false;
  }
};

// 判断用户是否同意保存的辅助函数
const isPositiveResponse = (response) => {
  const positiveWords = ['是', '好', '可以', '同意', '要', '嗯', '对', 'yes', '好的', '行'];
  return positiveWords.some(word => response.toLowerCase().includes(word));
};

const shouldSaveConversation = (aiResponse) => {
  // 这里添加你的判断逻辑
  // 例如：检测特定关键词或对话完成标志
  return aiResponse.includes('总结') || aiResponse.includes('完成');
}

const saveConversation = async () => {
  try {
    // 假设对话完成后的总结数据结构
    const summary = {
      title: "对话总结",  // 可以基于对话内容生成
      content: messages.value.map(m => `${m.role}: ${m.content}`).join('\n'),
      impacts: "...",  // 根据实际情况填写
      traits: "...",   // 根据实际情况填写
      recommendations: "..." // 根据实际情况填写
    };
    
    // 假设有用户ID，实际应该从用户系统获取
    const userId = 1;  // 临时使用固定值，实际应该从用户系统获取
    
    const result = await saveStoryToDatabase(userId, summary);
    ElMessage.success('对话已保存');
    return result;
  } catch (error) {
    console.error('保存对话失败:', error);
    ElMessage.error('保存对话失败');
  }
};

// 添加保存故事的函数
const saveStoryToDatabase = async () => {
  try {
    console.log('Starting save process...'); // 添加日志
    console.log('Current messages:', messages.value); // 添加日志

    const storyData = {
      user_id: DEFAULT_USER_ID,
      title: '对话记录', // 默认标题
      content: messages.value
        .map(m => `${m.role}: ${m.content}`)
        .join('\n'),
      impacts: '用户分享的经历和感受',
      traits: '用户展现的特质',
      recommendations: '对话中的建议'
    };

    console.log('Preparing to save story data:', storyData); // 添加日志

    const result = await saveStory(storyData);
    console.log('Save result:', result); // 添加日志
    
    ElMessage({
      message: '您的故事已经成功保存！感谢您的分享。',
      type: 'success',
      duration: 3000,
      showClose: true,
      center: true
    });

    return result;
  } catch (error) {
    console.error('Save error:', error);
    ElMessage({
      message: '保存故事失败: ' + error.message,
      type: 'error',
      duration: 5000,
      showClose: true
    });
  }
};
</script>

<style scoped>
.chat-container {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  display: flex;
  flex-direction: column;
  background-color: #F8F9FE;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
  padding: 8px;
}

.logo {
  display: flex;
  align-items: center;
  gap: 16px;
}

.user-icons {
  display: flex;
  align-items: center;
  gap: 16px;
}

.icon-bell {
  width: 24px;
  height: 24px;
  color: #A1A7B3;
}

.home-icon {
  width: 32px;
  height: 32px;
  position: absolute;
  top: 16px;
  left: 32px;
  cursor: pointer;
}

.avatar {
  width: 32px;
  height: 32px;
  background: linear-gradient(-60deg,
    #7F7FD5 0%,
    #86A8E7 50%,
    #91EAE4 100%
  );
  border-radius: 50%;
  position: absolute;
  top: 16px;
  right: 32px;
}

.message-list {
  margin-top: 32px;
  flex: 1;
  overflow-y: auto;
  padding: 20px;
  background: #ffffff;
}

.message {
  display: flex;
  margin-bottom: 20px;
  align-items: flex-start;
}

.message.user {
  flex-direction: row-reverse;
}

.message .avatar {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: linear-gradient(-60deg, #7F7FD5 0%, #86A8E7 50%, #91EAE4 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 8px;
  position: relative;
  top: 0;
  right: 0;
}

.content {
  max-width: 70%;
  padding: 12px 16px;
  border-radius: 20px;
  background: #e9e9eb;
  box-shadow: none;
  font-size: 14px;
  line-height: 1.4;
}

.message.assistant .content {
  border-top-left-radius: 4px;
  background: linear-gradient(-60deg,
    #7F7FD5 0%,
    #86A8E7 50%,
    #91EAE4 100%
  );
  color: white;
}

.message.user .content {
  border-top-right-radius: 4px;
  background: #e9e9eb;
  color: #333;
  box-shadow: none;
}

.message .avatar :deep(.el-icon) {
  color: white;
  font-size: 16px;
}

.input-area {
  padding: 10px;
  background: #ffffff;
  display: flex;
  gap: 8px;
  border-top: 1px solid #eee;
}

.input-area :deep(.el-textarea__inner) {
  min-height: 40px !important;
  max-height: 40px !important;
  resize: none;
}

.el-button {
  height: 40px;
  padding: 0 16px;
  background: linear-gradient(-60deg,
    #7F7FD5 0%,
    #86A8E7 50%,
    #91EAE4 100%
  ) !important;
  border: none !important;
  color: white !important;
  font-weight: 500;
  transition: opacity 0.3s ease;
}

.el-button:hover {
  opacity: 0.9;
}

.el-button:active {
  opacity: 0.8;
}

.el-button.is-loading {
  background: linear-gradient(-60deg,
    #7F7FD5 0%,
    #86A8E7 50%,
    #91EAE4 100%
  ) !important;
  opacity: 0.8;
}
</style>
