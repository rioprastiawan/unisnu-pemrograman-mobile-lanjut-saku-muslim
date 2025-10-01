<template>
  <div class="min-h-screen p-4 pb-20">
    <!-- Header -->
    <header class="flex items-center justify-between mb-6">
      <button
        @click="$router.back()"
        class="p-2 rounded-full bg-white/50 dark:bg-gray-800/50 theme-text-primary"
      >
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

      <h1 class="text-xl font-semibold theme-text-primary">Al-Qur'an</h1>

      <button
        class="p-2 rounded-full bg-white/50 dark:bg-gray-800/50 theme-text-primary"
      >
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
            d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
          ></path>
        </svg>
      </button>
    </header>

    <!-- Search Bar -->
    <div class="relative mb-6">
      <input
        v-model="searchQuery"
        type="text"
        placeholder="Search surah..."
        class="w-full p-4 pr-12 rounded-xl bg-white/70 dark:bg-gray-800/70 backdrop-blur-sm border border-green-100 dark:border-green-800 focus:outline-none focus:ring-2 focus:ring-green-200 dark:focus:ring-green-600 theme-text-primary placeholder-gray-400 dark:placeholder-gray-500"
      />
      <svg
        class="absolute right-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400 dark:text-gray-500"
        fill="none"
        stroke="currentColor"
        viewBox="0 0 24 24"
      >
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="2"
          d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
        ></path>
      </svg>
    </div>

    <!-- Surah List -->
    <div class="space-y-3">
      <div
        v-for="surah in filteredSurahs"
        :key="surah.number"
        @click="openSurah(surah)"
        class="bg-white/70 dark:bg-gray-800/70 backdrop-blur-sm rounded-xl p-4 border border-green-100 dark:border-green-800 cursor-pointer hover:bg-white/90 dark:hover:bg-gray-700/90 transition-all"
      >
        <div class="flex items-center justify-between">
          <div class="flex items-center">
            <!-- Surah Number -->
            <div
              class="w-10 h-10 bg-green-100 dark:bg-green-900/50 rounded-full flex items-center justify-center mr-4"
            >
              <span
                class="text-sm font-bold text-green-700 dark:text-green-400"
                >{{ surah.number }}</span
              >
            </div>

            <!-- Surah Info -->
            <div>
              <h3 class="font-semibold theme-text-primary">
                {{ surah.englishName }}
              </h3>
              <p class="text-sm theme-text-secondary">
                {{ surah.englishNameTranslation }}
              </p>
              <p class="text-xs theme-text-secondary">
                {{ surah.numberOfAyahs }} verses • {{ surah.revelationType }}
              </p>
            </div>
          </div>

          <!-- Arabic Name -->
          <div class="text-right">
            <div
              class="arabic-text text-xl font-bold text-green-700 dark:text-green-400 mb-1"
            >
              {{ surah.name }}
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="flex justify-center items-center py-8">
      <div
        class="animate-spin rounded-full h-8 w-8 border-b-2 border-green-600"
      ></div>
    </div>

    <!-- Error State -->
    <div v-if="error" class="text-center py-8">
      <p class="text-red-600">{{ error }}</p>
      <button
        @click="fetchSurahs"
        class="mt-2 px-4 py-2 bg-green-600 text-white rounded-lg"
      >
        Try Again
      </button>
    </div>
  </div>
</template>

<script setup>
const searchQuery = ref("");
const surahs = ref([]);
const loading = ref(true);
const error = ref(null);

// Mock data for now - will be replaced with API calls later
const mockSurahs = [
  {
    number: 1,
    name: "الفاتحة",
    englishName: "Al-Fatihah",
    englishNameTranslation: "The Opening",
    numberOfAyahs: 7,
    revelationType: "Meccan",
  },
  {
    number: 2,
    name: "البقرة",
    englishName: "Al-Baqarah",
    englishNameTranslation: "The Cow",
    numberOfAyahs: 286,
    revelationType: "Medinan",
  },
  {
    number: 3,
    name: "آل عمران",
    englishName: "Ali 'Imran",
    englishNameTranslation: "Family of Imran",
    numberOfAyahs: 200,
    revelationType: "Medinan",
  },
  {
    number: 4,
    name: "النساء",
    englishName: "An-Nisa",
    englishNameTranslation: "The Women",
    numberOfAyahs: 176,
    revelationType: "Medinan",
  },
  {
    number: 5,
    name: "المائدة",
    englishName: "Al-Ma'idah",
    englishNameTranslation: "The Table Spread",
    numberOfAyahs: 120,
    revelationType: "Medinan",
  },
];

const filteredSurahs = computed(() => {
  if (!searchQuery.value) return surahs.value;

  return surahs.value.filter(
    (surah) =>
      surah.englishName
        .toLowerCase()
        .includes(searchQuery.value.toLowerCase()) ||
      surah.englishNameTranslation
        .toLowerCase()
        .includes(searchQuery.value.toLowerCase())
  );
});

const fetchSurahs = async () => {
  try {
    loading.value = true;
    error.value = null;

    // For now, use mock data
    // In production, replace with API call to: http://api.alquran.cloud/v1/surah
    await new Promise((resolve) => setTimeout(resolve, 1000)); // Simulate API delay
    surahs.value = mockSurahs;
  } catch (err) {
    error.value = "Failed to load surahs";
  } finally {
    loading.value = false;
  }
};

const openSurah = (surah) => {
  // Navigate to surah detail page
  navigateTo(`/quran/${surah.number}`);
};

onMounted(() => {
  fetchSurahs();
});

// Set page title
useHead({
  title: "Al-Qur'an - Saku Muslim",
});
</script>
