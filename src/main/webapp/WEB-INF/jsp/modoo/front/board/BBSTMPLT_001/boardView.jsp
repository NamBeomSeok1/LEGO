<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/modoo/common/commonTagLibs.jsp"%>
<c:set var="title" value="${boardMaster.bbsNm }"/>
<!DOCTYPE html>
<html>
<head>
<title>${title}</title>
</head>
<body>

	<section class="sub-top" style="background-image:url('${CTX_ROOT}/resources/front/site/forum/image/sub/top_news.jpg')">
		<div class="wrap">
			<div class="txt-area">
				<h2>게시판</h2>
			</div>
		</div>
	</section>
	<div class="sub-contents wrap">
		<%--<section class="section">--%>
			<h3 class="txt-hide">뉴스</h3>
			<div class="view-type">
				<table>
					<caption>상세보기</caption>
					<thead>
					<tr>
						<th scope="col">
							<p>${board.nttSj}</p>
							<dl class="time">
								<fmt:formatDate value="${board.frstRegistPnttm}" pattern="yyyy-MM-dd"/>
							</dl>
						</th>
					</tr>
					</thead>
					<tbody>
					<tr>
						<td id="boardContents">
							<c:if test="${not empty board.thumbFilePath}">
								<img src="${board.thumbFilePath}" alt="" style="text-align: center;">
							</c:if>
							${board.nttCn}
						</td>
					</tr>
					</tbody>
				</table>
			</div>
			<div class="btn-cont ar">
				<a href="${CTX_ROOT}/board/boardList.do?bbsId=${board.bbsId}&pageIndex=${board.pageIndex}" class="btn-lg">목록</a>
			</div>
		<%--</section>--%>
	</div>
	<a href="#" class="btn-top"><span class="txt-hide">TOP</span></a>
</body>
</html>