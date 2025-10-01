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

export const usePrayerStore = defineStore("prayer", {
  state: () => ({
    prayerTimes: null as PrayerTimes | null,
    location: {
      city: "Jakarta",
      country: "Indonesia",
      latitude: -6.2088,
      longitude: 106.8456,
    } as LocationData,
    loading: false,
    error: null as string | null,
    currentTime: new Date(),
    qiblaDirection: 295, // Default Qibla direction for Jakarta
  }),

  getters: {
    formattedPrayerTimes: (state): PrayerTime[] => {
      if (!state.prayerTimes) return [];

      const prayers = [
        {
          name: "Fajr",
          time: state.prayerTimes.fajr,
          arabicName: "الفجر",
          icon: "🌅",
        },
        {
          name: "Sunrise",
          time: state.prayerTimes.sunrise,
          arabicName: "الشروق",
          icon: "☀️",
        },
        {
          name: "Dhuhr",
          time: state.prayerTimes.dhuhr,
          arabicName: "الظهر",
          icon: "🌞",
        },
        {
          name: "Asr",
          time: state.prayerTimes.asr,
          arabicName: "العصر",
          icon: "🌆",
        },
        {
          name: "Maghrib",
          time: state.prayerTimes.maghrib,
          arabicName: "المغرب",
          icon: "🌇",
        },
        {
          name: "Isha",
          time: state.prayerTimes.isha,
          arabicName: "العشاء",
          icon: "🌙",
        },
      ];

      return prayers.map((prayer) => ({
        ...prayer,
        isNext: this.isNextPrayer(prayer.time),
        isPassed: this.isPrayerPassed(prayer.time),
      }));
    },

    nextPrayer: (state): PrayerTime | null => {
      return this.formattedPrayerTimes.find((prayer) => prayer.isNext) || null;
    },

    timeUntilNextPrayer: (state): string => {
      const next = this.nextPrayer;
      if (!next) return "00:00:00";

      const now = state.currentTime;
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
    },
  },

  actions: {
    async fetchPrayerTimes() {
      this.loading = true;
      this.error = null;

      try {
        const today = new Date().toISOString().split("T")[0];
        const response = await $fetch(
          `https://api.aladhan.com/v1/timings/${today}`,
          {
            params: {
              latitude: this.location.latitude,
              longitude: this.location.longitude,
              method: 2, // Islamic Society of North America
            },
          }
        );

        this.prayerTimes = {
          fajr: response.data.timings.Fajr,
          sunrise: response.data.timings.Sunrise,
          dhuhr: response.data.timings.Dhuhr,
          asr: response.data.timings.Asr,
          maghrib: response.data.timings.Maghrib,
          isha: response.data.timings.Isha,
        };
      } catch (err) {
        this.error = "Failed to fetch prayer times";
        console.error(err);
      } finally {
        this.loading = false;
      }
    },

    updateCurrentTime() {
      this.currentTime = new Date();
    },

    isNextPrayer(time: string): boolean {
      const now = this.currentTime;
      const [hours, minutes] = time.split(":").map(Number);
      const prayerTime = new Date(now);
      prayerTime.setHours(hours, minutes, 0, 0);

      // Check if this is the next prayer
      const allTimes = this.prayerTimes;
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
    },

    isPrayerPassed(time: string): boolean {
      const now = this.currentTime;
      const [hours, minutes] = time.split(":").map(Number);
      const prayerTime = new Date(now);
      prayerTime.setHours(hours, minutes, 0, 0);

      return prayerTime < now;
    },

    async updateLocation(latitude: number, longitude: number) {
      this.location.latitude = latitude;
      this.location.longitude = longitude;

      // Update city name using reverse geocoding or API
      try {
        const response = await $fetch(
          `https://api.aladhan.com/v1/qibla/${latitude}/${longitude}`
        );
        this.qiblaDirection = response.data.direction;
      } catch (err) {
        console.error("Failed to update Qibla direction", err);
      }

      await this.fetchPrayerTimes();
    },
  },
});
