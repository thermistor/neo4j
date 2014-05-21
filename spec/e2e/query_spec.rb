describe 'Neo4j::ActiveNode queries' do


  # Copied from http://guides.rubyonrails.org/active_record_querying.html

  # http://guides.rubyonrails.org/active_record_querying.html#retrieving-a-single-object
  describe '1.1 Retrieving a Single Object' do

    describe 'Using a Primary Key' do
      describe 'find' do
        describe 'Client.find(10)' do
          it 'finds the client with primary key (id) 10'
        end
      end
      describe 'take'
      describe 'last'
      # ...
    end

  end

  describe '1.2 Retrieving Multiple Objects' do
    describe 'Using Multiple Primary Keys' do
      describe 'Client.find([1, 10])' do
        it 'finds the clients with primary keys 1 and 10'
      end

    end

  end


  describe '1.3 Retrieving Multiple Objects in Batches' do
    describe 'User.all' do

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