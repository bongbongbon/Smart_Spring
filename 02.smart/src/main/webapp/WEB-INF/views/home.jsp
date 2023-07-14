<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<html>
<head>
	<title>Home</title>
</head>
<body>

<h3 class="my-4">스마트 웹&amp;앱 과정</h3>
<img style= "width: 100%" src="img/hanul.png">
상품명: <input type="text" id="name">
가격: <input type="text" id="price" value="0">
<button onclick="test1()">보내기(jsp)</button>
<button onclick="xml()">보내기(xml)</button>
<div id="xml-result">
<table>
	<tr><th>커피</th><th>1500</th></tr>
	
</table>
</div>


<table id="ajax-result">
	<tr><th>상품명</th><th>가격</th></tr>
	
</table>

<script>
function xml() {
	$.ajax({
		url: 'xml',
	}).done(function( response ) {
// 		console.log( response )
		console.log($(response).find("product"))
		var tag = '';
		$(response).find("product").each(function() {
			var name = $(response).find("name").text()
			var price = $(response).find("price").text()
			tag += `<div><span>\${name}</span><span>\${price}</span></div>`;
		})
			$('#xml-result').html( tag )			
	})

}

function test1() {
	$.ajax({
		url: 'test1',
//	 	type: 'post', 
		data: { name: $('#name').val(), price: $("#price").val() },
	}).done(function( response ) {
		console.log( response )
		$('#ajax-result').append( response )
	})
}

</script>



</body>





</html>
