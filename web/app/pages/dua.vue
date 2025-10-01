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

      <h1 class="text-xl font-semibold theme-text-primary">Doa Harian</h1>

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
        placeholder="Search dua..."
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

    <!-- Categories -->
    <div class="flex space-x-3 mb-6 overflow-x-auto pb-2">
      <button
        v-for="category in categories"
        :key="category.id"
        @click="selectedCategory = category.id"
        class="px-4 py-2 rounded-full whitespace-nowrap transition-colors"
        :class="
          selectedCategory === category.id
            ? 'bg-green-600 text-white'
            : 'bg-white/70 dark:bg-gray-800/70 theme-text-primary hover:bg-white/90 dark:hover:bg-gray-700/90'
        "
      >
        {{ category.name }}
      </button>
    </div>

    <!-- Dua List -->
    <div class="space-y-4">
      <div
        v-for="dua in filteredDuas"
        :key="dua.id"
        class="bg-white/70 dark:bg-gray-800/70 backdrop-blur-sm rounded-xl p-6 border border-green-100 dark:border-green-800"
      >
        <!-- Dua Header -->
        <div class="flex items-center justify-between mb-4">
          <h3 class="font-semibold theme-text-primary">{{ dua.title }}</h3>
          <div class="flex items-center space-x-2">
            <button
              @click="playAudio(dua)"
              class="p-2 rounded-full bg-green-100 dark:bg-green-900/50 hover:bg-green-200 dark:hover:bg-green-800/50 transition-colors"
            >
              <svg
                class="w-4 h-4 text-green-600 dark:text-green-400"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M14.828 14.828a4 4 0 01-5.656 0M9 10h1.586a1 1 0 01.707.293l2.414 2.414a1 1 0 00.707.293H15a2 2 0 002-2V9a2 2 0 00-2-2h-1.586a1 1 0 01-.707-.293L9.293 4.293A1 1 0 008.586 4H7a2 2 0 00-2 2v8a2 2 0 002 2z"
                ></path>
              </svg>
            </button>
            <button
              @click="shareDua(dua)"
              class="p-2 rounded-full bg-blue-100 dark:bg-blue-900/50 hover:bg-blue-200 dark:hover:bg-blue-800/50 transition-colors"
            >
              <svg
                class="w-4 h-4 text-blue-600 dark:text-blue-400"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.367 2.684 3 3 0 00-5.367-2.684z"
                ></path>
              </svg>
            </button>
          </div>
        </div>

        <!-- Arabic Text -->
        <div
          class="arabic-text text-2xl leading-relaxed text-green-800 dark:text-green-300 mb-4 p-4 bg-green-50 dark:bg-green-900/30 rounded-lg"
        >
          {{ dua.arabic }}
        </div>

        <!-- Transliteration -->
        <div
          class="theme-text-primary italic mb-3 p-3 bg-gray-50 dark:bg-gray-800/50 rounded-lg"
        >
          <strong>Transliteration:</strong><br />
          {{ dua.transliteration }}
        </div>

        <!-- Translation -->
        <div
          class="theme-text-primary p-3 bg-blue-50 dark:bg-blue-900/30 rounded-lg"
        >
          <strong>Translation:</strong><br />
          {{ dua.translation }}
        </div>

        <!-- When to recite -->
        <div
          v-if="dua.when"
          class="mt-3 text-sm text-gray-600 p-2 bg-yellow-50 rounded-lg"
        >
          <strong>When to recite:</strong> {{ dua.when }}
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const searchQuery = ref("");
const selectedCategory = ref("all");

const categories = [
  { id: "all", name: "All" },
  { id: "morning", name: "Morning" },
  { id: "evening", name: "Evening" },
  { id: "eating", name: "Eating" },
  { id: "travel", name: "Travel" },
  { id: "daily", name: "Daily Life" },
];

const duas = ref([
  {
    id: 1,
    title: "Morning Dhikr",
    category: "morning",
    arabic:
      "أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ",
    transliteration:
      "Asbahnaa wa asbahal-mulku lillahi, walhamdu lillahi, laa ilaaha illallahu wahdahu laa shareeka lah",
    translation:
      "We have reached the morning and at this very time unto Allah belongs all sovereignty. All praise is for Allah. None has the right to be worshipped except Allah, alone, without partner.",
    when: "After Fajr prayer",
  },
  {
    id: 2,
    title: "Before Eating",
    category: "eating",
    arabic: "بِسْمِ اللَّهِ",
    transliteration: "Bismillah",
    translation: "In the name of Allah",
    when: "Before starting any meal",
  },
  {
    id: 3,
    title: "After Eating",
    category: "eating",
    arabic:
      "الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَذَا وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلاَ قُوَّةٍ",
    transliteration:
      "Alhamdulillahil-lathee at'amanee hatha wa razaqaneehe min ghayri hawlin minnee wa laa quwwah",
    translation:
      "All praise is due to Allah who gave me this food and provided it for me without any might nor power from myself.",
    when: "After finishing a meal",
  },
  {
    id: 4,
    title: "Leaving the House",
    category: "daily",
    arabic:
      "بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَّهِ، وَلاَ حَوْلَ وَلاَ قُوَّةَ إِلاَّ بِاللَّهِ",
    transliteration:
      "Bismillahi tawakkaltu 'alallahi, wa laa hawla wa laa quwwata illa billah",
    translation:
      "In the name of Allah, I trust in Allah, and there is no might nor power except with Allah.",
    when: "When leaving home",
  },
  {
    id: 5,
    title: "Evening Dhikr",
    category: "evening",
    arabic:
      "أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ",
    transliteration:
      "Amsaynaa wa amsal-mulku lillahi, walhamdu lillahi, laa ilaaha illallahu wahdahu laa shareeka lah",
    translation:
      "We have reached the evening and at this very time unto Allah belongs all sovereignty. All praise is for Allah. None has the right to be worshipped except Allah, alone, without partner.",
    when: "After Maghrib prayer",
  },
]);

const filteredDuas = computed(() => {
  let filtered = duas.value;

  // Filter by category
  if (selectedCategory.value !== "all") {
    filtered = filtered.filter(
      (dua) => dua.category === selectedCategory.value
    );
  }

  // Filter by search query
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase();
    filtered = filtered.filter(
      (dua) =>
        dua.title.toLowerCase().includes(query) ||
        dua.transliteration.toLowerCase().includes(query) ||
        dua.translation.toLowerCase().includes(query)
    );
  }

  return filtered;
});

const playAudio = (dua) => {
  // In a real app, this would play audio recitation
  alert(`Playing audio for: ${dua.title}`);
};

const shareDua = (dua) => {
  // In a real app, this would share the dua
  if (navigator.share) {
    navigator.share({
      title: dua.title,
      text: `${dua.arabic}\n\n${dua.transliteration}\n\n${dua.translation}`,
    });
  } else {
    // Fallback for browsers that don't support Web Share API
    alert("Share feature will be implemented");
  }
};

// Set page title
useHead({
  title: "Daily Duas - Saku Muslim",
});
</script>
