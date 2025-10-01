export interface PrayerTime {
  name: string;
  time: string;
  arabicName: string;
  icon: string;
  isNext?: boolean;
  isPassed?: boolean;
}

export interface PrayerTimes {
  fajr: string;
  sunrise: string;
  dhuhr: string;
  asr: string;
  maghrib: string;
  isha: string;
}

export interface LocationData {
  city: string;
  country: string;
  latitude: number;
  longitude: number;
}

export const usePrayerTimes = () => {
  const prayerTimes = ref<PrayerTimes | null>(null);
  const location = ref<LocationData>({
    city: "Jakarta",
    country: "Indonesia",
    latitude: -6.2088,
    longitude: 106.8456,
  });
  const loading = ref(false);
  const error = ref<string | null>(null);
  const currentTime = ref(new Date());
  const qiblaDirection = ref(295); // Default Qibla direction for Jakarta

  // Update current time every second
  const timeInterval = ref<NodeJS.Timeout | null>(null);

  const startTimeUpdates = () => {
    if (timeInterval.value) {
      clearInterval(timeInterval.value);
    }

    timeInterval.value = setInterval(() => {
      currentTime.value = new Date();
    }, 1000);
  };

  const stopTimeUpdates = () => {
    if (timeInterval.value) {
      clearInterval(timeInterval.value);
      timeInterval.value = null;
    }
  };

  const formattedPrayerTimes = computed((): PrayerTime[] => {
    if (!prayerTimes.value) return [];

    const prayers = [
      {
        name: "Fajr",
        time: prayerTimes.value.fajr,
        arabicName: "الفجر",
        icon: "🌅",
      },
      {
        name: "Sunrise",
        time: prayerTimes.value.sunrise,
        arabicName: "الشروق",
        icon: "☀️",
      },
      {
        name: "Dhuhr",
        time: prayerTimes.value.dhuhr,
        arabicName: "الظهر",
        icon: "🌞",
      },
      {
        name: "Asr",
        time: prayerTimes.value.asr,
        arabicName: "العصر",
        icon: "🌆",
      },
      {
        name: "Maghrib",
        time: prayerTimes.value.maghrib,
        arabicName: "المغرب",
        icon: "🌇",
      },
      {
        name: "Isha",
        time: prayerTimes.value.isha,
        arabicName: "العشاء",
        icon: "🌙",
      },
    ];

    return prayers.map((prayer) => ({
      ...prayer,
      isNext: isNextPrayer(prayer.time),
      isPassed: isPrayerPassed(prayer.time),
    }));
  });

  const nextPrayer = computed((): PrayerTime | null => {
    return formattedPrayerTimes.value.find((prayer) => prayer.isNext) || null;
  });

  const timeUntilNextPrayer = computed((): string => {
    const next = nextPrayer.value;
    if (!next) return "00:00:00";

    const now = currentTime.value;
    const [hours, minutes] = next.time.split(":").map(Number);
    const prayerTime = new Date(now);
    prayerTime.setHours(hours, minutes, 0, 0);

    // If prayer time has passed today, it's tomorrow
    if (prayerTime <= now) {
      prayerTime.setDate(prayerTime.getDate() + 1);
    }

    const diff = prayerTime.getTime() - now.getTime();
    const h = Math.floor(diff / (1000 * 60 * 60));
    const m = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
    const s = Math.floor((diff % (1000 * 60)) / 1000);

    return `${h.toString().padStart(2, "0")}:${m
      .toString()
      .padStart(2, "0")}:${s.toString().padStart(2, "0")}`;
  });

  const fetchPrayerTimes = async () => {
    loading.value = true;
    error.value = null;

    try {
      const today = new Date().toISOString().split("T")[0];
      const response = await $fetch(
        `https://api.aladhan.com/v1/timings/${today}`,
        {
          params: {
            latitude: location.value.latitude,
            longitude: location.value.longitude,
            method: 2, // Islamic Society of North America
          },
        }
      );

      prayerTimes.value = {
        fajr: response.data.timings.Fajr,
        sunrise: response.data.timings.Sunrise,
        dhuhr: response.data.timings.Dhuhr,
        asr: response.data.timings.Asr,
        maghrib: response.data.timings.Maghrib,
        isha: response.data.timings.Isha,
      };
    } catch (err) {
      error.value = "Failed to fetch prayer times";
      console.error(err);

      // Fallback to mock data
      prayerTimes.value = {
        fajr: "04:02",
        sunrise: "05:23",
        dhuhr: "11:20",
        asr: "14:45",
        maghrib: "17:45",
        isha: "19:00",
      };
    } finally {
      loading.value = false;
    }
  };

  const isNextPrayer = (time: string): boolean => {
    const now = currentTime.value;
    const [hours, minutes] = time.split(":").map(Number);
    const prayerTime = new Date(now);
    prayerTime.setHours(hours, minutes, 0, 0);

    // Check if this is the next prayer
    const allTimes = prayerTimes.value;
    if (!allTimes) return false;

    const times = [
      allTimes.fajr,
      allTimes.sunrise,
      allTimes.dhuhr,
      allTimes.asr,
      allTimes.maghrib,
      allTimes.isha,
    ];

    for (const t of times) {
      const [h, m] = t.split(":").map(Number);
      const pt = new Date(now);
      pt.setHours(h, m, 0, 0);

      if (pt > now) {
        return t === time;
      }
    }

    // If no prayer is left today, next is Fajr tomorrow
    return time === allTimes.fajr;
  };

  const isPrayerPassed = (time: string): boolean => {
    const now = currentTime.value;
    const [hours, minutes] = time.split(":").map(Number);
    const prayerTime = new Date(now);
    prayerTime.setHours(hours, minutes, 0, 0);

    return prayerTime < now;
  };

  const updateLocation = async (latitude: number, longitude: number) => {
    location.value.latitude = latitude;
    location.value.longitude = longitude;

    // Update city name and qibla direction
    try {
      const response = await $fetch(
        `https://api.aladhan.com/v1/qibla/${latitude}/${longitude}`
      );
      qiblaDirection.value = response.data.direction;

      // You might want to add reverse geocoding here to get city name
    } catch (err) {
      console.error("Failed to update Qibla direction", err);
    }

    await fetchPrayerTimes();
  };

  // Cleanup on unmount
  onUnmounted(() => {
    stopTimeUpdates();
  });

  return {
    // State
    prayerTimes: readonly(prayerTimes),
    location: readonly(location),
    loading: readonly(loading),
    error: readonly(error),
    currentTime: readonly(currentTime),
    qiblaDirection: readonly(qiblaDirection),

    // Computed
    formattedPrayerTimes,
    nextPrayer,
    timeUntilNextPrayer,

    // Methods
    fetchPrayerTimes,
    updateLocation,
    startTimeUpdates,
    stopTimeUpdates,
  };
};
