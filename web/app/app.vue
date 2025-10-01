<template>
  <div
    class="min-h-screen transition-colors duration-300"
    :class="themeBodyClasses"
  >
    <NuxtPage />

    <!-- Bottom Navigation -->
    <nav class="bottom-nav">
      <div class="flex justify-around items-center">
        <NuxtLink
          to="/"
          class="nav-item"
          :class="{ 'nav-item-active': $route.path === '/' }"
        >
          <div class="text-2xl mb-1">🕌</div>
          <span class="text-xs theme-text-primary">Kiblat</span>
        </NuxtLink>

        <NuxtLink
          to="/quran"
          class="nav-item"
          :class="{ 'nav-item-active': $route.path === '/quran' }"
        >
          <div class="text-2xl mb-1">📖</div>
          <span class="text-xs theme-text-primary">Al-Qur'an</span>
        </NuxtLink>

        <NuxtLink
          to="/settings"
          class="nav-item"
          :class="{ 'nav-item-active': $route.path === '/settings' }"
        >
          <div class="text-2xl mb-1">⚙️</div>
          <span class="text-xs theme-text-primary">Pengaturan</span>
        </NuxtLink>
      </div>
    </nav>

    <!-- Theme Toggle FAB -->
    <button
      @click="toggleTheme"
      class="fixed top-4 right-4 z-50 w-12 h-12 rounded-full shadow-lg transition-all duration-300 flex items-center justify-center"
      :class="themeToggleClasses"
    >
      <transition name="theme-icon" mode="out-in">
        <svg
          v-if="!isDark"
          key="sun"
          class="w-6 h-6"
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z"
          ></path>
        </svg>
        <svg
          v-else
          key="moon"
          class="w-6 h-6"
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z"
          ></path>
        </svg>
      </transition>
    </button>
  </div>
</template>

<script setup>
// Theme management - using simple ref instead of composable for now
const isDark = ref(false);

// Initialize theme
onMounted(() => {
  if (process.client) {
    const savedTheme = localStorage.getItem("saku-muslim-theme");
    if (savedTheme) {
      isDark.value = savedTheme === "dark";
    } else {
      isDark.value = window.matchMedia("(prefers-color-scheme: dark)").matches;
    }
    applyTheme();
  }
});

const toggleTheme = () => {
  isDark.value = !isDark.value;
  applyTheme();
  if (process.client) {
    localStorage.setItem("saku-muslim-theme", isDark.value ? "dark" : "light");
  }
};

const applyTheme = () => {
  if (process.client) {
    const html = document.documentElement;
    if (isDark.value) {
      html.classList.add("dark");
      html.classList.remove("light");
    } else {
      html.classList.add("light");
      html.classList.remove("dark");
    }
  }
};

const themeBodyClasses = computed(() =>
  isDark.value
    ? "bg-gradient-to-br from-gray-900 to-gray-800"
    : "bg-gradient-to-br from-green-50 to-emerald-50"
);

const themeToggleClasses = computed(() =>
  isDark.value
    ? "bg-gray-700 hover:bg-gray-600 text-yellow-400 border border-gray-600"
    : "bg-white hover:bg-gray-50 text-gray-700 border border-gray-200"
);

// Watch for theme changes and apply
watch(isDark, () => {
  applyTheme();
});
</script>

<style>
body {
  margin: 0;
  padding: 0;
  font-family: "Inter", sans-serif;
}

.theme-icon-enter-active,
.theme-icon-leave-active {
  transition: all 0.3s ease;
}

.theme-icon-enter-from {
  opacity: 0;
  transform: rotate(180deg);
}

.theme-icon-leave-to {
  opacity: 0;
  transform: rotate(-180deg);
}
</style>
