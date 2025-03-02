import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import ChatView from '../views/ChatView.vue'
import PastView from '../views/PastView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView
    },
    {
      path: '/chat-past',
      name: 'chat-past',
      component: ChatView
    },
    {
      path: '/chat-future',
      name: 'chat-future',
      component: ChatView
    },
    {
      path: '/past',
      name: 'past',
      component: PastView
    }
  ]
})

export default router
