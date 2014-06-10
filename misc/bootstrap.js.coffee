
# Bootstrap v3.1.0 (http://getbootstrap.com)
# Copyright 2011-2014 Twitter, Inc.
# Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)

if typeof jQuery === 'undefined'
  throw new Error 'Bootstrap requires jQuery'

###
========================================================================
Bootstrap: transition.js v3.1.0
http://getbootstrap.com/javascript/#transitions
========================================================================
Copyright 2011-2014 Twitter, Inc.
Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
========================================================================
###

+(jQuery) ->
  'use strict'

  # CSS TRANSITION SUPPORT (Shoutout: http://www.modernizr.com/)
  # ============================================================

  transitionEnd = ->
    transEndEventNames = {
      'WebkitTransition' : 'webkitTransitionEnd',
      'MozTransition'    : 'transitionend',
      'OTransition'      : 'oTransitionEnd otransitionend',
      'transition'       : 'transitionend'
    }

    el = document.createElement 'bootstrap'

    for name in transEndEventNames
      end: transEndEventNames[name] if el.style[name] !== undefined

    false # explicit for ie8 (  ._.)

  # http://blog.alexmaccaw.com/css-transitions
  $.fn.emulateTransitionEnd = (duration) ->
    called = false, $el = this
    $(this).one $.support.transition.end, ->
      called = true

    callback = ->
      $($el).trigger $.support.transition.end unless called

    setTimeout(callback, duration)
    this

  $ ->
    $.support.transition = transitionEnd()

# Translated through line 56 in bootstrap.js

###
========================================================================
Bootstrap: alert.js v3.1.0
http://getbootstrap.com/javascript/#alerts
========================================================================
Copyright 2011-2014 Twitter, Inc.
Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
========================================================================
###

+($) ->
  'use strict'

  # ALERT CLASS DEFINITION
  # ======================

  dismiss = '[data-dismiss="alert"]'
  Alert   = (el) ->
    $(el).on( 'click', dismiss, this.close)

  Alert.prototype.close = (e) ->
    $this    = $(this)
    selector = $this.attr 'data-target'

    unless selector
      selector = $this.attr 'href'
      selector = selector && selector.replace /.*?=#[^\s]*$)/, '' # strip for ie7
    
    parent = $(selector)

    e.preventDefault() if e

    unless $parent.length
      $parent = if $this.hasClass 'alert' then $this; else $this.parent()

    $parent.trigger(e = $.Event 'close.bs.alert')
    break if e.isDefaultPrevented()

    $parent.removeClass 'in'

    removeElement = ->
      $parent.trigger('closed.bs.alert').remove()

    if $.support.transition && $parent.hasclass 'fade'
      $parent
        .one($.support.transition.end, removeElement)
        .emulateTransitionEnd(150)
        else 
          removeElement()

  # ALERT PLUGIN DEFINITION
  # =======================

  old = $.fn.alert 
  $.fn.alert = (option) ->
    this.each ->
      $this = $(this)
      data  = $this.data('bs.alert')

      $this.data '(bs.alert', (data = new Alert(this)) unless data
        data[option].call($this) if typeof option == 'string'

  $.fn.alert.Constructor = Alert

  # ALERT NO CONFLICT
  # =================

  $.fn.alert.noConflict = ->
    $.fn.alert = old
    this

  # ALERT DATA-API
  # ==============

  $(document). on 'click.bs.alert.data-api', dismiss, Alert.prototype.close

###
========================================================================
Bootstrap: button.js v3.1.0
http://getbootstrap.com/javascript/#buttons
========================================================================
Copyright 2011-2014 Twitter, Inc.
Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
========================================================================
###

+($) ->
  'use strict'

  # BUTTON PUBLIC CLASS DEFINITION
  # ==============================

  Button = (element, options) ->
    this.$element  = $(element)
    this.options   = $.extend( {}, Button.DEFAULTS, options)
    this.isLoading = false

  Button.DEFAULTS = {
    loadingText: 'loading...'
  }

  Button.prototype.setState = (state) ->
    d    = 'disabled'
    $el  = this.$element
    val  = if $el.is 'input' then 'val'; else 'html'
    data = $el.data()

    state = state + 'Text'

    $el.data 'resetText', $el[val]() unless data.resetText

    $el[val](data[state] || this.options[state])

    # push to event loop to allow forms to submit
    set Timeout($.proxy( -> 
      if state == 'loadingText'
        this.isLoading = true
        $el.addClass(d).attr(d, d)
      else if this.isLoading
        this.isLoading = false
        $el.removeClass(d).removeAttr d 
      ), this), 0

  Button.prototype.toggle = ->
    changed = true 
    $parent = this.$element.closest '[data-toggle="buttons"]'
    if $parent.length
      $input = this.$element.find 'input'
      if $input.prop 'type' == 'radio'
        if ($input.prop 'checked') && (this.$element.hasClass 'active') 
          changed = false
        else 
          $parent.find('.active').removeClass 'active'

        $input.prop('checked', !this.$element.hasClass 'active').trigger 'change' if changed

      this.$element.toggleClass 'active' if changed

  $.fn.button = (option) ->
    this.each ->
      $this   = $(this)
      data    = $this.data('bs.button')
      options = typeof option == 'object' && option

      $this.data 'bs.button', (data = new Button(this, options)) unless data
      if option == 'toggle' then data.toggle() else if option then data.setState option

  $.fn.button.Constructor = Button

  # BUTTON NO CONFLICT
  # ==================

  $.fn.button.noConflict = ->
    $.fn.button = old 
    this 

  # BUTTON DATA-API
  # ===============

  $(document).on 'click.bs.button.data-api', '[data-toggle^=button]', (e) ->
    $btn = $(e.target)
    $btn = $btn.closest('.btn') unless $btn.hasClass 'btn'
    $btn.button('toggle')
    e.preventDefault()

###
========================================================================
Bootstrap: carousel.js v3.1.0
http://getbootstrap.com/javascript/#carousel
========================================================================
Copyright 2011-2014 Twitter, Inc.
Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
========================================================================
###

# The next line to be translated in bootstrap.js is line #264