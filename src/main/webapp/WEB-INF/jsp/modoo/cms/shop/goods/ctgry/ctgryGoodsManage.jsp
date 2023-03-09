<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/modoo/common/commonTagLibs.jsp"%>
<c:set var="pageTitle" value="카테고리 상품 관리"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>${pageTitle }</title>
	<link rel="stylesheet" type="text/css" href="${CTX_ROOT }/resources/lib/tui/tui-grid/tui-grid.min.css"/>
	<link rel="stylesheet" type="text/css" href="${CTX_ROOT }/resources/lib/tui/tui-pagination/tui-pagination.min.css"/>
	<link rel="stylesheet" type="text/css" href="${CTX_ROOT }/resources/lib/tempusdominus-bootstrap-4/css/tempusdominus-bootstrap-4.min.css"/>
	
	<link href="${CTX_ROOT }/resources/lib/bootstrap-table-master/dist/bootstrap-table.min.css" rel="stylesheet">
	<link href="${CTX_ROOT }/resources/lib/bootstrap-table-master/dist/extensions/reorder-rows/bootstrap-table-reorder-rows.css" rel="stylesheet">
	<link href="${CTX_ROOT }/resources/lib/open-iconic-master/font/css/open-iconic-bootstrap.css" rel="stylesheet">
	
	<style>
		td {
			color: #2F2F2F !important;
		}
		.btn-area {
			float: right;
		}
	</style>
