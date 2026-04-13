import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["icon"]

  connect() {
    // Check for saved user preference or default to light mode
    const savedTheme = localStorage.getItem('theme')
    if (savedTheme) {
      this.applyTheme(savedTheme)
    } else {
      this.applyTheme('light')
    }
    
    // Update icon based on current theme
    this.updateIcon()
  }

  toggle() {
    const isDark = document.documentElement.classList.contains('dark')
    const newTheme = isDark ? 'light' : 'dark'
    this.applyTheme(newTheme)
    localStorage.setItem('theme', newTheme)
    this.updateIcon()
  }

  applyTheme(theme) {
    if (theme === 'dark') {
      document.documentElement.classList.add('dark')
    } else {
      document.documentElement.classList.remove('dark')
    }
  }

  updateIcon() {
    if (!this.hasIconTarget) return

    const isDark = document.documentElement.classList.contains('dark')
    if (isDark) {
      this.iconTarget.innerHTML =
        '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z" />'
    } else {
      this.iconTarget.innerHTML =
        '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12.79A9 9 0 1111.21 3 7 7 0 0021 12.79z" />'
    }
  }
}
