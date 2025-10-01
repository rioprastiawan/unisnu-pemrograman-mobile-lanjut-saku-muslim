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

      <h1 class="text-xl font-semibold theme-text-primary">
        Kalkulator Warisan
      </h1>

      <button
        @click="showInfo = !showInfo"
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
            d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
          ></path>
        </svg>
      </button>
    </header>

    <!-- Information Modal -->
    <div
      v-if="showInfo"
      class="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4"
      @click="showInfo = false"
    >
      <div
        class="bg-white dark:bg-gray-800 rounded-xl p-6 max-w-md w-full max-h-96 overflow-y-auto"
        @click.stop
      >
        <h3 class="font-bold text-lg mb-4">📚 Panduan Warisan Islam</h3>
        <div class="space-y-3 text-sm text-gray-700">
          <p>
            <strong>Hukum Warisan Islam (Faraidh)</strong> adalah sistem
            pembagian harta warisan yang ditetapkan dalam Al-Qur'an dan Hadis.
          </p>
          <p><strong>Prinsip Utama:</strong></p>
          <ul class="list-disc list-inside space-y-1 ml-4">
            <li>Pembagian berdasarkan Al-Qur'an dan Sunnah</li>
            <li>
              Bagian laki-laki 2x bagian perempuan (dalam kondisi tertentu)
            </li>
            <li>Ada ahli waris yang berhak mendapat bagian tetap</li>
            <li>Sisa dibagi kepada ashabah (ahli waris sisa)</li>
          </ul>
          <p class="text-red-600">
            <strong>Penting:</strong> Konsultasikan dengan ulama atau ahli
            faraidh untuk kasus kompleks.
          </p>
        </div>
        <button
          @click="showInfo = false"
          class="mt-4 w-full bg-green-600 text-white py-2 rounded-lg"
        >
          Tutup
        </button>
      </div>
    </div>

    <!-- Estate Value Input -->
    <div class="bg-white/70 backdrop-blur-sm rounded-xl p-6 mb-6">
      <h3 class="font-semibold text-gray-900 mb-4">💰 Nilai Harta Warisan</h3>

      <div class="space-y-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2"
            >Total Harta (IDR)</label
          >
          <input
            v-model.number="estateValue"
            type="number"
            placeholder="Masukkan total nilai harta"
            class="w-full p-3 rounded-lg border border-gray-200 focus:outline-none focus:ring-2 focus:ring-green-200"
          />
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2"
            >Hutang & Biaya Pemakaman (IDR)</label
          >
          <input
            v-model.number="debts"
            type="number"
            placeholder="Hutang, biaya pemakaman, dll"
            class="w-full p-3 rounded-lg border border-gray-200 focus:outline-none focus:ring-2 focus:ring-green-200"
          />
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2"
            >Wasiat (maksimal 1/3 dari sisa harta)</label
          >
          <input
            v-model.number="wasiat"
            type="number"
            placeholder="Nilai wasiat"
            class="w-full p-3 rounded-lg border border-gray-200 focus:outline-none focus:ring-2 focus:ring-green-200"
          />
          <p class="text-xs text-gray-500 mt-1">
            Maksimal: {{ formatCurrency(maxWasiat) }}
          </p>
        </div>

        <div class="p-3 bg-green-50 rounded-lg">
          <div class="flex justify-between items-center">
            <span class="font-medium text-gray-700">Harta yang Dibagi:</span>
            <span class="text-lg font-bold text-green-600">{{
              formatCurrency(netEstate)
            }}</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Heirs Selection -->
    <div class="bg-white/70 backdrop-blur-sm rounded-xl p-6 mb-6">
      <h3 class="font-semibold text-gray-900 mb-4">👥 Ahli Waris</h3>

      <!-- Spouse -->
      <div class="mb-6">
        <h4 class="font-medium text-gray-800 mb-3">Pasangan</h4>
        <div class="grid grid-cols-2 gap-4">
          <label class="flex items-center space-x-2">
            <input
              v-model="heirs.spouse.type"
              type="radio"
              value="wife"
              class="text-green-600"
            />
            <span>Istri</span>
          </label>
          <label class="flex items-center space-x-2">
            <input
              v-model="heirs.spouse.type"
              type="radio"
              value="husband"
              class="text-green-600"
            />
            <span>Suami</span>
          </label>
        </div>
        <div v-if="heirs.spouse.type === 'wife'" class="mt-2">
          <label class="block text-sm text-gray-600">Jumlah Istri:</label>
          <input
            v-model.number="heirs.spouse.count"
            type="number"
            min="1"
            max="4"
            class="w-20 p-2 rounded border border-gray-200"
          />
        </div>
      </div>

      <!-- Children -->
      <div class="mb-6">
        <h4 class="font-medium text-gray-800 mb-3">Anak</h4>
        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-sm text-gray-600">Anak Laki-laki:</label>
            <input
              v-model.number="heirs.children.sons"
              type="number"
              min="0"
              class="w-full p-2 rounded border border-gray-200"
            />
          </div>
          <div>
            <label class="block text-sm text-gray-600">Anak Perempuan:</label>
            <input
              v-model.number="heirs.children.daughters"
              type="number"
              min="0"
              class="w-full p-2 rounded border border-gray-200"
            />
          </div>
        </div>
      </div>

      <!-- Parents -->
      <div class="mb-6">
        <h4 class="font-medium text-gray-800 mb-3">Orang Tua</h4>
        <div class="grid grid-cols-2 gap-4">
          <label class="flex items-center space-x-2">
            <input
              v-model="heirs.parents.father"
              type="checkbox"
              class="text-green-600"
            />
            <span>Ayah</span>
          </label>
          <label class="flex items-center space-x-2">
            <input
              v-model="heirs.parents.mother"
              type="checkbox"
              class="text-green-600"
            />
            <span>Ibu</span>
          </label>
        </div>
      </div>

      <!-- Siblings -->
      <div class="mb-6">
        <h4 class="font-medium text-gray-800 mb-3">Saudara</h4>
        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-sm text-gray-600"
              >Saudara Laki-laki:</label
            >
            <input
              v-model.number="heirs.siblings.brothers"
              type="number"
              min="0"
              class="w-full p-2 rounded border border-gray-200"
            />
          </div>
          <div>
            <label class="block text-sm text-gray-600"
              >Saudara Perempuan:</label
            >
            <input
              v-model.number="heirs.siblings.sisters"
              type="number"
              min="0"
              class="w-full p-2 rounded border border-gray-200"
            />
          </div>
        </div>
      </div>

      <!-- Grandchildren -->
      <div class="mb-6">
        <h4 class="font-medium text-gray-800 mb-3">
          Cucu (dari anak laki-laki)
        </h4>
        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-sm text-gray-600">Cucu Laki-laki:</label>
            <input
              v-model.number="heirs.grandchildren.grandsons"
              type="number"
              min="0"
              class="w-full p-2 rounded border border-gray-200"
            />
          </div>
          <div>
            <label class="block text-sm text-gray-600">Cucu Perempuan:</label>
            <input
              v-model.number="heirs.grandchildren.granddaughters"
              type="number"
              min="0"
              class="w-full p-2 rounded border border-gray-200"
            />
          </div>
        </div>
      </div>
    </div>

    <!-- Calculate Button -->
    <button
      @click="calculateInheritance"
      class="w-full bg-green-600 text-white py-4 rounded-xl font-semibold mb-6 hover:bg-green-700 transition-colors"
    >
      🧮 Hitung Pembagian Warisan
    </button>

    <!-- Results -->
    <div v-if="calculated" class="space-y-4">
      <h3 class="text-lg font-semibold text-gray-900">📊 Hasil Pembagian</h3>

      <div
        v-for="result in inheritanceResults"
        :key="result.heir"
        class="bg-white/70 backdrop-blur-sm rounded-xl p-4 border border-green-100"
      >
        <div class="flex justify-between items-center">
          <div>
            <h4 class="font-semibold text-gray-900">{{ result.heir }}</h4>
            <p class="text-sm text-gray-600">
              {{ result.basis }} ({{ result.fraction }})
            </p>
          </div>
          <div class="text-right">
            <div class="text-lg font-bold text-green-600">
              {{ formatCurrency(result.amount) }}
            </div>
            <div class="text-sm text-gray-500">{{ result.percentage }}%</div>
          </div>
        </div>
      </div>

      <!-- Summary -->
      <div class="bg-green-50 rounded-xl p-4 border border-green-200">
        <div class="flex justify-between items-center mb-2">
          <span class="font-medium text-gray-700">Total Dibagikan:</span>
          <span class="font-bold text-green-600">{{
            formatCurrency(totalDistributed)
          }}</span>
        </div>
        <div v-if="remaining > 0" class="flex justify-between items-center">
          <span class="font-medium text-gray-700">Sisa (untuk ashabah):</span>
          <span class="font-bold text-orange-600">{{
            formatCurrency(remaining)
          }}</span>
        </div>
      </div>
    </div>

    <!-- Important Notes -->
    <div class="bg-yellow-50 rounded-xl p-4 border border-yellow-200 mt-6">
      <h4 class="font-semibold text-yellow-900 mb-2">⚠️ Catatan Penting:</h4>
      <ul class="text-sm text-yellow-800 space-y-1 list-disc list-inside">
        <li>Kalkulator ini memberikan perhitungan dasar hukum faraidh</li>
        <li>Beberapa kasus khusus memerlukan konsultasi dengan ahli faraidh</li>
        <li>Pastikan semua ahli waris telah diidentifikasi dengan benar</li>
        <li>
          Pembagian dapat berbeda jika ada hijab (penghalang) antar ahli waris
        </li>
        <li>
          Disarankan untuk konsultasi dengan ulama atau notaris syariah untuk
          kepastian hukum
        </li>
      </ul>
    </div>
  </div>
