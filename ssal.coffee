
# global method
window.ssal = (params) =>

    # get parameters for sweetalert function
    # and specified buttons from parameters
    swalParams = {}
    buttons = null
    for own param, value of params
        if param == 'buttons'
            buttons = value
        else
            swalParams[param] = value

    # print error if buttons or sweetalert parameters are not defined
    if not swalParams? or not buttons?
        console.error "SwalExtend: Can't create Sweetalert. Parameters wrong."
        return

    # open a sweetalert with the paramters
    swal.apply this, [swalParams]

    # get the buttoncontainer
    buttoncontainer = document.getElementsByClassName('swal2-buttonswrapper')[0]

    # get default styles for cancel and confirm
    cancelStyle  = cssOfButtonWithClass 'swal2-cancel'
    confirmStlye = cssOfButtonWithClass 'swal2-confirm'

    # remove all existing cancel and confirm buttons
    # they will be removed by the swalExtend buttons
    removeOccurenciesOfButtonWithClass 'swal2-cancel'
    removeOccurenciesOfButtonWithClass 'swal2-confirm'

    for b in buttons

        # get button values
        label   = b['label']
        color   = b['color']
        handler = b['handler']

        # create a button element
        button = document.createElement('button')

        # set class and attributes
        button.setAttribute 'type', 'button'

        # set className and style depedning on the buttons function
        # (confirm or cancel)
        if handler == 'cancel'
            button.className = 'swal2-cancel swal2-styled'
            button.style.cssText = cancelStyle
        else
            button.className = 'swal2-confirm swal2-styled'
            button.style.cssText = confirmStlye

        # since the style is copied from the original button,
        # it can occurr that the button is hidden. Therefore
        # ignore the display style setting
        button.style.display = ''

        # set content to given label
        button.innerHTML = label

        # set color, if it is deined
        if color? and color != ''
            button.style.backgroundColor = color

        # append button to buttoncontainer
        buttoncontainer.appendChild button

        # if handler is a function, perform it on click
        if typeof handler is 'function'
            button.addEventListener 'click', handler

        # if handler is not null and not 'cancel', it has an unallowed
        # value. Therefore throw an error.
        else if handler? and not handler == 'cancel'
            console.error "SwalExtend: Handler must either be a function, null or 'cancel'"
            return

        # close the alert on click
        button.addEventListener 'click', -> sweetAlert.close()

cssOfButtonWithClass = (btnClass) =>
    buttons = document.getElementsByClassName btnClass
    if buttons? and buttons.length > 0
        return buttons[0].style.cssText
    return null

removeOccurenciesOfButtonWithClass = (btnClass) =>
    buttons = document.getElementsByClassName btnClass
    if buttons? and buttons.length > 0
        for button in buttons
            button.parentNode.removeChild button
