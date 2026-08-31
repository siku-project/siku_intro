<script setup lang="ts">
import { useIntroStore } from '@/stores/intro'

const intro = useIntroStore()

const demoLocation = (): void => {
  intro.showLocation({ title: 'LEGION SQUARE', subtitle: 'Le cœur de la ville', duration: 4000 })
}

const demoSubtitle = (): void => {
  intro.showSubtitle({
    speaker: 'MARCUS',
    text: 'Première fois en ville ? Suis-moi, je te fais le tour.',
    duration: 4000,
  })
}

const demoMessage = (): void => {
  intro.showMessage({ text: 'Votre histoire commence ici.', duration: 4000 })
}

const demoSequence = (): void => {
  intro.setActive(true)
  window.setTimeout(demoLocation, 600)
  window.setTimeout(demoSubtitle, 5000)
  window.setTimeout(demoMessage, 9500)
  window.setTimeout(() => intro.setActive(false), 14500)
}
</script>

<template>
  <aside class="panel">
    <p class="panel__title">INTRO DEBUG</p>

    <section class="panel__section">
      <label class="row">
        <span>Letterbox</span>
        <input
          type="checkbox"
          :checked="intro.active"
          @change="intro.setActive(($event.target as HTMLInputElement).checked)"
        />
      </label>
      <button type="button" class="panel__button" @click="demoLocation">Location</button>
      <button type="button" class="panel__button" @click="demoSubtitle">Sous-titre</button>
      <button type="button" class="panel__button" @click="demoMessage">Message</button>
      <button type="button" class="panel__button panel__button--alt" @click="demoSequence">
        Séquence complète
      </button>
    </section>
  </aside>
</template>

<style scoped>
.panel {
  position: fixed;
  right: 12px;
  top: 64px;
  z-index: 50;
  width: 200px;
  border: 1px solid rgba(42, 52, 71, 0.95);
  border-radius: 12px;
  background: rgba(13, 16, 25, 0.96);
  padding: 14px;
}

.panel__title {
  margin-bottom: 10px;
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.24em;
  color: #69ceff;
}

.panel__section {
  display: flex;
  flex-direction: column;
  gap: 7px;
}

.row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 11px;
  color: #a4acbc;
}

.row input {
  accent-color: #69ceff;
}

.panel__button {
  border: 1px solid rgba(105, 206, 255, 0.45);
  border-radius: 7px;
  background: rgba(105, 206, 255, 0.1);
  padding: 6px 0;
  font-size: 11px;
  font-weight: 600;
  color: #69ceff;
}

.panel__button:hover {
  background: rgba(105, 206, 255, 0.18);
}

.panel__button--alt {
  border-color: rgba(161, 140, 255, 0.45);
  background: rgba(161, 140, 255, 0.1);
  color: #a18cff;
}

.panel__button--alt:hover {
  background: rgba(161, 140, 255, 0.18);
}
</style>
