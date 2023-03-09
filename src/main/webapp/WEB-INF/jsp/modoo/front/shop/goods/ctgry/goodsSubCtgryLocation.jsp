<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/modoo/common/commonTagLibs.jsp"%>
<div class="snb-area border-top">
<nav class="snb">
    <ul>
		<c:if test="${not empty param.searchSubCtgryId}">
   		<li><a href="${CTX_ROOT}/shop/goods/goodsCtgryList.do?searchGoodsCtgryId=${param.searchGoodsCtgryId}&searchSubCtgryId=${param.searchSubCtgryId}&searchOrderField=${param.searchOrderField}"
  			<c:if test="${not empty param.searchSubCtgryId and empty param.searchThreeCtgryId}"> class="is-active"</c:if> >
			전체
		</a></li>
		</c:if>
    	<c:choose>
    		<c:when test="${subCtgryList.size() > 0}">
     			<%--<li><a href="${CTX_ROOT}/shop/goods/goodsCtgryList.do?searchGoodsCtgryId=${param.searchGoodsCtgryId}&searchSubCtgryId=${param.searchSubCtgryId}"
    				<c:if test="${empty param.searchThreeCtgryId}"> class="is-active"</c:if> >전체</a></li>--%>
   				<c:forEach var="subCtgry" items="${subCtgryList}">
					<li><a href="${CTX_ROOT}/shop/goods/goodsCtgryList.do?searchGoodsCtgryId=${param.searchGoodsCtgryId}&searchSubCtgryId=${param.searchSubCtgryId}&searchThreeCtgryId=${subCtgry.goodsCtgryId}&searchOrderField=${param.searchOrderField}"
						<c:if test="${param.searchThreeCtgryId eq subCtgry.goodsCtgryId}"> class="is-active"</c:if> >
						<c:out value="${subCtgry.goodsCtgryNm}"/></a>
					</li>
		    	</c:forEach>
    		</c:when>   		
    		<c:otherwise></c:otherwise>
    	</c:choose>
	</ul>
</nav>
</div>
                    