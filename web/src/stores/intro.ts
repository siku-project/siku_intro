import { ref } from 'vue'
import { defineStore } from 'pinia'

export interface IntroLocation {
  title: string
  subtitle?: string
}

export interface IntroSubtitle {
  speaker?: string
  text: string
}

export const useIntroStore = defineStore('intro', () => {
  const active = ref(false)
  const location = ref<IntroLocation | null>(null)
  const subtitle = ref<IntroSubtitle | null>(null)
  const message = ref<string | null>(null)

  const timers: Partial<Record<'location' | 'subtitle' | 'message', number>> = {}

  const schedule = (
    slot: 'location' | 'subtitle' | 'message',
    duration: unknown,
    hide: () => void,
  ): void => {
    window.clearTimeout(timers[slot])

    if (typeof duration === 'number' && duration > 0) {
      timers[slot] = window.setTimeout(hide, duration)
    }
  }

  const setActive = (next: boolean): void => {
    active.value = next

    if (!next) {
      hideLocation()
      hideSubtitle()
      hideMessage()
      stopMusic(600)
    }
  }

  const showLocation = (payload: IntroLocation & { duration?: number }): void => {
    location.value = { title: payload.title, subtitle: payload.subtitle }
    schedule('location', payload.duration, hideLocation)
  }

  function hideLocation(): void {
    location.value = null
  }

  const showSubtitle = (payload: IntroSubtitle & { duration?: number }): void => {
    subtitle.value = { speaker: payload.speaker, text: payload.text }
    schedule('subtitle', payload.duration, hideSubtitle)
  }

  function hideSubtitle(): void {
    subtitle.value = null
  }

  const showMessage = (payload: { text: string; duration?: number }): void => {
    message.value = payload.text
    schedule('message', payload.duration, hideMessage)
  }

  function hideMessage(): void {
    message.value = null
  }

  /** Plays an optional voice file; a missing or failing file is silence. */
  const playVoice = (file: unknown): void => {
    if (typeof file !== 'string' || file === '') {
      return
    }

    try {
      const audio = new Audio(file)
      void audio.play().catch(() => {})
    } catch {
      /* no voice shipped yet — the subtitle already carries the line */
    }
  }

  let musicTrack: HTMLAudioElement | null = null
  let musicRamp: number | undefined

  const rampMusicVolume = (target: number, duration: number, onDone?: () => void): void => {
    window.clearInterval(musicRamp)

    const track = musicTrack

    if (!track) {
      return
    }

    if (duration <= 0) {
      track.volume = target
      onDone?.()
      return
    }

    const start = track.volume
    const startedAt = performance.now()

    musicRamp = window.setInterval(() => {
      const progress = Math.min(1, (performance.now() - startedAt) / duration)
      track.volume = start + (target - start) * progress

      if (progress >= 1) {
        window.clearInterval(musicRamp)
        onDone?.()
      }
    }, 50)
  }

  /** Stops the montage track, through an optional fade-out. */
  const stopMusic = (fade = 0): void => {
    const track = musicTrack

    if (!track) {
      return
    }

    musicTrack = null
    rampMusicVolume(0, fade, () => {
      track.pause()
    })

    if (fade <= 0) {
      track.pause()
    }
  }

  /**
   * Starts the montage track, through an optional fade-in. A missing file
   * is silence: the montage plays on and the absence is only logged in
   * development.
   */
  const playMusic = (payload: { file?: unknown; volume?: unknown; fade?: unknown }): void => {
    if (typeof payload.file !== 'string' || payload.file === '') {
      return
    }

    stopMusic(0)

    const volume = typeof payload.volume === 'number' ? payload.volume : 0.5
    const fade = typeof payload.fade === 'number' ? payload.fade : 0

    try {
      const track = new Audio(payload.file)
      track.loop = true
      track.volume = fade > 0 ? 0 : volume
      musicTrack = track

      void track.play().catch((reason: unknown) => {
        if (import.meta.env.DEV) {
          console.debug('[intro] music track unavailable:', payload.file, reason)
        }
      })

      if (fade > 0) {
        rampMusicVolume(volume, fade)
      }
    } catch {
      musicTrack = null
    }
  }

  const music = (payload: {
    action?: unknown
    file?: unknown
    volume?: unknown
    fade?: unknown
  }): void => {
    if (payload.action === 'play') {
      playMusic(payload)
    } else if (payload.action === 'stop') {
      stopMusic(typeof payload.fade === 'number' ? payload.fade : 0)
    }
  }

  return {
    active,
    location,
    subtitle,
    message,
    setActive,
    showLocation,
    hideLocation,
    showSubtitle,
    hideSubtitle,
    showMessage,
    hideMessage,
    playVoice,
    music,
  }
})
