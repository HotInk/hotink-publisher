class AddWebthumbToFrontPages < ActiveRecord::Migration
    def self.up
      add_column :front_pages, :webthumb_file_name,    :string
      add_column :front_pages, :webthumb_content_type, :string
      add_column :front_pages, :webthumb_file_size,    :integer
      add_column :front_pages, :webthumb_updated_at,   :datetime
      
      add_column :front_page_versions, :webthumb_file_name,    :string
      add_column :front_page_versions, :webthumb_content_type, :string
      add_column :front_page_versions, :webthumb_file_size,    :integer
      add_column :front_page_versions, :webthumb_updated_at,   :datetime
    end

    def self.down
      remove_column :front_pages, :webthumb_file_name
      remove_column :front_pages, :webthumb_content_type
      remove_column :front_pages, :webthumb_file_size
      remove_column :front_pages, :webthumb_updated_at
      
      remove_column :front_page_versions, :webthumb_file_name
      remove_column :front_page_versions, :webthumb_content_type
      remove_column :front_page_versions, :webthumb_file_size
      remove_column :front_page_versions, :webthumb_updated_at
    end
end
