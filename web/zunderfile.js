require('zunder').setConfig({
  deployBranch: 'production',
  staticGlobs: {
    'static/**': '',
    'node_modules/font-awesome/fonts/**': '/fonts',
  },
})
