<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/modoo/common/commonTagLibs.jsp"%>
<%--
<select title="카테고리 선택" class="p10 m-block mb20" onchange="if(this.value) location.href=(this.value);">
	<option value="${CTX_ROOT}/shop/goods/goodsCtgryList.do?searchGoodsCtgryId=${param.searchGoodsCtgryId}&searchSubCtgryId=${param.searchSubCtgryId}&searchOrderField=${param.searchOrderField}" <c:if test="${param.searchSubCtgryId == null}"> class="is-active"</c:if>>전체</option>0
    <c:choose>
   		<c:when test="${threeCtgryList.size() > 0}">
           <c:forEach var="threeCtgry" items="${threeCtgryList}">
           <option value="${CTX_ROOT}/shop/goods/goodsCtgryList.do?searchGoodsCtgryId=${param.searchGoodsCtgryId}&searchSubCtgryId=${threeCtgry.upperGoodsCtgryId}&searchThreeCtgryId=${threeCtgry.goodsCtgryId}&searchOrderField=${param.searchOrderField}"
           	<c:if test="${param.searchThreeCtgryId eq threeCtgry.goodsCtgryId}"> selected class="is-active"</c:if>><c:out value="${threeCtgry.goodsCtgryNm}"/></option>
           </c:forEach>
           </c:when>
   		<c:otherwise></c:otherwise>
   	</c:choose>
</select>
--%>
