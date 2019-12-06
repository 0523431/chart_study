<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>막대그래프와 선 그래프로 게시글 작성자의 건수 출력하기</title>
<script type="text/javascript" src="http://www.chartjs.org/dist/2.9.3/Chart.min.js">
</script>
</head>

<sql:setDataSource var="conn" driver="org.mariadb.jdbc.Driver"
							  url="jdbc:mariadb://localhost:3306/classdb"
							  user="scott"
							  password="1234"/>
<sql:query var="rs" dataSource="${conn}">
	select name, count(*) as cnt from board
	group by name
	having cnt >1
	order by cnt desc
</sql:query>
</head>

<body>
	<div id="container" style="width: 60%;">
		<canvas id="canvas">
		</canvas>
	</div>
	<script type="text/javascript">
		var randomColorFactor = function() {
			return Math.round(Math.random() *255);
		};
		var randomColor = function(opacity) {
			return "rgba("+randomColorFactor() + ","
					+ randomColorFactor() + ","
					+ randomColorFactor() + ","
					+ (opacity || '.3') +")";
		};
		
		var config = {
				type : "bar",
				data : {
					datasets : [
					{
						type:"bar",
						label:"건수", // mover했을 때, 보이는 정보의 이름
						data:[<c:forEach items="${rs.rows}" var="m">
									"${m.cnt}",
							  </c:forEach>],
						backgroundColor:[<c:forEach items="${rs.rows}" var="m">
											randomColor(), // randomColor(투명도)
										 </c:forEach>],
						borderColor:[<c:forEach items="${rs.rows}" var="m">
										randomColor(1), // randomColor(투명도)
						 			 </c:forEach>],
					},
					{
						type:"line",
						label:"건수",
						data:[<c:forEach items="${rs.rows}" var="m">
									"${m.cnt}",
							  </c:forEach>, 0],
						// for문인 이유 : 건수만큼 색상이 필요해서
						backgroundColor:[<c:forEach items="${rs.rows}" var="m">
											randomColor(1), // randomColor(투명도)
										 </c:forEach>],
						fill:false,
						borderWidth:2,
						borderColor:[<c:forEach items="${rs.rows}" var="m">
										randomColor(1), // randomColor(투명도)
						 			 </c:forEach>],
					}],
					labels:[<c:forEach items="${rs.rows}" var="m">
								"${m.name}", // 글쓴이
							</c:forEach>]
				},
				options:{
					responsive:true,
					title : {
						display: true,
						text : "게시물 등록 건수"
					},
					legend : { // true : 선이랑 막대랑 동시에 나와서 없앰
						display: false
					},
					scales: {
						xAxes: [{
							display: true,
							scaleLabel: {
								display: true,
								labelString: '게시물 작성자'
							},
							stacked : true // 0부터 시작하게 해줌
						}],
						yAxes: [{
							display: true,
							scaleLabel: {
								display: true,
								labelString: '게시물 작성 건수'
							},
							stacked : true
						}]
					}
				}
		};
		
		window.onload = function() {
			var ctx = document.getElementById("canvas").getContext("2d");
			new Chart(ctx, config);
		}
	</script>
</body>
</html>