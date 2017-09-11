module DataProcessingModule
    
    def load_json_data(file_path = File.expand_path('data.json','db'))
        JSON.parse(File.read(file_path))
    end

    #convert hash to string
    def flatten_hash(hash)
        hash.map{|k,v| "#{v}"}.join(' ')
    end


    def search(str, search_type="all")
        #convert str to lowercase and remove characters like (', ")
        str_arr = str.downcase.gsub(/\"|\'/, '').split(' ')

        #select strings the begin with ^ for negetive search
        _str_arr = str_arr.select{|v|v=~/^-/} if !str_arr.empty?
        str_arr = !str_arr.empty? ? str_arr.join('|') : "" 

        #find matching record in the json
        result =load_json_data.select  {|hash| flatten_hash(hash).downcase =~ /#{str_arr}/}
        
        # remove records that contain strings in #_str_arr above if you are doing negetive search
        result = result.reject{|rej|flatten_hash(rej).downcase =~ /#{_str_arr.join('|').gsub(/^-/, '')}/} if !_str_arr.empty? && search_type =="negative_search"
        
        #find exact match in result
        result = result.select {|sel| (flatten_hash(sel).downcase.split(' ') & str.downcase.gsub(/\"|\'/, '').split(' ')).size == (str.downcase.gsub(/\"|\'/, '').split(' ')).size } if search_type =="exact_match"
        
        #sort by relevance
        result.sort do |x, y|  
                split_arr = str.downcase.gsub(/\"|\'/, '').split(' ')
                (flatten_hash(y).downcase.split(' ') & split_arr).size<=>(flatten_hash(x).downcase.split(' ') & split_arr).size
            end
    end
end