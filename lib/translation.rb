class Translation < ActiveRecord::Base
  belongs_to :translatable, :polymorphic => true
end
