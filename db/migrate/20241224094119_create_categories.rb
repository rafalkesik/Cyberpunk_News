class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :slug
      t.string :title
      t.string :description

      t.timestamps
    end

    # ⚠️ Note: This should have been added in seeds.rb instead of a migration.
    # This was a mistake, but it's kept here for historical consistency.
    # Best practice: Always insert static data in db/seeds.rb, not migrations.
    Category.create(slug: 'inne',
                    title: 'Inne',
                    description: 'Posty niepasujące do żadnej kategorii.')
  end
end
