<template>
  <div class="min-h-screen p-4 pb-20">
    <!-- Header -->
    <header class="flex items-center justify-between mb-6">
      <button @click="$router.back()" class="p-2 rounded-full bg-white/50">
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

      <div class="text-center">
        <h1 class="text-lg font-semibold text-gray-900">
          {{ surahInfo.englishName }}
        </h1>
        <p class="text-sm text-gray-600">
          {{ surahInfo.englishNameTranslation }}
        </p>
      </div>

      <button @click="toggleOptions" class="p-2 rounded-full bg-white/50">
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
            d="M12 5v.01M12 12v.01M12 19v.01M12 6a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2z"
          ></path>
        </svg>
      </button>
    </header>

    <!-- Options Panel -->
    <div
      v-if="showOptions"
      class="bg-white/80 backdrop-blur-sm rounded-xl p-4 mb-6 border border-green-100"
    >
      <div class="grid grid-cols-2 gap-4">
        <label class="flex items-center space-x-2">
          <input
            v-model="showTranslation"
            type="checkbox"
            class="text-green-600"
          />
          <span class="text-sm">Terjemahan</span>
        </label>
        <label class="flex items-center space-x-2">
          <input
            v-model="showTransliteration"
            type="checkbox"
            class="text-green-600"
          />
          <span class="text-sm">Transliterasi</span>
        </label>
      </div>

      <div class="mt-4">
        <label class="block text-sm font-medium text-gray-700 mb-2"
          >Ukuran Font Arab:</label
        >
        <input
          v-model="arabicFontSize"
          type="range"
          min="16"
          max="32"
          class="w-full"
        />
        <div class="flex justify-between text-xs text-gray-500">
          <span>Kecil</span>
          <span>Sedang</span>
          <span>Besar</span>
        </div>
      </div>
    </div>

    <!-- Surah Info -->
    <div class="bg-white/70 backdrop-blur-sm rounded-xl p-6 mb-6 text-center">
      <div class="arabic-text text-3xl font-bold text-green-700 mb-2">
        {{ surahInfo.name }}
      </div>
      <div class="text-lg font-semibold text-gray-900 mb-1">
        {{ surahInfo.englishName }}
      </div>
      <div class="text-sm text-gray-600 mb-4">
        {{ surahInfo.englishNameTranslation }}
      </div>
      <div class="flex justify-center space-x-6 text-sm text-gray-500">
        <div>
          <span class="font-medium">{{ surahInfo.numberOfAyahs }}</span> Ayat
        </div>
        <div>{{ surahInfo.revelationType }}</div>
        <div>Surah {{ surahInfo.number }}</div>
      </div>
    </div>

    <!-- Bismillah (except for Al-Fatihah and At-Tawbah) -->
    <div
      v-if="surahInfo.number !== 1 && surahInfo.number !== 9"
      class="bg-green-50 rounded-xl p-4 mb-6 text-center"
    >
      <div class="arabic-text text-2xl text-green-800">
        بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ
      </div>
      <div v-if="showTransliteration" class="text-sm text-gray-600 mt-2 italic">
        Bismillahir-rahmanir-rahim
      </div>
      <div v-if="showTranslation" class="text-sm text-gray-700 mt-1">
        Dengan nama Allah Yang Maha Pengasih lagi Maha Penyayang
      </div>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="flex justify-center items-center py-8">
      <div
        class="animate-spin rounded-full h-8 w-8 border-b-2 border-green-600"
      ></div>
    </div>

    <!-- Ayahs -->
    <div v-else class="space-y-6">
      <div
        v-for="ayah in ayahs"
        :key="ayah.number"
        class="bg-white/70 backdrop-blur-sm rounded-xl p-6 border border-green-100"
      >
        <!-- Ayah Number -->
        <div class="flex items-center justify-between mb-4">
          <div
            class="w-8 h-8 bg-green-600 text-white rounded-full flex items-center justify-center text-sm font-bold"
          >
            {{ ayah.numberInSurah }}
          </div>
          <div class="flex items-center space-x-2">
            <button
              @click="playAyah(ayah)"
              class="p-2 rounded-full bg-green-100 hover:bg-green-200 transition-colors"
            >
              <svg
                class="w-4 h-4 text-green-600"
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
              @click="shareAyah(ayah)"
              class="p-2 rounded-full bg-blue-100 hover:bg-blue-200 transition-colors"
            >
              <svg
                class="w-4 h-4 text-blue-600"
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
          class="arabic-text leading-loose text-green-800 mb-4 p-4 bg-green-50 rounded-lg"
          :style="{ fontSize: arabicFontSize + 'px' }"
        >
          {{ ayah.text }}
        </div>

        <!-- Transliteration -->
        <div
          v-if="showTransliteration"
          class="text-gray-700 italic mb-3 p-3 bg-gray-50 rounded-lg"
        >
          <strong>Transliteration:</strong><br />
          {{ ayah.transliteration }}
        </div>

        <!-- Translation -->
        <div
          v-if="showTranslation"
          class="text-gray-800 p-3 bg-blue-50 rounded-lg"
        >
          <strong>Translation:</strong><br />
          {{ ayah.translation }}
        </div>
      </div>
    </div>

    <!-- Navigation -->
    <div class="flex justify-between items-center mt-8">
      <button
        v-if="surahInfo.number > 1"
        @click="goToPreviousSurah"
        class="flex items-center space-x-2 px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors"
      >
        <svg
          class="w-4 h-4"
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
        <span>Surah Sebelumnya</span>
      </button>

      <button
        v-if="surahInfo.number < 114"
        @click="goToNextSurah"
        class="flex items-center space-x-2 px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors ml-auto"
      >
        <span>Surah Selanjutnya</span>
        <svg
          class="w-4 h-4"
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M9 5l7 7-7 7"
          ></path>
        </svg>
      </button>
    </div>
  </div>
