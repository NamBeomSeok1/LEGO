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
		<section class=" reference-view">
			<div class="img-area">
				<figure>
					<img src="${board.thumbFilePath}" alt="">
				</figure>
				<div class="btn-cont">
				<%--	<a href="/fms/downloadFile.do?atchFileId=${board.atchFileId}&fileSn=0" class="btn-xlg"><i class="ico-down"></i> 다운로드</a>--%>
					<a href="/fms/downloadFile.do?atchFileId=${board.atchFileId}&fileSn=0" class="btn-xlg"><i class="ico-down"></i> 다운로드</a>

				</div>
			</div>
			<div class="txt-area">
				<h3>${board.nttSj}</h3>
				<div class="txt">
					${board.nttCn}
				</div>
			</div>
		</section>
	</div>
	<a href="#" class="btn-top"><span class="txt-hide">TOP</span></a>
</body>
</html>