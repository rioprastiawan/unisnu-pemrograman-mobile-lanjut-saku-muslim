export const useTheme = () => {
  const isDark = ref(false);
  const colorMode = useColorMode();

  // Initialize theme from localStorage or system preference
  onMounted(() => {
    if (process.client) {
      const savedTheme = localStorage.getItem("theme");
      if (savedTheme) {
        isDark.value = savedTheme === "dark";
      } else {
        // Use system preference
        isDark.value = window.matchMedia(
          "(prefers-color-scheme: dark)"
        ).matches;
      }
      applyTheme();
    }
  });

  const toggleTheme = () => {
    isDark.value = !isDark.value;
    applyTheme();
    if (process.client) {
      localStorage.setItem("theme", isDark.value ? "dark" : "light");
    }
  };

  const applyTheme = () => {
    if (process.client) {
      const html = document.documentElement;
      if (isDark.value) {
        html.classList.add("dark");
        html.classList.remove("light");
      } else {
        html.classList.add("light");
        html.classList.remove("dark");
      }
    }
  };

  const themeClasses = computed(() => ({
    // Background gradients
    "bg-gradient-to-br from-green-50 to-emerald-50": !isDark.value,
    "dark:bg-gradient-to-br dark:from-gray-900 dark:to-gray-800": isDark.value,

    // Card backgrounds
    "bg-white/70": !isDark.value,
    "dark:bg-gray-800/70": isDark.value,

    // Text colors
    "text-gray-900": !isDark.value,
    "dark:text-gray-100": isDark.value,

    // Border colors
    "border-green-100": !isDark.value,
    "dark:border-gray-700": isDark.value,
  }));

  const cardClasses = computed(() => [
    "backdrop-blur-sm rounded-xl border transition-colors",
    isDark.value
      ? "bg-gray-800/80 border-gray-700 text-gray-100"
      : "bg-white/70 border-green-100 text-gray-900",
  ]);

  const inputClasses = computed(() => [
    "w-full p-3 rounded-lg border focus:outline-none focus:ring-2 transition-colors",
    isDark.value
      ? "bg-gray-700 border-gray-600 text-gray-100 focus:ring-green-400 placeholder-gray-400"
      : "bg-white border-gray-200 text-gray-900 focus:ring-green-200 placeholder-gray-500",
  ]);

  const buttonClasses = computed(() => [
    "px-4 py-2 rounded-lg font-medium transition-colors",
    isDark.value
      ? "bg-green-600 hover:bg-green-700 text-white"
      : "bg-green-600 hover:bg-green-700 text-white",
  ]);

  const secondaryButtonClasses = computed(() => [
    "p-2 rounded-full transition-colors",
    isDark.value
      ? "bg-gray-700/50 hover:bg-gray-600/50 text-gray-300"
      : "bg-white/50 hover:bg-white/70 text-gray-700",
  ]);

  return {
    isDark: readonly(isDark),
    toggleTheme,
    themeClasses,
    cardClasses,
    inputClasses,
    buttonClasses,
    secondaryButtonClasses,
  };
};