</template>

<script setup>
const route = useRoute();
const router = useRouter();

const showOptions = ref(false);
const showTranslation = ref(true);
const showTransliteration = ref(true);
const arabicFontSize = ref(24);
const loading = ref(true);

const surahNumber = computed(() => parseInt(route.params.id));

// Mock surah info - in real app would come from API
const surahInfo = ref({
  number: 1,
  name: "الفاتحة",
  englishName: "Al-Fatihah",
  englishNameTranslation: "The Opening",
  numberOfAyahs: 7,
  revelationType: "Meccan",
});

// Mock ayahs - in real app would come from API
const ayahs = ref([
  {
    number: 1,
    numberInSurah: 1,
    text: "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
    transliteration: "Bismillahir-rahmanir-rahim",
    translation: "Dengan nama Allah Yang Maha Pengasih lagi Maha Penyayang",
  },
  {
    number: 2,
    numberInSurah: 2,
    text: "الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ",
    transliteration: "Alhamdu lillahi rabbil-'alamin",
    translation: "Segala puji bagi Allah, Tuhan semesta alam",
  },
  {
    number: 3,
    numberInSurah: 3,
    text: "الرَّحْمَٰنِ الرَّحِيمِ",
    transliteration: "Ar-rahmanir-rahim",
    translation: "Yang Maha Pengasih lagi Maha Penyayang",
  },
  {
    number: 4,
    numberInSurah: 4,
    text: "مَالِكِ يَوْمِ الدِّينِ",
    transliteration: "Maliki yawmid-din",
    translation: "Pemilik hari pembalasan",
  },
  {
    number: 5,
    numberInSurah: 5,
    text: "إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ",
    transliteration: "Iyyaka na'budu wa iyyaka nasta'in",
    translation:
      "Hanya kepada Engkaulah kami menyembah dan hanya kepada Engkaulah kami memohon pertolongan",
  },
  {
    number: 6,
    numberInSurah: 6,
    text: "اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ",
    transliteration: "Ihdinash-shiratal-mustaqim",
    translation: "Tunjukilah kami jalan yang lurus",
  },
  {
    number: 7,
    numberInSurah: 7,
    text: "صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ",
    transliteration:
      "Shirathal-ladhina an'amta 'alayhim ghayril-maghdubi 'alayhim wa ladh-dhallin",
    translation:
      "(yaitu) jalan orang-orang yang telah Engkau beri nikmat kepadanya; bukan (jalan) mereka yang dimurkai dan bukan (pula jalan) mereka yang sesat",
  },
]);

const toggleOptions = () => {
  showOptions.value = !showOptions.value;
};

const playAyah = (ayah) => {
  // In a real app, this would play audio recitation
  alert(`Playing ayah ${ayah.numberInSurah}: ${ayah.transliteration}`);
};

const shareAyah = (ayah) => {
  if (navigator.share) {
    navigator.share({
      title: `${surahInfo.value.englishName} - Ayah ${ayah.numberInSurah}`,
      text: `${ayah.text}\n\n${ayah.transliteration}\n\n${ayah.translation}\n\n- ${surahInfo.value.englishName} (${ayah.numberInSurah}:${ayah.numberInSurah})`,
    });
  } else {
    // Fallback for browsers that don't support Web Share API
    alert("Share feature will be implemented");
  }
};

const goToPreviousSurah = () => {
  router.push(`/quran/${surahInfo.value.number - 1}`);
};

const goToNextSurah = () => {
  router.push(`/quran/${surahInfo.value.number + 1}`);
};

const loadSurah = async () => {
  loading.value = true;

  try {
    // In a real app, this would fetch from API
    // await fetchSurahData(surahNumber.value)

    // Mock data update based on surah number
    if (surahNumber.value === 1) {
      // Al-Fatihah data is already set
    } else {
      // Set mock data for other surahs
      surahInfo.value = {
        number: surahNumber.value,
        name: "البقرة", // Mock
        englishName: "Al-Baqarah", // Mock
        englishNameTranslation: "The Cow", // Mock
        numberOfAyahs: 286, // Mock
        revelationType: "Medinan", // Mock
      };

      // Mock some ayahs
      ayahs.value = [
        {
          number: 1,
          numberInSurah: 1,
          text: "الم",
          transliteration: "Alif Lam Mim",
          translation: "Alif Lam Mim",
        },
        {
          number: 2,
          numberInSurah: 2,
          text: "ذَٰلِكَ الْكِتَابُ لَا رَيْبَ ۛ فِيهِ ۛ هُدًى لِّلْمُتَّقِينَ",
          transliteration: "Zalikal-kitabu la rayba fih, hudan lil-muttaqin",
          translation:
            "Kitab (Al Quran) ini tidak ada keraguan padanya; petunjuk bagi mereka yang bertakwa",
        },
      ];
    }

    await new Promise((resolve) => setTimeout(resolve, 1000)); // Simulate API delay
  } catch (error) {
    console.error("Error loading surah:", error);
  } finally {
    loading.value = false;
  }
};

// Watch for route changes
watch(
  () => surahNumber.value,
  () => {
    loadSurah();
  },
  { immediate: true }
);

// Set page title
useHead({
  title: computed(
    () => `${surahInfo.value.englishName} - Al-Qur'an - Saku Muslim`
  ),
});
</script>
