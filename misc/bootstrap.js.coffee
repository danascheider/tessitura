
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
========================================================================
###

+($) ->
  'use strict'

  # DROPDOWN CLASS DEFINITION
  # =========================

  backdrop = '.dropdown-backdrop'
  toggle   = '[data-toggle=dropdown']
  Dropdown = (element) ->
    $(element).on 'click.bs.dropdown', this.toggle

  Dropdown.prototype.toggle = (e) ->
    $this = $(this)

    return if $this.is '.disabled, :disabled'

    $parent  = getParent $this
    isActive = $parent.hasClass 'open'

    clearMenus

    unless isActive
      if 'ontouchstart' in document.documentElement && !$parent.closest('.navbar-nav').length
        # if mobile use a backdrop because click events don't delegate
        $('<div class="dropdown-backdrop"/>').insertAfter($(this)).on 'click', clearMenus

      return if e.isDefaultPrevented

      $parent.toggleClass('open').trigger 'shown.bs.dropdown', relatedTarget

      $this.focus

    false

  Dropdown.prototype.keydown = (e) ->
    return unless /(38|40|27)/.test e.keyCode

    $this = $(this)

    e.preventDefault
    e.stopPropagation

    return if $this.is 'disabled, :disabled'

    $parent  = getParent $this
    isActive = $parent.hasClass 'open'

    if (isActive && e.keyCode == 27) || !isActive
      if e.which == 27 then $parent.find(toggle).focus
      $this.click

    desc   = ' li:not(.divider):visible a'
    $items = $parent.find '[role=menu]' + desc + ', [role=listbox]' + desc

    return unless $items.length

    index = $items.index $items.filter(':focus')

    index--   if e.keyCode == 38 && index > 0
    index++   if e.keyCode == 40 && index < $items.length - 1
    index = 0 unless ~index

    $items.eq(index).focus

  clearMenus(e) ->
    $(backdrop).remove
    $(toggle).each ->
      $parent = getParent $(this)
      relatedTarget = { relatedTarget: this }
      return unless $parent.hasClass 'open'
      $parent.trigger e = $.Event('hide.bs.dropdown', relatedTarget)
      return if e.isDefaultPrevented
      $parent.removeClass('open').trigger 'hidden.bs.dropdown', relatedTarget

  getParent($this) ->
    selector = $this.attr('data-target')

    unless selector
      selector = $this.attr 'href'
      selector = selector && /#[A-Za-z]/.test selector && selector.replace /.*(?=[^\s]*$)/, '' # strip for ie7

    $parent = selector && $(selector)

    $parent && ( if $parent.length then $parent else $this.parent )

  # DROPDOWN PLUGIN DEFINITION
  # ==========================

  old = $.fn.dropdown

  $.fn.dropdown = (option) ->
    this.each ->
      $this = $(this)
      data  = $this.data 'bs.dropdown'
      $this.data 'bs.dropdown', (data = newDropdown(this)) unless data
      data[option].call $this if typeof option == 'string'

  $.fn.dropdown.Constructor = Dropdown

  # DROPDOWN NO CONFLICT 
  # ====================

  $.fn.dropdown.noConflict = ->
    $.fn.dropdown = old
    this

  # APPLY TO STANDARD DROPDOWN ELEMENTS
  # ===================================

  $(document)
    .on('click.bs.dropdown.data-api', clearMenus)
    .on('click.bs.dropdown.data-api', '.dropdown form', (e) ->
      e.stopPropagation
    ).on('click.bs.dropdown.data-api', toggle, Dropdown.prototype.toggle)
    .on 'keydown.bs.dropdown.data-api', toggle + ', [role=menu], [role=listbox]', Dropdown.prototype.keydown

###
========================================================================
Bootstrap: modal.js v3.1.0
http://getbootstrap.com/javascript/#modals
========================================================================
Copyright 2011-2014 Twitter, Inc.
Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
========================================================================
###

