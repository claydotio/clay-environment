_ = require 'lodash'
Promise = if window?
  window.Promise
else
  # TODO: remove once v8 is updated
  # Avoid webpack include
  bluebird = 'bluebird'
  require bluebird

class Environment
  isMobile: ({userAgent} = {}) ->
    userAgent ?= navigator?.userAgent
    ///
      Mobile
    | iP(hone|od|ad)
    | Android
    | BlackBerry
    | IEMobile
    | Kindle
    | NetFront
    | Silk-Accelerated
    | (hpw|web)OS
    | Fennec
    | Minimo
    | Opera\ M(obi|ini)
    | Blazer
    | Dolfin
    | Dolphin
    | Skyfire
    | Zune
    ///.test userAgent

  isFacebook: ->
    window? and window.name.indexOf('canvas_fb') isnt -1

  isAndroid: ({userAgent} = {}) ->
    userAgent ?= navigator?.userAgent
    _.contains userAgent, 'Android'

  isiOS: ({userAgent} = {}) ->
    userAgent ?= navigator?.userAgent
    Boolean userAgent.match /iP(hone|od|ad)/g

  isGameApp: (gameKey, {userAgent} = {}) ->
    userAgent ?= navigator?.userAgent
    Boolean gameKey and
      _.contains userAgent?.toLowerCase(), " #{gameKey}/"

  isGameChromeApp: (gameKey, {userAgent}) ->
    userAgent ?= navigator?.userAgent
    Boolean gameKey and
      _.contains userAgent?.toLowerCase(), "chrome/#{gameKey}/"

  getAppVersion: (gameKey, {userAgent} = {}) ->
    userAgent ?= navigator?.userAgent
    regex = new RegExp("#{gameKey}\/([0-9\.]+)")
    matches = userAgent.match(regex)
    matches?[1]

  isClayApp: ({userAgent} = {}) ->
    userAgent ?= navigator?.userAgent
    _.contains userAgent?.toLowerCase(), 'clay/'

  isKikEnabled: ->
    Boolean window?.kik?.enabled

  getPlatform: ({gameKey, userAgent} = {}) =>
    userAgent ?= navigator?.userAgent

    if @isFacebook() then 'facebook'
    else if @isKikEnabled() then 'kik'
    else if @isGameChromeApp(gameKey, {userAgent}) then 'game_chrome_app'
    else if @isGameApp(gameKey, {userAgent}) then 'game_app'
    else if @isClayApp({userAgent}) then 'clay_app'
    else 'web'

module.exports = new Environment()
