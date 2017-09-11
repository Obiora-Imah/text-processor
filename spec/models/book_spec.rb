require 'rails_helper'

RSpec.describe Book,  type: :model do

  describe ".load_json_data" do
    it "loads data from json file" do
      data = Book.load_json_data
      expect(data).to_not be_empty
      expect(data).to be_an_instance_of(Array)
    end
  end

  describe ".search", type: :model do
    it "returns array of records that contains one or more words in any of the values" do
      data = get_result("Scripting Microsoft")
      expect(data).to be_an_instance_of(Array)
      expect(data).to_not be_empty
    end

    it "returns exact matching result" do
      data = get_result("Scripting Microsoft","exact_match")
      expect(data).to_not be_empty
      expect(data).to be_an_instance_of(Array)
      expect(data.size).to eq(2) 
    end

    it "returns sorted result" do
      data = get_result("Scripting Microsoft")
      first_Record =  Book.flatten_hash({
                                          "Name": "Windows PowerShell",
                                          "Type": "Command line interface, Curly-bracket, Interactive mode, Interpreted, Scripting",
                                          "Designed by": "Microsoft"
                                        })
      flat = Book.flatten_hash(data[0])
      expect(data).to_not be_empty
      expect(data).to be_an_instance_of(Array)
      expect(flat).to eq(first_Record) 
    end

    def get_result(str, type="all")
      Book.search(str, type)
    end
  end
end



