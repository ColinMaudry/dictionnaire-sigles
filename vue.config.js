process.env.VUE_APP_NBTERMS = require('./package.json').config.nbTerms
process.env.VUE_APP_RESOURCEURL = require('./package.json').config.resourceUrl

module.exports = {
  productionSourceMap: false
}
