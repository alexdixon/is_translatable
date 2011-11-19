# is\_translatable

(development in progress)

This is a simple library geared towards translating dynamic text in your database.
Unlike most similar libaries, is_translatable uses a single table for all translations, so once it's hooked up you won't
need to do anything fancy in your DB migrations to add support for translations.

## Usage

Add the 'translatable' declaration to your model and specify the columns you want translated:

    class TranslateMe < ActiveRecord::Base
      translatable :title, :description
    end

Now you can get/set translations on those columns (defaulting to the current locale):

    I18n.locale = :es
    t = TranslateMe.new
    t.set_translation(:title, 'In Spanish')
    t.get_translation(:title) # 'In Spanish'

Or if you want to override the locale:

    t.set_translation(:title, 'In French', :fr) # specific override
    t.get_translation(:title, :fr) # 'In French'

TODO: hookup behavior for default locale and fallbacking.

## Installation

TODO: create a migration generator, and make 'gem install is_translatable' work.

## Credits

Inspired by the is\_taggable gem at https://github.com/jamesgolick/is_taggable

## License

is\_translatable is available under the MIT license
