import { defineStore } from 'pinia'

export const useReportStore = defineStore('report', {
  state: () => ({
    reportList: [],
    loading: false,
    error: null,
  }),

  actions: {
    setReportList(reports) {
      this.reportList = reports
    },
    setLoading(status) {
      this.loading = status
    },
    setError(error) {
      this.error = error
    },
  },
})
