<script setup lang="ts">
import { defineAsyncComponent, onBeforeUnmount, onMounted } from 'vue'
import MainView from './views/MainView.vue'
import { applyLocale, type LocalePayload } from './utils/locale'
import { sendNuiCallback } from './utils/nui'

const BoilerplateView = import.meta.env.DEV
  ? defineAsyncComponent(() => import('./views/BoilerplateView.vue'))
  : null

interface NuiMessage {
  action?: string
  locale?: LocalePayload
}

const handleMessage = (event: MessageEvent<NuiMessage>) => {
  if (event.data?.action === 'siku_intro:nui:setLocale' && event.data.locale) {
    applyLocale(event.data.locale)
  }
}

onMounted(() => {
  window.addEventListener('message', handleMessage)
  sendNuiCallback('siku_intro:nui:ready')
})

onBeforeUnmount(() => {
  window.removeEventListener('message', handleMessage)
})
</script>

<template>
  <VApp>
    <component :is="BoilerplateView" v-if="BoilerplateView" />
    <MainView v-else />
  </VApp>
</template>

<style>
.v-application,
.v-application__wrap {
  background: transparent !important;
}
</style>
