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

      <h1 class="text-xl font-semibold theme-text-primary">Kalender Hijriah</h1>

      <button
        @click="goToToday"
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
            d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"
          ></path>
        </svg>
      </button>
    </header>

    <!-- Current Date Display -->
    <div
      class="bg-white/70 dark:bg-gray-800/70 backdrop-blur-sm rounded-xl p-6 mb-6 text-center"
    >
      <div class="text-3xl font-bold text-green-600 dark:text-green-400 mb-2">
        {{ currentHijriDate.day }}
      </div>
      <div class="text-lg font-semibold theme-text-primary mb-1">
        {{ currentHijriDate.month }} {{ currentHijriDate.year }}
      </div>
      <div class="text-sm theme-text-secondary">{{ currentGregorianDate }}</div>

      <!-- Special Events -->
      <div
        v-if="todayEvents.length > 0"
        class="mt-4 p-3 bg-yellow-50 rounded-lg"
      >
        <div class="text-sm font-semibold text-yellow-800 mb-1">
          🌟 Today's Events:
        </div>
        <div
          v-for="event in todayEvents"
          :key="event"
          class="text-sm text-yellow-700"
        >
          {{ event }}
        </div>
      </div>
    </div>

    <!-- Month Navigation -->
    <div class="flex items-center justify-between mb-6">
      <button
        @click="previousMonth"
        class="p-3 rounded-full bg-white/50 hover:bg-white/70 transition-colors"
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
            d="M15 19l-7-7 7-7"
          ></path>
        </svg>
      </button>

      <div class="text-center">
        <div class="text-lg font-semibold text-gray-900">
          {{ displayMonth }} {{ displayYear }}
        </div>
        <div class="text-sm text-gray-600">{{ displayGregorianMonth }}</div>
      </div>

      <button
        @click="nextMonth"
        class="p-3 rounded-full bg-white/50 hover:bg-white/70 transition-colors"
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
            d="M9 5l7 7-7 7"
          ></path>
        </svg>
      </button>
    </div>

    <!-- Calendar Grid -->
    <div class="bg-white/70 backdrop-blur-sm rounded-xl p-4 mb-6">
      <!-- Day Headers -->
      <div class="grid grid-cols-7 gap-1 mb-2">
        <div
          v-for="day in dayHeaders"
          :key="day"
          class="text-center text-sm font-semibold text-gray-600 p-2"
        >
          {{ day }}
        </div>
      </div>

      <!-- Calendar Days -->
      <div class="grid grid-cols-7 gap-1">
        <div
          v-for="date in calendarDays"
          :key="`${date.hijri}-${date.gregorian}`"
          class="aspect-square flex flex-col items-center justify-center p-1 rounded-lg transition-colors cursor-pointer"
          :class="{
            'bg-green-100 text-green-800': date.isToday,
            'bg-gray-100 text-gray-400': !date.isCurrentMonth,
            'hover:bg-green-50': date.isCurrentMonth && !date.isToday,
            'text-gray-900': date.isCurrentMonth && !date.isToday,
          }"
          @click="selectDate(date)"
        >
          <div class="text-sm font-semibold">{{ date.hijri }}</div>
          <div class="text-xs text-gray-500">{{ date.gregorian }}</div>
          <div
            v-if="date.hasEvent"
            class="w-1 h-1 bg-orange-400 rounded-full mt-1"
          ></div>
        </div>
      </div>
    </div>

    <!-- Islamic Events -->
    <div class="space-y-4">
      <h3 class="text-lg font-semibold text-gray-900">
        🌙 Upcoming Islamic Events
      </h3>

      <div
        v-for="event in upcomingEvents"
        :key="event.id"
        class="bg-white/70 backdrop-blur-sm rounded-xl p-4 border border-green-100"
      >
        <div class="flex items-start justify-between">
          <div>
            <h4 class="font-semibold text-gray-900">{{ event.name }}</h4>
            <p class="text-sm text-gray-600 mt-1">{{ event.description }}</p>
            <div class="flex items-center mt-2 text-sm text-gray-500">
              <svg
                class="w-4 h-4 mr-1"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"
                ></path>
              </svg>
              {{ event.hijriDate }} ({{ event.gregorianDate }})
            </div>
          </div>
          <div class="text-2xl">{{ event.icon }}</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const currentDate = ref(new Date());
