import { createRouter, createWebHistory } from 'vue-router'

import LoginPageVue from '@/components/UserPage/LoginPage.vue'
import RegisterPageVue from '@/components/UserPage/RegisterPage.vue'
import MainPageVue from '@/components/MainPage/MainPage.vue'
import EventListVue from '@/components/MainPage/EventList/EventList.vue'
import CreateEventVue from '@/components/MainPage/CreateEvent/CreateEvent.vue'
import UpdateEventVue from '@/components/MainPage/UpdateEvent/UpdateEvent.vue'
import UpdatePhaseVue from '@/components/MainPage/UpdatePhase/UpdatePhase.vue'
import PhaseListVue from '@/components/MainPage/PhaseList/PhaseList.vue'
import ReportListVue from '@/components/MainPage/ReportList/ReportList.vue'
import UpdateReportVue from '@/components/MainPage/UpdateReport/UpdateReport.vue'
import RevisePasswordVue from '@/components/UserPage/RevisePassword.vue'

const routes = [
  // 登录页
  { path: '/login', component: LoginPageVue },
  { path: '/register', component: RegisterPageVue },
  // 主页
  {
    path: '/',
    component: MainPageVue,
    children: [
      //
      { path: '/eventList', component: EventListVue },
      { path: '/createEvent', component: CreateEventVue },
      { path: '/updateEvent', component: UpdateEventVue },
      { path: '/updatePhase', component: UpdatePhaseVue },
      { path: '/phaseList', component: PhaseListVue },
      { path: '/reportList', component: ReportListVue },
      { path: '/updateReport', component: UpdateReportVue },
      { path: '/revisePassword', component: RevisePasswordVue },
    ],
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes: routes,
})

export default router
