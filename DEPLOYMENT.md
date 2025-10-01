`# GitHub Pages Deployment

## Setup Instructions

1. **Enable GitHub Pages in Repository Settings:**

   - Go to your repository on GitHub
   - Navigate to `Settings` > `Pages`
   - Under "Source", select `GitHub Actions`

2. **Manual Deployment:**

   - Go to the `Actions` tab in your GitHub repository
   - Click on "Deploy to GitHub Pages" workflow
   - Click "Run workflow" button
   - Select the branch (usually `main`) and click "Run workflow"

3. **First-time Setup:**
   - Make sure your repository name matches the `baseURL` in `nuxt.config.ts`
   - The current setup expects repository name: `unisnu-pemrograman-mobile-lanjut-saku-muslim`

## Build Configuration

The Nuxt app is configured for static site generation with:

- **SSR disabled** for GitHub Pages compatibility
- **Prerendered routes** for all main pages
- **Base URL** configured for GitHub Pages subdirectory

## Deployment Process

When you trigger the workflow:

1. **Build Step:** Installs dependencies and builds the Nuxt app
2. **Deploy Step:** Uploads the generated static files to GitHub Pages

## Access Your App

After successful deployment, your app will be available at:

```
https://rioprastiawan.github.io/unisnu-pemrograman-mobile-lanjut-saku-muslim/
```

## Troubleshooting

- Ensure GitHub Pages is enabled in repository settings
- Check that all routes are included in the `prerender.routes` array
- Verify the `baseURL` matches your repository name
- Monitor the Actions tab for any build errors
