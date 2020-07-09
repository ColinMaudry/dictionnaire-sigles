module.exports = {
  publicPath: process.env.NODE_ENV === 'production'
    ? '/dictionnaire-sigles/'
    : '/',
  productionSourceMap: false
}

