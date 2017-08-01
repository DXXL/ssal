# SuperSweetAlert

**Features:**
- **Multiple buttons** groupable
- Display iframe

*More features may come in future*

## Installation

Copy the ssal.min.js into your project and link it right after your link to Sweetalert 2, found at https://github.com/limonte/sweetalert2.

## Usage

Create an alert as you would normally with Sweetalert2, but use `ssal()` instead of `swal()`.
*Please do not use any button related property (confirmButtonColor, hasCancelButton, etc...).*

#### Note
All examples are written in JavaScript, althoug SuperSweetAlert is written in CoffeeScript. Keep in mind that "CoffeeScript's just JavaScript". I also have a example in CoffeeScript highlighting all feautures, previously explained in detail

### Multiple buttons

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

### section between buttons

To group the buttons, enter `'section'` into the buttons array, to define a new section. The following buttons will be displayed in the next row.

Example:

```
ssal({
    someStandardSwalProperties: 'someValue',
    buttons: [
        {
            label: 'Some text',
            color: '',
            handler: function() {
                ... do some stuff ...
            }
        }
        {
            label: 'Some text',
            color: '#DD6B55',
            handler: function() {
                ... do some stuff ...
            }
        },
        'section', // the following cancel button will be displayed in the next row
        {
            label: 'Some text',
            color: '',
            handler: 'cancel'
        }
    ]
});
```

### iframe

SuperSweetAlert lets you embed another page within your alert. This can be useful for example to display previews. It also let's you completely decide on the elements shown in the alert. *A feature to get values from a form, defined in an iframe may come in future*

Example:

```
ssal({
    title: 'Some title',
    iframe: {
        width: 400,
        height: 400,
        src: '/form.html'
    },
    buttons: [
        {
            label: 'Some text',
            color: '',
            handler: function() {
                ... do some stuff ...
            }
        }
    ]
});
```

### Full CoffeeScript example

Here is also a full example in CoffeScript:

```
ssal
    title: 'some title'
    allowOutsideClick: true
    iframe: {
        width: 400
        height: 400
        src: '/frame.html'
    }
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
        'section'
        {
            label: 'Cancel'
            color: ''
            handler: 'cancel'
        }
    ]
```

## License

Licensed under the Mozilla Public License 2.0 found in LICENSE file
