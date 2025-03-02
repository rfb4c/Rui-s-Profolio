<template>
  <div class="page-wrapper">
    <div class="card">
      <h2>修改密码</h2>
      <form>
        <div class="form-group">
          <el-tooltip
            :content="errors.currentPassword"
            placement="right"
            :show-after="0"
            :hide-after="3000"
            effect="light"
            :visible="!!errors.currentPassword"
          >
            <input
              type="password"
              v-model="passwordForm.currentPassword"
              placeholder="当前密码"
              @blur="validateCurrentPassword"
            />
          </el-tooltip>
        </div>
        <div class="form-group">
          <el-tooltip
            :content="errors.newPassword"
            placement="right"
            :show-after="0"
            :hide-after="3000"
            effect="light"
            :visible="!!errors.newPassword"
          >
            <input
              type="password"
              v-model="passwordForm.newPassword"
              placeholder="新密码"
              @blur="validateNewPassword"
            />
          </el-tooltip>
        </div>
        <div class="form-group">
          <el-tooltip
            :content="errors.confirmNewPassword"
            placement="right"
            :show-after="0"
            :hide-after="3000"
            effect="light"
            :visible="!!errors.confirmNewPassword"
          >
            <input
              type="password"
              v-model="passwordForm.confirmNewPassword"
              placeholder="确认新密码"
              @blur="validateConfirmNewPassword"
            />
          </el-tooltip>
        </div>
        <button type="submit" class="submit-btn" @click.prevent="handleChangePassword">
          修改密码
        </button>
      </form>
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

const router = useRouter()
const passwordForm = ref({
  currentPassword: '',
  newPassword: '',
  confirmNewPassword: '',
})

const errors = ref({
  currentPassword: '',
  newPassword: '',
  confirmNewPassword: '',
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

// 验证当前密码
const validateCurrentPassword = () => {
  if (!passwordForm.value.currentPassword) {
    errors.value.currentPassword = '当前密码不能为空'
    return false
  }
  errors.value.currentPassword = ''
  return true
}

// 验证新密码
const validateNewPassword = () => {
  if (!passwordForm.value.newPassword) {
    errors.value.newPassword = '新密码不能为空'
    return false
  } else if (passwordForm.value.newPassword.length < 6) {
    errors.value.newPassword = '新密码长度至少6位'
    return false
  }
  errors.value.newPassword = ''
  return true
}

// 验证确认新密码
const validateConfirmNewPassword = () => {
  if (!passwordForm.value.confirmNewPassword) {
    errors.value.confirmNewPassword = '请确认新密码'
    return false
  } else if (passwordForm.value.confirmNewPassword !== passwordForm.value.newPassword) {
    errors.value.confirmNewPassword = '两次输入的新密码不一致'
    return false
  }
  errors.value.confirmNewPassword = ''
  return true
}

// 处理修改密码
const handleChangePassword = () => {
  // 验证所有字段
  const isCurrentPasswordValid = validateCurrentPassword()
  const isNewPasswordValid = validateNewPassword()
  const isConfirmNewPasswordValid = validateConfirmNewPassword()

  if (isCurrentPasswordValid && isNewPasswordValid && isConfirmNewPasswordValid) {
    // 这里添加修改密码逻辑
    showMessage('密码修改成功', false)
    // 例如，跳转到其他页面
    // router.push('/somePage')
  }
}
</script>

<style scoped>
.page-wrapper {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #f0f0f0;
  padding: 20px;
  box-sizing: border-box;
}

.card {
  width: 100%;
  max-width: 500px;
  background: white;
  border-radius: 8px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  padding: 30px;
  box-sizing: border-box;
}

.card h2 {
  text-align: center;
  margin-bottom: 30px;
  font-size: 28px;
  color: #333;
}

.form-group {
  margin-bottom: 20px;
}

.form-group input {
  width: 100%;
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 16px;
  outline: none;
  transition: border-color 0.3s;
}

.form-group input:focus {
  border-color: #007bff;
}

.submit-btn {
  width: 100%;
  padding: 12px;
  background: #007bff;
  color: white;
  border: none;
  border-radius: 4px;
  font-size: 18px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.submit-btn:hover {
  background-color: #0056b3;
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
