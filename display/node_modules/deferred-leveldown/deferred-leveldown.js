var AbstractLevelDOWN = require('abstract-leveldown').AbstractLevelDOWN
var inherits = require('inherits')
var DeferredIterator = require('./deferred-iterator')
var deferrables = 'put get del batch clear'.split(' ')
var optionalDeferrables = 'approximateSize compactRange'.split(' ')

function DeferredLevelDOWN (db) {
  AbstractLevelDOWN.call(this, '')
  this._db = db
  this._operations = []
  closed(this)
}

inherits(DeferredLevelDOWN, AbstractLevelDOWN)

DeferredLevelDOWN.prototype.type = 'deferred-leveldown'

DeferredLevelDOWN.prototype._open = function (options, callback) {
  var self = this

  this._db.open(options, function (err) {
    if (err) return callback(err)

    self._operations.forEach(function (op) {
      if (op.iterator) {
        op.iterator.setDb(self._db)
      } else {
        self._db[op.method].apply(self._db, op.args)
      }
    })
    self._operations = []

    open(self)
    callback()
  })
}

DeferredLevelDOWN.prototype._close = function (callback) {
  var self = this

  this._db.close(function (err) {
    if (err) return callback(err)
    closed(self)
    callback()
  })
}

function open (self) {
  deferrables.concat('iterator').forEach(function (m) {
    self['_' + m] = function () {
      return this._db[m].apply(this._db, arguments)
    }
  })
  optionalDeferrables.forEach(function (m) {
    if (typeof self._db[m] === 'function') {
      self[m] = function () {
        return this._db[m].apply(this._db, arguments)
      }
    }
  })
}

function closed (self) {
  deferrables.forEach(function (m) {
    self['_' + m] = function () {
      this._operations.push({ method: m, args: arguments })
    }
  })
  optionalDeferrables.forEach(function (m) {
    if (typeof self._db[m] === 'function') {
      self[m] = function () {
        this._operations.push({ method: m, args: arguments })
      }
    }
  })
  self._iterator = function (options) {
    var it = new DeferredIterator(options)
    this._operations.push({ iterator: it })
    return it
  }
}

DeferredLevelDOWN.prototype._serializeKey = function (key) {
  return key
}

DeferredLevelDOWN.prototype._serializeValue = function (value) {
  return value
}

module.exports = DeferredLevelDOWN
module.exports.DeferredIterator = DeferredIterator
