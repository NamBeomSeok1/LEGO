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
			 style="background-image:url('../../../resources/front/site/forum/image/sub/top_gallery.jpg')">
		<div class="wrap">
			<div class="txt-area">
				<h2>갤러리</h2>
			</div>
			<nav class="lnb">
				<ul>
					<li><a href="${CTX_ROOT}/board/boardList.do?bbsId=BBSMSTR_000000000000" class="">게시판</a></li>
					<li><a href="#none" class="is-active" >갤러리</a></li>
				</ul>
			</nav>
		</div>
	</section>
	<div class="sub-contents wrap">
		<section>
			<input type="hidden" id="totalCnt" value="${fn:length(resultList)}"/>
			<c:if test="${empty resultList}">
				<ul class="reference-list">
					<li>자료가 없습니다.</li>
				</ul>
			</c:if>
			<c:if test="${not empty resultList}">
				<c:if test="${not empty idList}">
				<ul class="tabs-nav">
					<c:forEach var="id" items="${idList}" >
						<c:set var="active" value=""/>
						<c:if test="${searchVO.ctgryId eq id}">
							<c:set var="active" value="is-active"/>
						</c:if>
						<li><a href="#none" onclick="moveCtgry('${id}')" class="${active}">제 ${id}회 미래교육 AI포럼</a></li>
						<%--<li><a href="#none" onclick="moveCtgry('2')" class="">제 2회</a></li>--%>
					</c:forEach>
				</ul>
				</c:if>

				<form:form modelAttribute="searchVO" id="searchForm" name="searchForm" method="get" action="${CTX_ROOT }/board/boardList.do">
					<fieldset>
						<form:hidden path="pageIndex"/>
						<form:hidden path="bbsId"/>
						<form:hidden path="ctgryId"/>
					</fieldset>
				</form:form>

				<ul class="img-list">
					<c:forEach var="item" items="${resultList}" varStatus="status">
					<li id="li${status.index+1}" data-no="${status.index+1}">
						<a href="#none">
							<figure>
								<img src="${item.thumbFilePath}" alt=" ">
							</figure>
						</a>
					</li>
					</c:forEach>
				</ul>
				<ul class="paging">
					<c:url var="pageUrl" value="/board/boardList.do">
						<c:param name="menuNo" value="${param.menuNo }"/>
						<c:param name="menuId" value="${boardMaster.bbsId }"/>
						<c:param name="bbsId" value="${boardMaster.bbsId }"/>
						<c:param name="ctgryId" value="${searchVO.ctgryId}"/>
						<c:param name="searchKeyword" value="${searchVO.searchKeyword }"/>
						<c:param name="pageIndex" value=""/>
					</c:url>
						<modoo:pagination paginationInfo="${paginationInfo}" type="text" jsFunction="" pageUrl="${pageUrl }" pageCssClass="paging"/>
				</ul>
			</c:if>
		</section>

		<div class="layer-img"  data-no="">
			<figure>
				<!-- 원본 이미지 -->
				<img src="" alt=" " class="img" >
			</figure>
			<div class="layer-img-fnc">
				<button type="button" class="btn-prev" data-img="0"><span class="txt-hide">이전</span></button>
				<button type="button" class="btn-next" data-img="" ><span class="txt-hide">다음</span></button>
				<button type="button" class="btn-close"><span class="txt-hide">닫기</span></button>
			</div>
			<button type="button" class="layer-img-dim"></button>
		</div>
	</div>
	<a href="#" class="btn-top"><span class="txt-hide">TOP</span></a>
	<javascript>
		<script charset="UTF-8">

			var totalCnt = $('#totalCnt').val();

			function moveCtgry(id){
				$('#ctgryId').val(id);
				$('#pageIndex').val(1);
				$('#searchForm').submit();
			}

			/* layer-img 열기 */
			$(document).on('click','.img-list img', function() {
				var curNo =  $(this).parents('li').data('no');
				var $img = $(this).attr('src');
				$num = $(this).data('img');
				$('.layer-img').addClass('is-active');
				$('.layer-img').find('.img').attr( {
					'src': $img
				})
				$('.layer-img').data('no', curNo);
			});

			/* layer-img 닫기 */
			$(document).on('click', '.layer-img .btn-close, .layer-img-dim', function() {
				$('.layer-img').removeClass('is-active');
			});

			/* layer-img 다음/이전 */
			$(document).on('click','.btn-prev, .btn-next',function (){
				var type = $(this).attr('class');
				var curNo = $('.layer-img').data('no');
				var nextNo = 0;
				if(type == 'btn-prev'){
					nextNo = Number(curNo)-1;
				}else{
					nextNo = Number(curNo)+1;
				}
				if(totalCnt < nextNo || nextNo < 1) {
					$('.layer-img .btn-close').trigger('click');
				}else{
					var $img = $('#li'+ nextNo +'').children('a').children('figure').children('img').attr('src');
					$('.layer-img').find('.img').attr({
						'src': $img
					})
					$('.layer-img').data('no', nextNo);
				}
			})
		</script>
	</javascript>
</body>
</html>