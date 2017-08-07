###                                                                   #
# This Source Code Form is subject to the terms of the Mozilla Public #
# License, v. 2.0. If a copy of the MPL was not distributed with this #
# file, You can obtain one at http://mozilla.org/MPL/2.0/.            #
#                                                                   ###

# global method
window.ssal = (params) ->

    # remove existing handlers to prepare for current alert
    window.iframehandler = null
    window.handlers = {}
    window.handlerID = null

    # get parameters for standard swal and for ssal
    swalParams = {}
    buttons = null
    for own param, value of params

        # get buttons and store them
        if param is 'buttons'
            buttons = value

        else if param is 'iframe'

            # create html for iframe
            if not params['html']?

                # create html for the given iframe values
                htmlstr = '<iframe id="swal2-iframe" frameBorder="0" width="'+value['width']+'px" height="'+value['height']+'px" src="'+value['src']+'"></iframe>'
                swalParams['html'] = htmlstr

                # if the alert is smaller than the iframe, set it to the iframe's size
                width = value['width'] + 20
                if swalParams['width'] < width then swalParams['width'] = width

            else
                # throw error if there is also html defined
                console.warning "SwalExtend: Can't have html and iframe in Sweetalert. Html is ignored."
                return

        else if param is 'width'
            if not isNaN value
                swalParams['width'] = value.toString() + 'px'

        else

            # append to default sweetalert attributes
            swalParams[param] = value

    # print error if sweetalert parameters are not defined
    if not swalParams?
        console.error "SwalExtend: Can't create Sweetalert. Parameters wrong or missing."
        return

    # print error if buttons are missing
    if not buttons?
        console.error "SwalExtend: Can't create Sweetalert. Buttons not defined."
        return

    # open a sweetalert with the paramters
    swal.apply this, [swalParams]

    # create the needed buttons
    createButtons buttons

    return

createButtons = (buttons) ->

    # get the buttoncontainer, and wait until swal is displayed
    buttoncontainer = document.getElementsByClassName('swal2-buttonswrapper')[0]

    # get default styles for cancel and confirm
    cancelStyle  = cssOfElementWithClass 'swal2-cancel'
    confirmStlye = cssOfElementWithClass 'swal2-confirm'

    # remove all existing cancel and confirm buttons
    # they will be removed by the swalExtend buttons
    removeOccurenciesOfElementWithClass 'swal2-cancel'
    removeOccurenciesOfElementWithClass 'swal2-confirm'

    i = 0
    for b in buttons

        if b is 'section'
            br = document.createElement 'br'
            buttoncontainer.appendChild br
        else

            # get button values
            label = b['label']
            color = b['color']

            # get handler and store reference to it globally
            handler = b['handler']
            window.handlers["#{i}"] = handler

            # close by default on button click
            close   = if b['close']? then b['close'] else true

            # if it has an iframe try to get the iframe handler
            hasiframe = false
            if b['iframehandler']?
                hasiframe = true
                window.iframehandler = b['iframehandler']

            # get the button's type: confirm or cancel
            isConfirm = false
            if typeof handler is 'function' or hasiframe
                isConfirm = true
            else if handler? and handler isnt 'cancel'
                # if handler is not null and not 'cancel', it has an unallowed
                # value. Therefore throw an error.
                console.error "SwalExtend: Handler must either be a function, null or 'cancel'"
                return

            # create a button element
            button = document.createElement 'button'

            # set id for iframe
            if hasiframe
                button.setAttribute 'iframeid', "#{i}"

            # set id for the handler
            button.setAttribute 'id', "#{i}"

            # set className and style depedning on the buttons function
            if isConfirm
                button.className = 'swal2-confirm swal2-styled'
                button.style.cssText = confirmStlye
            else
                button.className = 'swal2-cancel swal2-styled'
                button.style.cssText = cancelStyle

            # since the style is copied from the original button,
            # it can occurr that the button is hidden. Therefore
            # ignore the display style setting
            button.style.display = ''

            # set content to given label
            button.innerHTML = label

            # set color, if it is deined
            if color? and color isnt ''
                button.style.backgroundColor = color

            # append button to buttoncontainer
            buttoncontainer.appendChild button

            # if button is confirm button, close the alert and
            # perform handler, once it was done so
            if isConfirm
                if hasiframe
                    button.addEventListener 'click', (event) ->
                        ifr = document.getElementById 'swal2-iframe'
                        innerDoc = ifr.contentDocument or ifr.contentWindow.document

                        if window.iframehandler(innerDoc) is true
                            element = event.srcElement
                            window.handlerID = element.getAttribute 'id'
                            sweetAlert.close()

                        return
                else
                    button.addEventListener 'click', (event) ->
                        element = event.srcElement
                        window.handlerID = element.getAttribute 'id'
                        sweetAlert.close()
                        return
            else
                # if button is cancel, only close
                button.addEventListener 'click', ->
                    sweetAlert.close()

        i++

    return

# get css string of an element with the given calls
cssOfElementWithClass = (elCl) ->
    elements = document.getElementsByClassName elCl
    if elements? and elements.length > 0
        return elements[0].style.cssText
    return null

# remove all occurrencies of an element with a specific class
removeOccurenciesOfElementWithClass = (elCl) ->
    elements = document.getElementsByClassName elCl
    if elements? and elements.length > 0
        for element in elements
            element.parentNode.removeChild element
    return

# store iframe conten globally
window.iframehandler = null

# store handlers globally
window.handlers = {}
window.handlerID = null

# perform handler once the alert was closed
window.mut = new MutationObserver((mutations, mut) ->
    if not document.body.classList.contains 'swal2-shown' and handlers.length > 0

        # perform given handler if exists
        handler = window.handlers[window.handlerID]
        if handler?
            handler()

    return
)

# execute once the page loaded
document.addEventListener 'DOMContentLoaded', (->
    window.mut.observe document.body, 'attributes': true
), false
