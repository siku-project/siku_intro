<script setup lang="ts">
import { storeToRefs } from 'pinia'
import { useIntroStore } from '@/stores/intro'

const { active, location, subtitle, message } = storeToRefs(useIntroStore())
</script>

<template>
  <div class="intro pointer-events-none fixed inset-0 select-none">
    <Transition name="bars">
      <div v-if="active" class="intro__bars" aria-hidden="true">
        <span class="intro__bar intro__bar--top"></span>
        <span class="intro__bar intro__bar--bottom"></span>
      </div>
    </Transition>

    <Transition name="loc">
      <div v-if="location" class="loc">
        <span class="loc__rail" aria-hidden="true"></span>
        <div>
          <p class="loc__title">{{ location.title }}</p>
          <p v-if="location.subtitle" class="loc__subtitle">{{ location.subtitle }}</p>
        </div>
      </div>
    </Transition>

    <Transition name="sub">
      <div v-if="subtitle" class="sub">
        <p v-if="subtitle.speaker" class="sub__speaker">{{ subtitle.speaker }}</p>
        <p class="sub__text">{{ subtitle.text }}</p>
      </div>
    </Transition>

    <Transition name="msg">
      <p v-if="message" class="msg">{{ message }}</p>
    </Transition>
  </div>
</template>

<style scoped>
.intro__bar {
  position: absolute;
  inset-inline: 0;
  height: 7vh;
  background: #05060a;
}

.intro__bar--top {
  top: 0;
}

.intro__bar--bottom {
  bottom: 0;
}

.bars-enter-active,
.bars-leave-active {
  transition: opacity 0.6s ease;
}

.bars-enter-from,
.bars-leave-to {
  opacity: 0;
}

.loc {
  position: absolute;
  left: 4.2vw;
  bottom: 12vh;
  display: flex;
  align-items: stretch;
  gap: 14px;
}

.loc__rail {
  width: 3px;
  border-radius: 9999px;
  background: linear-gradient(180deg, #69ceff, #a18cff);
  box-shadow: 0 0 14px rgba(105, 206, 255, 0.5);
}

.loc__title {
  font-size: 34px;
  font-weight: 700;
  letter-spacing: 0.08em;
  line-height: 1.05;
  text-transform: uppercase;
  color: #f5f7fc;
  text-shadow: 0 2px 12px rgba(5, 6, 10, 0.9);
}

.loc__subtitle {
  margin-top: 5px;
  font-size: 14px;
  font-weight: 500;
  letter-spacing: 0.04em;
  color: #a4acbc;
  text-shadow: 0 1px 8px rgba(5, 6, 10, 0.9);
}

.loc-enter-active {
  transition:
    opacity 0.5s ease,
    transform 0.5s cubic-bezier(0.22, 0.6, 0.2, 1);
}

.loc-leave-active {
  transition:
    opacity 0.35s ease,
    transform 0.35s ease;
}

.loc-enter-from {
  opacity: 0;
  transform: translateX(-18px);
}

.loc-leave-to {
  opacity: 0;
  transform: translateX(10px);
}

.sub {
  position: absolute;
  inset-inline: 0;
  bottom: 9.5vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 3px;
  padding-inline: 18vw;
  text-align: center;
}

.sub__speaker {
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.26em;
  text-transform: uppercase;
  color: #69ceff;
  text-shadow: 0 1px 8px rgba(5, 6, 10, 0.95);
}

.sub__text {
  max-width: 860px;
  font-size: 19px;
  font-weight: 500;
  line-height: 1.45;
  color: rgba(245, 247, 252, 0.97);
  text-shadow: 0 2px 10px rgba(5, 6, 10, 0.95);
}

.sub-enter-active,
.sub-leave-active {
  transition:
    opacity 0.3s ease,
    transform 0.3s ease;
}

.sub-enter-from,
.sub-leave-to {
  opacity: 0;
  transform: translateY(8px);
}

.msg {
  position: absolute;
  inset-inline: 0;
  top: 44%;
  text-align: center;
  font-size: 30px;
  font-weight: 300;
  letter-spacing: 0.3em;
  text-transform: uppercase;
  color: #f5f7fc;
  text-shadow:
    0 0 26px rgba(105, 206, 255, 0.35),
    0 0 40px rgba(161, 140, 255, 0.25),
    0 2px 12px rgba(5, 6, 10, 0.9);
}

.msg-enter-active {
  transition:
    opacity 1s ease,
    letter-spacing 1s ease;
}

.msg-leave-active {
  transition: opacity 0.6s ease;
}

.msg-enter-from {
  opacity: 0;
  letter-spacing: 0.42em;
}

.msg-leave-to {
  opacity: 0;
}
</style>
