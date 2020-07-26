process.env.VUE_APP_NBTERMS = require('./package.json').config.nbTerms
process.env.VUE_APP_RESOURCEURL = require('./package.json').config.resourceUrl

const MarkdownIt = require('markdown-it')
const md = new MarkdownIt()

module.exports = {
  productionSourceMap: false,
  configureWebpack: {
  module: {
    rules: [
      {
        test: /\.md$/,
        loader: 'ware-loader',
        enforce: 'pre',
        options: {
          raw: true,
          middleware: function(source) {
            return `<template><div>${md.render(source)}</div></template>`
          }
        }
      },
      {
        test: /\.md$/,
        use: 'vue-loader'
      }
    ]
  }
}
}
