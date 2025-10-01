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

      <h1 class="text-xl font-semibold theme-text-primary">Kalkulator Zakat</h1>

      <div class="w-10"></div>
      <!-- Spacer -->
    </header>

    <!-- Zakat Types -->
    <div class="grid grid-cols-2 gap-4 mb-6">
      <button
        v-for="type in zakatTypes"
        :key="type.id"
        @click="selectedType = type.id"
        class="p-4 rounded-xl border transition-all"
        :class="
          selectedType === type.id
            ? 'bg-green-600 text-white border-green-600'
            : 'bg-white/70 dark:bg-gray-800/70 theme-text-primary border-green-100 dark:border-green-800 hover:bg-white/90 dark:hover:bg-gray-700/90'
        "
      >
        <div class="text-2xl mb-2">{{ type.icon }}</div>
        <div class="font-semibold">{{ type.name }}</div>
      </button>
    </div>

    <!-- Zakat Mal Calculator -->
    <div v-if="selectedType === 'mal'" class="space-y-6">
      <div
        class="bg-white/70 dark:bg-gray-800/70 backdrop-blur-sm rounded-xl p-6 border border-green-100 dark:border-green-800"
      >
        <h3 class="font-semibold theme-text-primary mb-4">
          Zakat Mal (Wealth)
        </h3>

        <!-- Input Assets -->
        <div class="space-y-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2"
              >Cash & Savings (IDR)</label
            >
            <input
              v-model.number="malAssets.cash"
              type="number"
              placeholder="Enter amount"
              class="w-full p-3 rounded-lg border border-gray-200 focus:outline-none focus:ring-2 focus:ring-green-200"
            />
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2"
              >Gold (grams)</label
            >
            <input
              v-model.number="malAssets.gold"
              type="number"
              placeholder="Enter weight in grams"
              class="w-full p-3 rounded-lg border border-gray-200 focus:outline-none focus:ring-2 focus:ring-green-200"
            />
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2"
              >Silver (grams)</label
            >
            <input
              v-model.number="malAssets.silver"
              type="number"
              placeholder="Enter weight in grams"
              class="w-full p-3 rounded-lg border border-gray-200 focus:outline-none focus:ring-2 focus:ring-green-200"
            />
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2"
              >Investments & Business (IDR)</label
            >
            <input
              v-model.number="malAssets.investments"
              type="number"
              placeholder="Enter amount"
              class="w-full p-3 rounded-lg border border-gray-200 focus:outline-none focus:ring-2 focus:ring-green-200"
            />
          </div>
        </div>

        <!-- Results -->
        <div class="mt-6 p-4 bg-green-50 rounded-lg">
          <div class="flex justify-between items-center mb-2">
            <span class="text-gray-700">Total Assets:</span>
            <span class="font-semibold">{{
              formatCurrency(totalMalAssets)
            }}</span>
          </div>
          <div class="flex justify-between items-center mb-2">
            <span class="text-gray-700">Nisab (85g gold):</span>
            <span class="font-semibold">{{ formatCurrency(goldNisab) }}</span>
          </div>
          <div class="flex justify-between items-center mb-4">
            <span class="text-gray-700">Eligible for Zakat:</span>
            <span
              class="font-semibold"
              :class="isEligibleForMalZakat ? 'text-green-600' : 'text-red-600'"
            >
              {{ isEligibleForMalZakat ? "Yes" : "No" }}
            </span>
          </div>

          <div v-if="isEligibleForMalZakat" class="border-t pt-4">
            <div class="flex justify-between items-center">
              <span class="text-lg font-semibold text-gray-900"
                >Zakat Due (2.5%):</span
              >
              <span class="text-2xl font-bold text-green-600">{{
                formatCurrency(malZakatAmount)
              }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Zakat Fitrah Calculator -->
    <div v-if="selectedType === 'fitrah'" class="space-y-6">
      <div
        class="bg-white/70 backdrop-blur-sm rounded-xl p-6 border border-green-100"
      >
        <h3 class="font-semibold text-gray-900 mb-4">Zakat Fitrah</h3>

        <div class="space-y-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2"
              >Number of People</label
            >
            <input
              v-model.number="fitrahPeople"
              type="number"
              min="1"
              placeholder="Enter number of people"
              class="w-full p-3 rounded-lg border border-gray-200 focus:outline-none focus:ring-2 focus:ring-green-200"
            />
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2"
              >Type of Food</label
            >
            <select
              v-model="fitrahType"
              class="w-full p-3 rounded-lg border border-gray-200 focus:outline-none focus:ring-2 focus:ring-green-200"
            >
              <option value="rice">Rice (IDR 15,000/person)</option>
              <option value="wheat">Wheat (IDR 20,000/person)</option>
              <option value="barley">Barley (IDR 18,000/person)</option>
              <option value="dates">Dates (IDR 25,000/person)</option>
            </select>
          </div>
        </div>

        <!-- Results -->
        <div class="mt-6 p-4 bg-green-50 rounded-lg">
          <div class="flex justify-between items-center mb-2">
            <span class="text-gray-700">Amount per person:</span>
            <span class="font-semibold">{{
              formatCurrency(fitrahAmounts[fitrahType])
            }}</span>
          </div>
          <div class="flex justify-between items-center mb-4">
            <span class="text-gray-700">Number of people:</span>
            <span class="font-semibold">{{ fitrahPeople }}</span>
          </div>

          <div class="border-t pt-4">
            <div class="flex justify-between items-center">
              <span class="text-lg font-semibold text-gray-900"
                >Total Zakat Fitrah:</span
              >
              <span class="text-2xl font-bold text-green-600">{{
                formatCurrency(totalFitrahAmount)
              }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Information -->
      <div class="bg-blue-50 rounded-xl p-4 border border-blue-200">
        <h4 class="font-semibold text-blue-900 mb-2">📝 Important Notes:</h4>
        <ul class="text-sm text-blue-800 space-y-1 list-disc list-inside">
          <li>Zakat Fitrah must be paid before Eid prayer</li>
          <li>
            It's obligatory for every Muslim who has food for more than a day
          </li>
          <li>The amount is approximately 2.5 kg of staple food per person</li>
          <li>You can pay in cash equivalent to the food value</li>
        </ul>
      </div>
    </div>

    <!-- Information Card -->
    <div class="bg-yellow-50 rounded-xl p-4 border border-yellow-200">
      <h4 class="font-semibold text-yellow-900 mb-2">💡 Zakat Information:</h4>
      <ul class="text-sm text-yellow-800 space-y-1 list-disc list-inside">
        <li>Zakat is one of the five pillars of Islam</li>
        <li>It purifies your wealth and helps the needy</li>
        <li>Calculate annually based on Islamic calendar</li>
        <li>Consult with Islamic scholars for complex situations</li>
      </ul>
    </div>
  </div>
</template>

<script setup>
const selectedType = ref("mal");

const zakatTypes = [
  { id: "mal", name: "Zakat Mal", icon: "💰" },
  { id: "fitrah", name: "Zakat Fitrah", icon: "🌾" },
];

// Mal Zakat
const malAssets = ref({
  cash: 0,
  gold: 0,
  silver: 0,
  investments: 0,
});

const goldPricePerGram = ref(1000000); // IDR per gram (approximate)
const silverPricePerGram = ref(15000); // IDR per gram (approximate)

const totalMalAssets = computed(() => {
  return (
    malAssets.value.cash +
    malAssets.value.investments +
    malAssets.value.gold * goldPricePerGram.value +
    malAssets.value.silver * silverPricePerGram.value
  );
});

const goldNisab = computed(() => {
  return 85 * goldPricePerGram.value; // 85 grams of gold
});

const silverNisab = computed(() => {
  return 595 * silverPricePerGram.value; // 595 grams of silver
});

const isEligibleForMalZakat = computed(() => {
  return totalMalAssets.value >= goldNisab.value;
});

const malZakatAmount = computed(() => {
  return isEligibleForMalZakat.value ? totalMalAssets.value * 0.025 : 0;
});

// Fitrah Zakat
const fitrahPeople = ref(1);
const fitrahType = ref("rice");

const fitrahAmounts = {
  rice: 15000,
  wheat: 20000,
  barley: 18000,
  dates: 25000,
};

const totalFitrahAmount = computed(() => {
  return fitrahPeople.value * fitrahAmounts[fitrahType.value];
});

const formatCurrency = (amount) => {
  return new Intl.NumberFormat("id-ID", {
    style: "currency",
    currency: "IDR",
    minimumFractionDigits: 0,
  }).format(amount);
};

// Set page title
useHead({
  title: "Zakat Calculator - Saku Muslim",
});
</script>
