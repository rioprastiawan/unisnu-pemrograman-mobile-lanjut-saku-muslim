<template>
  <div class="min-h-screen p-4 pb-20">
    <!-- Header -->
    <header class="flex items-center justify-between mb-6">
      <button @click="$router.back()" class="theme-button">
        <svg
          class="w-6 h-6"
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M15 19l-7-7 7-7"
          ></path>
        </svg>
      </button>

      <h1 class="text-xl font-semibold theme-text-primary">
        {{ $t("settings.title") }}
      </h1>

      <div class="w-10"></div>
      <!-- Spacer -->
    </header>

    <!-- Menu Grid -->
    <div class="grid grid-cols-2 gap-4 mb-6">
      <!-- Al-Qur'an -->
      <button
        @click="$router.push('/quran')"
        class="theme-card p-6 hover:opacity-80 transition-all text-center"
      >
        <div class="text-4xl mb-3">📖</div>
        <h3 class="font-semibold theme-text-primary mb-1">
          {{ $t("navigation.quran") }}
        </h3>
        <p class="text-sm theme-text-secondary">{{ $t("quran.title") }}</p>
      </button>

      <!-- Doa Harian -->
      <button
        @click="$router.push('/dua')"
        class="theme-card p-6 hover:opacity-80 transition-all text-center"
      >
        <div class="text-4xl mb-3">🤲</div>
        <h3 class="font-semibold theme-text-primary mb-1">
          {{ $t("navigation.dua") }}
        </h3>
        <p class="text-sm theme-text-secondary">{{ $t("dua.title") }}</p>
      </button>

      <!-- Kalkulator Zakat -->
      <button
        @click="$router.push('/zakat')"
        class="bg-white/70 backdrop-blur-sm rounded-xl p-6 border border-green-100 hover:bg-white/90 transition-all text-center"
      >
        <div class="text-4xl mb-3">💰</div>
        <h3 class="font-semibold text-gray-900 mb-1">Kalkulator Zakat</h3>
        <p class="text-sm text-gray-600">Calculate your zakat</p>
      </button>

      <!-- Kalkulator Warisan -->
      <button
        @click="$router.push('/inheritance')"
        class="bg-white/70 backdrop-blur-sm rounded-xl p-6 border border-green-100 hover:bg-white/90 transition-all text-center"
      >
        <div class="text-4xl mb-3">📜</div>
        <h3 class="font-semibold text-gray-900 mb-1">Kalkulator Warisan</h3>
        <p class="text-sm text-gray-600">Islamic inheritance calculator</p>
      </button>

      <!-- Arah Kiblat -->
      <button
        @click="$router.push('/qibla')"
        class="bg-white/70 backdrop-blur-sm rounded-xl p-6 border border-green-100 hover:bg-white/90 transition-all text-center"
      >
        <div class="text-4xl mb-3">🧭</div>
        <h3 class="font-semibold text-gray-900 mb-1">Arah Kiblat</h3>
        <p class="text-sm text-gray-600">Find Qibla direction</p>
      </button>

      <!-- Kalender Hijriah -->
      <button
        @click="$router.push('/calendar')"
        class="bg-white/70 backdrop-blur-sm rounded-xl p-6 border border-green-100 hover:bg-white/90 transition-all text-center"
      >
        <div class="text-4xl mb-3">📅</div>
        <h3 class="font-semibold text-gray-900 mb-1">Kalender Hijriah</h3>
        <p class="text-sm text-gray-600">Islamic calendar</p>
      </button>
    </div>

    <!-- Additional Settings -->
    <div class="space-y-3">
      <h2 class="text-lg font-semibold text-gray-900 mb-4">Settings</h2>

      <!-- Location Settings -->
      <div class="theme-card p-4">
        <div class="flex items-center justify-between">
          <div class="flex items-center">
            <div class="text-2xl mr-3">📍</div>
            <div>
              <h3 class="font-medium theme-text-primary">Location</h3>
              <p class="text-sm theme-text-secondary">{{ currentLocation }}</p>
            </div>
          </div>
          <button
            @click="updateLocation"
            class="text-green-600 hover:text-green-700"
          >
            <svg
              class="w-5 h-5"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"
              ></path>
            </svg>
          </button>
        </div>
      </div>

      <!-- Notification Settings -->
      <div class="theme-card p-4">
        <div class="flex items-center justify-between">
          <div class="flex items-center">
            <div class="text-2xl mr-3">🔔</div>
            <div>
              <h3 class="font-medium theme-text-primary">
                Prayer Notifications
              </h3>
              <p class="text-sm theme-text-secondary">
                Get notified for prayer times
              </p>
            </div>
          </div>
          <label class="relative inline-flex items-center cursor-pointer">
            <input
              v-model="notificationsEnabled"
              type="checkbox"
              class="sr-only peer"
            />
            <div
              class="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-green-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-green-600"
            ></div>
          </label>
        </div>
      </div>

      <!-- Language Settings -->
      <div class="theme-card p-4">
        <div class="flex items-center justify-between">
          <div class="flex items-center">
            <div class="text-2xl mr-3">🌐</div>
            <div>
              <h3 class="font-medium theme-text-primary">
                {{ $t("settings.language") }}
              </h3>
              <p class="text-sm theme-text-secondary">
                {{ currentLanguageName }}
              </p>
            </div>
          </div>
          <div class="flex items-center space-x-2">
            <button
              @click="setLanguage('id')"
              class="px-3 py-1 rounded-lg text-sm font-medium transition-colors"
              :class="
                $i18n.locale === 'id'
                  ? 'bg-green-600 text-white'
                  : 'bg-gray-200 text-gray-700 dark:bg-gray-700 dark:text-gray-300'
              "
            >
              🇮🇩 ID
            </button>
            <button
              @click="setLanguage('en')"
              class="px-3 py-1 rounded-lg text-sm font-medium transition-colors"
              :class="
                $i18n.locale === 'en'
                  ? 'bg-green-600 text-white'
                  : 'bg-gray-200 text-gray-700 dark:bg-gray-700 dark:text-gray-300'
              "
            >
              🇺🇸 EN
            </button>
          </div>
        </div>
      </div>

      <!-- Theme Settings -->
      <div class="theme-card p-4">
        <div class="flex items-center justify-between">
          <div class="flex items-center">
            <div class="text-2xl mr-3">🎨</div>
            <div>
              <h3 class="font-medium theme-text-primary">Theme</h3>
              <p class="text-sm theme-text-secondary">
                Choose your preferred theme
              </p>
            </div>
          </div>
          <div class="flex items-center space-x-2">
            <button
              @click="setTheme('light')"
              class="px-3 py-1 rounded-lg text-sm font-medium transition-colors"
              :class="
                !isDark
                  ? 'bg-green-600 text-white'
                  : 'bg-gray-200 text-gray-700 dark:bg-gray-700 dark:text-gray-300'
              "
            >
              ☀️ Light
            </button>
            <button
              @click="setTheme('dark')"
              class="px-3 py-1 rounded-lg text-sm font-medium transition-colors"
              :class="
                isDark
                  ? 'bg-green-600 text-white'
                  : 'bg-gray-200 text-gray-700 dark:bg-gray-700 dark:text-gray-300'
              "
            >
              🌙 Dark
            </button>
          </div>
        </div>
      </div>

      <!-- About -->
      <div class="theme-card p-4">
        <div class="flex items-center">
          <div class="text-2xl mr-3">ℹ️</div>
          <div>
            <h3 class="font-medium theme-text-primary">About Saku Muslim</h3>
            <p class="text-sm theme-text-secondary">Version 1.0.0</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const { locale, locales } = useI18n();
