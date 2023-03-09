<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/modoo/common/commonTagLibs.jsp"%>
	<div class="wrap">
	<h1 class="logo"><a href="${CTX_ROOT}/index.do">DX 교육데이터협회</a></h1>
	<div class="menu-area">
		<button type="button" class="btn-menu-toggle"><span>메뉴</span></button>
		<nav class="menu">
			<ul>
				<li>
					<a href="#none">협회소개</a>
					<ul>
						<li><a href="${CTX_ROOT}/about/intro.do">협회소개</a></li>
						<li><a href="${CTX_ROOT}/about/greeting.do">인사말</a></li>
					</ul>
				</li>
				<li><a href="${CTX_ROOT}/board/boardList.do?bbsId=BBSMSTR_000000000003">간행물</a></li>
				<li>
					<a href="#none">게시판</a>
					<ul>
						<li><a href="${CTX_ROOT}/board/boardList.do?bbsId=BBSMSTR_000000000000">게시판</a></li>
						<li><a href="${CTX_ROOT}/board/boardList.do?bbsId=BBSMSTR_000000000002">갤러리</a></li>
					</ul>
				</li>
				<li><a href="${CTX_ROOT}/board/boardList.do?bbsId=BBSMSTR_000000000001">포럼자료</a></li>
				<li><a href="https://www.youtube.com/channel/UC2ksbLRjmxZo-cPsWnCPgMA" target="_blank">포럼LIVE</a></li>
			</ul>
		</nav>
	</div>
</div>