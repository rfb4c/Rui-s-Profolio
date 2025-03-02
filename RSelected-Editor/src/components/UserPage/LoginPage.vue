<template>
  <div class="page-wrapper">
    <div class="main-container">
      <div class="decorative-gray"></div>
      <div class="decorative-blue"></div>
      <div class="left-section">
        <div class="text-content">
          <h1>R Selected Editor</h1>
          <p>Our vision: Break the filter bubble.</p>
        </div>
        <div class="image-container">
          <img src="@/assets/R.png" alt="Security illustration" />
        </div>
      </div>

      <div class="right-section">
        <div class="login-section">
          <h2>欢迎，播种者</h2>
          <form>
            <div class="form-group email">
              <input type="email" v-model="loginForm.email" placeholder="Email" />
            </div>
            <div class="form-group password">
              <input type="password" v-model="loginForm.password" placeholder="Password" />
            </div>
            <div class="form-options">
              <label class="remember-me">
                <input type="checkbox" />
                <span>Remember Me</span>
              </label>
              <a href="#" class="forgot-password">Forgot Your Password?</a>
            </div>
            <button type="submit" class="login-btn" @click.prevent="handleLogin">LOGIN</button>
          </form>
          <div class="create-account">
            Not a member? <a href="#" @click="goToRegister">Create Account</a>
          </div>
        </div>
      </div>
    </div>

    <div
      class="message-box"
      v-if="message.show"
      :class="{ show: message.show, error: message.isError }"
    >
      <div class="message-content">
        {{ message.text }}
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { User, Lock } from '@element-plus/icons-vue'
import { useRouter } from 'vue-router'
import { userService } from '@/services/userService'

const router = useRouter()
const loginForm = ref({
  email: '',
  password: '',
})
const rememberMe = ref(false)

const message = ref({
  show: false,
  text: '',
  isError: false,
})

const showMessage = (text, isError = true) => {
  message.value.text = text
  message.value.isError = isError
  message.value.show = true
  setTimeout(() => {
    message.value.show = false
  }, 3000)
}

const handleLogin = async () => {
  if (!loginForm.value.email || !loginForm.value.password) {
    showMessage('请输入邮箱和密码')
    return
  }

  try {
    const response = await userService.login({
      email: loginForm.value.email,
      password: loginForm.value.password,
    })

    if (response.flag) {
      showMessage('登录成功', false)
      localStorage.setItem('user', JSON.stringify(response.data))
      setTimeout(() => {
        router.push('/eventList')
      }, 1500)
    } else {
      showMessage(response.message || '登录失败')
    }
  } catch (error) {
    showMessage(error.message || '登录失败，请稍后重试')
  }
}

const goToRegister = () => {
  router.push('/register')
}
</script>

<style scoped>
/* 重置默认样式 */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

/* 页面包装器 */
.page-wrapper {
  min-height: 100vh;
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #f0f0f0;
  padding: 20px;
}

/* 主容器（外层大卡片） */
.main-container {
  width: 73%;
  height: 75vh;
  background: white;
  border-radius: 0;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
  display: flex;
  position: relative;
  overflow: hidden;
}

/* 装饰元素 */
.decorative-gray {
  position: absolute;
  bottom: -200px;
  left: 35%;
  width: 700px;
  height: 700px;
  background: #4a4a4a;
  border-radius: 50%;
  opacity: 0.06;
  transform: rotate(-15deg);
  z-index: 0;
}

.decorative-blue {
  position: absolute;
  top: -250px;
  left: 45%;
  width: 900px;
  height: 900px;
  background: #1e90ff;
  border-radius: 50%;
  opacity: 0.07;
  transform: rotate(15deg);
  z-index: 0;
}

/* 左侧区域 */
.left-section {
  width: 50%;
  padding: 60px;
  display: flex;
  flex-direction: column;
  gap: 40px;
}

.text-content {
  padding-top: 20px;
}