const currentLocation = ref("Jakarta, Indonesia");
const notificationsEnabled = ref(true);
const isDark = ref(false);

// Get current language name
const currentLanguageName = computed(() => {
  const currentLocale = locales.value.find((l) => l.code === locale.value);
  return currentLocale ? currentLocale.name : "Unknown";
});

// Initialize theme
onMounted(() => {
  if (process.client) {
    const savedTheme = localStorage.getItem("saku-muslim-theme");
    isDark.value =
      savedTheme === "dark" ||
      (!savedTheme &&
        window.matchMedia("(prefers-color-scheme: dark)").matches);
  }
});

const setTheme = (theme) => {
  isDark.value = theme === "dark";
  if (process.client) {
    localStorage.setItem("saku-muslim-theme", theme);
    const html = document.documentElement;
    if (theme === "dark") {
      html.classList.add("dark");
      html.classList.remove("light");
    } else {
      html.classList.add("light");
      html.classList.remove("dark");
    }
  }
};

const setLanguage = async (lang) => {
  await navigateTo(
    locale.value === "id" && lang !== "id"
      ? `/${lang}${$route.path}`
      : $route.path,
    {
      replace: true,
    }
  );
  locale.value = lang;
};

const updateLocation = () => {
  // In a real app, this would open a location picker or use GPS
  alert("Location update feature will be implemented");
};

// Set page title
useHead({
  title: "Settings - Saku Muslim",
});
</script>
