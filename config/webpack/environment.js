const { environment } = require('@rails/webpacker')
const erb =  require('./loaders/erb')

//environment.loaders.insert('erb', erb, { before: 'babel' })
environment.loaders.append('erb', erb)
module.exports = environment
