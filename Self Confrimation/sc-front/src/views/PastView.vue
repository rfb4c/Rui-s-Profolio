<template>
  <div class="past-container">
    <!-- 顶部区域 -->
    <div class="header">
      <div class="logo">
        <img src="@/assets/home.png" class="home-icon" @click="goHome" />
      </div>
      <div class="user-icons">
        <i class="icon-bell"></i>
        <div class="avatar"></div>
      </div>
    </div>

    <!-- 选择模式区域 -->
    <div class="section mood-section">
      <h3 class="section-title">选择板块</h3>
      <div class="mood-grid">
        <div class="mood-card" @click="$router.push('/chat-past')">
          <div class="mood-icon">
            <img src="@/assets/newPast1.png" class="mood-image" />
          </div>
          <div class="mood-content">
            <span class="mood-text">新的回忆</span>
            <span class="mood-subtitle">开启新的对话</span>
          </div>
        </div>
        <div class="mood-card">
          <div class="mood-icon">
            <img src="@/assets/oldPast1.png" class="mood-image" />
          </div>
          <div class="mood-content">
            <span class="mood-text">过去的回忆</span>
            <span class="mood-subtitle">查看历史对话</span>
          </div>
        </div>
      </div>
    </div>

    <!-- 珍贵回忆区域 -->
    <div class="section">
      <h3 class="section-title">珍贵回忆</h3>
      <div class="courses-grid">
        <div class="course-card" v-for="memory in memories" :key="memory.id">
          <div class="main-content">
            <p class="course-description">
              <span class="quote custom-quote">"</span>{{ memory.content }}
            </p>
            <h4 class="course-title">{{ memory.date }}</h4>
          </div>
          <div class="additional-content">
            <div class="story-traits">
              <div class="traits-container">
                <span class="trait-tag" v-for="(tag, index) in memory.tags" :key="index">
                  {{ tag }}
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.past-container {
  padding: 0;
  background-color: #F8F9FE;
  min-height: 100vh;
  max-width: 100%;
  margin: 0 auto;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
  padding: 8px;
}

.logo {
  display: flex;
  align-items: center;
  gap: 16px;
}

.icon-bell {
  width: 24px;
  height: 24px;
  color: #A1A7B3;
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

.home-icon {
  width: 32px;
  height: 32px;
  position: absolute;
  top: 16px;
  left: 32px;
  cursor: pointer;
}

.section-title {
  color: #A1A7B3;
  font-size: 14px;
  font-weight: 400;
  margin-bottom: 12px;
}

.mood-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
  padding: 0 4px;
}

.mood-card {
  background: white;
  border-radius: 20px;
  padding: 16px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
  box-shadow: 
    8px 8px 24px rgba(103, 110, 203, 0.08),
    4px 4px 8px rgba(103, 110, 203, 0.06);
  cursor: pointer;
  transition: transform 0.2s ease;
}

.mood-card:hover {
  transform: translateY(-2px);
}

.mood-icon {
  width: 60px;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.mood-image {
  width: 100%;
  height: 100%;
  object-fit: contain;
}

.mood-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
}

.mood-text {
  font-size: 16px;
  font-weight: 500;
  color: #333;
}

.mood-subtitle {
  font-size: 12px;
  color: #A1A7B3;
}

.courses-grid {
  display: flex;
  flex-direction: column;
  gap: 16px;
  padding: 0 4px;
}

.course-card {
  background: white;
  border-radius: 20px;
  padding: 16px;
  box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.04);
}

.main-content {
  margin-bottom: 12px;
}

.course-description {
  font-size: 14px;
  color: #333;
  line-height: 1.5;
}

.course-title {
  font-size: 12px;
  color: #A1A7B3;
  margin-top: 8px;
}

.additional-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.story-traits {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.trait-tag {
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 12px;
  background: #F0F2F5;
  color: #666;
}

/* 添加标题样式 */
.title-section {
  margin: 20px 0 32px;
  padding: 0 16px;
}

.main-title {
  font-size: 24px;
  font-weight: 700;
  color: #333;
  background: linear-gradient(-60deg,
    #7F7FD5 0%,
    #86A8E7 50%,
    #91EAE4 100%
  );
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
  letter-spacing: 1px;
}

/* 调整第一个 section 的上边距 */
.section:first-of-type {
  margin-top: 64px;
}

.mood-section {
  margin-bottom: 32px;
}

.section {
  margin-top: 32px;
}

/* 调整消息列表的上边距，以适应新的导航栏 */
.message-list {
  margin-top: 64px;
  /* 其他样式保持不变 */
}
</style>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { UserFilled, Service } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { chatWithAI } from '../services/grok'

const route = useRoute()
const messages = ref([])
const inputMessage = ref('')
const messageList = ref(null)
const loading = ref(false)

// 添加打字机效果的函数
const typeMessage = (fullMessage) => {
  return new Promise((resolve) => {
    let currentText = ''
    const message = {
      role: 'assistant',
      content: '',
      timestamp: Date.now(),
    }
    messages.value.push(message)
    
    let index = 0
    const interval = setInterval(() => {
      if (index < fullMessage.length) {
        currentText += fullMessage[index]
        message.content = currentText
        index++
      } else {
        clearInterval(interval)
        resolve()
      }
    }, 50) // 每50毫秒打出一个字
  })
}

onMounted(async () => {
  // 根据路由设置不同的初始消息
  const initialMessage = route.path === '/chat-past'
    ? '你好！我是来自过去的AI咨询师。让我们开始对话吧！'
    : '你好！我是来自未来的AI咨询师。让我们开始对话吧！'
    
  // 使用打字机效果显示初始消息
  await typeMessage(initialMessage)
})

const sendMessage = async () => {
  if (!inputMessage.value.trim() || loading.value) return

  const userMessage = inputMessage.value

  messages.value.push({
    role: 'user',
    content: userMessage,
    timestamp: Date.now(),
  })

  inputMessage.value = ''
  loading.value = true

  try {
    const aiResponse = await chatWithAI(userMessage)
    // 使用打字机效果显示AI回复
    await typeMessage(aiResponse)
  } catch (error) {
    console.error(error)
    ElMessage.error('发送消息失败，请重试')
  } finally {
    loading.value = false
  }

  setTimeout(() => {
    if (messageList.value) {
      messageList.value.scrollTop = messageList.value.scrollHeight
    }
  }, 100)
}
</script>

<script>
export default {
  name: 'PastView',
  methods: {
    goHome() {
      this.$router.push('/');
    }
  },
  data() {
    return {
      memories: [
        {
          id: 1,
          date: '2000年夏',
          content: '第一次去海边，看着无边无际的大海，内心充满了好奇和向往。爸爸教我游泳，虽然呛了好多水，但那种自由的感觉至今难忘。',
          tags: ['家庭', '探索', '欢乐']
        },
        {
          id: 2,
          date: '2005年春',
          content: '和小伙伴们在田野间追逐蝴蝶，采摘野花。那时的空气中总是充满着青草的香味，还有我们清脆的笑声。',
          tags: ['友情', '自然', '童趣']
        },
        {
          id: 3,
          date: '2010年秋',
          content: '第一次参加学校的文艺汇演，演奏了一首钢琴曲。虽然很紧张，但当听到掌声的那一刻，所有的努力都值得了。',
          tags: ['成长', '音乐', '勇气']
        }
      ]
    }
  }
}
</script> 