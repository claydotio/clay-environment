should = require('clay-chai').should()
rewire = require 'rewire'

Environment = rewire '../src'

GAME_KEY = 'kittencards'
NEXUS_4_UA =  '5.0 (Linux; Android 4.2.1; en-us; Nexus 4 ' +
              'Build/JOP40D) AppleWebKit/535.19 (KHTML, like Gecko) ' +
              'Chrome/18.0.1025.166 Mobile Safari/535.19'
IPHONE_6_UA = 'Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like ' +
              'Mac OS X) AppleWebKit/600.1.3 (KHTML, like ' +
              'Gecko) Version/8.0 Mobile/12A4345d ' +
              'Safari/600.1.4'
CLAY_APP_UA = 'Mozilla/5.0 (Linux; Android 4.4.0; en-us; ' +
              'Nexus 4 Build/JOP40D) AppleWebKit/535.19 ' +
              '(KHTML, like Gecko) Clay/0.0.4' +
              'Chrome/18.0.1025.166 Mobile Safari/535.19'
GAME_APP_UA = 'Mozilla/5.0 (Linux; Android 4.4.0; en-us; ' +
              'Nexus 4 Build/JOP40D) AppleWebKit/535.19 ' +
              "(KHTML, like Gecko) #{GAME_KEY}/0.0.4" +
              'Chrome/18.0.1025.166 Mobile Safari/535.19'

describe 'Environment', ->

  describe 'isMobile', ->
    it 'true', ->
      overrides = {navigator: {appVersion: NEXUS_4_UA}}
      Environment.__with__(overrides) ->
        Environment.isAndroid().should.be.true

    it 'false', ->
      overrides = {navigator: {appVersion: 'not mob!le'}}
      Environment.__with__(overrides) ->
        Environment.isAndroid().should.be.false

  describe 'isAndroid', ->
    it 'true', ->
      overrides = {navigator: {appVersion: NEXUS_4_UA}}
      Environment.__with__(overrides) ->
        Environment.isAndroid().should.be.true

    it 'false', ->
      overrides = {navigator: {appVersion: IPHONE_6_UA}}
      Environment.__with__(overrides) ->
        Environment.isAndroid().should.be.false

  describe 'isiOS', ->
    it 'true', ->
      overrides = {navigator: {appVersion: IPHONE_6_UA}}
      Environment.__with__(overrides) ->
        Environment.isiOS().should.be.true

    it 'false', ->
      overrides = {navigator: {appVersion: NEXUS_4_UA}}
      Environment.__with__(overrides) ->
        Environment.isiOS().should.be.false

  describe 'isClayApp', ->
    it 'true', ->
      overrides = {navigator: {userAgent: CLAY_APP_UA}}
      Environment.__with__(overrides) ->
        Environment.isClayApp().should.be.true

    it 'false', ->
      overrides = {navigator: {userAgent: 'not cl@yapp'}}
      Environment.__with__(overrides) ->
        Environment.isClayApp().should.be.false

  describe 'isGameApp', ->
    it 'true', ->
      overrides = {navigator: {userAgent: GAME_APP_UA}}
      Environment.__with__(overrides) ->
        Environment.isGameApp(GAME_KEY).should.be.true

    it 'false (missing gameUserAgentId)', ->
      overrides = {navigator: {userAgent: GAME_APP_UA}}
      Environment.__with__(overrides) ->
        Environment.isGameApp().should.be.false

    it 'false', ->
      overrides = {navigator: {userAgent: 'not cl@yapp'}}
      Environment.__with__(overrides) ->
        Environment.isGameApp(GAME_KEY).should.be.false

  describe 'isKikEnabled', ->
    it 'true', ->
      overrides =
        PortalService:
          registerMethods: -> null
          call: (method) ->
            method.should.be 'kik.isEnabled'
            Promise.resolve true

      Environment.__with__(overrides) ->
        Environment.isKikEnabled().then (isKikEnabled) ->
          isKikEnabled.should.be true

    it 'false', ->
      overrides =
        PortalService:
          registerMethods: -> null
          call: (method) ->
            method.should.be 'kik.isEnabled'
            Promise.resolve false

      Environment.__with__(overrides) ->
        Environment.isKikEnabled().then (isKikEnabled) ->
          isKikEnabled.should.be false

  describe 'getPlatform', ->
    it 'kik', ->
      Environment.isKikEnabledCopy = Environment.isKikEnabled
      Environment.isKikEnabled = -> Promise.resolve true
      Environment.getPlatform().then (platform) ->
        Environment.isKikEnabled = Environment.isKikEnabledCopy
        platform.should.be 'kik'
