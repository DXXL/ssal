
# global method
window.ssal = (params) ->

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
                iframe = value
                htmlstr = '<iframe id="swal2-iframe" frameBorder="0" width="'+iframe['width']+'px" height="'+iframe['height']+'px" src="'+iframe['src']+'"></iframe>'
                swalParams['html'] = htmlstr

                # if the alert is smaller than the iframe, set it to the iframe's size
                width = iframe['width'] + 20
                if swalParams['width'] < width then swalParams['width'] = width

            else
                # throw error if there is also html defined
                console.warning "SwalExtend: Can't have html and iframe in Sweetalert. Html is ignored."
                return

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

    # remove existing handlers to prepare for current alert
    window.handlers = {}
    window.handlerID = null

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

        # get button values
        label = b['label']
        color = b['color']

        # get handler and store reference to it globally
        handler = b['handler']
        window.handlers["#{i}"] = handler

        # close by default on button click
        close   = if b['close']? then b['close'] else true

        # get the button's type: confirm or cancel
        isConfirm = false
        if typeof handler is 'function'
            isConfirm = true
        else if handler? and handler isnt 'cancel'
            # if handler is not null and not 'cancel', it has an unallowed
            # value. Therefore throw an error.
            console.error "SwalExtend: Handler must either be a function, null or 'cancel'"
            return

        # create a button element
        button = document.createElement 'button'

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
            button.addEventListener 'click', (event) ->
                element = event.srcElement
                window.handlerID = element.getAttribute 'id'
                sweetAlert.close()
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

# store handlers globally
window.handlers = {}
window.handlerID = null

# perform handler once the alert was closed
mut = new MutationObserver((mutations, mut) ->
    if not document.body.classList.contains 'swal2-shown' and handlers.length > 0
        handler = window.handlers[window.handlerID]
        if handler?
            handler()
    return
)
mut.observe document.getElementsByTagName('body')[0], 'attributes': true
