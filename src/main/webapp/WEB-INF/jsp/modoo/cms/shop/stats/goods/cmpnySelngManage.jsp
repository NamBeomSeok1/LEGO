<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/modoo/common/commonTagLibs.jsp"%>
<c:set var="pageTitle" value="입점사 매출 순위"/>
<!DOCTYPE html>
<html>
<head>
	<title>${pageTitle }</title>
	<link rel="stylesheet" type="text/css" href="${CTX_ROOT}/resources/lib/jquery-ui/jquery-ui.min.css"/>
	<link rel="stylesheet" type="text/css" href="${CTX_ROOT }/resources/lib/tui/tui-grid/tui-grid.min.css"/>
	<link rel="stylesheet" type="text/css" href="${CTX_ROOT }/resources/lib/tui/tui-chart/tui-chart.min.css"/>
	<link rel="stylesheet" type="text/css" href="${CTX_ROOT }/resources/lib/tempusdominus-bootstrap-4/css/tempusdominus-bootstrap-4.min.css"/>
	<style>
		.cms-search-box {border:1px solid #dfdfdf; border-left:0.3rem solid #5a5c69;box-shadow: 0 .15rem 1.75rem 0 rgba(58,59,69,.15)!important;}
		#searchCmpnyNmResult { background: #fffab6; }
	</style>
</head>
<body>
	<div class="card shadow page-wrapper">
		<div class="card-header">
			<h6 class="m-0 font-weight-bold text-primary">${pageTitle }</h6>
		</div>
		<div class="card-body">
			<form:form modelAttribute="searchVO" id="searchForm" name="searchForm" method="get" action="${CTX_ROOT }/decms/shop/stats/cmpnySelngList.json">
				<fieldset class="cms-search-box container-fluid rounded pt-3 pb-3 mb-3">
					<div class="row mb-2">
						<div class="col-lg-8">
							<div class="form-row">
								<div class="col-auto">
									<div class="input-group input-group-sm" id="datepicker-searchBgnde" data-target-input="nearest">
										<form:input path="searchBgnde" cssClass="form-control datetimepicker-input" data-target="#datepicker-searchBgnde"/>
										<div class="input-group-append" data-target="#datepicker-searchBgnde" data-toggle="datetimepicker">
											<div class="input-group-text"><i class="fas fa-calendar"></i></div>
										</div>
									</div>
								</div>
								<div class="col-auto">~</div>
								<div class="col-auto">
									<div class="input-group input-group-sm" id="datepicker-searchEndde" data-target-input="nearest">
										<form:input path="searchEndde" cssClass="form-control datetimepicker-input" data-target="#datepicker-searchEndde"/>
										<div class="input-group-append" data-target="#datepicker-searchEndde" data-toggle="datetimepicker">
											<div class="input-group-text"><i class="fas fa-calendar"></i></div>
										</div>
									</div>
								</div>
								<div class="col-auto">
									<button type="submit" class="btn btn-dark btn-sm"><i class="fas fa-search"></i> 검색</button>
								</div>
							</div>
						</div>
					</div>
					<div class="mb-2">
						<button type="button" class="btnDateSearch btn btn-secondary btn-sm" data-begin="${searchMonth11 }" data-end="${searchMonth12 }">지난달</button>
						<button type="button" class="btnDateSearch btn btn-secondary btn-sm" data-begin="${searchToday }" data-end="${searchToday }">이번달</button>
						<button type="button" class="btnDateSearch btn btn-secondary btn-sm" data-begin="${searchWeek11 }" data-end="${searchWeek12 }">이번주</button>
						<button type="button" class="btnDateSearch btn btn-secondary btn-sm" data-begin="${searchThreeDay }" data-end="${searchToday }">3일간</button>
					</div>
					<div class="row">
						<div class="col-sm-6">
							<div class="input-group input-group-sm">
								<div class="input-group-prepend"><span class="input-group-text">입점사명</span></div>
								<input type="text" id="searchCmpnyNmResult" class="form-control form-control-sm" readonly="readonly" value="${cmpnyNm }"/>
								<input type="hidden" name="searchCmpnyId"/>
								<button type="button" id="btnRemoveCmpnyInfo" class="btn btn-secondary btn-sm rounded-0"><i class="fas fa-times"></i></button>
								<input type="text" id="searchCmpnyNm" class="form-control form-control-sm" placeholder="업체명을 입력하세요"/>
								<div class="input-group-append">
									<button type="button" id="btnSearchCmpny" class="btn btn-dark btn-sm"><i class="fas fa-search"></i> 업체검색</button>
								</div>
							</div>
						</div>
					</div>
				</fieldset>
			</form:form>
			
			<div class="mt-2">
				<div id="chart1"></div>
				<%-- <div class="text-right">
					<a href="${CTX_ROOT }/decms/shop/stats/cmpnySelngListExcel.do" id="btnExcelDownload" class="btn btn-success btn-sm"><i class="fas fa-file-excel"></i> 엑셀 다운로드</a>
				</div> --%>
				<div id="data-grid" class="mt-3"></div>
			</div>

		</div>
	</div>
	<javascript>
		<script src="${CTX_ROOT}/resources/lib/tui/tui-code-snippet/tui-code-snippet.min.js"></script>
		<script src="${CTX_ROOT}/resources/lib/tui/tui-grid/tui-grid.min.js"></script>
		<script src="${CTX_ROOT}/resources/lib/tui/tui-chart/tui-chart-all.min.js"></script>
		<script src="${CTX_ROOT}/resources/lib/tempusdominus-bootstrap-4/js/tempusdominus-bootstrap-4.min.js"></script>
		<script src="${CTX_ROOT}/resources/lib/jquery-ui/jquery-ui.min.js"></script>
		<script src="${CTX_ROOT}/resources/decms/shop/stats/goods/js/cmpnySelngManage.js"></script>
	</javascript>
</body>
</html>