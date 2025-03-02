import axios from 'axios'

// 创建 axios 实例
const api = axios.create({
  // baseURL: import.meta.env.VITE_API_URL || 'http://localhost:8080/users', // 设置你的 API 基础URL
  baseURL: import.meta.env.VITE_API_URL || 'https://r-selected.com/users', // 设置你的 API 基础URL
  timeout: 5000,
  headers: {
    'Content-Type': 'application/json',
  },
})

export const userService = {
  async register(userData) {
    try {
      const response = await api.post('/register', userData)
      return response.data
    } catch (error) {
      throw error.response?.data || error
    }
  },

  // 在 userService.js 中添加
  async login(loginData) {
    try {
      const response = await api.post('/login', loginData)
      return response.data
    } catch (error) {
      throw error.response?.data || error
    }
  },
}
