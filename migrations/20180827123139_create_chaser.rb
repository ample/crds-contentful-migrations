class CreateChaser < RevertableMigration

  self.content_type_id = 'chaser'

  def up
    with_space do |space|
      content_type = space.content_types.create(
        name: 'Chaser',
        id: content_type_id,
        description: 'The Chaser is an object that contains Chaser questions and can be added to articles and messages.'
      )

      content_type.fields.create(id: 'title', name: 'Title', type: 'Symbol', required: true)
      content_type.fields.create(id: 'published_at', name: 'Published At', type: 'Date', required: true)
      content_type.fields.create(id: 'intro', name: 'Intro text', type: 'Text', required: true)
      content_type.fields.create(id: 'chaser_questions', name: 'Chaser Questions', type: 'Array', items: items_of_type('Entry', 'chaser_question'))
      content_type.fields.create(id: 'challenge', name: 'Challenge', type: 'Text')

      content_type.save
      content_type.publish
    end
  end
end