###
+function ($) {
  'use strict';

  // MODAL CLASS DEFINITION
  // ======================

  var Modal = function (element, options) {
    this.options   = options
    this.$element  = $(element)
    this.$backdrop =
    this.isShown   = null

    if (this.options.remote) {
      this.$element
        .find('.modal-content')
        .load(this.options.remote, $.proxy(function () {
          this.$element.trigger('loaded.bs.modal')
        }, this))
    }
  }

  Modal.DEFAULTS = {
    backdrop: true,
    keyboard: true,
    show: true
  }

  Modal.prototype.toggle = function (_relatedTarget) {
    return this[!this.isShown ? 'show' : 'hide'](_relatedTarget)
  }

  Modal.prototype.show = function (_relatedTarget) {
    var that = this
    var e    = $.Event('show.bs.modal', { relatedTarget: _relatedTarget })

    this.$element.trigger(e)

    if (this.isShown || e.isDefaultPrevented()) return

    this.isShown = true

    this.escape()

    this.$element.on('click.dismiss.bs.modal', '[data-dismiss="modal"]', $.proxy(this.hide, this))

    this.backdrop(function () {
      var transition = $.support.transition && that.$element.hasClass('fade')

      if (!that.$element.parent().length) {
        that.$element.appendTo(document.body) // don't move modals dom position
      }

      that.$element
        .show()
        .scrollTop(0)

      if (transition) {
        that.$element[0].offsetWidth // force reflow
      }

      that.$element
        .addClass('in')
        .attr('aria-hidden', false)

      that.enforceFocus()

      var e = $.Event('shown.bs.modal', { relatedTarget: _relatedTarget })

      transition ?
        that.$element.find('.modal-dialog') // wait for modal to slide in
          .one($.support.transition.end, function () {
            that.$element.focus().trigger(e)
          })
          .emulateTransitionEnd(300) :
        that.$element.focus().trigger(e)
    })
  }

  Modal.prototype.hide = function (e) {
    if (e) e.preventDefault()

    e = $.Event('hide.bs.modal')

    this.$element.trigger(e)

    if (!this.isShown || e.isDefaultPrevented()) return

    this.isShown = false

    this.escape()

    $(document).off('focusin.bs.modal')

    this.$element
      .removeClass('in')
      .attr('aria-hidden', true)
      .off('click.dismiss.bs.modal')

    $.support.transition && this.$element.hasClass('fade') ?
      this.$element
        .one($.support.transition.end, $.proxy(this.hideModal, this))
        .emulateTransitionEnd(300) :
      this.hideModal()
  }

  Modal.prototype.enforceFocus = function () {
    $(document)
      .off('focusin.bs.modal') // guard against infinite focus loop
      .on('focusin.bs.modal', $.proxy(function (e) {
        if (this.$element[0] !== e.target && !this.$element.has(e.target).length) {
          this.$element.focus()
        }
      }, this))
  }

  Modal.prototype.escape = function () {
    if (this.isShown && this.options.keyboard) {
      this.$element.on('keyup.dismiss.bs.modal', $.proxy(function (e) {
        e.which == 27 && this.hide()
      }, this))
    } else if (!this.isShown) {
      this.$element.off('keyup.dismiss.bs.modal')
    }
  }

  Modal.prototype.hideModal = function () {
    var that = this
    this.$element.hide()
    this.backdrop(function () {
      that.removeBackdrop()
      that.$element.trigger('hidden.bs.modal')
    })
  }

  Modal.prototype.removeBackdrop = function () {
    this.$backdrop && this.$backdrop.remove()
    this.$backdrop = null
  }

  Modal.prototype.backdrop = function (callback) {
    var animate = this.$element.hasClass('fade') ? 'fade' : ''

    if (this.isShown && this.options.backdrop) {
      var doAnimate = $.support.transition && animate

      this.$backdrop = $('<div class="modal-backdrop ' + animate + '" />')
        .appendTo(document.body)

      this.$element.on('click.dismiss.bs.modal', $.proxy(function (e) {
        if (e.target !== e.currentTarget) return
        this.options.backdrop == 'static'
          ? this.$element[0].focus.call(this.$element[0])
          : this.hide.call(this)
      }, this))

      if (doAnimate) this.$backdrop[0].offsetWidth // force reflow

      this.$backdrop.addClass('in')

      if (!callback) return

      doAnimate ?
        this.$backdrop
          .one($.support.transition.end, callback)
          .emulateTransitionEnd(150) :
        callback()

    } else if (!this.isShown && this.$backdrop) {
      this.$backdrop.removeClass('in')

      $.support.transition && this.$element.hasClass('fade') ?
        this.$backdrop
          .one($.support.transition.end, callback)
          .emulateTransitionEnd(150) :
        callback()

    } else if (callback) {
      callback()
    }
  }


  // MODAL PLUGIN DEFINITION
  // =======================

  var old = $.fn.modal

  $.fn.modal = function (option, _relatedTarget) {
    return this.each(function () {
      var $this   = $(this)
      var data    = $this.data('bs.modal')
      var options = $.extend({}, Modal.DEFAULTS, $this.data(), typeof option == 'object' && option)

      if (!data) $this.data('bs.modal', (data = new Modal(this, options)))
      if (typeof option == 'string') data[option](_relatedTarget)
      else if (options.show) data.show(_relatedTarget)
    })
  }

  $.fn.modal.Constructor = Modal


  // MODAL NO CONFLICT
  // =================

  $.fn.modal.noConflict = function () {
    $.fn.modal = old
    return this
  }


  // MODAL DATA-API
  // ==============

  $(document).on('click.bs.modal.data-api', '[data-toggle="modal"]', function (e) {
    var $this   = $(this)
    var href    = $this.attr('href')
    var $target = $($this.attr('data-target') || (href && href.replace(/.*(?=#[^\s]+$)/, ''))) //strip for ie7
    var option  = $target.data('bs.modal') ? 'toggle' : $.extend({ remote: !/#/.test(href) && href }, $target.data(), $this.data())

    if ($this.is('a')) e.preventDefault()

    $target
      .modal(option, this)
      .one('hide', function () {
        $this.is(':visible') && $this.focus()
      })
  })

  $(document)
    .on('show.bs.modal', '.modal', function () { $(document.body).addClass('modal-open') })
    .on('hidden.bs.modal', '.modal', function () { $(document.body).removeClass('modal-open') })

}(jQuery);

/* ========================================================================
 * Bootstrap: tooltip.js v3.1.0
 * http://getbootstrap.com/javascript/#tooltip
 * Inspired by the original jQuery.tipsy by Jason Frame
 * ========================================================================
 * Copyright 2011-2014 Twitter, Inc.
 * Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
 * ======================================================================== */

 LINE 1033 OF BOOTSTRAP.JS
###