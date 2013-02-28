module Colonel
  module Array
    %w[second third fourth fifth].each_with_index do |name,index|
      define_method name do
        self[index+1]
      end unless method_defined? name
    end
  end
end