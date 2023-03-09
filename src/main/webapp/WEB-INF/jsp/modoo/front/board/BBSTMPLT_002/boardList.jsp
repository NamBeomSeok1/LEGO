<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/modoo/common/commonTagLibs.jsp"%>
<c:set var="title" value="${boardMaster.bbsNm }"/>
<!DOCTYPE html>
<html>
<head>
<title>${title}</title>
</head>
<body>
	<section class="sub-top"
			 style="background-image:url('${CTX_ROOT}/resources/front/site/forum/image/sub/top_reference.jpg')">
		<div class="wrap">
			<div class="txt-area">
				<h2>${title}</h2>
			</div>
		</div>
	</section>
	<div class="sub-contents wrap">
		<c:if test="${empty resultList}">
			<ul class="reference-list">
				<li>자료가 없습니다.</li>
			</ul>
		</c:if>
		<c:forEach var="num" items="${resultList}" varStatus="status">
			<c:set value="${status.count}" var="cnt"/>
			<section class="border-box">
			<div class="tit-area ac">
				<h3 class="tit-sm">제 ${cnt}회</h3>
			</div>
			<c:forEach var="item" items="${status.current}" >
				<ul class="reference-list">
				<c:forEach var="bbs" items="${item.value}" >
						<li>
							<a href="${CTX_ROOT}/board/boardView.do?bbsId=${bbs.bbsId}&nttId=${bbs.nttId}">
								<div class="img-area">
									<figure>
										<img src="${bbs.thumbFilePath}" alt="">
									</figure>
								</div>
								<div class="txt-area">${bbs.nttSj}</div>
							</a>
						</li>
				</c:forEach>
				</ul>
			</c:forEach>
			</section>
		</c:forEach>
	</div>
	<a href="#" class="btn-top"><span class="txt-hide">TOP</span></a>
</body>
</html>