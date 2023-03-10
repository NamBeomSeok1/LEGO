package modoo.front.shop.goods.info.web;

import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import modoo.module.common.service.JsonResult;
import modoo.module.sale.service.SaleService;
import modoo.module.sale.service.impl.SaleVO;
import modoo.module.shop.goods.dlvy.service.OrderDlvyVO;
import modoo.module.shop.goods.info.service.GoodsItemService;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.com.cmm.ComDefaultCodeVO;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.EgovCmmUseService;
import egovframework.com.cmm.service.EgovProperties;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import modoo.module.biling.service.IniFunc;
import modoo.module.common.web.CommonDefaultController;
import modoo.module.mber.info.service.MberService;
import modoo.module.mber.info.service.MberVO;
import modoo.module.shop.cmpny.service.CmpnyService;
import modoo.module.shop.cmpny.service.CmpnyVO;
import modoo.module.shop.goods.brand.service.GoodsBrandService;
import modoo.module.shop.goods.brand.service.GoodsBrandVO;
import modoo.module.shop.goods.cart.service.CartVO;
import modoo.module.shop.goods.ctgry.service.GoodsCtgryService;
import modoo.module.shop.goods.ctgry.service.GoodsCtgryVO;
import modoo.module.shop.goods.info.service.GoodsService;
import modoo.module.shop.goods.info.service.GoodsVO;
import modoo.module.shop.goods.keyword.service.GoodsKeywordService;
import modoo.module.shop.goods.order.service.OrderService;
import modoo.module.shop.goods.order.service.OrderVO;
import modoo.module.shop.goods.sch.service.GoodsSearchService;
import modoo.module.shop.goods.sch.service.GoodsSearchVO;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class GoodsController extends CommonDefaultController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(GoodsController.class);
	
	private static final Integer BEST_FIRST_UNIT = 15;
	private static final Integer BEST_PAGE_UNIT = 30;
	private static final Integer CTGRY_PAGE_UNIT = 12;
	private static final Integer SEARCH_PAGE_UNIT = 12;
	
	//private static final String ROOT_CTGRY_ID = "GCTGRY_0000000000000";
	
	//private static final String DEFAULT_GROUP_ID = "GROUP_00000000000000";
	private static final String EZWEL_GROUP_ID = "GROUP_00000000000001";
	private static final String DEFAULT_PRTNR_ID = "PRTNR_0000";
	private static final String EZWEL_PRTNR_ID = "PRTNR_0001";
	
	@Resource(name = "goodsService")
	private GoodsService goodsService;
	
	@Resource(name = "goodsCtgryService")
	private GoodsCtgryService goodsCtgryService;
	
	@Resource(name = "goodsSearchService")
	private GoodsSearchService goodsSearchService;
	
	@Resource(name = "goodsKeywordService")
	private GoodsKeywordService goodsKeywordService;
	
	@Resource(name = "EgovCmmUseService")
	private EgovCmmUseService cmmUseService;
	
	@Resource(name = "cmpnyService")
	private CmpnyService cmpnyService;

	@Resource(name = "orderService")
	private OrderService orderService;
	
	@Resource(name = "mberService")
	private MberService mberService;
	
	@Resource(name = "goodsBrandService")
	private GoodsBrandService goodsBrandService;

	@Resource(name = "saleService")
	private SaleService saleService;

	@Resource(name = "goodsItemService")
	private GoodsItemService goodsItemService;

	/**
	 * ????????? ?????? ??????
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/embed/shop/goods/bestGoodsList.do")
	public String bestGoodsList(@ModelAttribute("searchVO") GoodsVO searchVO,
		Integer lastPageIndex, Model model) throws Exception {
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

		if(EgovUserDetailsHelper.isAuthenticated()) {
			if(!EgovUserDetailsHelper.getAuthorities().contains("ROLE_SHOP")) {
				if(EZWEL_GROUP_ID.equals(user.getGroupId())) {
					searchVO.setSearchPrtnrId(EZWEL_PRTNR_ID);
				}else {
					searchVO.setSearchPrtnrId(DEFAULT_PRTNR_ID);
				}

				System.out.println("??????"+user.getSbscrbMberAt());
				if("Y".equals(user.getSbscrbMberAt())){
					searchVO.setSearchGoodsExpsrCode("SBS");
				}else{
					searchVO.setSearchGoodsExpsrCode("GNRL");
				}
			}
		}else {
			searchVO.setSearchGoodsExpsrCode("ALL");
			searchVO.setSearchPrtnrId(DEFAULT_PRTNR_ID);
		}
		
		/* ????????? ?????? ?????? ?????? */
		if (user != null) {
			if(EZWEL_GROUP_ID.equals(user.getGroupId())) {
				searchVO.setSearchEventPrtnrId(EZWEL_PRTNR_ID);
			}else {
				searchVO.setSearchEventPrtnrId(DEFAULT_PRTNR_ID);
			}
		} else {
			searchVO.setSearchEventPrtnrId(DEFAULT_PRTNR_ID);
		}
		
		// ?????? ????????? BEST ?????? ??????
		searchVO.setSearchMainBestGoodsAt("Y");
		
		PaginationInfo paginationInfo = new PaginationInfo();
		if(lastPageIndex == null || lastPageIndex == 1) {
			if(lastPageIndex != null && lastPageIndex == 1) {
				searchVO.setPageIndex(1);
			}
			if(searchVO.getPageIndex() == 1) {
				searchVO.setRecordCountPerPage(BEST_FIRST_UNIT);
				searchVO.setFirstIndex(0);
			}else {
				searchVO.setRecordCountPerPage(30);
				searchVO.setFirstIndex(BEST_PAGE_UNIT * (searchVO.getPageIndex()-1) - BEST_FIRST_UNIT);
			}
		}else {
			searchVO.setPageUnit(BEST_PAGE_UNIT * lastPageIndex - BEST_FIRST_UNIT);
			this.setPagination(paginationInfo, searchVO);
			int pageIndex = (int)Math.round((float)searchVO.getPageUnit() / (float)BEST_PAGE_UNIT);
			searchVO.setPageIndex(pageIndex);
		}
		
		/*
		if(lastPageIndex == null ||  lastPageIndex == 1) {
			searchVO.setPageUnit(BEST_PAGE_UNIT);
		}else {
			searchVO.setPageUnit(BEST_PAGE_UNIT * lastPageIndex);
		}
		this.setPagination(paginationInfo, searchVO);
		*/
		
		List<?> resultList = goodsService.selectBestGoodsList(searchVO);
		model.addAttribute("resultList", resultList);

		int totalRecordCount = goodsService.selectBestGoodsListCnt(searchVO);
		paginationInfo.setTotalRecordCount(totalRecordCount);
		model.addAttribute("paginationInfo", paginationInfo);
		
		model.addAttribute("prtnrId", searchVO.getSearchEventPrtnrId());
		
		return "modoo/front/shop/goods/info/bestGoodsList";
	}

	/**
	 * ????????? ?????? ??????
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/embed/shop/goods/saleGoodsList.do")
	public String saleGoodsList(@ModelAttribute("searchVO") SaleVO searchVO,
								Integer lastPageIndex, Model model) throws Exception {
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

		if(EgovUserDetailsHelper.isAuthenticated()) {
			if(!EgovUserDetailsHelper.getAuthorities().contains("ROLE_SHOP")) {
				/*if(EZWEL_GROUP_ID.equals(user.getGroupId())) {
					searchVO.setSearchPrtnrId(EZWEL_PRTNR_ID);
				}else {
					searchVO.setSearchPrtnrId(DEFAULT_PRTNR_ID);
				}*/

				if("Y".equals(user.getSbscrbMberAt())){
					searchVO.setSearchGoodsExpsrCode("SBS");
				}else{
					searchVO.setSearchGoodsExpsrCode("GNRL");
				}
			}
		}else {
			searchVO.setSearchGoodsExpsrCode("ALL");
			/*searchVO.setSearchPrtnrId(DEFAULT_PRTNR_ID);*/
		}

		/* ????????? ?????? ?????? ?????? */
		/*if (user != null) {
			if(EZWEL_GROUP_ID.equals(user.getGroupId())) {
				searchVO.setSearchEventPrtnrId(EZWEL_PRTNR_ID);
			}else {
				searchVO.setSearchEventPrtnrId(DEFAULT_PRTNR_ID);
			}
		} else {
			searchVO.setSearchEventPrtnrId(DEFAULT_PRTNR_ID);
		}

		// ?????? ????????? BEST ?????? ??????
		searchVO.setSearchMainBestGoodsAt("Y");

		PaginationInfo paginationInfo = new PaginationInfo();
		if(lastPageIndex == null || lastPageIndex == 1) {
			if(lastPageIndex != null && lastPageIndex == 1) {
				searchVO.setPageIndex(1);
			}
			if(searchVO.getPageIndex() == 1) {
				searchVO.setRecordCountPerPage(BEST_FIRST_UNIT);
				searchVO.setFirstIndex(0);
			}else {
				searchVO.setRecordCountPerPage(30);
				searchVO.setFirstIndex(BEST_PAGE_UNIT * (searchVO.getPageIndex()-1) - BEST_FIRST_UNIT);
			}
		}else {
			searchVO.setPageUnit(BEST_PAGE_UNIT * lastPageIndex - BEST_FIRST_UNIT);
			this.setPagination(paginationInfo, searchVO);
			int pageIndex = (int)Math.round((float)searchVO.getPageUnit() / (float)BEST_PAGE_UNIT);
			searchVO.setPageIndex(pageIndex);
		}
		*/
		/*
		if(lastPageIndex == null ||  lastPageIndex == 1) {
			searchVO.setPageUnit(BEST_PAGE_UNIT);
		}else {
			searchVO.setPageUnit(BEST_PAGE_UNIT * lastPageIndex);
		}
		this.setPagination(paginationInfo, searchVO);
		*/

		searchVO.setPrtnrId(DEFAULT_PRTNR_ID);
		List<?> resultList = saleService.selectSaleGoodsList(searchVO);
		model.addAttribute("resultList", resultList);

		/*int totalRecordCount = goodsService.selectBestGoodsListCnt(searchVO);
		paginationInfo.setTotalRecordCount(totalRecordCount);
		model.addAttribute("paginationInfo", paginationInfo);

		model.addAttribute("prtnrId", searchVO.getSearchEventPrtnrId());*/

		return "modoo/front/shop/goods/info/saleGoodsList";
	}
	
	/**
	 * ?????? ????????? ??????
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/embed/shop/goods/mainGoodsList.do")
	public String mainGoodsList(@ModelAttribute("searchVO") GoodsVO searchVO, Model model) throws Exception {
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();


		if(EgovUserDetailsHelper.isAuthenticated()) {
			if(!EgovUserDetailsHelper.getAuthorities().contains("ROLE_SHOP")) {
				if(EZWEL_GROUP_ID.equals(user.getGroupId())) {
					searchVO.setSearchPrtnrId(EZWEL_PRTNR_ID);
				}else {
					searchVO.setSearchPrtnrId(DEFAULT_PRTNR_ID);
				}

				System.out.println("??????"+user.getSbscrbMberAt());
				if("Y".equals(user.getSbscrbMberAt())){
					searchVO.setSearchGoodsExpsrCode("SBS");
				}else{
					searchVO.setSearchGoodsExpsrCode("GNRL");
				}
			}
		}else {
			searchVO.setSearchGoodsExpsrCode("ALL");
			searchVO.setSearchPrtnrId(DEFAULT_PRTNR_ID);
		}
		
		List<?> resultList = goodsService.selectMainGoodsList(searchVO);
		model.addAttribute("resultList", resultList);

		//int totalRecordCount = goodsService.selectMainGoodsListCnt(searchVO);
		
		model.addAttribute("prtnrId", searchVO.getSearchEventPrtnrId());
		
		return "modoo/front/shop/goods/info/mainGoodsList";
	}

	/**
	 * ?????? ?????? ????????? ??????
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/embed/shop/goods/prvuseGoodsList.do")
	public String mainGoodsList(Model model) throws Exception {
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

		if(user!=null){
			List<?> prvuseGoodsList = goodsService.selectPrvuseGoodsList(user.getId());
			if(prvuseGoodsList.size()>0)model.addAttribute("prvuseGoodsList", prvuseGoodsList);
		}

		return "modoo/front/shop/goods/info/prvuseGoodsList";
	}

	/**
	 * ?????? ??????
	 * @param searchVO
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/shop/goods/goodsView.do")
	public String goodsView(@ModelAttribute("searchVO") GoodsVO searchVO, Model model,HttpServletRequest request) throws Exception {
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if(EgovUserDetailsHelper.isAuthenticated()) {
			model.addAttribute("user", user);
			if(!EgovUserDetailsHelper.getAuthorities().contains("ROLE_SHOP")) {
				if(EZWEL_GROUP_ID.equals(user.getGroupId())) {
					searchVO.setSearchPrtnrId(EZWEL_PRTNR_ID);
				}else {
					searchVO.setSearchPrtnrId(DEFAULT_PRTNR_ID);
				}
			}
		}else {
			searchVO.setSearchPrtnrId(DEFAULT_PRTNR_ID);
		}
		
		//????????????
		ComDefaultCodeVO codeVO = new ComDefaultCodeVO();
		codeVO.setCodeId("CMS023");
		List<?> wdCodeList = cmmUseService.selectCmmCodeDetail(codeVO);
		model.addAttribute("wdCodeList", wdCodeList);

//		if(!EgovUserDetailsHelper.getAuthorities().contains("ROLE_SHOP")) { //?????? ????????? ????????? ??????
//			searchVO.setSearchRegistSttusCode("C"); //????????????
//		}else {
//			model.addAttribute("viewMode", "Y");
//		}
		
		//?????? ??????
		GoodsVO goods = goodsService.selectGoods(searchVO);
		if(goods == null) {
			model.addAttribute("ERR_CODE", "NONE");
			return "modoo/front/shop/goods/info/goodsViewError";
		}
		model.addAttribute("goods", goods);
		
		//??????????????????
		if("Y".equals(goods.getAdultCrtAt()) && user!=null){
			MberVO mber = new MberVO();
			mber.setEsntlId(user.getUniqId());
			mber = mberService.selectMber(mber);
			if(mber!=null){
				model.addAttribute("adultCrtYn" , mber.getAdultCrtYn());
			}else{
				model.addAttribute("adultCrtYn" , "N");
			}
			//???????????? ????????????
			HashMap<String,String> iniCertMap = new HashMap(); 
			String mid			= EgovProperties.getProperty("INICIS.card.mid");									// [??????] ????????? MID
			String siteurl		= request.getServerName();						// [??????] ????????? ????????? -> (URL Encoding ????????????)
			String tradeid		= "test12345";							// [??????] ????????? ????????????
			String diCode		= "Test001DI";							// [??????] ??? ????????? ??????
			String mstr			= "a=1|b=2";							// [??????] ????????? ???????????? -> (URL Encoding ????????????)
			String closeUrl		= "https://"+siteurl+"/embed/cardCertResult.do";				// [??????] ??????, ???????????? ?????? ??? ???????????? ????????? ????????? URL -> (URL Encoding ????????????)
			String okUrl		= "https://"+siteurl+"/embed/cardCertResult.do";	// [??????] ???????????? ?????? ????????? ????????? ?????? ????????? URL	 -> (URL Encoding ????????????)

			/* URL Encoding ???????????? ?????? */
			siteurl		= URLEncoder.encode(siteurl, "UTF-8");
			mstr		= URLEncoder.encode(mstr, "UTF-8");
			closeUrl	= URLEncoder.encode(closeUrl, "UTF-8");
			okUrl		= URLEncoder.encode(okUrl, "UTF-8");
			
			iniCertMap.put("mid", mid);
			iniCertMap.put("siteurl", siteurl);
			iniCertMap.put("tradeid", tradeid);
			iniCertMap.put("diCode", diCode);
			iniCertMap.put("mstr", mstr);
			iniCertMap.put("closeUrl", closeUrl);
			iniCertMap.put("okUrl", okUrl);
			model.addAttribute("iniCertInfo",iniCertMap);
		}
		
		int chkCnt = 0;
		//?????? ?????? ??????
		if(user!=null){
			OrderVO order = new OrderVO();
			order.setGoodsId(goods.getGoodsId());
			order.setOrdrrId(user.getId());
			chkCnt = orderService.selectExprnCnt(order);
		}
		model.addAttribute("exprnChkCnt", chkCnt);
		
		
		//?????? ??????
		CmpnyVO cmpny = new CmpnyVO();
		cmpny.setCmpnyId(goods.getCmpnyId());
		cmpny = cmpnyService.selectCmpny(cmpny);
		model.addAttribute("cmpny", cmpny);
		
		//????????? ??????
		GoodsBrandVO brand = new GoodsBrandVO();
		brand.setBrandId(goods.getBrandId());
		brand = goodsBrandService.selectGoodsBrand(brand);
		model.addAttribute("brand", brand);
		
		//?????????????????? (???????????? ???????????? ?????????)
		model.addAttribute("systemDlvyPolicyCn", EgovProperties.getProperty("GOODS.plicy.cn"));
		
		//????????? ??????
		goodsService.updateGoodsRdcnt(goods);
		
		//??????
		CartVO goodsCart = new CartVO();
		goodsCart.setOrderCo(1);
		
		model.addAttribute("goodsCart", goodsCart);
		
		/* ????????? ?????? ?????? ?????? */
		if (user != null) {
			if(EZWEL_GROUP_ID.equals(user.getGroupId())) {
				searchVO.setSearchPrtnrId(EZWEL_PRTNR_ID);
			}else {
				searchVO.setSearchPrtnrId(DEFAULT_PRTNR_ID);
			}
		} else {
			searchVO.setSearchPrtnrId(DEFAULT_PRTNR_ID);
		}
		GoodsVO goodsEventInfo = goodsService.selectGoods(searchVO);
		model.addAttribute("goodsEventInfo", goodsEventInfo);
		
		return "modoo/front/shop/goods/info/goodsView";
	}
	
	
	/**
	 * ????????????
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping("/embed/cardCertResult.do")
	public String cardCertResult(HttpServletRequest request,Model model){
		
		IniFunc iniFunc = new IniFunc();
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		try {
			String MID = EgovProperties.getProperty("INICIS.card.mid");		
			String SEEDKEY =EgovProperties.getProperty("INISIS.card.seedKey");
			String SEEDIV =EgovProperties.getProperty("INISIS.card.seedIv");
			String Resultcd		= request.getParameter("Resultcd");		// ?????? ??????
			String Resultmsg	= request.getParameter("Resultmsg");	// ?????? ????????? -> URLEncoding
			String Transid		= request.getParameter("Transid");		// ???????????? ID
			String Tradeid		= request.getParameter("Tradeid");		// ????????? ????????????
			String MSTR			= request.getParameter("MSTR");			// ????????? ???????????? -> URLEncoding
			String Signdate		= request.getParameter("Signdate");		// ????????????
			String Name			= request.getParameter("Name");			// ?????? -> [SEED ?????????]			ex) ?????????
			String Socialno		= request.getParameter("Socialno");		// ???????????? -> [SEED ?????????]		ex) 20190101
			String Sex			= request.getParameter("Sex");			// ?????? -> [SEED ?????????]			ex) M
			String Foreigner	= request.getParameter("Foreigner");	// ????????? ?????? -> [SEED ?????????]	ex) L
			String Ci			= request.getParameter("Ci");			// Ci -> ??? ?????????				comment : ??? ????????? ??? ???????????? ????????? ??????.
			String Di			= request.getParameter("Di");			// Di -> ??? ?????????				comment : ??? ????????? ??? ???????????? ????????? ??????.
			String DI_CODE		= request.getParameter("DI_CODE");		// ??? ????????? ??????
			String Mac			= request.getParameter("Mac");			// Hash Value -> [sha256]		ex)mid???+signdate???+Ci???+Tradeid???+Transid???
		
			if(StringUtils.isNotEmpty(Resultmsg)){
				Resultmsg = URLDecoder.decode(Resultmsg, "UTF-8");
			}else{
				model.addAttribute("result","cancle");
				return "modoo/front/cmm/etc/cardCertResult";
			}
			if(!"".equals(MSTR)) MSTR = URLDecoder.decode(MSTR, "UTF-8");
	
			if("0000".equals(Resultcd)){ // ?????? ?????? (0000)??? ?????? - ??????
	
				// signature ??????(????????????:??????????????? ??????)
				String oriMac = MID+Signdate+Ci+Tradeid+Transid;
				oriMac = iniFunc.encrypteSHA256(oriMac); // oriMac ????????? sha-256 ??????
	
				/* ????????? ????????? ?????? ?????? */
				if(!oriMac.equals(Mac)){
					/*
					 * ????????? ????????? ?????? ??????
					 */
					model.addAttribute("result",false);
				}else{
					/*
					 * ?????? ?????? ??? ????????? DB??????
					 */
					MberVO mber = new MberVO();
					mber.setEsntlId(user.getUniqId());
					mber.setAdultCrtYn("Y");
					mberService.updateMber(mber);
					model.addAttribute("result",true);
					LOGGER.info("?????? ???????????? ????????? ?????? ??????");
				}
			}else{ // ???????????? (0000) ?????? ?????? - ?????? ??????
				/*
				 * ?????? ?????? ??? ????????? DB??????
				 */
				model.addAttribute("result",false);
				 LOGGER.info("?????? ???????????? ????????? ?????? ??????");
			}
		
		} catch (Exception e) {
			loggerError(LOGGER, e);
			 LOGGER.info("?????? ???????????? ????????? ?????? ??????"+e);
			 model.addAttribute("result",false);
		}
		return "modoo/front/cmm/etc/cardCertResult";
	}
	
	/**
	 * ????????? ?????? ?????????
	 * @param model
	 * @return
	 * @throws Exception
	 */
	/*@RequestMapping(value = "/shop/goods/goodsGuidance.do")
	public String goodsGuidance(GoodsVO searchVO, Model model) throws Exception {
		CmpnyVO cmpny = new CmpnyVO();
		cmpny.setCmpnyId(searchVO.getCmpnyId());
		
		cmpny = cmpnyService.selectCmpny(cmpny);
		model.addAttribute("cmpny", cmpny);
		
		return "modoo/front/shop/goods/info/goodsGuidance";
	}*/
	
	/**
	 * ?????? ???????????? ??????
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/shop/goods/goodsCtgryList.do")
	public String goodsCtgryList(@ModelAttribute("searchVO") GoodsVO searchVO, Model model) throws Exception {
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if(EgovUserDetailsHelper.isAuthenticated()) {
			if(!EgovUserDetailsHelper.getAuthorities().contains("ROLE_SHOP")) {
				if(EZWEL_GROUP_ID.equals(user.getGroupId())) {
					searchVO.setSearchPrtnrId(EZWEL_PRTNR_ID);
				}else {
					searchVO.setSearchPrtnrId(DEFAULT_PRTNR_ID);
				}

				if("Y".equals(user.getSbscrbMberAt())){
					searchVO.setSearchGoodsExpsrCode("SBS");
				}else{
					searchVO.setSearchGoodsExpsrCode("GNRL");
				}
			}
		}else {
			searchVO.setSearchGoodsExpsrCode("ALL");
			searchVO.setSearchPrtnrId(DEFAULT_PRTNR_ID);
		}
		
		/* ????????? ?????? ?????? ?????? */
		if (user != null) {
			if(EZWEL_GROUP_ID.equals(user.getGroupId())) {
				searchVO.setSearchEventPrtnrId(EZWEL_PRTNR_ID);
			}else {
				searchVO.setSearchEventPrtnrId(DEFAULT_PRTNR_ID);
			}
		} else {
			searchVO.setSearchEventPrtnrId(DEFAULT_PRTNR_ID);
		}
		
		//?????? (?????? > ?????????????????????) GCTGRY_0000000000027
		if("GCTGRY_0000000000002".equals(searchVO.getSearchGoodsCtgryId()) || (StringUtils.isNotEmpty(searchVO.getSearchSubCtgryId()) && "GCTGRY_0000000000027".equals(searchVO.getSearchSubCtgryId()))) {
			// ????????????????????? ???????????? ????????? ?????? ??? ??? ????????? ????????? 2020.12.03
		}/*else {
			// ??????????????? ??????
			searchVO.setSearchKndCode("SBS");
		}*/

		// ??????????????? ??????
		//searchVO.setSearchKndCode("SBS");
		
		GoodsCtgryVO ctgry = new GoodsCtgryVO();
		ctgry.setSearchPrtnrId(searchVO.getSearchPrtnrId());
		List<GoodsCtgryVO> ctgryMenuList = goodsCtgryService.selectGoodsCtgryTreeList(ctgry);
		model.addAttribute("ctgryMenuList", ctgryMenuList);
		
		/*
		GoodsCtgryVO ctgry2 = new GoodsCtgryVO();
		ctgry2.setGoodsCtgryId(searchVO.getGoodsCtgryId());
		ctgry2.setSearchPrtnrId(searchVO.getSearchPrtnrId());
		List<GoodsCtgryVO> subCtgryList = goodsCtgryService.selectSubCtgryList(ctgry2);
		model.addAttribute("subCtgryList", subCtgryList);
		*/
		
		PaginationInfo paginationInfo = new PaginationInfo();
		searchVO.setPageUnit(CTGRY_PAGE_UNIT);
		//this.setPagination(paginationInfo, searchVO);
		this.setPagination(paginationInfo, searchVO, 5); //2020.11.25 ????????????
		
		//?????? ORDER
		if(StringUtils.isNotEmpty(searchVO.getSearchOrderField())) {
			if("LPC".equals(searchVO.getSearchOrderField())) {
				searchVO.setSearchOrderType("ASC");
			} else if( "HPC".equals(searchVO.getSearchOrderField())
					|| "RDCNT".equals(searchVO.getSearchOrderField()) 
					|| "LAT".equals(searchVO.getSearchOrderField()) 
					|| "SEL".equals(searchVO.getSearchOrderField()) ) {
				searchVO.setSearchOrderType("DESC");
			}
		} else {
			searchVO.setSearchOrderField("RDCNT"); //?????? ?????????
			searchVO.setSearchOrderType("DESC");
		}
		
		searchVO.setSearchRegistSttusCode("C"); //????????????
		searchVO.setSearchCtgrySnAt("Y");//???????????????????????????

		List<?> resultList = goodsService.selectGoodsList(searchVO);
		model.addAttribute("resultList", resultList);

		int totalRecordCount = goodsService.selectGoodsListCnt(searchVO);
		paginationInfo.setTotalRecordCount(totalRecordCount);
		model.addAttribute("paginationInfo", paginationInfo);
		
		return "modoo/front/shop/goods/info/goodsCtgryList";
	}
	
	/**
	 * ?????? ????????????
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/shop/goods/goodsSearch.do")
	public String goodsSearch(@ModelAttribute("searchVO") GoodsVO searchVO,
			String storeSearchWrdAt,
			HttpSession session, Model model) throws Exception {
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if(EgovUserDetailsHelper.isAuthenticated()) {
			if(!EgovUserDetailsHelper.getAuthorities().contains("ROLE_SHOP")) {
				if(EZWEL_GROUP_ID.equals(user.getGroupId())) {
					searchVO.setSearchPrtnrId(EZWEL_PRTNR_ID);
				}else {
					searchVO.setSearchPrtnrId(DEFAULT_PRTNR_ID);
				}
				if("Y".equals(user.getSbscrbMberAt())){
					searchVO.setSearchGoodsExpsrCode("SBS");
				}else{
					searchVO.setSearchGoodsExpsrCode("GNRL");
				}
			}
		}else {
			searchVO.setSearchGoodsExpsrCode("ALL");
			searchVO.setSearchPrtnrId(DEFAULT_PRTNR_ID);
		}
		
		// ??????????????? ??????
		//searchVO.setSearchKndCode("SBS");
		
		PaginationInfo paginationInfo = new PaginationInfo();
		searchVO.setPageUnit(SEARCH_PAGE_UNIT);
		this.setPagination(paginationInfo, searchVO);
		
		//?????? ORDER
		if(StringUtils.isNotEmpty(searchVO.getSearchOrderField())) {
			if("LPC".equals(searchVO.getSearchOrderField())) {
				searchVO.setSearchOrderType("ASC");
			} else if( "HPC".equals(searchVO.getSearchOrderField())
					|| "RDCNT".equals(searchVO.getSearchOrderField()) 
					|| "LAT".equals(searchVO.getSearchOrderField()) 
					|| "SEL".equals(searchVO.getSearchOrderField()) ) {
				searchVO.setSearchOrderType("DESC");
			}
		} else {
			searchVO.setSearchOrderField("RDCNT"); //?????? ?????????
			searchVO.setSearchOrderType("DESC");
		}

		
		// ??????????????? ????????? ??????
		List<String> searchWordList = new ArrayList<String>();
		if(StringUtils.isNotEmpty(searchVO.getSearchKeyword())) {
			searchWordList = Arrays.asList(searchVO.getSearchKeyword().split(" "));
		}
		searchVO.setSearchGoodsKeyword(searchWordList);

		searchVO.setSearchRegistSttusCode("C"); //????????????
		
		//????????? ???????????? ????????? ?????? ??????
		List<?> keywordList = goodsKeywordService.selectRelationGoodsKeywordList(searchVO);
		model.addAttribute("keywordList", keywordList);
		
		
		List<?> resultList = goodsService.selectGoodsList(searchVO);
		model.addAttribute("resultList", resultList);

		int totalRecordCount = goodsService.selectGoodsListCnt(searchVO);
		paginationInfo.setTotalRecordCount(totalRecordCount);
		model.addAttribute("paginationInfo", paginationInfo);
		
		
		//???????????? ??? ?????? ??????
		if(StringUtils.isNotEmpty(searchVO.getSearchKeyword()) && StringUtils.isNotEmpty(storeSearchWrdAt) && "Y".equals(storeSearchWrdAt)) {
			GoodsSearchVO goodsSearch = new GoodsSearchVO();
			if(user != null) {
				goodsSearch.setEsntlId(user.getUniqId());
			}
			goodsSearch.setSessionId(session.getId());
			goodsSearch.setSrchwrd(searchVO.getSearchKeyword());
			goodsSearchService.insertGoodsSearch(goodsSearch);
		}

		return "modoo/front/shop/goods/info/goodsSearch";
	}

	/**
	 * ????????? ???????????? ????????? ??????
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/shop/goods/secondOptValues.json")
	@ResponseBody
	public JsonResult getOrderStatusList(OrderDlvyVO searchVO,
										 @RequestParam(name="opt1", required = false) String opt1,
										 @RequestParam(name="goodsId", required = false) String goodsId) throws Exception {
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		JsonResult jsonResult = new JsonResult();
		try {

			EgovMap paramMap = new EgovMap();
			paramMap.put("opt1", opt1);
			paramMap.put("goodsId", goodsId);

			jsonResult.put("resultList", goodsItemService.selectOptnValues(paramMap));
			jsonResult.setSuccess(true);
		}catch (Exception e) {
			e.printStackTrace();
			jsonResult.setMessage("");
			jsonResult.setSuccess(false);
		}

		return jsonResult;
	}
	

}
