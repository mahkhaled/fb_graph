module FbGraph
  module OpenGraph
    class Action < Node
      include Connections::Comments
      include Connections::Likes

      attr_accessor :type, :application, :from, :objects, :start_time, :end_time, :publish_time
      attr_accessor :raw_attributes

      def initialize(identifier, attributes = {})
        super
        @raw_attributes = attributes
        @type = attributes[:type]
        if application = attributes[:application]
          @application = Application.new(application[:id], application)
        end
        if from = attributes[:from]
          @from = User.new(from[:id], from)
        end
        @objects = {}
        if attributes[:data]
          attributes[:data].each do |key, _attributes_|
            @objects[key] = Object.new _attributes_[:id], _attributes_
          end
        end
        @objects = @objects.with_indifferent_access
        [:start_time, :end_time, :publish_time].each do |key|
          self.send "#{key}=", Time.parse(attributes[key]) if attributes[key]
        end

        # cached connection
        @_likes_ = Collection.new(attributes[:likes])
        @_comments_ = Collection.new(attributes[:comments])
      end
    end
  end
end