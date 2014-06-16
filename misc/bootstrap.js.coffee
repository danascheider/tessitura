
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

+($) ->
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

+($) ->
  'use strict'

  # CAROUSEL CLASS DEFINITION
  # =========================

  Carousel = (element, options) ->
    this.$element    = $(element)
    this.$indicators = this.$element.find('.carousel-indicators')
    this.options     = options
    # Assignments with nothing on the left include
    # this.paused, this.sliding, this.interval, this.$active
    this.$items      = null

    this.options.pause == 'hover' && this.$element
      .on('mouseenter', $.proxy(this.pause, this))
      .on('mouseleave', $.proxy(this.cycle, this))

  Carousel.DEFAULTS = {
    interval: 5000,
    pause: 'hover',
    wrap: true
  }

  Carousel.prototype.cycle = (e) ->
    e || (this.paused = false)

    this.interval && clearInterval(this.interval)

    this.options.interval 
      && !this.paused
      && (this.interval = setInterval $.proxy(this.next, this), this.options.interval)

    this

  Carousel.prototype.getActiveIndex = ->
    this.$active = this.$element.find '.item.active'
    this.$items  = this.$active.parent().children()

    this.$items.index(this.$active)

  Carousel.prototype.to = (pos) ->
    that        = this
    activeIndex = this.getActiveIndex

    return if (pos > (this.$items.length - 1) || pos < 0)

    if (this.sliding) then return this.$element.one 'slid.bs.carousel', ->
      that.to(pos)

    if activeIndex == pos
      this.pause().cycle()

    this.slide(if poas > activeIndex then 'next' else 'prev', $(this.$items[pos]))

  Carousel.prototype.pause = (e) ->
    e || (this.paused = true)

    if this.$element.find('.next, .prev').length && $.support.transition
      this.$element.trigger $.support.transition.end
      this.cycle true

    this.interval = clearInterval this.interval

    this

  Carousel.prototype.prev = ->
    return if this.sliding
    return this.slide('prev')

  Carousel.prototype.slide = (type, next) ->
    $active   = this.$element.find '.item.active'
    $next     = next || $active[type]
    isCycling = this.interval
    direction = if type == 'next' then 'left' else 'right'
    fallback  = if type == 'next' then 'first' else 'last'
    that      = this

    unless $next.length
      return unless this.options.wrap
      $next = this.$element.find('.item')[fallback]

    return (this.sliding = false) if $next.hassClass 'active'

    e = $.Event('slide.bs.carousel'), { relatedTarget: $next[0], direction: direction }
    this.$element.trigger e 
    return if e.isDefaultPrevented

    this.sliding = true

    isCycling && this.pause()

    if this.$indicators.length 
      this.$indicators.find('.active').removeClass 'active'
      this.$element.one 'slid.bs.carousel', ->
        $nextIndicator = $(that.$indicators.children[that.getActiveIndex])
        $nextIndicator && $nextIndicator.addClass('active')

    if $.support.transition && this.$element.hasClass 'slide'
      $next.addclass type 
        $next[0].offsetWidth # force reflow
        $active.addClass(direction)
        $next.addclass(direction)
        $.active
          .one $.support.transition.end, ->
            $next.removeClass([type, direction].join ' ').addClass 'active'
            $active.removeClass(['active', direction].join ' ')
            that.sliding = false
            setTimeout( ->
              that.$element.trigger 'slid.bs.carousel', 0
              )
          .emulateTransitionEnd $active.css('transition-duration').slice(0, -1) * 1000
    else 
      $active.removeClass('active')
      $next.addClass('active')
      this.sliding = false 
      this.$element.trigger 'slid.bs.carousel'

    isCycling && this.cycle 

    this 

  # CAROUSEL PLUGIN DEFINITION
  # ==========================

  old = $.fn.carousel 

  $.fn.carousel = (option) ->
    this.each( ->
      $this   = $(this) 
      data    = $this.data('bs.carousel')
      options = $.extend {}, Carousel.DEFAULTS, $this.data, (typeof option == 'object' && option)
      action  = if typeof option == 'string' then option else options.slide

      $this.data'bs.carousel', (data = new Carousel(this, options)) unless data 
      if typeof option == 'number' then data.to option 
      else if action then data[action] 
      else if options.interval then data.pause().cycle
      )

  $.fn.carousel.Contructor = Carousel

  # CAROUSEL NO CONFLICT
  # ====================

  $.fn.carousel.noConflict = ->
    $.fn.carousel = old
    return this

  # CAROUSEL DATA-API
  # =================

  $(document).on('click.bs.carousel.data-api', '[data-slide], [data-slide-to]', (e) ->
    $this   = $(this), href
    $target = $($this.attr 'data-target' || (href = $this.attr 'href' && href.replace /.*(?=#[^\s]+$)/, '')) # strip for ie7
    options = $.extend {}, $target.data, $this.data 
    slideIndex = $this.attr 'data-slide-to'
    options.interval = false if slideIndex

    $target.carousel options

    if slideIndex = $this.attr 'data-slide-to'
      $target.data('bs.carousel').to(slideIndex)

    e.preventDefault

  $(window).on 'load', ->
    $('[data-ride="carousel"]').each ->
      $carousel = $(this) 
      $carousel.carousel $carousel.data

###
========================================================================
Bootstrap: collapse.js v3.1.0
http://getbootstrap.com/javascript/#collapse
========================================================================
Copyright 2011-2014 Twitter, Inc.
Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
========================================================================
###

+($) ->
  'use strict'

  # COLLAPSE PUBLIC CLASS DEFINITION
  # ================================

  Collapse = (element, options) ->
    this.$element      = $(element)
    this.options       = $.extend {}, Collapse.DEFAULTS, options 
    this.transitioning = null

    this.$parent  = $(this.options.parent) if this.options.parent
    this.toggle if this.options.toggle

  Collapse.DEFAULTS = { toggle: true }

  Collapse.prototype.dimension = ->
    hasWidth = this.$element.hasClass 'width'
    if hasWidth then 'width' else 'height'

  Collapse.prototype.show = ->
    return if this.transitioning || this.$element.hasClass 'in'

    startEvent = $.Event 'show.bs.collapse'
    this.$element.trigger startEvent
    return if startEvent.isDefaultPrevented

    actives = this.$parent && this.$parent.find '> .panel > .in'

    if actives && actives.length
      hasData = actives.data 'bs.collapse'
      return if hasData && hasData.transitioning
      actives.collapse 'hide'
      hasData || actives.data 'bs.collapse', null

      dimension = this.dimension

      this.$element.removeClass('collapse').addClass('collapsing')[dimension](0)
      this.transitioning = 1

      complete = ->
        this.$element.removeClass('collapsing').addClass('collapse in')[dimension]('auto')
        this.transitioning = 0
        this.$element.trigger 'shown.bs.collapse'

      complete.call this unless $.support.transition 

      scrollSize = $.camelCase ['scroll', dimension].join('-')

      this.$element
        .one($.support.transition.end, $.proxy(complete, this))
        .emulateTransitionEnd(350)
        [dimension](this.$element[0][scrollSize])

  Collapse.prototype.hide = ->
    return if this.transitioning || !this.$element.hasClass 'in'

    startEvent = $.Event 'hide.bs.collapse'
    this.$element.trigger startEvent
    return if startEvent.isDefaultPrevented

    dimension = this.dimension

    this.$element
      [dimension](this.$element[dimension])
      [0].offsetHeight

    this.$element.addClass('collapsing').removeClass('collapse').removeClass('in')

    this.transitioning = 1

    complete = ->
      this.transitioning = 0
      this.$element.trigger('hidden.bs.collapse').removeClass('collapsing').addClass('collapse')

    complete.call this unless $.support.transition

    this.$element 
      [dimension](0)
      .one($.support.transition.end, $.proxy(complete, this))
      .emulateTransitionEnd(350)

  Collapse.prototype.toggle = ->
    index = if this.$element.hasClass 'in' then 'hide' else 'show'
    this.[index]

  # COLLAPSE PLUGIN DEFINITION
  # ==========================

  old = $.fn.collapse

  $.fn.collapse = (option) ->
    this.each( ->
      $this   = $(this)
      data    = $this.data 'bs.collapse'
      options = $.extend {}, Collapse.DEFAULTS, $.this.data, typeof option == 'object' && option 

      option = !option if !data && options.toggle && option == 'show'
      $this.data 'bs.collapse', (data = new Collapse(this, options)) unless data
      data[option] if typeof option == 'string'
      )

  $.fn.collapse.Constructor = Collapse

  # COLLAPSE NO CONFLICT
  # ====================

  $.fn.collapse.noConflict = ->
    $.fn.collapse = old
    this

  # COLLAPSE DATA-API
  # =================

  $(document).on( 'click.bs.collapse.data-api', '[data-toggle=collapse]', (e) ->
    $this   = $(this), href
    target  = $this.attr 'data-target' 
              || e.preventDefault 
              || (href = $this.attr 'href') && href.replace /.&(?=#[^\s]+$)/, '' # strip for ie7
    $target = $(target)
    data    = $target.data 'bs.collapse'
    option  = if data then 'toggle' else $this.data 
    parent  = $this.attr 'data-parent'
    $parent = parent && $(parent)

    unless data && data.transitioning
      if $parent 
        $parent.find('[data-toggle=collapse][data-parent="' + parent + '"]').not($this).addClass 'collapsed'
      method = if $target.hasClass 'in' then 'addClass' else 'removeClass'
      $this[method] 'collapsed'

    $target.collapse option
    )
  
###
========================================================================
Bootstrap: dropdown.js v3.1.0
http://getbootstrap.com/javascript/#dropdowns
========================================================================
Copyright 2011-2014 Twitter, Inc.
Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
======================================================================== */
###