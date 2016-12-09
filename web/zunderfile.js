require('zunder').setConfig({
  appCache: true,
  appCacheTransform (files) {
    return files.map((file) => {
      if (/fontawesome/.test(file)) {
        file = `${file}?v=4.7.0`
      }
      return file
    })
  },
  deployBranch: 'production',
  staticGlobs: {
    'static/**': '',
    'node_modules/font-awesome/fonts/**': '/fonts',
  },
})
