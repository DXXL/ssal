# SuperSweetAlert

**Adds the ability to have multiple buttons to a Sweetalert2.**
*More features may come in future*

# Installation

Copy the ssal.min.js into your project and link it right after your link to Sweetalert 2, found at https://github.com/limonte/sweetalert2.

# Usage

Create an alert as you would normally with Sweetalert2, but use `ssal()` instead of `swal()`.
*Please do not use any button related property (confirmButtonColor, hasCancelButton, etc...).*
Here is how you specify the buttons to be displayed:

```
ssal({
    someStandardSwalProperties: 'someValue',
    buttons: [
        // confirm button with default swal color
        {
            label: 'Some text',
            color: '',
            handler: function() {
                ... do some stuff ...
            }
        },
        // confirm button with different color
        {
            label: 'Some text',
            color: '#DD6B55',
            handler: function() {
                ... do some stuff ...
            }
        },
        // cancel button with default color
        {
            label: 'Some text',
            color: '',
            handler: 'cancel'
        },
        // also a cancel button
        {
            label: 'Some text',
            color: '',
            handler: null
        }
    ]
});
```

Here is also a full example in Coffescript:

```
ssal
    title: 'some title'
    allowOutsideClick: true
    buttons: [
        {
            label: 'First button'
            color: ''
            handler: -> window.location = 'some ref'
        }
        {
            label: 'Second colored button'
            color: '#DD6B55'
            handler: -> doStuff()
        }
        {
            label: 'Cancel'
            color: ''
            handler: 'cancel'
        }
    ]
```

# License

Licensed under the Mozilla Public License 2.0 found in LICENSE file
