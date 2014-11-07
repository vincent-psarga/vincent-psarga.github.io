CV maker
========

This project creates the content for [vpsarga.net](http://www.vpsarga.net). It is a basic CV creator using Ruby.

Except for the content of the ``assets/images`` folder (flags from [FamFamFam](http://www.famfamfam.com/lab/icons/flags/) and the logos belonging to their company) and the fonts located under ``assets/font`` (provided by [IcoMoon](https://icomoon.io/)), the code is released under the [WTF public licence](http://www.wtfpl.net/).
You can fork this project and use it for your personnal CV.

TODO
----

 - detect languages based on the content of ``data``
 - generate a PDF file with ``wkhtmltopdf`` when the html files are updated


Forking and using
-----------------

After forking, the first step will be to update the CNAME file in order to use your own domain (or remove it if you want to use Github pages).

You'll need to have Ruby and bundle installed:

    git clone <your fork url>
    cd <your fork name>
    bundle

Updating the HTML output is done with the command ``bin/cv_maker``. If you do not want to manually build everytime you do a change, simply start Guard (``bundle exec guard``) that will build the file when you update the code.

### Updating data

Data for the main page are located in ``data/content.yml``. The structure should be pretty simple to understand.

Data named ``body`` are written using the markdown structure (expect for the skills, where it is a list).

Places are the list of places referenced in the document (for education and experiences). Each one must have a unique id used as key in the hash. They are referenced using ``where-uid`` in experiences and educations.

### i18n / l10n

The system does not use any internationalization/localization existing library. The system is pretty basic. The translation are done using the same structure than the original context and specifying the value for ``title`` and ``body`` keys.
You can also speify your translations in the ``keywords`` hash of the localization file. The key is the text in the original context, the value its translation.
