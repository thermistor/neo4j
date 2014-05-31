require 'spec_helper'

class Person
  include Neo4j::ActiveNode

  property :name, type: String
  property :age, type: Integer

end

describe 'Neo4j::ActiveNode queries' do


  # Copied from http://guides.rubyonrails.org/active_record_querying.html

  # http://guides.rubyonrails.org/active_record_querying.html#retrieving-a-single-object

  before(:each) { delete_db }

  shared_context "people" do |attribute_list|
    let(:people) do
      attribute_list.map do |attributes|
        Person.create(attributes)
      end
    end
  end

  describe '1.1 Retrieving a Single Object' do
    describe 'Using a Primary Key' do
      describe 'find' do
        subject { Person.find(id) }
        let(:id) { people.first.id }

        include_context 'people', [] do
          let(:id) { 0 }
          it { should == nil }
        end
        include_context 'people', [{}] do
          it { should == people.first }
        end
        include_context 'people', [{},{}] do
          it { should == people.first }
        end
      end
      describe 'take' do
        subject { Person.take }

        include_context 'people', [] do
          it { should == nil }
        end
        include_context 'people', [{}] do
          it { require 'pry'; binding.pry; should be_a Person }
        end
        include_context 'people', [{},{}] do
          it { should be_a Person }
        end

      end

      describe 'first' do
        subject { Person.first }

        include_context 'people', [] do
          it { should == nil }
        end
        include_context 'people', [{}] do
          it { should == people.first }
        end
        include_context 'people', [{},{}] do
          it { should == people.first }
        end

      end

      describe 'last' do
        subject { Person.last }

        include_context 'people', [] do
          it { should == nil }
        end
        include_context 'people', [{}] do
          it { should == people.last }
        end
        include_context 'people', [{},{}] do
          it { should == people.last }
        end

      end

      describe 'find_by' do
        subject { Person.find_by name: 'Brian' }

        include_context 'people', [{name: 'Brian'}, {name: 'Andreas'}] do
          it { should == people.first }
        end

        include_context 'people', [{name: 'Andreas'}, {name: 'Brian'}] do
          it { should == nil }
        end

        include_context 'people', [{name: 'Brian!'}, {name: 'Andreas'}] do
          it { should == nil }
        end
      end

      # ...
    end

  end

  describe '1.2 Retrieving Multiple Objects' do
    describe 'Using Multiple Primary Keys' do
      describe 'Client.find([1, 10])' do
        subject { Person.find(ids) }

        include_context 'people', [{}, {}] do
          context 'two ids' do
            let(:ids) { [people.first.id, people.last.id] }
            it { should == people }
          end
          context 'one id' do
            let(:ids) { [people.last.id] }
            it { should == [people.last] }
          end
          context 'one existing ID, one non-existing ID' do
            let(:ids) { [people.first.id, 99999999999] }
            it { should == [people.first] }
          end

        end

      end

      describe '#take(n)' do
        subject { Person.take(n).map(&:class) }

        include_context 'people', [] do
          (0..2).each do |i|
            context "n = #{i}" do
              let(:n) { i }
              it { should == [] }
            end
          end
        end
        include_context 'people', [{}] do
          context "n = 0" do
            it { should == [] }
          end
          context "n = 1" do
            it { should == [Person] }
          end
          context "n = 2" do
            it { should == [Person] }
          end
        end
      end

      [:first, :last].each do |method|
        describe "##{method}(n)" do
          subject { Person.send(method, n) }

          include_context 'people', [] do
            (0..2).each do |i|
              context "n = #{i}" do
                let(:n) { i }
                it { should == [] }
              end
            end
          end
          include_context 'people', [{}] do
            context "n = 0" do
              it { should == [] }
            end
            context "n = 1" do
              it { should == people }
            end
            context "n = 2" do
              it { should == people }
            end
          end
          include_context 'people', [{}] do
            context "n = 0" do
              it { should == [] }
            end
            context "n = 1" do
              it { should == people.send(method) }
            end
            context "n = 2" do
              it { should == people }
            end
          end
        end
      end



    end

  end


  describe '1.3 Retrieving Multiple Objects in Batches' do
    describe 'User.find_each' do
      it 'should execute multiple queries'
      it 'should use :batch_size'
      it 'should use :start'
    end
    describe 'User.find_in_batches' do
      it 'should yield multiple times'
      it 'should use :batch_size'
      it 'should use :start'
    end
    # ...
  end

  describe '2.1 Pure String Conditions' do
    describe %q[Client.where("orders_count = '2'")] do

    end
  end

  describe '2.2 Array Conditions' do
    describe 'Client.where("orders_count = {orders}", orders: params[:orders])' do

    end
  end

  describe '2.3 Hash Conditions' do
    it 'allows querying of properties'
    it 'allows querying of relationships'
  end


  describe '3 Ordering' do
    describe 'Client.order(:created_at)'
    describe 'Client.order("created_at")'
    describe 'Client.order(created_at: :desc)'
    # ...
  end

  describe '4 Selecting Specific Fields' do
    describe 'Client.select("viewable_by, locked")'

    describe 'Client.select(:name).distinct'
  end

  describe '5 Limit and Offset' do
    describe 'Client.limit(5)'
    describe 'Client.limit(5).offset(30)'
  end

  describe '6 Group' do
    # Not sure we can or should do this
    # http://docs.neo4j.org/chunked/stable/query-aggregation.html
  end

  describe '7 Having' do
    # not sure we should do this,
    # http://stackoverflow.com/questions/18138752/can-neo4j-cypher-query-do-similar-thing-as-having-in-sql
  end

  # Scope ?

  # 15 Dynamic Finders
  describe '15 Dynamic Finders'

  describe '16 Find or Build a New Object'

  describe '18 Existence of Objects'

  describe '19 Calculations' do

    describe '19.1 Count' do
      describe 'Client.count'
      describe %q[Client.where(first_name: 'Ryan').count']
    end

    describe '19.2 Average'
    describe '19.3 Minimum' do
      describe 'Client.minimum("age")'
    end
    describe '19.4 Maximum' do
      describe 'Client.maximum("age")'
    end

    describe '19.5 Sum' do
      describe 'Client.sum("orders_count")'
    end


  end
end

