<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>����׷����� �� �׷����� �Խñ� �ۼ����� �Ǽ� ����ϱ�</title>
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
						label:"�Ǽ�", // mover���� ��, ���̴� ������ �̸�
						data:[<c:forEach items="${rs.rows}" var="m">
									"${m.cnt}",
							  </c:forEach>],
						backgroundColor:[<c:forEach items="${rs.rows}" var="m">
											randomColor(), // randomColor(����)
										 </c:forEach>],
						borderColor:[<c:forEach items="${rs.rows}" var="m">
										randomColor(1), // randomColor(����)
						 			 </c:forEach>],
					},
					{
						type:"line",
						label:"�Ǽ�",
						data:[<c:forEach items="${rs.rows}" var="m">
									"${m.cnt}",
							  </c:forEach>, 0],
						// for���� ���� : �Ǽ���ŭ ������ �ʿ��ؼ�
						backgroundColor:[<c:forEach items="${rs.rows}" var="m">
											randomColor(1), // randomColor(����)
										 </c:forEach>],
						fill:false,
						borderWidth:2,
						borderColor:[<c:forEach items="${rs.rows}" var="m">
										randomColor(1), // randomColor(����)
						 			 </c:forEach>],
					}],
					labels:[<c:forEach items="${rs.rows}" var="m">
								"${m.name}", // �۾���
							</c:forEach>]
				},
				options:{
					responsive:true,
					title : {
						display: true,
						text : "�Խù� ��� �Ǽ�"
					},
					legend : { // true : ���̶� ����� ���ÿ� ���ͼ� ����
						display: false
					},
					scales: {
						xAxes: [{
							display: true,
							scaleLabel: {
								display: true,
								labelString: '�Խù� �ۼ���'
							},
							stacked : true // 0���� �����ϰ� ����
						}],
						yAxes: [{
							display: true,
							scaleLabel: {
								display: true,
								labelString: '�Խù� �ۼ� �Ǽ�'
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