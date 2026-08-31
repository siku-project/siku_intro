<script setup lang="ts">
import { computed, ref } from 'vue'
import type { Component } from 'vue'
import DevTopBar from '@/components/boilerplate/DevTopBar.vue'
import DevFab from '@/components/boilerplate/DevFab.vue'
import DevViewSelector from '@/components/boilerplate/DevViewSelector.vue'
import IntroDevPanel from '@/components/dev/IntroDevPanel.vue'
import IntroView from '@/views/IntroView.vue'
import backgroundUrl from '@/assets/boilerplate-background.jpg'

const viewComponents: Record<string, Component> = {
  Intro: IntroView,
}

const views: string[] = Object.keys(viewComponents)
const currentView = ref('Intro')

const activeComponent = computed<Component | null>(() =>
  currentView.value !== 'none' ? (viewComponents[currentView.value] ?? null) : null,
)

const handleSelectView = (view: string) => {
  currentView.value = view
}
</script>

<template>
  <div
    class="fixed inset-0 h-full w-full bg-gray-900 bg-contain bg-center bg-no-repeat transition-all duration-300 md:bg-cover"
    :style="{ backgroundImage: `url(${backgroundUrl})` }"
  >
    <component :is="activeComponent" v-if="activeComponent" />

    <IntroDevPanel v-if="currentView === 'Intro'" />

    <DevTopBar />
    <DevFab :current-view="currentView" />
    <DevViewSelector :views="views" :current-view="currentView" @select-view="handleSelectView" />
  </div>
</template>
