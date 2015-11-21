_ = require 'lodash'
Promise = if window?
  window.Promise
else
  # TODO: remove once v8 is updated
  # Avoid webpack include
  bluebird = 'bluebird'
  require bluebird

if window?
  PortalService = require './services/portal'
  PortalService.registerMethods()

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

  isAndroid: ->
    _.contains navigator?.appVersion, 'Android'

  isiOS: ->
    Boolean navigator?.appVersion.match /iP(hone|od|ad)/g

  isGameApp: (gameKey) ->
    Boolean gameKey and
      _.contains navigator?.userAgent?.toLowerCase(), "#{gameKey}/"

  getAppVersion: (gameKey) ->
    regex = new RegExp("#{gameKey}\/([0-9\.]+)")
    matches = navigator.userAgent.match(regex)
    matches?[1]

  isClayApp: ->
    _.contains navigator?.userAgent?.toLowerCase(), 'clay/'

  isKikEnabled: ->
    if PortalService?
      PortalService.call 'kik.isEnabled'
    else
      Promise.resolve false

  getPlatform: ({gameKey} = {}) =>
    @isKikEnabled().then (isKik) =>
      if isKik then 'kik'
      else if @isGameApp(gameKey) then 'game_app'
      else if @isClayApp() then 'clay_app'
      else 'web'

module.exports = new Environment()
