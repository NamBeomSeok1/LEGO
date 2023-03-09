package modoo.front.cmm.web;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.swing.plaf.synth.SynthOptionPaneUI;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.batch.core.scope.context.SynchronizationManagerSupport;
import org.springframework.security.access.method.P;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.EgovProperties;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import modoo.module.banner.service.BannerService;
import modoo.module.banner.service.BannerVO;
import modoo.module.common.service.JsonResult;
import modoo.module.common.util.SiteDomainHelper;
import modoo.module.common.web.CommonDefaultController;
import modoo.module.event.service.GoodsEventService;
import modoo.module.event.service.impl.GoodsEventVO;
import modoo.module.mber.info.service.MberService;
import modoo.module.mber.info.service.MberVO;
import modoo.module.popup.service.PopupService;
import modoo.module.popup.service.PopupVO;
import modoo.module.shop.goods.brand.service.GoodsBrandGroup;
import modoo.module.shop.goods.brand.service.GoodsBrandService;
import modoo.module.shop.goods.brand.service.GoodsBrandVO;
import modoo.module.shop.goods.cart.service.CartService;
import modoo.module.shop.goods.cart.service.CartVO;
import modoo.module.shop.goods.ctgry.service.GoodsCtgryService;
import modoo.module.shop.goods.ctgry.service.GoodsCtgryVO;
import modoo.module.shop.goods.sch.service.GoodsSearchService;
import modoo.module.shop.goods.sch.service.GoodsSearchVO;
import modoo.module.site.service.SiteService;
import modoo.module.site.service.SiteVO;

