<template>
  <div class="min-h-screen p-4 pb-20">
    <!-- Header -->
    <header class="flex items-center justify-between mb-6">
      <button class="p-2 rounded-full bg-white/50">
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

      <button class="p-2 rounded-full bg-white/50">
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
            d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"
          ></path>
        </svg>
      </button>
    </header>

    <!-- Next Prayer Section -->
    <div class="bg-white/70 backdrop-blur-sm rounded-2xl p-6 mb-6 text-center">
      <div class="text-4xl font-bold text-gray-900 mb-1">
        {{ nextPrayerTime }} AM
      </div>
      <div class="text-green-600 font-medium mb-2">
        Next prayer: {{ nextPrayerName }}
      </div>
      <div class="text-2xl font-mono text-gray-700 mb-4">
        {{ countdown }}
      </div>

      <!-- Location -->
      <div class="flex items-center justify-center text-gray-600 mb-4">
        <svg
          class="w-4 h-4 mr-2"
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"
          ></path>
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"
          ></path>
        </svg>
        {{ location }}
      </div>

      <!-- Qibla Direction -->
      <div class="flex justify-center">
        <button
          @click="$router.push('/qibla')"
          class="flex flex-col items-center p-3 rounded-xl bg-green-100 hover:bg-green-200 transition-colors"
        >
          <div class="text-3xl mb-1">🕋</div>
          <span class="text-sm text-green-700 font-medium"
            >Qibla Direction</span
          >
        </button>
      </div>
    </div>

    <!-- Prayer Times Today -->
    <div class="mb-6">
      <h2 class="text-lg font-semibold text-gray-900 mb-4">
        Prayer Times Today
      </h2>

      <div class="space-y-3">
        <div
          v-for="prayer in prayerTimes"
          :key="prayer.name"
          class="prayer-card flex items-center justify-between"
          :class="{
            'prayer-active': prayer.isNext,
            'opacity-50': prayer.isPassed,
          }"
        >
          <div class="flex items-center">
            <div class="text-2xl mr-3">{{ prayer.icon }}</div>
            <div>
              <div class="font-medium text-gray-900">{{ prayer.name }}</div>
              <div class="text-sm text-gray-500">{{ prayer.status }}</div>
            </div>
          </div>
          <div class="text-right">
            <div class="font-semibold text-gray-900">{{ prayer.time }}</div>
            <div class="text-sm text-gray-500">{{ prayer.status }}</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
// Mock data for now - will be replaced with API calls later
const nextPrayerTime = ref("04:31");
const nextPrayerName = ref("Fajr");
const countdown = ref("00:29:58");
const location = ref("Jakarta, Indonesia");

const prayerTimes = ref([
  {
    name: "Fajr",
    time: "04:02",
    icon: "🌅",
    status: "Subuh",
    isNext: true,
    isPassed: false,
  },
  {
    name: "Sunrise",
    time: "05:23",
    icon: "☀️",
    status: "Sunrise",
    isNext: false,
    isPassed: false,
  },
  {
    name: "Dhuhr",
    time: "11:20",
    icon: "🌞",
    status: "Dzuhur",
    isNext: false,
    isPassed: false,
  },
  {
    name: "Asr",
    time: "14:45",
    icon: "🌆",
    status: "Ashar",
    isNext: false,
    isPassed: false,
  },
  {
    name: "Maghrib",
    time: "17:45",
    icon: "🌇",
    status: "Maghrib",
    isNext: false,
    isPassed: true,
  },
]);

// Update countdown every second
onMounted(() => {
  const updateCountdown = () => {
    // This will be replaced with actual countdown logic
    const now = new Date();
    const seconds = now.getSeconds();
    const minutes = now.getMinutes();

    // Mock countdown - will implement proper logic later
    countdown.value = `00:${(59 - minutes).toString().padStart(2, "0")}:${(
      59 - seconds
    )
      .toString()
      .padStart(2, "0")}`;
  };

  updateCountdown();
  setInterval(updateCountdown, 1000);
});

// Set page title
useHead({
  title: "Saku Muslim - Prayer Times",
});
</script>
