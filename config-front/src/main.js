import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import vuetify from './plugins/vuetify'
import { EMPTY_KEY } from './util.js'


Vue.config.productionTip = false

Vue.mixin({
  methods: {
    currKey() {
      if (this.currentKey === EMPTY_KEY) {
        return { type: '什么也不做', value: '' }
      }
      return this.currConfig()[this.currentKey]
    },
    currConfig() {
      return this.config[this.$route.name]
    },
  },
  computed: {
    config() {
      return this.$store.state.config
    }
  },
})

const vm = new Vue({
  router,
  store,
  vuetify,
  render: h => h(App)
}).$mount('#app')

window.vm = vm
