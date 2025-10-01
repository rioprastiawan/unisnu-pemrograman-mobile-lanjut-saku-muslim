// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: "2025-07-15",
  devtools: { enabled: true },
  ssr: false, // Disable SSR for GitHub Pages
  nitro: {
    prerender: {
      routes: [
        "/",
        "/quran",
        "/dua",
        "/qibla",
        "/zakat",
        "/inheritance",
        "/calendar",
        "/settings",
        "/en",
        "/en/quran",
        "/en/dua",
        "/en/qibla",
        "/en/zakat",
        "/en/inheritance",
        "/en/calendar",
        "/en/settings",
      ],
    },
  },
  modules: [
    "@nuxtjs/tailwindcss",
    "@pinia/nuxt",
    "@vueuse/nuxt",
    "@nuxtjs/google-fonts",
    "@nuxtjs/i18n",
  ],
  i18n: {
    defaultLocale: "id",
    locales: [
      {
        code: "id",
        name: "Bahasa Indonesia",
        file: "id.json",
      },
      {
        code: "en",
        name: "English",
        file: "en.json",
      },
    ],
    langDir: "locales/",
    strategy: "prefix_except_default",
  },
  googleFonts: {
    families: {
      Inter: [400, 500, 600, 700],
      Amiri: [400, 700], // For Arabic text
    },
  },
  css: ["~/assets/css/main.css"],
  app: {
    baseURL:
      process.env.NODE_ENV === "production"
        ? "/unisnu-pemrograman-mobile-lanjut-saku-muslim/"
        : "/",
    head: {
      title: "Saku Muslim",
      meta: [
        { charset: "utf-8" },
        { name: "viewport", content: "width=device-width, initial-scale=1" },
        {
          name: "description",
          content:
            "Aplikasi Saku Muslim - Waktu Sholat, Kiblat, Al-Quran, dan lebih banyak lagi",
        },
      ],
    },
  },
});