</template>

<script setup>
const showInfo = ref(false);
const calculated = ref(false);

// Estate values
const estateValue = ref(0);
const debts = ref(0);
const wasiat = ref(0);

// Heirs data
const heirs = ref({
  spouse: {
    type: null, // 'husband' or 'wife'
    count: 1, // for wives (max 4)
  },
  children: {
    sons: 0,
    daughters: 0,
  },
  parents: {
    father: false,
    mother: false,
  },
  siblings: {
    brothers: 0,
    sisters: 0,
  },
  grandchildren: {
    grandsons: 0,
    granddaughters: 0,
  },
});

const inheritanceResults = ref([]);

const netEstate = computed(() => {
  const afterDebts = estateValue.value - debts.value;
  const afterWasiat = afterDebts - Math.min(wasiat.value, afterDebts / 3);
  return Math.max(0, afterWasiat);
});

const maxWasiat = computed(() => {
  const afterDebts = estateValue.value - debts.value;
  return Math.max(0, afterDebts / 3);
});

const totalDistributed = computed(() => {
  return inheritanceResults.value.reduce(
    (sum, result) => sum + result.amount,
    0
  );
});

const remaining = computed(() => {
  return netEstate.value - totalDistributed.value;
});

const calculateInheritance = () => {
  const results = [];
  let estate = netEstate.value;

  if (estate <= 0) {
    alert("Nilai harta warisan harus lebih dari 0");
    return;
  }

  // Calculate fixed shares (Fara'id)

  // Spouse inheritance
  if (heirs.value.spouse.type) {
    let spouseShare = 0;
    let spouseFraction = "";

    if (heirs.value.spouse.type === "husband") {
      // Husband gets 1/2 if no children, 1/4 if there are children
      if (heirs.value.children.sons + heirs.value.children.daughters === 0) {
        spouseShare = estate / 2;
        spouseFraction = "1/2";
      } else {
        spouseShare = estate / 4;
        spouseFraction = "1/4";
      }

      results.push({
        heir: "Suami",
        amount: spouseShare,
        fraction: spouseFraction,
        percentage: ((spouseShare / estate) * 100).toFixed(1),
        basis: "Bagian tetap suami",
      });
    } else if (heirs.value.spouse.type === "wife") {
      // Wife gets 1/4 if no children, 1/8 if there are children
      let sharePerWife = 0;
      if (heirs.value.children.sons + heirs.value.children.daughters === 0) {
        sharePerWife = estate / 4 / heirs.value.spouse.count;
        spouseFraction = `1/4 ÷ ${heirs.value.spouse.count}`;
      } else {
        sharePerWife = estate / 8 / heirs.value.spouse.count;
        spouseFraction = `1/8 ÷ ${heirs.value.spouse.count}`;
      }

      results.push({
        heir: `Istri (${heirs.value.spouse.count} orang)`,
        amount: sharePerWife * heirs.value.spouse.count,
        fraction: spouseFraction,
        percentage: (
          ((sharePerWife * heirs.value.spouse.count) / estate) *
          100
        ).toFixed(1),
        basis: "Bagian tetap istri",
      });
    }
  }

  // Parents inheritance
  if (heirs.value.parents.father) {
    let fatherShare = 0;
    let fatherFraction = "";

    if (heirs.value.children.sons + heirs.value.children.daughters === 0) {
      // Father gets 1/6 as fixed share + residue as ashabah
      fatherShare = estate / 6;
      fatherFraction = "1/6 + sisa";
    } else {
      // Father gets 1/6 only
      fatherShare = estate / 6;
      fatherFraction = "1/6";
    }

    results.push({
      heir: "Ayah",
      amount: fatherShare,
      fraction: fatherFraction,
      percentage: ((fatherShare / estate) * 100).toFixed(1),
      basis: "Bagian tetap ayah",
    });
  }

  if (heirs.value.parents.mother) {
    let motherShare = 0;
    let motherFraction = "";

    if (
      heirs.value.children.sons + heirs.value.children.daughters === 0 &&
      heirs.value.siblings.brothers + heirs.value.siblings.sisters < 2
    ) {
      // Mother gets 1/3
      motherShare = estate / 3;
      motherFraction = "1/3";
    } else {
      // Mother gets 1/6
      motherShare = estate / 6;
      motherFraction = "1/6";
    }

    results.push({
      heir: "Ibu",
      amount: motherShare,
      fraction: motherFraction,
      percentage: ((motherShare / estate) * 100).toFixed(1),
      basis: "Bagian tetap ibu",
    });
  }

  // Children inheritance (simplified calculation)
  const totalChildren =
    heirs.value.children.sons + heirs.value.children.daughters;
  if (totalChildren > 0) {
    // This is a simplified calculation
    // In real faraidh, children inheritance is more complex
    const remainingForChildren = estate * 0.6; // Approximate
    const sonShare =
      remainingForChildren /
      (heirs.value.children.sons * 2 + heirs.value.children.daughters);
    const daughterShare = sonShare / 2;

    if (heirs.value.children.sons > 0) {
      results.push({
        heir: `Anak Laki-laki (${heirs.value.children.sons} orang)`,
        amount: sonShare * heirs.value.children.sons,
        fraction: "Sisa (2x anak perempuan)",
        percentage: (
          ((sonShare * heirs.value.children.sons) / estate) *
          100
        ).toFixed(1),
        basis: "Ashabah/sisa",
      });
    }

    if (heirs.value.children.daughters > 0) {
      results.push({
        heir: `Anak Perempuan (${heirs.value.children.daughters} orang)`,
        amount: daughterShare * heirs.value.children.daughters,
        fraction: "Sisa (1/2 dari anak laki-laki)",
        percentage: (
          ((daughterShare * heirs.value.children.daughters) / estate) *
          100
        ).toFixed(1),
        basis: "Ashabah/sisa",
      });
    }
  }

  inheritanceResults.value = results;
  calculated.value = true;
};

const formatCurrency = (amount) => {
  return new Intl.NumberFormat("id-ID", {
    style: "currency",
    currency: "IDR",
    minimumFractionDigits: 0,
  }).format(amount);
};

// Set page title
useHead({
  title: "Islamic Inheritance Calculator - Saku Muslim",
});
</script>