</head>
<body>

	<div class="card shadow page-wrapper">
		<div class="card-header">
			<h6 class="m-0 font-weight-bold text-primary">${pageTitle }</h6>
		</div>
		<div class="card-body">
			<%--<div class="col-sm-1">
				<select id="selectCtgryId">
					<c:set var="ctgryList" value=""/>
					<option value="0">==선택==</option>
					<c:forEach items="${list}" var="item">
						<c:forEach items="${item._children}" var="subCtgry" varStatus="status">
							<c:set var="ctgryList" value="${item._children}"/>
							<c:set var="isSelect" value=""/>
							<option value="${subCtgry.goodsCtgryId}">${subCtgry.goodsCtgryNm}</option>
						</c:forEach>
					</c:forEach>
				</select>
			</div>--%>
				<ul class="nav nav-tabs" id="myTab" role="tablist">
					<c:forEach items="${list}" var="ctgry">
						<li class="nav-item">
							<c:set var="sharp" value="#" />
							<a class="nav-link <c:if test="${fn:contains(ctgry.goodsCtgryNm, '구독권')}">active</c:if>" data-ctgryid="${ctgry.goodsCtgryId}" id="${ctgry.goodsCtgryId}-tab" data-toggle="tab" href="${sharp}${ctgry.goodsCtgryId}" role="tab" aria-controls="home"  aria-selected="true">${ctgry.goodsCtgryNm}</a>
						</li>
					</c:forEach>
				</ul>
				<ul class="nav nav-tabs" id="myTab2" role="tablist">
					<c:forEach items="${subCtgryList}" var="subCtgry">
						<li class="nav-item">
							<c:set var="sharp" value="#" />
							<a class="nav-link" data-ctgryid="${subCtgry.goodsCtgryId}" id="${subCtgry.goodsCtgryId}-tab" data-toggle="tab" href="${sharp}${subCtgry.goodsCtgryId}" role="tab" aria-controls="home"  aria-selected="true">${subCtgry.goodsCtgryNm}</a>
						</li>
					</c:forEach>
				</ul>
			<div id="myTabContent" class="tab-content">
				<c:forEach items="${wholeList}" var="ctgry">
					<div class="tab-pane fade <c:if test="${fn:contains(ctgry.goodsCtgryNm, '구독권')}">show active</c:if>" id="${ctgry.goodsCtgryId}" role="tabpanel" aria-labelledby="${ctgry.goodsCtgryId}-tab">
							<div class="container-fluid">
								<div class="row">
									<div class="col-sm-11">
										<table class="table table-sm table-bordered data-table"
											   id="table-${ctgry.goodsCtgryId}-tab"
											   data-search="true"
											   data-use-row-attr-func="true"
											   data-reorderable-rows="true"
											   data-resizable="true"
											   data-height="600">
										<thead>
											<tr>
											  <th scope="col" data-field="ctgrySn" data-sortable="false">노출<br>순서</th>
											  <th scope="col" data-field="goodsId" data-sortable="false">상품코드</th>
											  <th scope="col" data-field="goodsKndCode" data-sortable="false" data-formatter="goodsKindFormatter">종류</th>
											  <th scope="col" data-field="goodsTitleImagePath" data-sortable="false" data-formatter="imageFormatter">이미지</th>
											  <th scope="col" data-field="goodsNm" data-sortable="false">상품명</th>
											  <th scope="col" data-field="goodsPc" data-sortable="false" data-formatter="priceFormatter">판매가</th>
											  <th scope="col" data-field="registSttusCode" data-sortable="false" data-formatter="sttusFormatter">등록상태</th>
											</tr>

										  </thead>
										  <tbody>

										  </tbody>
										</table>

									</div>

								</input>
								<div class="row mt-5">
									<div class="col-sm">
										<button class="btn btn-sm btn-danger btn-area save-btn"  onclick="saveSaleGoodsData();">저장</button>
										<%--<button class="btn btn-sm btn-secondary btn-area" onclick="location.reload(true);">취소</button>--%>
									</div>
								</div>
						</div>
				</div>
			</div>
		</c:forEach>
	</div>


	<!-- 상품 모달 -->
	<div class="modal fade" id="recomendListModal" tabindex="-1" role="dialog" aria-labelledby="recomendListModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable modal-dark">
			<div class="modal-content">
				<div class="modal-header">
					<h6 class="modal-title" id="cmpnyListModalLabel">상품목록</h6>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form name="recomendSearchForm" id="recomendSearchForm" method="get" action="${CTX_ROOT}/decms/shop/goods/goodsList.json">
						<fieldset>
							<input type="hidden" id="recomendPageIndex" name="pageIndex" value=""/>
							<input type="hidden" name="searchCmpnyId" value="${goods.cmpnyId }"/>
							<input type="hidden" name="searchNotGoodsId" value="${goods.goodsId }"/>
						</fieldset>
						<div class="form-group row">
							<div class="col-auto">
								<select name="searchPrtnrId" class="custom-select custom-select-sm">
									<option value="">제휴사</option>
									<option value="PRTNR_0000">B2C</option>
									<option value="PRTNR_0001">이지웰</option>
								</select>
							</div>
							<div class="col-auto">
								<label for="searchCondition" class="sr-only">검색분류</label>
								<select name="searchCondition" class="custom-select custom-select-sm">
									<option value="PDN">상품번호</option>
									<option value="GNM">상품명</option>
								</select>
							</div>
							<div class="col-auto">
								<div class="input-group input-group-sm">
									<input type="text" name="searchKeyword" class="form-control" value=""/>
									<span class="input-group-append">
										<button type="submit" class="btn btn-primary"><i class="fas fa-search"></i>검색</button>
									</span>
								</div>
							</div>
						</div>
					</form>
					<div class="recomend-grid">
						<div id="data-recomend-grid" class="mt-3"></div>
						<div id="data-recomend-grid-pagination" class="tui-pagination"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<javascript>
		<script src="${CTX_ROOT}/resources/lib/tui/tui-code-snippet/tui-code-snippet.min.js"></script>
		<script src="${CTX_ROOT}/resources/lib/tui/tui-pagination/tui-pagination.min.js"></script>
		<script src="${CTX_ROOT}/resources/lib/tui/tui-grid/tui-grid.min.js"></script>
		<script src="${CTX_ROOT}/resources/lib/tempusdominus-bootstrap-4/js/tempusdominus-bootstrap-4.min.js"></script>
		<script src="${CTX_ROOT}/resources/lib/jquery-ui/jquery-ui.min.js"></script>
		
		<script src="${CTX_ROOT }/resources/lib/TableDnD-master/js/jquery.tablednd.js"></script>
		<script src="${CTX_ROOT }/resources/lib/bootstrap-table-master/dist/bootstrap-table.min.js"></script>
		<script src="${CTX_ROOT }/resources/lib/bootstrap-table-master/dist/extensions/reorder-rows/bootstrap-table-reorder-rows.min.js"></script>

		<script src="${CTX_ROOT}/resources/decms/shop/goods/ctgry/js/ctgryGoodsManage.js"></script>


	</javascript>
</body>
</html>