const selectedMonth = ref(1); // Muharram = 1
const selectedYear = ref(1446); // Current Hijri year

const hijriMonths = [
  "Muharram",
  "Safar",
  "Rabi' al-awwal",
  "Rabi' al-thani",
  "Jumada al-awwal",
  "Jumada al-thani",
  "Rajab",
  "Sha'ban",
  "Ramadan",
  "Shawwal",
  "Dhu al-Qi'dah",
  "Dhu al-Hijjah",
];

const dayHeaders = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

// Mock current Hijri date
const currentHijriDate = ref({
  day: 23,
  month: "Rabi' al-awwal",
  year: 1446,
});

const currentGregorianDate = computed(() => {
  return currentDate.value.toLocaleDateString("en-US", {
    weekday: "long",
    year: "numeric",
    month: "long",
    day: "numeric",
  });
});

const displayMonth = computed(() => hijriMonths[selectedMonth.value - 1]);
const displayYear = computed(() => selectedYear.value);
const displayGregorianMonth = computed(() => {
  // This would normally convert Hijri to Gregorian
  return new Date().toLocaleDateString("en-US", {
    month: "long",
    year: "numeric",
  });
});

// Mock calendar days for current month
const calendarDays = computed(() => {
  const days = [];

  // Previous month days
  for (let i = 26; i <= 30; i++) {
    days.push({
      hijri: i,
      gregorian: i - 10, // Mock Gregorian equivalent
      isCurrentMonth: false,
      isToday: false,
      hasEvent: false,
    });
  }

  // Current month days
  for (let i = 1; i <= 30; i++) {
    days.push({
      hijri: i,
      gregorian: i + 15, // Mock Gregorian equivalent
      isCurrentMonth: true,
      isToday: i === currentHijriDate.value.day && selectedMonth.value === 3, // Rabi' al-awwal
      hasEvent: [1, 12, 27].includes(i), // Mock events on these days
    });
  }

  // Next month days
  for (let i = 1; i <= 7; i++) {
    days.push({
      hijri: i,
      gregorian: i + 45, // Mock Gregorian equivalent
      isCurrentMonth: false,
      isToday: false,
      hasEvent: false,
    });
  }

  return days;
});

const todayEvents = ref(["Maulid an-Nabi (Prophet's Birthday)"]);

const upcomingEvents = ref([
  {
    id: 1,
    name: "Maulid an-Nabi",
    description: "Birthday of Prophet Muhammad (PBUH)",
    hijriDate: "12 Rabi' al-awwal 1446",
    gregorianDate: "October 15, 2024",
    icon: "🌟",
  },
  {
    id: 2,
    name: "Isra and Mi'raj",
    description: "Night Journey of Prophet Muhammad (PBUH)",
    hijriDate: "27 Rajab 1446",
    gregorianDate: "January 28, 2025",
    icon: "🌙",
  },
  {
    id: 3,
    name: "First of Ramadan",
    description: "Beginning of the holy month of fasting",
    hijriDate: "1 Ramadan 1446",
    gregorianDate: "March 1, 2025",
    icon: "🌙",
  },
  {
    id: 4,
    name: "Laylat al-Qadr",
    description: "Night of Power (estimated)",
    hijriDate: "27 Ramadan 1446",
    gregorianDate: "March 27, 2025",
    icon: "✨",
  },
  {
    id: 5,
    name: "Eid al-Fitr",
    description: "Festival of Breaking the Fast",
    hijriDate: "1 Shawwal 1446",
    gregorianDate: "March 31, 2025",
    icon: "🎉",
  },
]);

const previousMonth = () => {
  if (selectedMonth.value === 1) {
    selectedMonth.value = 12;
    selectedYear.value--;
  } else {
    selectedMonth.value--;
  }
};

const nextMonth = () => {
  if (selectedMonth.value === 12) {
    selectedMonth.value = 1;
    selectedYear.value++;
  } else {
    selectedMonth.value++;
  }
};

const goToToday = () => {
  selectedMonth.value = 3; // Rabi' al-awwal
  selectedYear.value = 1446;
};

const selectDate = (date) => {
  if (date.isCurrentMonth) {
    // Handle date selection
    console.log("Selected date:", date);
  }
};

// Set page title
useHead({
  title: "Islamic Calendar - Saku Muslim",
});
</script>
