require 'active_record'
require 'translation'

module IsTranslatable
  module ActiveRecordExtension
    def is_translatable(*kinds)
      include IsTranslatable::Methods
    end
  end

  module Methods
    def self.included(klass)
      klass.class_eval do
        include IsTranslatable::Methods::InstanceMethods

        has_many :translations, :as => :translatable, :dependent => :destroy, :autosave => true
        accepts_nested_attributes_for :translations
      end
    end

    module InstanceMethods
      def set_translation(kind, t, locale=nil)
        locale ||= I18n.locale
        translations.build({:kind => kind.to_s, :translation => t, :locale => locale.to_s})
      end
  
      def get_translation(kind, locale=nil)
        locale ||= I18n.locale
        t = translations.find_by_kind(kind.to_s, :conditions => {:locale => locale.to_s})
        t ||= find_translation(kind, locale)
        t.nil? ? '' : t.translation
      end

    protected
      def find_translation(kind, locale)
        translations.each do |t|
          return t if t.kind == kind.to_s && t.locale == locale.to_s
        end
        nil
      end
    end
  end
end

ActiveRecord::Base.send(:extend, IsTranslatable::ActiveRecordExtension)
