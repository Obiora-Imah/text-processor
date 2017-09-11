
function BookStore(){
    this.init();
}

BookStore.prototype.init =function(){
    self = this;
     $('.search-panel .dropdown-menu').find('a').click(function(e) {
		e.preventDefault();
		var param = $(this).attr("href").replace("#","");
		var concept = $(this).text();
		$('.search-panel span#search_concept').text(concept);
		$('.input-group #search_param').val(param);
	});
    $("#btn-search").click(function(){
        self.search($("#txt-keyword").val(), $("#search_param").val())
    })

    $(document).keypress(function(e) {
        if(e.which == 13) {
            self.search($("#txt-keyword").val(), $("#search_param").val());
        }
    });
}

BookStore.prototype.search=function(str,search_type){
    self = this;
    $.get( "/search?q="+str + "&search_type=" + search_type, function( data ) {
       self.setResult(data)
    });
}

BookStore.prototype.setResult=function(data){
    var $container = $("#tblBody");
    $container.html("")
    if($("#rec-div").hasClass("hide")){
        $("#rec-div").removeClass("hide")
    }

    if(data.books.length>0){
        console.log(data)
        data.books.forEach(function(book){
            $row = "<tr><td>"
            $row = $row + book["Name"] +"</td><td>";
            $row = $row + book["Type"] +"</td><td>";
            $row = $row + book["Designed by"] +"</td></tr>";
            $container.append($row)
        })
    }else{
        $container.append("<tr><td></h2>No Record Found</h2></td></tr>")
    }
}

