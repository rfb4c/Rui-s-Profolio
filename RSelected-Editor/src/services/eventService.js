// src/services/eventService.js
import axios from 'axios'

const api = axios.create({
  // baseURL: import.meta.env.VITE_API_URL || 'http://localhost:8080/editor/events',
  baseURL: import.meta.env.VITE_API_URL || 'https://r-selected.com/editor/events',
  timeout: 5000,
  headers: {
    'Content-Type': 'application/json',
  },
})

export const eventService = {
  async getEventsWithStats() {
    try {
      const response = await api.get('/stats')
      return response.data
    } catch (error) {
      throw error.response?.data || error
    }
  },

  async deleteEvent(eventId) {
    try {
      const id = parseInt(eventId)
      if (isNaN(id)) {
        throw new Error('Invalid event ID')
      }
      console.log('Sending delete request for event ID:', id)
      const response = await api.delete(`/${id}`)
      console.log('Delete response:', response)

      if (response.status === 200) {
        if (!response.data || Object.keys(response.data).length === 0) {
          return { flag: true, message: '删除成功' }
        }
        return response.data
      } else {
        throw new Error('Delete request failed')
      }
    } catch (error) {
      console.error('Delete error:', error)
      throw { flag: false, message: error.message || '删除失败' }
    }
  },

  async getEventDetail(eventId) {
    try {
      const id = parseInt(eventId)
      if (isNaN(id)) {
        throw new Error('Invalid event ID')
      }
      const response = await api.get(`/updateEvent/${id}`)
      return response.data
    } catch (error) {
      throw error.response?.data || error
    }
  },

  async createEvent(eventData) {
    try {
      const formattedData = {
        ...eventData,
        occurrenceTime: eventData.occurrenceTime ? new Date(eventData.occurrenceTime) : null,
      }

      const response = await api.post('/insertEvent', formattedData)
      return response.data
    } catch (error) {
      throw error.response?.data || error
    }
  },

  async updateEvent(eventId, eventData) {
    try {
      const id = parseInt(eventId)
      if (isNaN(id)) {
        throw new Error('Invalid event ID')
      }

      const formattedData = {
        ...eventData,
        occurrenceTime: eventData.occurrenceTime ? new Date(eventData.occurrenceTime) : null,
      }

      const response = await api.put(`/updateEvent/update/${id}`, formattedData)
      return response.data
    } catch (error) {
      throw error.response?.data || error
    }
  },
}
