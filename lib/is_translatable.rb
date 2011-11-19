require 'active_record'

module IsTranslatable
  module ActiveRecordExtension
    def is_translatable(*kinds)
      include IsTranslatable::Methods
    end
  end

  module Methods
    def self.included(klass)
    end

    def set_translation(kind, t, locale_override=nil)
    end

	def get_translation(kind, locale_override=nil)
	end
  end
end

ActiveRecord::Base.send(:extend, IsTranslatable::ActiveRecordExtension)
