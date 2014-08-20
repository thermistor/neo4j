require 'spec_helper'


describe 'linked list' do


  describe 'has_many :out, :parts, model_class: self, layout: :list' do
    let(:clazz) do
      UniqueClass.create do
        include Neo4j::ActiveNode
        property :name
        has_many :out, :parts, model_class: self, layout: :list  # support sorted_list ?, or layout: list, layout_type:
      end
    end

    context 'append nodes' do
      it 'can append new nodes to an empty list' do
        n = clazz.create
        n1 = clazz.create
        n2 = clazz.create
        n.parts << n1 << n2

        expect(n.parts.to_a).to eq([n2,n1])  # append last first !
        res = n.query_as(:n).match("n-[:friends*]->(other)").pluck(:other)
        expect(res.to_a).to eq([n1,n2])
      end
    end

    context 'delete node' do
      it 'can delete a node in the middle of the list' do
        n = clazz.create
        n1 = clazz.create
        n2 = clazz.create
        n3 = clazz.create

        n.parts << n1 << n2 << n3

        n2.destroy
        expect(n.parts.to_a).to eq([n2,n1])  # append last first !
        res = n.query_as(:n).match("n-[:friends*]->(other)").pluck(:other)
        expect(res.to_a).to eq([n1,n2])
      end
    end
  end


  ### THIS IS WHAT THE CODE ABOVE SHOULD DO

  let(:clazz) do
    UniqueClass.create do
      include Neo4j::ActiveNode
      property :name
    end
  end


  before do
    @n1 = clazz.create name: 'c1'
    @n2 = clazz.create name: 'n2'
    @n3 = clazz.create name: 'n3'
    @n4 = clazz.create name: 'n4'

    @n1.create_rel(:friends, @n2)
    @n2.create_rel(:friends, @n3)
    @n3.create_rel(:friends, @n4)
  end

  it 'create and list all nodes' do
    res = @n1.query_as(:n1).match("n1-[:friends*]->(other)").pluck(:other)
    expect(res.to_a).to eq([@n2,@n3,@n4])
  end

  context 'insert' do

    it 'insert first' do
      prev_rel = @n2.rel(dir: :incoming, type: :friends)
      prev_rel.del

      n5 = clazz.create name: 'n5'
      @n1.create_rel(:friends, n5)
      n5.create_rel(:friends, @n2)

      res = @n1.query_as(:n1).match("n1-[:friends*]->(other)").pluck(:other)
      expect(res.to_a).to eq([n5, @n2, @n3,@n4])
    end
  end
  
  
  context 'delete' do
    it 'can delete middle node' do
      next_node = @n3.node(dir: :outgoing, type: :friends)
      prev_node = @n3.node(dir: :incoming, type: :friends)
      @n3.destroy
      prev_node.create_rel(:friends, next_node)
      res = @n1.query_as(:n1).match("n1-[:friends*]->(other)").pluck(:other)
      expect(res.to_a).to eq([@n2,@n4])
    end

    it 'can delete first node' do
      next_node = @n2.node(dir: :outgoing, type: :friends)
      prev_node = @n2.node(dir: :incoming, type: :friends)
      @n2.destroy
      prev_node.create_rel(:friends, next_node)
      res = @n1.query_as(:n1).match("n1-[:friends*]->(other)").pluck(:other)
      expect(res.to_a).to eq([@n3,@n4])
    end

    it 'can delete last node' do
      next_node = @n4.node(dir: :outgoing, type: :friends)
      prev_node = @n4.node(dir: :incoming, type: :friends)
      @n4.destroy
      prev_node.create_rel(:friends, next_node) if next_node
      res = @n1.query_as(:n1).match("n1-[:friends*]->(other)").pluck(:other)
      expect(res.to_a).to eq([@n2,@n3])
    end
  end

end