import Vue from 'vue'
import Vuex from 'vuex'
import axios from 'axios';
import { host } from '../util';


Vue.use(Vuex)

function processConfig(config) {
  config['CapslockAbbrKeys'] = Object.keys(config.CapslockAbbr)
  config['SemicolonAbbrKeys'] = Object.keys(config.SemicolonAbbr)
  return config
}

const s = new Vuex.Store({
  state: {
    config: null,
    snackbar: false,
    snackbarText: '',
  },
  mutations: {
    SET_CONFIG(state, value) {
      console.log('update config', value)
      state.config = value
    },
    SET_SNACKBAR(state, {snackbar, snackbarText}) {
      state.snackbar = snackbar
      state.snackbarText = snackbarText
    },
  },
  actions: {
    saveConfig(store) {
      axios
        .put(`${host}/config`, processConfig(store.state.config))
        .then(resp => {
          console.log(resp.data)
          store.commit('SET_SNACKBAR', {snackbar: true, snackbarText: `保存成功, 请按 alt+' 重启 MyKeymap`})
        })
        .catch(error => {
          store.commit('SET_SNACKBAR', {snackbar: true, snackbarText: `保存失败`})
          throw error
        })
    },
    fetchConfig(store) {
      return axios.get(`${host}/config`)
        .then(resp => store.commit('SET_CONFIG', resp.data))
        .catch(error => {
          throw error // 方便后面看堆栈定位问题
        })
    }
  },
  modules: {
  }
})
s.dispatch('fetchConfig')
export default s