<script setup lang="ts">
import { useI18n } from 'vue-i18n'

const { t } = useI18n()
</script>

<template>
  <div class="main">
    <section class="sk-panel panel">
      <p class="sk-label">siku_intro</p>
      <div class="sk-rule"></div>
      <h1 class="title">{{ t('intro.title') }}</h1>
      <p class="subtitle">{{ t('intro.subtitle') }}</p>
    </section>
  </div>
</template>

<style scoped>
.main {
  position: fixed;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
}

.panel {
  display: flex;
  flex-direction: column;
  gap: 18px;
  width: 440px;
  padding: var(--sk-panel-pad);
  text-align: center;
}

.title {
  font-size: 24px;
  font-weight: 600;
  letter-spacing: 0.18em;
  text-transform: uppercase;
  color: var(--sk-text);
}

.subtitle {
  font-size: 13px;
  color: var(--sk-text-muted);
}
</style>
