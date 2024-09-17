# frozen_string_literal: true

require 'json'

# mixin
module BasicSerialize
  @@serializer = JSON

  def serialize
    obj = {}
    instance_variables.map do |var|
      obj[var] = instance_variable_get(var)
    end

    @@serializer.dump obj
  end

  def unserialize(string)
    json = IO.new(IO.sysopen(string)).gets
    obj = @@serializer.parse(json)
    obj.keys.each do |key|
      instance_variable_set(key, obj[key])
    end
  end
end