.text-content h1 {
  font-size: 24px;
  margin-bottom: 16px;
  color: #333;
}

.text-content p {
  color: #666;
  line-height: 1.6;
}

.image-container {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
}

.image-container img {
  max-width: 80%;
  height: auto;
  object-fit: contain;
}

/* 右侧区域 */
.right-section {
  width: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 40px;
}

/* 右侧登录卡片区域 */
.login-section {
  position: relative;
  z-index: 1;
  width: 80%;
  min-height: 450px;
  background: white;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  padding: 50px 40px;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.login-section h2 {
  font-size: 18px;
  color: #333;
  margin-bottom: 40px;
  font-weight: 500;
  text-align: center;
}

.form-group {
  margin-bottom: 25px;
  position: relative;
}

.form-group input {
  width: 100%;
  padding: 12px 0;
  border: none;
  border-bottom: 1px solid #e0e0e0;
  font-size: 14px;
  outline: none;
  padding-left: 30px;
  transition: all 0.3s ease;
}

/* 添加焦点效果 */
.form-group input:focus {
  border-bottom-color: #007bff;
}

/* 可以选择同时改变图标颜色 */
.form-group input:focus + .icon {
  color: #007bff;
}

/* 如果使用伪元素作为图标，也可以这样写 */
.form-group input:focus ~ .form-group::before {
  filter: invert(48%) sepia(79%) saturate(2476%) hue-rotate(190deg) brightness(118%) contrast(119%);
}

/* 输入框图标 */
.form-group::before {
  content: '';
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 20px;
  height: 20px;
  background-size: contain;
  background-repeat: no-repeat;
}

.form-group.email::before {
  background-image: url('path-to-email-icon.svg'); /* 需要添加邮箱图标 */
}

.form-group.password::before {
  background-image: url('path-to-password-icon.svg'); /* 需要添加密码图标 */
}

/* 记住我和忘记密码行 */
.form-options {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
  font-size: 13px;
}

.remember-me {
  display: flex;
  align-items: center;
  gap: 8px;
}

.remember-me input[type='checkbox'] {
  width: 16px;
  height: 16px;
}

.forgot-password {
  color: #666;
  text-decoration: none;
}

/* 登录按钮 */
.login-btn {
  width: 100%;
  padding: 15px;
  background: #007bff;
  color: white;
  border: none;
  border-radius: 25px;
  font-size: 16px;
  cursor: pointer;
  margin: 20px 0;
  box-shadow: 0 4px 15px rgba(0, 123, 255, 0.3);
}

/* 创建账号链接 */
.create-account {
  text-align: center;
  margin-top: 20px;
  font-size: 14px;
  color: #666;
}

.create-account a {
  color: #4caf50;
  text-decoration: none;
  font-weight: 500;
}

/* 如果需要装饰性元素 */
.decorative-shape-1 {
  position: absolute;
  bottom: -50px;
  left: -50px;
  width: 200px;
  height: 200px;
  background: #e8f3ff;
  border-radius: 50%;
  z-index: 0;
}

.decorative-shape-2 {
  position: absolute;
  top: -30px;
  right: -30px;
  width: 150px;
  height: 150px;
  background: #e8fff3;
  border-radius: 50%;
  z-index: 0;
}

.create-link {
  color: #4caf50;
  cursor: pointer;
}

.create-link:hover {
  text-decoration: underline;
}

/* 添加消息框样式 */
.message-box {
  position: fixed;
  top: 20px;
  right: -300px;
  width: 280px;
  padding: 16px 20px;
  border-radius: 4px;
  background-color: white;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.15);
  transition: all 0.3s ease;
  z-index: 1000;
}

.message-box.show {
  right: 20px;
}

.message-box.error {
  border-left: 4px solid #ff4444;
}

.message-box:not(.error) {
  border-left: 4px solid #4caf50;
}

.message-content {
  color: #333;
  font-size: 14px;
  line-height: 1.4;
}
</style>
