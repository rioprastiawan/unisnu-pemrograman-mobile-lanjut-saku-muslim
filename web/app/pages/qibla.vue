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

      <h1 class="text-xl font-semibold theme-text-primary">Qibla Direction</h1>

      <div class="w-10"></div>
      <!-- Spacer -->
    </header>

    <!-- Location Info -->
    <div
      class="bg-white/70 dark:bg-gray-800/70 backdrop-blur-sm rounded-xl p-4 mb-6 text-center"
    >
      <div class="flex items-center justify-center theme-text-secondary mb-2">
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
      <div class="text-sm text-gray-500">
        Distance to Kaaba: {{ distanceToKaaba }} km
      </div>
    </div>

    <!-- Compass -->
    <div class="bg-white/70 backdrop-blur-sm rounded-2xl p-8 mb-6">
      <div class="relative w-80 h-80 mx-auto">
        <!-- Compass Circle -->
        <div
          class="absolute inset-0 rounded-full border-4 border-green-200 bg-gradient-to-br from-green-50 to-white"
        >
          <!-- Cardinal Directions -->
          <div
            class="absolute top-2 left-1/2 transform -translate-x-1/2 text-sm font-bold text-gray-700"
          >
            N
          </div>
          <div
            class="absolute bottom-2 left-1/2 transform -translate-x-1/2 text-sm font-bold text-gray-700"
          >
            S
          </div>
          <div
            class="absolute left-2 top-1/2 transform -translate-y-1/2 text-sm font-bold text-gray-700"
          >
            W
          </div>
          <div
            class="absolute right-2 top-1/2 transform -translate-y-1/2 text-sm font-bold text-gray-700"
          >
            E
          </div>

          <!-- Degree Markings -->
          <div
            v-for="degree in degreeMarkings"
            :key="degree"
            class="absolute w-1 h-4 bg-gray-300"
            :style="{
              top: '10px',
              left: '50%',
              transformOrigin: 'center 150px',
              transform: `translateX(-50%) rotate(${degree}deg)`,
            }"
          ></div>
        </div>

        <!-- Phone Direction Indicator -->
        <div
          class="absolute top-1/2 left-1/2 w-1 h-20 bg-blue-500 transform -translate-x-1/2 -translate-y-full origin-bottom transition-transform duration-300"
          :style="{
            transform: `translateX(-50%) translateY(-100%) rotate(${phoneDirection}deg)`,
          }"
        >
          <div
            class="absolute -top-2 left-1/2 transform -translate-x-1/2 w-0 h-0 border-l-2 border-r-2 border-b-4 border-transparent border-b-blue-500"
          ></div>
        </div>

        <!-- Qibla Direction Indicator -->
        <div
          class="absolute top-1/2 left-1/2 w-1 h-24 bg-green-600 transform -translate-x-1/2 -translate-y-full origin-bottom transition-transform duration-300"
          :style="{
            transform: `translateX(-50%) translateY(-100%) rotate(${qiblaDirection}deg)`,
          }"
        >
          <div
            class="absolute -top-3 left-1/2 transform -translate-x-1/2 text-2xl"
          >
            🕋
          </div>
        </div>

        <!-- Center Dot -->
        <div
          class="absolute top-1/2 left-1/2 w-4 h-4 bg-gray-800 rounded-full transform -translate-x-1/2 -translate-y-1/2"
        ></div>
      </div>
    </div>

    <!-- Direction Info -->
    <div class="space-y-4">
      <div
        class="bg-white/70 backdrop-blur-sm rounded-xl p-4 border border-green-100"
      >
        <div class="flex items-center justify-between">
          <div>
            <h3 class="font-semibold text-gray-900">Qibla Direction</h3>
            <p class="text-sm text-gray-600">Direction to Kaaba</p>
          </div>
          <div class="text-right">
            <div class="text-2xl font-bold text-green-600">
              {{ qiblaDirection }}°
            </div>
            <div class="text-sm text-gray-500">
              {{ getDirectionName(qiblaDirection) }}
            </div>
          </div>
        </div>
      </div>

      <div
        class="bg-white/70 backdrop-blur-sm rounded-xl p-4 border border-green-100"
      >
        <div class="flex items-center justify-between">
          <div>
            <h3 class="font-semibold text-gray-900">Your Direction</h3>
            <p class="text-sm text-gray-600">Current phone orientation</p>
          </div>
          <div class="text-right">
            <div class="text-2xl font-bold text-blue-600">
              {{ phoneDirection }}°
            </div>
            <div class="text-sm text-gray-500">
              {{ getDirectionName(phoneDirection) }}
            </div>
          </div>
        </div>
      </div>

      <!-- Calibration Instructions -->
      <div class="bg-blue-50 rounded-xl p-4 border border-blue-200">
        <h3 class="font-semibold text-blue-900 mb-2">📱 How to use:</h3>
        <ol class="text-sm text-blue-800 space-y-1 list-decimal list-inside">
          <li>Hold your phone flat</li>
          <li>Allow location and compass access</li>
          <li>Rotate until the blue arrow aligns with the green Kaaba</li>
          <li>Face the direction where both arrows point</li>
        </ol>
      </div>
    </div>
  </div>
</template>

<script setup>
const location = ref("Jakarta, Indonesia");
const distanceToKaaba = ref("8,964");
const qiblaDirection = ref(295); // Qibla direction for Jakarta
const phoneDirection = ref(0); // Current phone orientation

// Generate degree markings for compass
const degreeMarkings = computed(() => {
  const markings = [];
  for (let i = 0; i < 360; i += 10) {
    markings.push(i);
  }
  return markings;
});

const getDirectionName = (degree) => {
  const directions = [
    { name: "N", min: 0, max: 11.25 },
    { name: "NNE", min: 11.25, max: 33.75 },
    { name: "NE", min: 33.75, max: 56.25 },
    { name: "ENE", min: 56.25, max: 78.75 },
    { name: "E", min: 78.75, max: 101.25 },
    { name: "ESE", min: 101.25, max: 123.75 },
    { name: "SE", min: 123.75, max: 146.25 },
    { name: "SSE", min: 146.25, max: 168.75 },
    { name: "S", min: 168.75, max: 191.25 },
    { name: "SSW", min: 191.25, max: 213.75 },
    { name: "SW", min: 213.75, max: 236.25 },
    { name: "WSW", min: 236.25, max: 258.75 },
    { name: "W", min: 258.75, max: 281.25 },
    { name: "WNW", min: 281.25, max: 303.75 },
    { name: "NW", min: 303.75, max: 326.25 },
    { name: "NNW", min: 326.25, max: 348.75 },
    { name: "N", min: 348.75, max: 360 },
  ];

  const direction = directions.find((d) => degree >= d.min && degree < d.max);
  return direction ? direction.name : "N";
};

// Simulate compass movement for demo
onMounted(() => {
  // In a real app, this would use the device compass API
  let angle = 0;
  const interval = setInterval(() => {
    angle += 1;
    phoneDirection.value = angle % 360;
  }, 100);

  // Cleanup
  onUnmounted(() => {
    clearInterval(interval);
  });
});

// Set page title
useHead({
  title: "Qibla Direction - Saku Muslim",
});
</script>
