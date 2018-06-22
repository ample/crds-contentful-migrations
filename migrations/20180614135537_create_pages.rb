require_relative '../lib/migration_utils'

class CreatePages < ContentfulMigrations::Migration
  include MigrationUtils

  def initialize(name = self.class.name, version = nil, client = nil, space = nil)
    @type = 'page'
    super(name, version, client, space)
  end

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Page',
        id: @type,
        description: 'A piece of content distinguished by a unique path'
      )
      content_type.fields.create(id: 'title', name: 'Title', type: 'Symbol', required: true)
      content_type.fields.create(id: 'slug', name: 'Slug', type: 'Symbol', required: true, validations: [uniqueness_of])
      content_type.fields.create(id: 'body', name: 'Body', type: 'Text')
      content_type.fields.create(id: 'show_header', name: 'Show Header?', type: 'Boolean', required: true)
      content_type.fields.create(id: 'show_footer', name: 'Show Footer?', type: 'Boolean', required: true)

      validation_in = Contentful::Management::Validation.new
      validation_in.in = ['container-fluid', 'container', 'eight-column']
      content_type.fields.create(id: 'layout', name: 'Layout', type: 'Symbol', required: true, validations: [validation_in])

      content_type.save
      content_type.publish
      apply_editor(space, 'slug', 'slugEditor')
    end
  end

end