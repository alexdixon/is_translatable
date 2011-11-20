require 'active_record'
require 'translation'

module IsTranslatable
  module ActiveRecordExtension
    def translatable(*kinds)
      class_attribute :translatable_kinds
      self.translatable_kinds ||= {}
      self.translatable_kinds = kinds.map(&:to_s)

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
        validate_kind(kind)
        locale ||= I18n.locale
        t_obj = find_translation(kind, locale)
        if t_obj.nil?
          translations.build({:kind => kind.to_s, :translation => t, :locale => locale.to_s})
        else
          t_obj.translation = t
        end
      end
  
      def get_translation(kind, locale=nil)
        validate_kind(kind)
        locale ||= I18n.locale
        t = translations.find_by_kind(kind.to_s, :conditions => {:locale => locale.to_s})
        t ||= find_translation(kind, locale)
        t.translation unless t.nil?
      end

      def remove_translation(kind, locale = nil)
        validate_kind(kind)
        locale ||= I18n.locale
        t = find_translation(kind, locale)
        t.mark_for_destruction unless t.nil?
      end

    protected
      def find_translation(kind, locale)
        translations.each do |t|
          return t if t.kind == kind.to_s && t.locale == locale.to_s
        end
        nil
      end

      def validate_kind(kind)
        raise ArgumentError.new("#{kind} is not a translatable field") unless translatable_kinds.include?(kind.to_s)
      end
    end
  end
end

ActiveRecord::Base.send(:extend, IsTranslatable::ActiveRecordExtension)
