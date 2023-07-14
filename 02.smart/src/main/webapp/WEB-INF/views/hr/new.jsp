<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
	
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h3 class="my-4">사원정보등록</h3>
	<form method="post" action="register">
	<table class="tb-row">
		<colgroup>			
			<col width="180px">
			<col>
		</colgroup>

		<tr>
			<th>사원명</th>
			<td><div class="row">
					<div class="col-auto">
						<input type="text" required name="last_name" placeholder="성" class="form-control">
					</div>
					<div class="col-auto">
						<input type="text"  name="first_name" placeholder="이름" class="form-control">
					</div>
			</div>
			</td>
		</tr>
		<tr>
			<th>이메일</th>
			
			<td><div class="col-auto">
						<input  type="text" required name="email" class="form-control">
					</div></td>
		</tr>
		<tr>
			<th>전화번호</th>
			<td><div class="col-auto">
						<input type="text" name="phone_number" class="form-control">
					</div></td>
		</tr>
		<tr>
			<th>급여</th>
			<td><div class="col-auto">
						<input type="text" required name="salary" class="form-control">
					</div></td>
		</tr>
		<tr>
			<th>입사일자</th>
			<td><div class="row">
			<div class="col-auto">
						<input class="date " type="text" name="hire_date" required>
					</div>
					</div></td>
					
		</tr>
		<tr>
			<th>부서</th>
			<td>
				<div class="row">
						<div class="col-auto">
						<select class="form-select" name="department_id" class="form-control">
								<option value="-1">소속없음</option>
								<c:forEach items="${departments}" var ="d">
								<option  ${vo.department_id eq d.department_id ? 'selected': ''} value="${d.department_id }">${d.department_name}</option>
							</c:forEach>
						</select>
						</div>
						</div>
			</td>
		</tr>
		<tr>
			<th>업무</th>
			<td>	<div class="row">
						<div class="col-auto">
						<select class="form-select" name="job_id" class="form-control">
							<c:forEach items="${jobs}" var ="j">
								<option value="${j.job_id}">${j.job_title}</option>
							</c:forEach>
						</select>
						</div>
						</div></td>
		</tr>
	</table>
	<div class="btn-toolbar my-3 gap-2 justify-content-center">
			<button class="btn btn-primary px-4">저장</button>
			<button class="btn btn-outline-primary px-4" type="button" onclick="history.go(-1)" >취소</button>
	</div>
	</form>
	
	<script>
	$(function() {
		$('[name=hire_date]').val( new Date().toJSON().substr(0,10) )
	})
	</script>
	

</body>
</html>