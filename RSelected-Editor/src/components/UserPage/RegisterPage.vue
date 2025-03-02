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
          <h2>创建账号</h2>
          <form>
            <div class="form-group email">
              <el-tooltip
                :content="errors.email"
                placement="right"
                :show-after="0"
                :hide-after="3000"
                effect="light"
                :visible="!!errors.email"
              >
                <input
                  type="email"
                  v-model="registerForm.email"
                  placeholder="Email"
                  @blur="validateEmail"
                />
              </el-tooltip>
            </div>
            <div class="form-group password">
              <el-tooltip
                :content="errors.password"
                placement="right"
                :show-after="0"
                :hide-after="3000"
                effect="light"
                :visible="!!errors.password"
              >
                <input
                  type="password"
                  v-model="registerForm.password"
                  placeholder="Password"
                  @blur="validatePassword"
                />
              </el-tooltip>
            </div>
            <div class="form-group password">
              <el-tooltip
                :content="errors.confirmPassword"
                placement="right"
                :show-after="0"
                :hide-after="3000"
                effect="light"
                :visible="!!errors.confirmPassword"
              >
                <input
                  type="password"
                  v-model="registerForm.confirmPassword"
                  placeholder="Confirm Password"
                  @blur="validateConfirmPassword"
                />
              </el-tooltip>
            </div>
            <button type="submit" class="login-btn" @click.prevent="handleRegister">
              REGISTER
            </button>
          </form>
          <div class="create-account">
            Already have an account? <a href="#" @click="goToLogin">Login</a>
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
import { useRouter } from 'vue-router'
import { ElTooltip } from 'element-plus'
import { userService } from '@/services/userService'

const router = useRouter()
const registerForm = ref({
  email: '',
  password: '',
  confirmPassword: '',
})

const errors = ref({
  email: '',
  password: '',
  confirmPassword: '',
})

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

// 验证邮箱
const validateEmail = () => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  if (!registerForm.value.email) {
    errors.value.email = '邮箱不能为空'
    return false
  } else if (!emailRegex.test(registerForm.value.email)) {
    errors.value.email = '请输入有效的邮箱地址'
    return false
  }
  errors.value.email = ''
  return true
}

// 验证密码
const validatePassword = () => {
  if (!registerForm.value.password) {
    errors.value.password = '密码不能为空'
    return false
  } else if (registerForm.value.password.length < 6) {
    errors.value.password = '密码长度至少6位'
    return false
  }
  errors.value.password = ''
  return true
}

// 验证确认密码
const validateConfirmPassword = () => {
  if (!registerForm.value.confirmPassword) {
    errors.value.confirmPassword = '请确认密码'
    return false
  } else if (registerForm.value.confirmPassword !== registerForm.value.password) {
    errors.value.confirmPassword = '两次输入的密码不一致'
    return false
  }
  errors.value.confirmPassword = ''
  return true
}

// 修改 handleRegister 函数
const handleRegister = async () => {
  // 验证所有字段
  const isEmailValid = validateEmail()
  const isPasswordValid = validatePassword()
  const isConfirmPasswordValid = validateConfirmPassword()

  if (isEmailValid && isPasswordValid && isConfirmPasswordValid) {
    try {
      const userData = {
        email: registerForm.value.email,
        password: registerForm.value.password,
        username: registerForm.value.email.split('@')[0], // 默认使用邮箱前缀作为用户名
      }

      const response = await userService.register(userData)

      if (response.flag) {
        showMessage(response.message, false) // 显示成功消息
        setTimeout(() => {
          router.push('/login')
        }, 1500)
      } else {
        showMessage(response.message) // 显示错误消息
      }
    } catch (error) {
      showMessage(error.message || '注册失败，请稍后重试')
    }
  }
}

const goToLogin = () => {
  router.push('/login')
}
</script>

<style scoped>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

.page-wrapper {
  min-height: 100vh;
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #f0f0f0;
  padding: 20px;
}

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

.right-section {
  width: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 40px;
}

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
  margin-bottom: 4px;
}

.form-group input:focus {
  border-bottom-color: #007bff;
}

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

.login-btn {
  margin-top: 30px;
}

/* 自定义 Element Plus Tooltip 样式 */
:deep(.el-tooltip__popper) {
  background: white !important;
  color: #ff4444 !important;
  border: 1px solid #ff4444 !important;
  padding: 8px 12px !important;
  font-size: 13px !important;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1) !important;
}

:deep(.el-tooltip__popper[x-placement^='right'] .popper__arrow) {
  border-right-color: #ff4444 !important;
}

:deep(.el-tooltip__popper[x-placement^='right'] .popper__arrow::after) {
  border-right-color: white !important;
}
</style>
