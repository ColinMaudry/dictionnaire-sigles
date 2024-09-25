process.env.VUE_APP_NBTERMS = require('./package.json').config.nbTerms
process.env.VUE_APP_RESOURCEID = require('./package.json').config.resourceId


module.exports = {
  productionSourceMap: false
}
