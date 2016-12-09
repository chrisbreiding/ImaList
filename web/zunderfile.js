require('zunder').setConfig({
  appCache: true,
  deployBranch: 'production',
  staticGlobs: {
    'static/**': '',
    'node_modules/font-awesome/fonts/**': '/fonts',
  },
})
