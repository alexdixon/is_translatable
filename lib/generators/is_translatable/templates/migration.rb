class IsTranslatableMigration < ActiveRecord::Migration
  def self.up
    create_table :translations do |t|
      t.string    :translatable_type , :default => ''
      t.integer   :translatable_id
      t.string    :kind
      t.string    :locale, :limit => 5
      t.text      :translation
    end

    add_index :translations, [:translatable_id, :translatable_type, :kind, :locale], :name => 'index_translations'
  end

  def self.down
    drop_table :translations
  end
end
