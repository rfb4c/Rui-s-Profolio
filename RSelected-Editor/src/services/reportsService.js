import axios from 'axios'

const api = axios.create({
  // baseURL: import.meta.env.VITE_API_URL || 'http://localhost:8080/editor/reports',
  baseURL: import.meta.env.VITE_API_URL || 'https://r-selected.com/editor/reports', // 设置你的 API 基础URL
  timeout: 5000,
  headers: {
    'Content-Type': 'application/json',
  },
})

export const reportsService = {
  async getReportListFull() {
    try {
      const response = await api.get('/fulllist')
      return response.data
    } catch (error) {
      throw error.response?.data || error
    }
  },

  async getReportsByPhaseId(phaseId) {
    try {
      const response = await api.get(`/list/${phaseId}`)
      return response.data
    } catch (error) {
      throw error.response?.data || error
    }
  },

  async deleteReport(reportId) {
    try {
      const response = await api.delete(`/${reportId}`)
      return response.data
    } catch (error) {
      throw error.response?.data || error
    }
  },

  async insertReport(reportData) {
    try {
      const response = await api.post('/reports/insert', reportData)
      return response.data
    } catch (error) {
      throw error.response?.data || error
    }
  },

  async getMediaCodeByName(mediaName) {
    try {
      const response = await api.get(`/media/code/${encodeURIComponent(mediaName)}`)
      return response.data
    } catch (error) {
      throw error.response?.data || error
    }
  },

  async getReportDetail(reportId) {
    try {
      const response = await api.get(`/detail/${reportId}`)
      return response.data
    } catch (error) {
      throw error.response?.data || error
    }
  },

  async updateReport(reportId, reportData) {
    try {
      const response = await api.put(`/${reportId}`, reportData)
      return response.data
    } catch (error) {
      throw error.response?.data || error
    }
  },
}
