require_relative "../../test_helper"

class AST__Node__TypeApplicationTest < Minitest::Test
  include TestHelper
  include FactoryHelper

  def buffer(string)
    buffer = RBS::Buffer.new(name: "foo.rbs", content: string)
    RBS::Location.new(buffer, 0, string.size)
  end

  def test_one_type
    with_factory do
      loc = buffer("$String")

      app = Steep::AST::Node::TypeApplication.parse(loc)

      assert_equal "String", app.type_str
      app.types(nil, factory, []).tap do |types|
        assert_equal 1, types.size
        assert_equal parse_type("::String"), types[0]
        assert_equal "String", types[0].location.source
      end
    end
  end

  def test_sequence_type
    with_factory do
      loc = buffer("$ String, Integer")

      app = Steep::AST::Node::TypeApplication.parse(loc)

      assert_equal "String, Integer", app.type_str
      app.types(nil, factory, []).tap do |types|
        assert_equal 2, types.size

        assert_equal parse_type("::String"), types[0]
        assert_equal "String", types[0].location.source

        assert_equal parse_type("::Integer"), types[1]
        assert_equal "Integer", types[1].location.source
      end
    end
  end
end
