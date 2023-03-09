<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/modoo/common/commonTagLibs.jsp"%>
<!doctype html>
<html lang="ko-KR">
<head>
	<title><sitemesh:write property="title"/></title>
	<meta charset="utf-8"/>
	<meta content="IE=edge" http-equiv="X-UA-Compatible"/>
	<meta content="width=device-width, initial-scale=1, shrink-to-fit=no" name="viewport"/>
	<link rel="stylesheet" type="text/css" href="${CTX_ROOT}/resources/decms/template/css/sb-admin-2.min.css"/>
	<link rel="stylesheet" type="text/css" href="${CTX_ROOT}/resources/lib/fontawesome-free/css/all.min.css"/>
	<link rel="stylesheet" type="text/css" href="${CTX_ROOT}/resources/lib/summernote/summernote-bs4.min.css"/>
	<link rel="stylesheet" type="text/css" href="${CTX_ROOT}/resources/decms/common/css/decms.css?20201230"/>
	<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"/>
	<script> var CTX_ROOT = '${CTX_ROOT}'; <%-- Document ROOT PATH --%> </script>
	<c:choose>
    <c:when test="${CMS_MODE eq 'DEV' }"> <script> debug = function(str) { console.log(str); }; </script> </c:when>
    <c:otherwise> <script> debug = function(str) { }; </script> </c:otherwise>
    </c:choose>
	<sitemesh:write property="head"/>
</head>
<body>
<c:choose>
	<c:when test="${fn:contains(USER_ROLE,'ROLE_ADMIN')}"> <c:set var="gradientCss" value="bg-gradient-primary"/> </c:when>
	<c:otherwise> <c:set var="gradientCss" value="bg-gradient-cmpny"/> </c:otherwise>
</c:choose>
<c:choose>
<c:when test="${fn:contains(USER_ROLE,'ROLE_SHOP')}">
	<div id="wrapper">
		<ul class="navbar-nav ${gradientCss } sidebar sidebar-dark accordion " id="accordionSidebar">
			<a id="decms-logo" class="sidebar-brand d-flex align-items-center justify-content-center" href="${CTX_ROOT}/decms/index.do">
				<div class="sidebar-brand-icon rotate-n-15">
				</div>
				<div class="sidebar-brand-text mx-3">게시판 관리자
				</div>
			</a>
			<hr class="sidebar-divider my-0"/>

			<li class="nav-item active">
				<c:if test="${fn:contains(USER_ROLE,'ROLE_SHOP') and fn:contains(USER_ROLE, 'ROLE_EMPLOYEE')}">
					<a class="nav-link" href="${CTX_ROOT}/index.do" target="_blank">
						<i class="fas fa-fw fa-home"></i>
						<span>HOME</span>
					</a>
				</c:if>
			</li>
			<hr class="sidebar-divider"/>



					
				<c:if test="${fn:contains(USER_ROLE,'ROLE_ADMIN')}">
					<a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseSystem" aria-expanded="true" aria-controls="collapseSystem">
						<i class="fas fa-fw fa-cog"></i>
						<span>CMS 관리</span>
					</a>

					<div id="collapseSystem" class="collapse" aria-labelledby="headingTwo" data-parent="#accordionSidebar">
						<div class="bg-white py-2 collapse-inner rounded">
							<c:url var="boardMasterUrl" value="/decms/board/master/boardMasterManage.do">
								<c:param name="menuId" value="boardMaster"/>
							</c:url>
							<a class="collapse-item" href="<c:out value="${boardMasterUrl }"/>" data-menu-id="boardMaster">게시판</a>
						</div>


						<%--<div class="bg-white py-2 collapse-inner rounded">
							<h6 class="collapse-header">회원관리</h6>
							<c:url var="mberManageUserUrl" value="/decms/mber/mberManage.do">
								<c:param name="menuId" value="mberManageUser"/>
								<c:param name="searchUserType" value="USER"/>
							</c:url>
							<a class="collapse-item" href="<c:out value="${mberManageUserUrl }"/>" data-menu-id="mberManageUser">일반회원</a>
							<c:url var="mberManageShopUrl" value="/decms/mber/mberManage.do">
								<c:param name="menuId" value="mberManageShop"/>
								<c:param name="searchUserType" value="SHOP"/>
							</c:url>
							<a class="collapse-item" href="<c:out value="${mberManageShopUrl }"/>" data-menu-id="mberManageShop">업체회원</a>
							<c:url var="mberManageAdminUrl" value="/decms/mber/mberManage.do">
								<c:param name="menuId" value="mberManageAdmin"/>
								<c:param name="searchUserType" value="ADMIN"/>
							</c:url>
							<a class="collapse-item" href="<c:out value="${mberManageAdminUrl }"/>" data-menu-id="mberManageAdmin">관리자</a>
						</div>--%>

