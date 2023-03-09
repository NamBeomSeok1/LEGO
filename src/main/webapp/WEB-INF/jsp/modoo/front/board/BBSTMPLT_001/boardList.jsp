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
			<nav class="lnb">
				<ul>
					<li><a href="#none" class="is-active">게시판</a></li>
					<li><a href="${CTX_ROOT}/board/boardList.do?bbsId=BBSMSTR_000000000002" >갤러리</a></li>
				</ul>
			</nav>
		</div>
	</section>
	<div class="sub-contents wrap">
		<form:form modelAttribute="searchVO" id="searchForm" name="searchForm" method="get" action="${CTX_ROOT }/board/boardList.do">
			<fieldset>
				<form:hidden path="pageIndex"/>
				<form:hidden path="bbsId"/>
			</fieldset>
			<div class="sch-area">
				<div class="sch">
					<form:input path="searchKeyword" placeholder="제목이나 내용을 입력하세요."/>
					<button type="submit" class="btn-sch"><span class="txt-hide">검색</span></button>
				</div>
			</div>
		</form:form>
		<%--<section class="section">--%>
			<h3 class="txt-hide">뉴스</h3>
			<ul class="board-list">
				<c:if test="${not empty resultList}">
					<c:forEach var="result" items="${resultList }" varStatus="status">
					<li>
						<a href="${CTX_ROOT}/board/boardView.do?nttId=${result.nttId}&bbsId=${result.bbsId}">
							<div class="txt"><span class="label spot">공지</span> <p>${result.nttSj}</p></div>
							<span class="time"><fmt:formatDate value="${result.frstRegistPnttm}" pattern="yyyy-MM-dd"/></span>
						</a>
					</li>
					</c:forEach>
				</c:if>
				<c:if test="${empty resultList}">
					<li>
						<div class="txt" style="text-align: center"> <p>게시물이 없습니다.</p></div>
					</li>
				</c:if>
			</ul>
			<ul class="paging">
			<c:url var="pageUrl" value="/board/boardList.do">
				<c:param name="menuNo" value="${param.menuNo }"/>
				<c:param name="menuId" value="${boardMaster.bbsId }"/>
				<c:param name="bbsId" value="${boardMaster.bbsId }"/>
				<c:param name="searchCondition" value="${searchVO.searchCondition }"/>
				<c:param name="searchKeyword" value="${searchVO.searchKeyword }"/>
				<c:param name="pageIndex" value=""/>
			</c:url>
			<modoo:pagination paginationInfo="${paginationInfo}" type="text" jsFunction="" pageUrl="${pageUrl }" pageCssClass="paging"/>
		<%--</section>--%>
	</div>
</body>
</html>