@Controller
public class IndexController extends CommonDefaultController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(IndexController.class);
	
	@Resource(name = "popupService")
	private PopupService popupService;
	
	@Resource(name = "siteService")
	private SiteService siteService;
	
	@Resource(name = "goodsCtgryService")
	private GoodsCtgryService goodsCtgryService;
	
	@Resource(name = "mberService")
	private MberService mberService;
	
	@Resource(name = "goodsBrandService")
	private GoodsBrandService goodsBrandService;
	
	@Resource(name = "goodsSearchService")
	private GoodsSearchService goodsSearchService;
	
	@Resource(name= "cartService")
	private CartService cartService;
	
	@Resource(name="bannerService")
	private BannerService bannerService;
	
	@Resource(name="goodsEventService")
	private GoodsEventService goodsEventService;
	
	
	private static final String ROOT_CTGRY_ID = "GCTGRY_0000000000000";
	private static final int HIT_DAY = 30;
	
	private static final String EZWEL_GROUP_ID = "GROUP_00000000000001";
	private static final String DEFAULT_PRTNR_ID = "PRTNR_0000";
	private static final String EZWEL_PRTNR_ID = "PRTNR_0001";
	
	/*
	@RequestMapping(value = "/index.do")
	public String index(HttpServletRequest request, Model model) throws Exception {
		String siteId = SiteDomainHelper.getSiteId();
		boolean isLogin = EgovUserDetailsHelper.isAuthenticated();
		
		if(isLogin) {
			LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			model.addAttribute("USER", user);
			
			List<String> roleList = EgovUserDetailsHelper.getAuthorities();
			model.addAttribute("roleList", roleList);
		}
		
		PopupVO popup = new PopupVO();
		popup.setSearchSiteId(SiteDomainHelper.getSiteId());
		popup.setFirstIndex(0);
		popup.setSearchTodayAt("Y");
		popup.setRecordCountPerPage(Integer.MAX_VALUE);
		List<?> popupList = popupService.selectPopupList(popup);
		model.addAttribute("popupList", popupList);
		
		String testSessison = (String)((HttpServletRequest)request).getSession().getAttribute("testsession");
		
		return "modoo/front/cmm/index";
	}
	*/

	@RequestMapping(value = "/index.do")
	public String index(HttpServletRequest request, Model model, HttpSession session) throws Exception {
		String siteId = SiteDomainHelper.getSiteId();

		GoodsEventVO goodsEvent = new GoodsEventVO();

		//팝업
		PopupVO popup = new PopupVO();
		popup.setSearchSiteId(SiteDomainHelper.getSiteId());
		popup.setFirstIndex(0);
		popup.setSearchTodayAt("Y");
		popup.setRecordCountPerPage(Integer.MAX_VALUE);
		List<?> popupList = popupService.selectPopupList(popup);
		model.addAttribute("popupList", popupList);

		return "modoo/front/site/" + siteId + "/index";
		
	}

	@RequestMapping(value = "/about/intro.do")
	public String moveIntro(HttpServletRequest request, Model model, HttpSession session) throws Exception {
		String siteId = SiteDomainHelper.getSiteId();

		return "modoo/front/site/" + siteId + "/about";

	}

	@RequestMapping(value = "/about/greeting.do")
	public String moveGreeting(HttpServletRequest request, Model model, HttpSession session) throws Exception {
		String siteId = SiteDomainHelper.getSiteId();

		return "modoo/front/site/" + siteId + "/greeting";
	}

	/**
	 * 레이아웃 공통 header
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/header.do")
	public String header(HttpServletRequest request, Model model) throws Exception {
		
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		model.addAttribute("user", user);

		String siteId = SiteDomainHelper.getSiteId();
		SiteVO site = siteService.getSiteCashedInfo(siteId);
		model.addAttribute("site", site);


		return "modoo/front/site/" + siteId + "/LAYOUT/layoutHeader";
	}
	
	
	/**
	 * 레이아웃 공통 모바일 메뉴 
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/embed/mMenu.do")
	public String mMenu(HttpServletRequest request, Model model) throws Exception {
		
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		model.addAttribute("user", user);
		
		String old_url = request.getHeader("referer");
		if(old_url.contains("/user/sign/loginUser.do") && user!=null){
			old_url="/index.do";
		}
		model.addAttribute("oldUrl", old_url);
		
		String siteId = SiteDomainHelper.getSiteId();
		SiteVO site = siteService.getSiteCashedInfo(siteId);
		model.addAttribute("site", site);
		GoodsCtgryVO ctgry = new GoodsCtgryVO();

		return "modoo/front/site/" + siteId + "/LAYOUT/mMenu";
	}
	
	/**
	 * 레이아웃 공통 footer
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/footer.do")
	public String footer(HttpServletRequest request, Model model) throws Exception {
		String siteId = SiteDomainHelper.getSiteId();
		SiteVO site = siteService.getSiteCashedInfo(siteId);
		model.addAttribute("site", site);
		
		boolean isLogin = EgovUserDetailsHelper.isAuthenticated();
		if(isLogin) {
			List<String> roleList = EgovUserDetailsHelper.getAuthorities();
			model.addAttribute("roleList", roleList);
		}
		
		return "modoo/front/site/" + siteId + "/LAYOUT/layoutFooter";
	}
	
	/**
	 * 브랜드메뉴 목록
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/embed/shop/brandMenuList.do")
	public String brandMenuList(Model model) throws Exception {
		GoodsBrandVO goodsBrand = new GoodsBrandVO();
		
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if(EgovUserDetailsHelper.isAuthenticated()) {
			if(!EgovUserDetailsHelper.getAuthorities().contains("ROLE_SHOP")) {
				if(EZWEL_GROUP_ID.equals(user.getGroupId())) {
					goodsBrand.setSearchPrtnrId(EZWEL_PRTNR_ID);
				}else {
					goodsBrand.setSearchPrtnrId(DEFAULT_PRTNR_ID);
				}
			}
		}else {
			goodsBrand.setSearchPrtnrId(DEFAULT_PRTNR_ID);
		}
		
		
		//브랜드
		List<GoodsBrandGroup> brandMenuList = goodsBrandService.selectGoodsBrandMenuList(goodsBrand);
		model.addAttribute("brandMenuList", brandMenuList);
		return "modoo/front/shop/goods/brand/brandMenuList";
	}

	/**
	 * 검색 키워드 목록 javascript
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/embed/shop/searchKeywordJs.do")
	public String searchKeywordsJs(Model model) throws Exception {
		List<GoodsSearchVO> keywordList = new ArrayList<GoodsSearchVO>();
		List<GoodsSearchVO> hitWrdList = new ArrayList<GoodsSearchVO>();
		if(EgovUserDetailsHelper.isAuthenticated()) {
			LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			GoodsSearchVO keyword = new GoodsSearchVO();
			keyword.setSearchEsntlId(user.getUniqId());
			keyword.setRecordCountPerPage(100); //임시
			keywordList = goodsSearchService.selectUserGoodsSearchWrdList(keyword);
			model.addAttribute("keywordList", keywordList);
		}else {
			model.addAttribute("keywordList", keywordList);
		}
		
		//인기검색어
		hitWrdList = goodsSearchService.selectHotGoodsSearchWrdList(HIT_DAY);
		model.addAttribute("hitWrdList", hitWrdList);
		
		return "modoo/front/cmm/searchKeywordsJs";
	}
	
	/**
	 * 사용자 검색기록 삭제
	 * @return
	 */
	@RequestMapping(value = "/shop/removeSearchKeyword.json", method = RequestMethod.POST)
	@ResponseBody
	public JsonResult removeSearchKeyword() {
		JsonResult jsonResult = new JsonResult();
		
		try {
			if(EgovUserDetailsHelper.isAuthenticated()) {
				LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
				GoodsSearchVO goodsSearch = new GoodsSearchVO();
				goodsSearch.setSearchEsntlId(user.getUniqId());
				goodsSearchService.deleteUserGoodsSearchList(goodsSearch);
				jsonResult.setSuccess(true);
				
			}
		} catch(Exception e) {
			loggerError(LOGGER, e);
			jsonResult.setSuccess(false);
			jsonResult.setMessage(egovMessageSource.getMessage("fail.common.delete")); //삭제가 실패하였습니다
		}
		
		return jsonResult;
	}
	
	
	/**
	 * 약관동의 이동
	 * @param req
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/terms.do")
	public String moveTerms(HttpServletRequest req,Model model) throws Exception{
		
		String menuNm = req.getParameter("menuNm");
		
		String siteId = SiteDomainHelper.getSiteId();
		SiteVO site = siteService.getSiteCashedInfo(siteId);
		model.addAttribute("site", site);
		
		if("info".equals(menuNm)){
			model.addAttribute("content",site.getPrivInfo());
		}else if("use".equals(menuNm)){
			model.addAttribute("content",site.getTermsCond());
		}
		model.addAttribute("title",req.getParameter("title"));
		return "modoo/front/cmm/etc/terms";
	}

	/**
	 * 약관동의 팝업
	 * @param req
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/embed/termsPopup.do")
	public String termsPopup(HttpServletRequest req,Model model) throws Exception{
		
		return "modoo/front/cmm/etc/termsPopup";
	}
	
	//인트로 페이지 - 오픈 전 임시용
	@RequestMapping(value = "/embed/intro.do")
	public String intro(HttpServletRequest request, Model model) throws Exception {
		String siteId = SiteDomainHelper.getSiteId();
		return "modoo/front/site/" + siteId + "/intro";
	}
	
	/**
	 * 사이트맵
	 * @param req
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/sitemap.do")
	public String sitemap(HttpServletRequest req,Model model) throws Exception{
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		GoodsCtgryVO ctgry = new GoodsCtgryVO();
		ctgry.setSearchUpperGoodsCtgryId(ROOT_CTGRY_ID);
		ctgry.setActvtyAt("Y");

		if(EgovUserDetailsHelper.isAuthenticated()) {
			if(!EgovUserDetailsHelper.getAuthorities().contains("ROLE_SHOP")) {
				if(EZWEL_GROUP_ID.equals(user.getGroupId())) {
					ctgry.setSearchPrtnrId(EZWEL_PRTNR_ID);
				}else {
					ctgry.setSearchPrtnrId(DEFAULT_PRTNR_ID);
				}
			}
		}else {
			ctgry.setSearchPrtnrId(DEFAULT_PRTNR_ID);
		}

		List<GoodsCtgryVO> ctgryMenuList = goodsCtgryService.selectGoodsCtgryTreeList(ctgry);

		model.addAttribute("ctgryMenuList", ctgryMenuList);
		
		return "modoo/front/cmm/sitemap";
	}
	
	/**
	 * 사이트맵 xml 파싱용 메소드
	 * @param req
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping("/sitemap.xml")
	public String sitemapsml(HttpServletRequest req) throws Exception{
		final String CTX_ROOT = "http://store.foxedu.kr";
		
		GoodsCtgryVO ctgry = new GoodsCtgryVO();
		ctgry.setSearchUpperGoodsCtgryId(ROOT_CTGRY_ID);
		ctgry.setActvtyAt("Y");
		ctgry.setSearchPrtnrId(DEFAULT_PRTNR_ID);
		
		List<GoodsCtgryVO> ctgryMenuList = goodsCtgryService.selectGoodsCtgryTreeList(ctgry);
		
		StringBuffer responseXml = new StringBuffer("");
		responseXml.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
		responseXml.append("<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">");

		responseXml.append("<url>");
		responseXml.append("<loc><![CDATA[" + CTX_ROOT +"]]></loc>");
		responseXml.append("<lastmod>2022-03-21T13:20:53+09:00</lastmod>");
		responseXml.append("<changefreq>weekly</changefreq>");
		responseXml.append("<priority>0.8</priority>");
		responseXml.append("</url>");

		//인덱스
		responseXml.append("<url>");
		responseXml.append("<loc><![CDATA[" + CTX_ROOT +"/index.do"+"]]></loc>");
		responseXml.append("<lastmod>2022-03-21T13:20:53+09:00</lastmod>");
		responseXml.append("<changefreq>weekly</changefreq>");
		responseXml.append("<priority>0.8</priority>");
		responseXml.append("</url>");

		//로그인
		responseXml.append("<url>");
		responseXml.append("<loc><![CDATA[" + CTX_ROOT + "/user/sign/loginUser.do" + "]]></loc>");
		responseXml.append("<lastmod>2022-03-21T13:20:53+09:00</lastmod>");
		responseXml.append("<changefreq>weekly</changefreq>");
		responseXml.append("<priority>0.8</priority>");
		responseXml.append("</url>");

		//카테고리 url
		for (int i=0; i<ctgryMenuList.size(); i++) {
			GoodsCtgryVO ctgryMenu = ctgryMenuList.get(i);
			
			if ("Y".equals(ctgryMenu.getActvtyAt())) {
				responseXml.append("<url>");
				responseXml.append("<loc><![CDATA[" + CTX_ROOT + "/shop/goods/goodsCtgryList.do?searchGoodsCtgryId=" + ctgryMenu.getGoodsCtgryId() + "]]></loc>");
				responseXml.append("<lastmod>2022-03-21T13:20:53+09:00</lastmod>");
				responseXml.append("<changefreq>weekly</changefreq>");
				responseXml.append("</url>");	
			}
		}


		//모바일 메뉴
		responseXml.append("<url>");
		responseXml.append("<loc><![CDATA[" + CTX_ROOT + "/board/boardList.do"+"]]></loc>");
		responseXml.append("<lastmod>2022-03-21T13:20:53+09:00</lastmod>");
		responseXml.append("<changefreq>weekly</changefreq>");
		responseXml.append("<priority>0.8</priority>");
		responseXml.append("</url>");
		

		//FAQ
		responseXml.append("<url>");
		responseXml.append("<loc><![CDATA[" + CTX_ROOT + "/user/my/faqList.do?menuId=cs_FAQ" + "]]></loc>");
		responseXml.append("<lastmod>2022-03-21T13:20:53+09:00</lastmod>");
		responseXml.append("<changefreq>weekly</changefreq>");
		responseXml.append("<priority>0.7</priority>");
		responseXml.append("</url>");

		//QNA
		responseXml.append("<url>");
		responseXml.append("<loc><![CDATA[" + CTX_ROOT + "/user/my/qainfo.do?menuId=cs_siteQna&qaSeCode=SITE" + "]]></loc>");
		responseXml.append("<lastmod>2022-03-21T13:20:53+09:00</lastmod>");
		responseXml.append("<changefreq>weekly</changefreq>");
		responseXml.append("<priority>0.7</priority>");
		responseXml.append("</url>");

		//상품상세
		responseXml.append("<url>");
		responseXml.append("<loc><![CDATA[" + CTX_ROOT + "/shop/goods/goodsView.do?goodsId=GOODS_00000000001615" + "]]></loc>");
		responseXml.append("<lastmod>2022-03-21T13:20:53+09:00</lastmod>");
		responseXml.append("<changefreq>weekly</changefreq>");
		responseXml.append("<priority>0.6</priority>");
		responseXml.append("</url>");

		responseXml.append("</urlset>");
		
		return responseXml.toString();

	}
}