<!-- 						<div class="bg-white py-2 collapse-inner rounded"> -->
<!-- 							<h6 class="collapse-header">메시지관리</h6> -->
<%-- 							<c:url var="alimtalkUrl" value="/decms/alimtalk/alimtalkManage.do"> --%>
<%-- 								<c:param name="menuId" value="alimtalkMaster"/> --%>
<%-- 							</c:url> --%>
<%-- 							<a class="collapse-item" href="<c:out value="${alimtalkUrl }"/>" data-menu-id="alimtalkMaster">알림톡 발송내역</a> --%>
<!-- 						</div> -->
							<%--<div class="bg-white py-2 collapse-inner rounded">
								<h6 class="collapse-header">코드</h6>
								<c:url var="commonCodeManageUrl" value="/decms/code/commonCodeManage.do">
									<c:param name="menuId" value="commonCodeManage"/>
								</c:url>
								<a class="collapse-item" href="<c:url value="${commonCodeManageUrl }"/>" data-menu-id="commonCodeManage">공통코드</a>
							</div>--%>

					</div>
				</c:if>
			</li>
			<hr class="sidebar-divider d-none d-md-block"/>

			<div class="text-center d-none d-md-inline">
				<button class="rounded-circle border-0" id="sidebarToggle"></button>
			</div>
		</ul>
		<div id="content-wrapper" class="d-flex flex-column">
			<div id="content">
				<nav class="navbar navbar-expand navbar-light bg-white topbar mb-2 static-top shadow">
					<button id="sidebarToggleTop" class="btn btn-link d-md-none rounded-circle mr-3">
						<i class="fa fa-bars"></i>
					</button>
					<ul class="navbar-nav ml-auto">
						<li class="nav-item dropdown no-arrow">
							<a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
								<span class="mr-2 d-none d-lg-inline text-gray-600 small">${USER_NAME } (${USER_ID})</span>
								<img class="img-profile rounded-circle" src="/resources/decms/common/image/user.png"/>
							</a>
							<div class="dropdown-menu dropdown-menu-right shadow animated--grow-in" aria-labelledby="userDropdown">
								<a class="dropdown-item" href="${CTX_ROOT}/user/sign/logout.do" data-event="confirm" data-message="로그아웃 하시겠습니까?">
									<i class="fas fa-sign-out-alt fa-sm fa-fw mr-2 text-gray-400"></i> Logout
								</a>
							</div>
						</li>

					</ul>
				</nav>

				<section id="content-view">
					<sitemesh:write property="body"/>
				</section>
			</div>

			<footer class="sticky-footer bg-white">
				<div class="container my-auto">
					<div class="copyright text-center my-auto">
						<span>Copyright &copy; CMS 2020</span>
					</div>
				</div>
			</footer>

		</div>
	</div>
</c:when>
<c:otherwise>
	<sitemesh:write property="body"/>
</c:otherwise>
</c:choose>
	<script src="${CTX_ROOT}/resources/lib/jquery/jquery.min.js"></script>
	<script src="${CTX_ROOT}/resources/lib/axios/axios.min.js"></script>
	<script src="${CTX_ROOT}/resources/lib/jquery-form/jquery.form.min.js"></script>
	<script src="${CTX_ROOT}/resources/lib/popperjs/umd/popper.min.js"></script>
	<script src="${CTX_ROOT}/resources/lib/bootstrap/js/bootstrap.min.js"></script>
	<script src="${CTX_ROOT}/resources/lib/jquery.easing/jquery.easing.min.js"></script>
	<script src="${CTX_ROOT}/resources/lib/bootbox/bootbox.all.min.js"></script>
	<script src="${CTX_ROOT}/resources/decms/template/js/sb-admin-2.min.js"></script>
	<script src="${CTX_ROOT}/resources/lib/summernote/summernote-bs4.min.js"></script>
	<script src="${CTX_ROOT}/resources/lib/summernote/lang/summernote-ko-KR.min.js"></script>
	<script src="${CTX_ROOT}/resources/lib/moment/moment-with-locales.min.js"></script>
	<script src="${CTX_ROOT}/resources/decms/common/js/script.js?20201229"></script>
	<sitemesh:write property="javascript"/>

	<div class="loading" style="display:none;">
		<p><img src="/resources/decms/common/image/loading.gif" alt="loading"/><br/>잠시만 기다리세요.</p>
	</div>
</body>
</html>