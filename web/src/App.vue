<script setup lang="ts">
import { defineAsyncComponent, onBeforeUnmount, onMounted } from 'vue'
import IntroView from './views/IntroView.vue'
import { useIntroStore } from './stores/intro'
import { applyLocale, type LocalePayload } from './utils/locale'
import { sendNuiCallback } from './utils/nui'

const BoilerplateView = import.meta.env.DEV
  ? defineAsyncComponent(() => import('./views/BoilerplateView.vue'))
  : null

const intro = useIntroStore()

interface NuiMessage {
  action?: string
  locale?: LocalePayload
  payload?: Record<string, unknown>
}

const handleMessage = (event: MessageEvent<NuiMessage>) => {
  const { action, locale, payload } = event.data ?? {}

  if (!action?.startsWith('siku_intro:nui:')) {
    return
  }

  if (action === 'siku_intro:nui:setLocale' && locale) {
    applyLocale(locale)
    return
  }

  const data = payload ?? {}

  switch (action) {
    case 'siku_intro:nui:setActive':
      intro.setActive(data.active === true)
      break
    case 'siku_intro:nui:showLocation':
      intro.showLocation(data as { title: string; subtitle?: string; duration?: number })
      break
    case 'siku_intro:nui:hideLocation':
      intro.hideLocation()
      break
    case 'siku_intro:nui:showSubtitle':
      intro.showSubtitle(data as { speaker?: string; text: string; duration?: number })
      intro.playVoice(data.voice)
      break
    case 'siku_intro:nui:hideSubtitle':
      intro.hideSubtitle()
      break
    case 'siku_intro:nui:showMessage':
      intro.showMessage(data as { text: string; duration?: number })
      break
    case 'siku_intro:nui:hideMessage':
      intro.hideMessage()
      break
    case 'siku_intro:nui:music':
      intro.music(data)
      break
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
    <IntroView v-else />
  </VApp>
</template>

<style>
.v-application,
.v-application__wrap {
  background: transparent !important;
}
</style>
