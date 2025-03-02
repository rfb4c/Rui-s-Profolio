import axios from 'axios'

const api = axios.create({
  // baseURL: import.meta.env.VITE_API_URL || 'http://localhost:8080/editor/phase',
  baseURL: import.meta.env.VITE_API_URL || 'https://r-selected.com/editor/phase',
  timeout: 5000,
  headers: {
    'Content-Type': 'application/json',
  },
})

export const phaseService = {
  async getPhasesByEventId(eventId) {
    try {
      const id = parseInt(eventId)
      if (isNaN(id)) {
        throw new Error('Invalid event ID')
      }
      const response = await api.get(`/list/${id}`)
      return response.data
    } catch (error) {
      throw error.response?.data || error
    }
  },

  async deletePhase(phaseId) {
    try {
      const id = parseInt(phaseId)
      if (isNaN(id)) {
        throw new Error('Invalid phase ID')
      }
      const response = await api.delete(`/${id}`)
      return response.data
    } catch (error) {
      throw error.response?.data || error
    }
  },

  async insertPhase(phaseData) {
    try {
      const formattedData = {
        ...phaseData,
        phaseOccurrenceTime: phaseData.phaseOccurrenceTime
          ? new Date(phaseData.phaseOccurrenceTime).toISOString()
          : null,
      }

      const response = await api.post('/insert', formattedData)
      return response.data
    } catch (error) {
      throw error.response?.data || error
    }
  },

  async updatePhase(phaseData) {
    try {
      const response = await api.put(`/update`, phaseData)
      return response.data
    } catch (error) {
      throw error.response?.data || error
    }
  },
}
