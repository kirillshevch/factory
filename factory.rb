class Factory
  def self.new(*args, &block)
    Class.new do
      args.each { |name| self.send("attr_accessor", name) }

      define_method "initialize" do |*values|
        values.each_with_index do |value, index|
          instance_variable_set("@#{args[index]}", value)
        end
      end

      define_method "[]" do |value|
        if value.class == Fixnum
          instance_variable_get("@#{args[value]}")
        else
          instance_variable_get("@#{value}")
        end
      end

      class_eval &block if block_given?
    end
  end
end

Customer = Factory.new(:name, :address) do
  def greeting
    puts "Hello #{name}!"
  end
end
joe = Customer.new("Dave", "123 Main")

joe.greeting

puts joe.name
puts joe["name"]
puts joe[:name]
puts joe[0]
