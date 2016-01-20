_ = require 'lodash'
Promise = if window?
  window.Promise
else
  # TODO: remove once v8 is updated
  # Avoid webpack include
  bluebird = 'bluebird'
  require bluebird

class Environment
  isMobile: ->
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
    ///.test navigator?.userAgent

  isFacebook: ->
    window? and window.name.indexOf('canvas_fb') isnt -1

  isAndroid: ->
    _.contains navigator?.appVersion, 'Android'

  isiOS: ->
    Boolean navigator?.appVersion.match /iP(hone|od|ad)/g

  isGameApp: (gameKey) ->
    Boolean gameKey and
      _.contains navigator?.userAgent?.toLowerCase(), " #{gameKey}/"

  isGameChromeApp: (gameKey) ->
    Boolean gameKey and
      _.contains navigator?.userAgent?.toLowerCase(), "chrome/#{gameKey}/"

  getAppVersion: (gameKey) ->
    regex = new RegExp("#{gameKey}\/([0-9\.]+)")
    matches = navigator.userAgent.match(regex)
    matches?[1]

  isClayApp: ->
    _.contains navigator?.userAgent?.toLowerCase(), 'clay/'

  isKikEnabled: ->
    Boolean window?.kik?.enabled

  getPlatform: ({gameKey} = {}) =>
    if @isFacebook() then 'facebook'
    else if @isKikEnabled then 'kik'
    else if @isGameChromeApp(gameKey) then 'game_chrome_app'
    else if @isGameApp(gameKey) then 'game_app'
    else if @isClayApp() then 'clay_app'
    else 'web'

module.exports = new Environment()
