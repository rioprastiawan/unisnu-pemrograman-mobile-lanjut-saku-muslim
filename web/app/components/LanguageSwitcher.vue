<template>
  <div class="relative">
    <button
      @click="showDropdown = !showDropdown"
      class="flex items-center space-x-2 px-3 py-2 rounded-lg theme-button"
    >
      <span class="text-sm">{{ currentLanguageFlag }}</span>
      <span class="text-sm font-medium theme-text-primary">{{
        currentLanguageCode.toUpperCase()
      }}</span>
      <svg
        class="w-4 h-4 theme-text-secondary"
        fill="none"
        stroke="currentColor"
        viewBox="0 0 24 24"
      >
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="2"
          d="M19 9l-7 7-7-7"
        ></path>
      </svg>
    </button>

    <div
      v-if="showDropdown"
      class="absolute top-full right-0 mt-2 w-32 theme-card rounded-lg shadow-lg border border-gray-200 dark:border-gray-600 z-50"
    >
      <button
        v-for="language in availableLanguages"
        :key="language.code"
        @click="selectLanguage(language.code)"
        class="w-full px-3 py-2 text-left hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors first:rounded-t-lg last:rounded-b-lg"
        :class="{
          'bg-green-50 dark:bg-green-900/30':
            language.code === currentLanguageCode,
        }"
      >
        <div class="flex items-center space-x-2">
          <span>{{ language.flag }}</span>
          <span class="text-sm theme-text-primary">{{ language.name }}</span>
        </div>
      </button>
    </div>
  </div>
</template>

<script setup>
const { locale, locales } = useI18n();
const showDropdown = ref(false);

const currentLanguageCode = computed(() => locale.value);

const currentLanguageFlag = computed(() => {
  const flags = {
    id: "🇮🇩",
    en: "🇺🇸",
  };
  return flags[locale.value] || "🌐";
});

const availableLanguages = computed(() => [
  { code: "id", name: "Indonesia", flag: "🇮🇩" },
  { code: "en", name: "English", flag: "🇺🇸" },
]);

const selectLanguage = async (lang) => {
  showDropdown.value = false;
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

// Close dropdown when clicking outside
onMounted(() => {
  const handleClickOutside = (event) => {
    if (!event.target.closest(".relative")) {
      showDropdown.value = false;
    }
  };
  document.addEventListener("click", handleClickOutside);
  onUnmounted(() => {
    document.removeEventListener("click", handleClickOutside);
  });
});
</script>
