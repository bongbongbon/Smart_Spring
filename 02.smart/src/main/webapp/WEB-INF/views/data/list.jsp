<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h3 class="my-4">공공데이터</h3>

<ul class="nav nav-pills justify-content-center gap-3 mb-3">
  <li class="nav-item">
    <a class="nav-link">약국조회</a>
  </li>
  <li class="nav-item">
    <a class="nav-link">유기동물조회</a>
  </li>
</ul>

<div class="row mb-3 justify-content-between">
	<div class="col-auto d-flex gap-2 animal-top"> <!-- 유기동물 조회시만 사용될 부분 -->
	</div>
	
	<div class="col-auto pharmacy-top"> <!-- 약국조회시만 사용될 부분 -->
		<div class="input-group">
			<label class="col-form-label me-3">약국명</label>
			<input type="text" id="name" class="form-control">
			<button class="btn btn-primary px-3" id="btn-search"><i class="fa-solid fa-magnifying-glass"></i></button>
		</div>
	</div>
		
	<div class="col-auto">				<!-- 약국/유기동물 조회시 모두 사용될 부분 -->
		<select class="form-select" id="pageList">
			<c:forEach var="i" begin="1" end="5">
			<option value="${10*i}">${10*i}개씩</option>
			</c:forEach>
		</select>
	</div>
</div>

<div id="data-list"></div>

<jsp:include page="/WEB-INF/views/include/loading.jsp"/>
<jsp:include page="/WEB-INF/views/include/modal_image.jsp"/>

<script src="<c:url value='/js/animal.js'/>"></script>
<script src="<c:url value='/js/animal.js?${dd}'/>"></script>

<script type="text/javascript" 
src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpClientId=3n13cy7hca"></script>
 
<script type="text/javascript" 
src="//dapi.kakao.com/v2/maps/sdk.js?appkey=2c2f869bde6a62041bec9bf790f7f5dd"></script>
<script>
//약국명 검색시
$('#name').keyup(function(e){
	if( e.keyCode==13 ) pharmacy_list( 1 );
})
$('#btn-search').click(function(){
	pharmacy_list( 1 );	
})

//한 페이지에 보여질 목록수 변경시
$('#pageList').change(function(){
	page.pageList = $(this).val();
	if( $('table.pharmacy').length > 0 ) pharmacy_list( 1 );	
	else if( $('table.animal').length > 0 ) animal_list( 1 );	
})

$(function(){
	//버튼 강제클릭
	$('ul.nav-pills li').eq(1).trigger('click');
})

/*  
$('ul.nav-pills li').click(function(){
	$('ul.nav-pills li a').removeClass('active');
	$(this).children('a').addClass('active');
	
	var idx = $(this).index();
	if ( idx==0 ) 			pharmacy_list();
	else if( idx==1 )		animal_list();
})
*/

$('ul.nav-pills li').on({
	'click': function(){
		$('ul.nav-pills li a').removeClass('active');
		$(this).children('a').addClass('active');
		
		var idx = $(this).index();
		if ( idx==0 ) 			pharmacy_list( 1 );
		else if( idx==1 )		animal_list( 1 );
	},
	'mouseover': function(){
		$(this).addClass('shadow') //마우스 올린 탭에 그림자 만들기
	},
	'mouseleave': function(){
		$(this).removeClass('shadow')
	}
})

//약국목록 조회
function pharmacy_list( pageNo ){
	$('.pharmacy-top').removeClass('d-none');
	$('#data-list').empty();
	$('.pagination').closest('nav').remove(); //페이지목록이 이미 있으면 삭제
	$('.loading').show();
	
	var table = 
	`
	<table class="tb-list pharmacy">	
		<colgroup><col width="300px"><col width="160px"><col></colgroup>
		<thead><tr><th>약국명</th><th>전화번호</th><th>주소</th></tr></thead>
		<tbody></tbody>
	</table>
	`;
	$('#data-list').html( table );
	
	
	table = '';
	$.ajax({
		url: "<c:url value='/data/pharmacy'/>",
		data: { pageNo: pageNo, rows: page.pageList, name: $('#name').val() },
		async: false,
	}).done(function( response ){
		console.log( response )
		response = response.response.body;
		$(response.items.item).each(function(){
			table += 
			`
			<tr><td><a class="map text-link" data-x="\${this.XPos}" data-y="\${this.YPos}" >\${ this.yadmNm }</a></td>
				<td>\${ this.telno ? this.telno : '-' }</td>
				<td class="text-start">\${ this.addr }</td>
			</tr>
			`;			
		})
		$('#data-list .pharmacy tbody').html( table );
		
		//페이지 목록 표현
		makePage( response.totalCount, pageNo )
		//$('.loading').hide() 
	})
	
	setTimeout( function(){ $('.loading').hide() }, 300);
}

$(document)
.on('click', '.pagination a', function(){ //페이지번호 클릭시
	if( $(this).hasClass('active') ) return;
	if( $('table.pharmacy').length > 0 )   pharmacy_list( $(this).data('page') );
	else if( $('table.animal').length > 0 )   animal_list( $(this).data('page') );
})
.on('click', '.map', function(){ //약국명 클릭시 지도에 약국위치 표시하기
	if( $(this).data('x')=='undefined' || $(this).data('y')=='undefined'  ){
		alert('위경도가 없어 위치를 표시할 수 없습니다')
	}else
		showNaverMap( $(this) );
		//showKakaoMap( $(this) );
})

