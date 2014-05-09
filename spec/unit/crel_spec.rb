require 'spec_helper'

describe Neo4j::ActiveNode::Crel do
  describe Neo4j::ActiveNode::Crel::Query do

    let(:label) { 'User' }

    describe 'instance' do
      subject { Neo4j::ActiveNode::Crel::Query.new(label) }
      let(:conditions) { {} }
      let(:matches) { {} }

      it { should be_an_instance_of Neo4j::ActiveNode::Crel::Query }
      its(:to_cypher) { should == "MATCH n:#{label}" }

      describe 'where' do
        subject { super().where(conditions) }

        it { should be_an_instance_of Neo4j::ActiveNode::Crel::Query }

        context 'basic conditions' do
          let(:conditions) { {foo: 'bar'} }
          its(:to_cypher) { should == "MATCH n:#{label} WHERE foo=`bar`" }
        end

        context 'multiple conditions' do
          let(:conditions) { {foo: 'bar', baz: 'biz'} }
          its(:to_cypher) { should == "MATCH n:#{label} WHERE foo=`bar` AND baz=`biz`" }
        end

        describe 'subsequent calls' do
          let(:conditions) { {test: 'tusk'} }
          context 'where call' do
            subject { super().where(tisk: 'task') }

            it { should be_an_instance_of Neo4j::ActiveNode::Crel::Query }
            its(:to_cypher) { should == "MATCH n:#{label} WHERE test=`tusk` AND tisk=`task`" }
          end

          context 'match call' do
            subject { super().match('b:Bar') }
            
            it { should be_an_instance_of Neo4j::ActiveNode::Crel::Query }
            its(:to_cypher) { should == "MATCH n:#{label}, b:Bar WHERE test=`tusk`" }
          end
        end
      end

      describe 'match' do
        subject { super().match(matches) }

        it { should be_an_instance_of Neo4j::ActiveNode::Crel::Query }

        context "a string argument" do
          let(:matches) { "q:Foo" }
          its(:to_cypher) { should == "MATCH n:#{label}, q:Foo" }
        end

        context "an array argument" do
          let(:matches) { ["q:Foo", "r:Roo"] }
          its(:to_cypher) { should == "MATCH n:#{label}, q:Foo, r:Roo" }
        end
      end

    end
  end

  describe Neo4j::ActiveNode::Crel::ClassMethods do

    let(:classA) do
      Class.new do
        include Neo4j::ActiveNode::Crel
      end
    end

  end
end
