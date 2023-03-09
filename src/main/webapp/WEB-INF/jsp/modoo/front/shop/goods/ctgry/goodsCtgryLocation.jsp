<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/modoo/common/commonTagLibs.jsp"%>

				<div class="location">
					<c:if test="${empty menuCtgryList }">
						<a href="${CTX_ROOT }/index.do"><strong>HOME</strong></a>
					</c:if>
					<c:forEach var="item" items="${menuCtgryList }" varStatus="status">
						<c:choose>
						<c:when test="${item.goodsCtgryNm eq 'ROOT' }">
							<a href="${CTX_ROOT }/index.do"><strong>HOME</strong></a>
						</c:when>
						<c:otherwise>
							<%--<a href="${CTX_ROOT }/shop/goods/goodsCtgryList.do?searchGoodsCtgryId=${item.goodsCtgryId}">${item.goodsCtgryNm }</a>--%>
							<a href="#none">${item.goodsCtgryNm }</a>
						</c:otherwise>
						</c:choose>
					</c:forEach>
                </div>