//네이버지도로 약국위치 표시
function showNaverMap( point ){
	$('#modal-image .modal-body').empty();

	//지도를 담을 영역 만들기
	$('#modal-image').after( "<div id='modal-map' style='width:668px; height:700px'></div>"  );

	var xy = new naver.maps.LatLng( point.data('y'), point.data('x') );
	var mapOptions = {
	    center: xy,
	    zoom: 16
	};
	var map = new naver.maps.Map('modal-map', mapOptions);
	
	//원하는 위치에 마커 올리기
	var marker = new naver.maps.Marker({
	    position: xy,
	    map: map
	});
	
	//마커 위에 정보 창 올리기
	var name = point.text();
	var infowindow = new naver.maps.InfoWindow({
	    content: `<div class='text-danger fw-bold p-2'>\${name}</div>`
	});
	infowindow.open(map, marker);

	
	$('#modal-image .modal-body').html( $('#modal-map') );
	new bootstrap.Modal( $('#modal-image') ).show();
}

//카카오지도로 약국위치 표시
function showKakaoMap( point ){
	$('#modal-image .modal-body').empty();
	
	//지도를 담을 영역 만들기
	$('#modal-image').after( "<div id='modal-map' style='width:668px; height:700px'></div>"  );
	
	var xy = new kakao.maps.LatLng( point.data('y'), point.data('x')); //위(y)/경도(x)
	var container = document.getElementById('modal-map'); //지도를 담을 영역의 DOM 레퍼런스
	var options = { //지도를 생성할 때 필요한 기본 옵션
		center: xy, //지도의 중심좌표.
		level: 3 //지도의 레벨(확대, 축소 정도)
	};

	var map = new kakao.maps.Map(container, options); //지도 생성 및 객체 리턴
	
	// 마커를 생성합니다
	var marker = new kakao.maps.Marker({
	    position: xy
	});

	// 마커가 지도 위에 표시되도록 설정합니다
	marker.setMap(map);
	
	// 인포윈도우를 생성합니다
	var name = point.text();
	var infowindow = new kakao.maps.InfoWindow({
	    position : xy, 
	    content : `<div class='text-danger fw-bold p-2'>\${name}</div>`
	});
	// 마커 위에 인포윈도우를 표시합니다. 두번째 파라미터인 marker를 넣어주지 않으면 지도 위에 표시됩니다
	infowindow.open(map, marker); 
	
	
	$('#modal-image .modal-body').html( $('#modal-map') );
	new bootstrap.Modal( $('#modal-image') ).show();
	
}

//네이버 맵 client id: 3n13cy7hca

var page = { pageList: 10, blockPage: 10, curPage: 1 }; //페이지당보여질목록수, 블럭당보여질페이지수
//페이지정보 만들기
function makePage( totalList, curPage ){
	$('.pagination').closest('nav').remove(); //페이지목록이 이미 있으면 삭제
	
	page.totalList = totalList; //총목록수
	page.curPage = curPage; //현재페이지번호
	page.totalPage = Math.ceil( page.totalList / page.pageList );  //총페이지수
	page.totalBlock = Math.ceil( page.totalPage / page.blockPage ); //총블럭수
	page.curBlock = Math.ceil( page.curPage / page.blockPage ); //현재블럭번호
	page.endPage = page.curBlock * page.blockPage ; //끝페이지번호
	page.beginPage = page.endPage - (page.blockPage-1); //시작페이지번호
	if( page.totalPage < page.endPage )  page.endPage = page.totalPage;
	
	console.log( page )
	
	var prev = page.curBlock==1 ?'invisible':'';
	var next = page.curBlock==page.totalBlock ? 'invisible' :'';
	
	var nav =
		`<nav>
		  <ul class="pagination mt-3 justify-content-center">
		    
		    <!-- 이전블럭 -->
	    	<li class="page-item"> <!-- 처음으로 -->
	    		<a class="page-link \${prev}" data-page="1"><i class="fa-solid fa-angles-left"></i></a>
	    	</li>
	    	<li class="page-item"> <!-- 이전으로 -->
	    		<a class="page-link \${prev}" data-page="\${page.beginPage-page.blockPage}"><i class="fa-solid fa-angle-left"></i></a>
	    	</li>`;
	    
	for(var no=page.beginPage; no<=page.endPage; no++){
		nav +=
		`<li class="page-item">
			\${ no == page.curPage 
					? `<a class="page-link active">\${no}</a>`
					: `<a class="page-link" data-page="\${no}">\${no}</a>`
				}
		</li>
		`;
	}
	    
	nav +=   	 	
	    <!-- 다음블럭 -->    
	    `<li class="page-item"> <!-- 다음 -->
	    	<a class="page-link \${next}" data-page="\${page.endPage+1}"><i class="fa-solid fa-angle-right"></i></a>
	    </li>
	    <li class="page-item"> <!-- 마지막 -->
	    	<a class="page-link \${next}" data-page="\${page.totalPage}"><i class="fa-solid fa-angles-right"></i></a>
	    </li>
	    
	  </ul>
	</nav>`;
	
	$('#data-list').after( nav );
	
}




</script>

</body>
</html>