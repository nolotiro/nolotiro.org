# https://github.com/reed/turbolinks-compatibility/blob/master/content/libraries/google_adsense.md

class AdSense
  constructor: (@ad_client) ->
    if google?
      google.load 'ads', '1'
      google.setOnLoadCallback @initPage
      @ads = {}
      $(document).on 'page:fetch', =>
        @clearAds()
      $(document).on 'page:load', =>
        @initPage()

  initPage: =>
    ad.load() for id, ad of @ads

  clearAds: ->
    @ads = {}
    window.google_prev_ad_slotnames_by_region[''] = '' if window.google_prev_ad_slotnames_by_region
    window.google_num_ad_slots = 0

  newAd: (container, options) ->
    id = (options.format || 'ad') + '_' + container.id
    @ads[id] = new Ad @, id, container, options

class Ad
  constructor: (@adsense, @id, @container, @options) ->

  load: ->
    if @ad_object? then @refresh() else @create()

  refresh: ->
    @ad_object.refresh()

  create: ->
    @ad_object = new google.ads.Ad @adsense.ad_client, @container, @options


window.MyAdSense = new AdSense "ca-pub-5360961269901609"
