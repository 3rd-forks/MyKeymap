// Composables
import Home from '@/views/Home.vue'
import Keymap from '@/views/Keymap.vue'
import { createRouter, createWebHistory } from 'vue-router'
import Settings from "@/views/Settings.vue";

const routes = [
  {
    path: '/',
    component: () => import('@/layouts/default/Default.vue'),
    children: [
      {
        path: '',
        name: 'Home',
        component: Home,
      },
      { path: "/keymap/:id", component: Keymap },
      { path: "/settings", component: Settings },
      { path: "/customHotkeys", component: Home },
      { path: "/:key(.*[aA]bbr)", component: Home },
    ],
  },
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
})

export default router
