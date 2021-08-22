import { createApp } from 'vue'
import App from './App.vue'
import router from './router'

import axios from 'axios'
import VueAxios from 'vue-axios'

import Toaster from '@meforma/vue-toaster';

const app = createApp(App)
app.use(router) 
app.use(VueAxios, axios) 
app.use(Toaster);
app.mount('#app')

