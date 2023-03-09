<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/modoo/common/commonTagLibs.jsp"%>
<!DOCTYPE html>
<html lang="ko">

<head>
	<title>DX 교육데이터협회</title>

	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="Author" content="">
	<meta name="Keywords" content="">
	<meta name="Description" content="">
	<meta name="format-detection" content="telephone=no">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport"
		  content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no" />
	<link href="${CTX_ROOT}/resources/front/site/forum/css/style.css" rel="stylesheet" />
</head>

<body>

    <section class="sub-top" style="background-image:url('../../../resources/front/site/forum/image/sub/top_about.jpg')">
        <div class="wrap">
            <div class="txt-area">
                <h2>협회소개</h2>
            </div>
            <nav class="lnb">
                <ul>
                    <li><a href="/about/intro.do">협회소개</a></li>
                    <li><a href="#none"  class="is-active">인사말</a></li>
                </ul>
            </nav>
        </div>
    </section>
    <div class="sub-contents wrap">
        <div class="tit-area">
            <h3 class="tit">인사말</h3>
        </div>
        <section class="section greeting border-box">
            <div class="img-area">
                <figure>
                    <img src="../../../resources/front/site/forum/image/sub/greeting1.jpg" alt=" ">
                    <figcaption>
                        <h4>DX교육데이터협회장 김두연</h4>
                  <%--      <span>前) 건양대학교 교수/창의융합대학 학장</span>
                        <span>前) 교육부 교육정보화과장</span>
                        <span>前) 한국교육학술정보원 연구위원</span>--%>
                    </figcaption>
                </figure>
            </div>
            <div class="txt-area">
                <h5>DX교육데이터협회를 방문해 주셔서 감사합니다.</h5>
                <p>4차 산업혁명의 핵심인 빅데이터와 인공지능(AI)은 다양한 분야에 적용되어 새로운 가치를 창출하고 있습니다. 특히 교육분야는 정부와 민간 등 여러 분야에서 양질의 데이터를 보유하고 있어 데이터의 가치창출 측면에서 타 분야 대비 잠재력이 매우 크다고 평가하고 있습니다.</p>
                <p>DX교육데이터협회는 공공기관, 각 급 학교, 민간기업 그리고 각 분야의 전문가들이 모여 데이터 기반의 맞춤형 개별 학습, 학생 주도의 능동적 학습 등 혁신적인 교육방법 확산을 시작으로 미래교육을 선도하고자 합니다.</p>
                <p>이를 위해, 데이터와 인공지능을 활용한 교육혁신 방안과 사례를 공유하고자 미래교육 AI포럼을 개최하겠습니다. 이를 교육에 활용하기 위한 정책을 개발하고 제안하겠습니다. 또, 교원이 주체가 되어 교육의 디지털 대전환이 이루어 질수 있도록 지원하며, 회원의 권익보호에 최선을 다 하겠습니다.</p>
                <p>감사합니다.</p>
                <cite class="sign">DX교육데이터협회장 김두연 올림</cite>
            </div>
        </section>
        <%--<section class="section greeting border-box">
            <div class="img-area">
                <figure>
                    <img src="../../../resources/front/site/forum/image/sub/greeting2.jpg" alt=" ">
                    <figcaption>
                        <h4>경상남도 교육감 박종훈</h4>
                    </figcaption>
                </figure>
            </div>
            <div class="txt-area">
                <h5>깊어가는 가을이 이제 겨울의 시작으로 이어지고 있습니다.</h5>
                <p>차가워지는 날씨 속에서도 미래교육에 대한 뜨거운 열기로 가득한 ‘미래교육 AI포럼’ 개최를 진심으로 축하합니다.</p>
                <p>우리는 사회의 디지털 전환을 일상생활에서 직접 경험하고 있습니다. 정보통신기술의 급속한 변화는 지식과 정보의 생산, 접근, 활용 방식을 바꾸고 있으며, 교육에 있어서 디지털 전환을 강력하게 촉구하고 있습니다. </p>
                <p>코로나19로 디지털화가 가속화하고 데이터 축적을 통한 인공지능의 도입이 확산하고 있습니다. 학령인구 감소와 시대적 변화에 따른 교육의 역할에 대한 근본적인 고민이 제기되고, 미래 사회를 살아갈 학생의 역량 제고를 위해 새로운 가치 창출을 위한 교육 데이터 활용의 필요성이 대두되었습니다. 아울러, 디지털 전환기 교육자치 역량 제고와 교육의 공공성, 신뢰성 제고를 위한 빅데이터 와 인공지능 기반의 새로운 체제 구축이 필요해졌습니다. </p>
                <p>이에 경상남도교육청은 지난 2021년 ‘교육 대전환’을 선언하고, 인공지능과 빅데이터를 활용한 학생 맞춤형 교육으로 ‘아이들의 개별성을 삶의 힘으로 만들어주는 교육’, ‘지속 가능한 미래를 만들어 가는 교육’을 만들어 가고 있습니다.</p>
                <p>오늘 포럼은 2021년 유네스코 ‘함께 그려보는 우리의 미래’ 보고서가 던진 미래의 교육을 위해 ‘우리가 계속해야 할 것과 중단해야 할 것, 창조적으로 새롭게 만들어내야 할 것은 무엇인가’라는 세 가지 질문에 대해 깊이 있게 생각하고, 토론하여 교육의 미래를 만들어 가는 중요한 디딤돌을 놓는 자리라고 생각합니다.</p>
                <p>교육의 새로운 미래를 창조적으로 만들어 가기 위해 오늘 행사를 준비해주신 분과 함께 해주신 모든 분께 감사드립니다.</p>
                <cite class="sign">경상남도 교육감 박종훈</cite>
            </div>
        </section>
        <section class="section greeting border-box">
            <div class="img-area">
                <figure>
                    <img src="../../../resources/front/site/forum/image/sub/greeting3.jpg" alt=" ">
                    <figcaption>
                        <h4>서울특별시 교육감 조희연</h4>
                    </figcaption>
                </figure>
            </div>
            <div class="txt-area">
                <h5>안녕하십니까?<br>
                    <em class="spot2">미래다움으로 새로운 인간다움을 기르는</em> 서울특별시교육감 조희연입니다.</h5>
                <p>먼저, 교육 데이터를 어떻게 활용할 것인가에 대해 논의할 자리가 만들어진 것에 대해 기쁘게 생각합니다.<br>
                    아울러, 자리를 함께 준비해 주신 박종훈 경상남도교육감님과 강준호 서울대 사범대학장님께 감사드립니다.
                </p>
                <p>미래 사회에서 데이터의 활용은 공교육에 큰 변화를 이끌 것입니다. 전통적인 교육과정은 디지털 교육과정으로 전환되어 학습자의 역량을 발굴하고, 학습자에게 성공적인 학습 경험을 제공해 줄 수 있는 맞춤형 학습이 강조되고 있습니다.</p>
                <p>이러한 시대 변화에 맞춰 우리 서울시교육청은 원격수업지원 플랫폼인 뉴쌤을 인공지능 기반 맞춤형 교수학습 플랫폼으로 전환하고자「뉴쌤3.0 고도화 계획」을 수립하였습니다. </p>
                <p>미래교육 환경지원을 위한 블랜디드 통합수업 지원체계를 통한‘질 높은 공교육’의 실현, 교육과정에서 학생들의 학습 경험 데이터 수집 및 분석을 위한 인공지능 기반 교수학습 지원 서비스로의 고도화를 모색하고 있습니다.</p>
                <p>이를 통해 서울교육의 데이터 파이프라인을 위한 통합 로그인 체계 구현, LTI 기반 서비스 연동, 학습분석지표를 정의하여 데이터 분석을 기반으로 개별 학습자 맞춤형 처방과 교원의 교수학습을 지원할 것입니다.</p>
                <p>서울시교육청은 메타버스를 활용한 수학 학습 플랫폼을 전국 교육청 최초로 구축·운영하고 있습니다. 여기서 한 걸음 더 나아가 교육공간, 창작공간, 다양한 콘텐츠, 마이룸이 있는 서울형 메타버스 플랫폼을 구축할 것입니다.
                </p>
                <p>메타버스 환경에서 발생하는 학습 경험 데이터를 수집·분석하여 학습자 처방을 해주는 새로운 모델을 공교육에서 제시하는 계기가 되도록 하겠습니다.</p>
                <p> 서울특별시교육청과 경상남도교육청은 올 초 업무 협약과 실무 추진을 통해 학생 중심 개별 맞춤형 교육 실현을 위해 인공지능 기반 한국형 교육데이터셋 연구 개발의 첫 걸음을 디뎠습니다. 공교육에서의 정형·비정형 데이터 수집 및 활용 방안과 데이터 표준 지표를 마련하기 위해 노력할 것입니다.</p>
                <p>오늘 포럼에서 나온 다양한 피드백을 통해 기업 생태계 포용 방안과 공교육에서 인공지능(AI) 기반 교수학습 방안을 체계적으로 마련해 나갈 것입니다.</p>
                <p>공교육에서 이러한 시도는 한국 교육의 새로운 지평을 여는 기틀이 될 것이며, 나아가 세계적으로 우리 교육의 우수성을 알리는 계기가 될 것입니다.</p>
                <p>
                    한 명 한 명의 아이들이 주도적으로 살아갈 수 있도록 다양성이 꽃피는 공존의 혁신미래교육을 만들기 위해 서울시교육청이 한 발 더 나아가겠습니다.</p>
                <p>감사합니다.</p>
                <cite class="sign">서울특별시 교육감 조희연</cite>
            </div>
        </section>
        <section class="section greeting border-box">
            <div class="img-area">
                <figure>
                    <img src="../../../resources/front/site/forum/image/sub/greeting4.jpg" alt=" ">
                    <figcaption>
                        <h4>서울대학교 사범대학장 강준호</h4>
                    </figcaption>
                </figure>
            </div>
            <div class="txt-area">
                <h5>여러분 반갑습니다. 서울대학교 사범대학 학장 강준호입니다.</h5>
                <p>미래교육과 교육혁신에 관심을 가진 여러 전문가, 연구자, 교육 관계자 여러분과 자리를 함께하게 되어 기쁘게 생각합니다. ‘미래교육 AI 포럼’은 서울대 사범대학이 경남교육청, 서울시교육청과 함께 인공지능 시대 교육의 새로운 방향을 모색하는 뜻깊은 자리가 될 것입니다. </p>
                <p>우리 사회는 교육환경의 대전환기를 맞이하였습니다. 디지털 전환, 학령인구 감소, 지식의 폭발적 생산과 유통 등 동시다발적이고 총체적인 변화의 물결 속에 교육은 새로운 도전에 직면해 있습니다. 특히, 인공지능 기반의 교육혁신이 가속화되고 있는 상황에서 지식 전달 중심의 획일적인 교육을 개별 학습자를 위한 맞춤형 교육으로 전환하기 위해 교육 정책가, 연구자, 현장 교사들의 적극적인 자세가 필요합니다. </p>
                <p>과거의 지식 전달형 교육으로는 미래 세대가 갖춰야 할 창의력과 문제해결력을 길러줄 수 없으며 다양한 사람들과 더불어 살아가는 데 필요한 공동체 의식도 함양하기 어렵습니다. 이를 극복하기 위해 학습자 개개인이 가지고 있는 잠재력을 최대로 길러주는 맞춤형 교육이 필요합니다. 이 점에서 교육데이터와 인공지능에 대한 사회적 기대가 높습니다. 교사가 간과하기 쉬운 학생의 필요와 능력을 인공지능이 정확히 진단하고 수업 개선을 위해 유용한 정보를 제공할 수 있기 때문입니다. </p>
                <p>서울대 사범대학에서는 교육의 패러다임 전환을 위해 연구개발과 교사교육에 전력을 다하고 있습니다. 인공지능 기반 맞춤형 교육을 위한 원천지식과 기술 개발을 위해 교육과 뇌과학, 컴퓨터과학, 데이터과학 등의 융복합연구를 지원하는 학습과학연구소 설립을 추진 중에 있습니다. 또한 교육부의 지원을 받아서 예비교원과 현직교원의 인공지능 및 디지털 리터러시 함양을 위한 AIEDAP(아이에답)이라는 대규모 국책사업을 진행하고 있습니다. 저희의 이러한 노력이 미래교육을 위한 초석을 다지는 데 기여하기를 희망합니다. </p>
                <p>이번 ‘미래교육 AI 포럼’이 교육데이터와 인공지능 기반의 미래교육을 설계하는 데 큰 통찰을 제공할 것으로 기대합니다. 특히, 시도교육청과 대학교가 협력함으로써 교육이론과 실천 간의 간격을 좁히고 현실적이면서도 효과적인 교육혁신을 다 함께 만들어갈 수 있을 것입니다.
                </p>
                <p>이번 포럼이 일회적인 행사로 끝나지 않고 지속 가능한 협력관계로 발전할 수 있기를 기원합니다. 포럼에 참여해주신 모든 분들께 감사드리며 인공지능 시대 미래교육의 방향을 모색하는 귀한 시간이 되기를 진심으로 바랍니다.
                </p>
                <p>감사합니다. </p>
                <cite class="sign">서울대학교 사범대학장 강준호</cite>
            </div>
        </section>--%>
    </div>
    <a href="#" class="btn-top"><span class="txt-hide">TOP</span></a>

<!--퍼블 layout-->
<javascript>
</javascript>
</body>

</html>