_ = require 'lodash'
if window?
  portal = require 'portal-gun'

class PortalService
  constructor: ->
    if window?
      portal.up()

  call: ->
    unless window?
      throw new Error 'PortalService cannot be used server-side'
    portal.call.apply portal, arguments

  registerMethods: ->
    unless window?
      throw new Error 'PortalService cannot be used server-side'

    portal.on 'kik.isEnabled', -> window.kik?.enabled

module.exports = new PortalService()
