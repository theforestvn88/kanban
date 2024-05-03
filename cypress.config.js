const { defineConfig } = require('cypress')

module.exports = defineConfig({
  // setupNodeEvents can be defined in either
  // the e2e or component configuration
  e2e: {
    setupNodeEvents(on, config) {
      on('before:browser:launch', (browser = {}, launchOptions) => {
        /* ... */
      })
    },
  },
  screenshotsFolder: "tmp/cypress_screenshots",
  defaultCommandTimeout: 10000,
  trashAssetsBeforeRuns: false,
  video: false,
})
