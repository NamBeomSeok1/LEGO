package modoo.cms.shop.goods.info.web;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Stream;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import modoo.module.shop.goods.info.service.GoodsCouponVO;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import modoo.module.shop.goods.label.service.GoodsLabelService;
import modoo.module.shop.goods.label.service.GoodsLabelVO;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import egovframework.com.cmm.ComDefaultCodeVO;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.EgovCmmUseService;
import egovframework.com.cmm.service.EgovProperties;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import modoo.module.common.service.FileMngUtil;
import modoo.module.common.service.JsonResult;
import modoo.module.common.util.CommonUtils;
import modoo.module.common.web.CommonDefaultController;
import modoo.module.shop.cmpny.service.CmpnyService;
import modoo.module.shop.cmpny.service.CmpnyVO;
import modoo.module.shop.cmpny.service.PrtnrCmpnyService;
import modoo.module.shop.cmpny.service.PrtnrCmpnyVO;
import modoo.module.shop.goods.brand.service.GoodsBrandService;
import modoo.module.shop.goods.brand.service.GoodsBrandVO;
import modoo.module.shop.goods.ctgry.service.GoodsCtgryService;
import modoo.module.shop.goods.ctgry.service.GoodsCtgryVO;
import modoo.module.shop.goods.image.service.GoodsImageVO;
import modoo.module.shop.goods.info.service.GoodsItemVO;
import modoo.module.shop.goods.info.service.GoodsService;
import modoo.module.shop.goods.info.service.GoodsVO;
import modoo.module.shop.hdry.service.HdryCmpnyService;
import modoo.module.shop.hdry.service.HdryCmpnyVO;

@Controller
public class CmsGoodsController extends CommonDefaultController {

	private static final Logger LOGGER = LoggerFactory.getLogger(CmsGoodsController.class);

	private static final String ROOT_CTGRY_ID = "GCTGRY_0000000000000"; //????????? ????????????ID

	@Resource(name = "cmpnyService")
	private CmpnyService cmpnyService;

	@Resource(name = "goodsService")
	private GoodsService goodsService;

	/** EgovCmmUseService */
	@Resource(name = "EgovCmmUseService")
	private EgovCmmUseService cmmUseService;

	@Resource(name = "goodsCtgryService")
	private GoodsCtgryService goodsCtgryService;

	@Resource(name = "goodsBrandService")
	private GoodsBrandService goodsBrandService;

	@Resource(name = "prtnrCmpnyService")
	private PrtnrCmpnyService prtnrCmpnyService;

	@Resource(name = "hdryCmpnyService")
	private HdryCmpnyService hdryCmpnyService;

	@Resource(name = "goodsLabelService")
	private GoodsLabelService goodsLabelService;


	@Resource(name = "fileMngUtil")
	private FileMngUtil fileMngUtil;

	/**
	 * ?????? ??????
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/decms/shop/goods/goodsManage.do")
	public String goodsManage(@ModelAttribute("searchVO") GoodsVO searchVO, Model model) throws Exception {
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if(!EgovUserDetailsHelper.getAuthorities().contains("ROLE_EMPLOYEE")) {
			if(StringUtils.isEmpty(user.getCmpnyId())) { //?????? ????????? ????????? ?????????.
				return "redirect:/decms/index.do";
			}
			searchVO.setSearchCmpnyId(user.getCmpnyId());
		}

		GoodsCtgryVO goodsCtgry = new GoodsCtgryVO();
		goodsCtgry.setSearchUpperGoodsCtgryId(ROOT_CTGRY_ID);
		List<?> cate1List = goodsCtgryService.selectGoodsCtgryList(goodsCtgry);
		model.addAttribute("cate1List", cate1List);

		//?????? ?????? ?????????
		EgovMap sttusCntinfo = goodsService.selectGoodsSttusCnt(searchVO);
		model.addAttribute("sttusCntinfo", sttusCntinfo);

		//??????????????????
		ComDefaultCodeVO codeVO = new ComDefaultCodeVO();
		codeVO.setCodeId("CMS013");
		List<?> registSttusCodeList = cmmUseService.selectCmmCodeDetail(codeVO);
		model.addAttribute("registSttusCodeList", registSttusCodeList);

		//????????????????????????
		codeVO.setCodeId("CMS033");
		List<?> vchKindCodeList = cmmUseService.selectCmmCodeDetail(codeVO);
		model.addAttribute("vchKindCodeList", vchKindCodeList);

		//????????????????????????
		codeVO.setCodeId("CMS035");
		List<?> goodsExpsrCodeList = cmmUseService.selectCmmCodeDetail(codeVO);
		model.addAttribute("goodsExpsrCodeList", goodsExpsrCodeList);


		return "modoo/cms/shop/goods/info/goodsManage";
	}

	/**
	 * ?????? ??????
	 * @param searchVO
	 * @return
	 */
	@RequestMapping(value = "/decms/shop/goods/goodsList.json")
	@ResponseBody
	public JsonResult goodsList(GoodsVO searchVO,
								@RequestParam(name="searchCateCode1", required = false) String searchCateCode1,
								@RequestParam(name="searchCateCode2", required = false) String searchCateCode2,
								@RequestParam(name="searchCateCode3", required = false) String searchCateCode3
	) {
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		JsonResult jsonResult = new JsonResult();

		if(!EgovUserDetailsHelper.getAuthorities().contains("ROLE_EMPLOYEE")) {
			if(StringUtils.isEmpty(user.getCmpnyId())) { //?????? ????????? ????????? ?????????.
				jsonResult.setMessage(egovMessageSource.getMessage("cms.fail.not.cmpnyId")); //??????????????? ???????????????.
				jsonResult.setSuccess(false);
				return jsonResult;
			}
			searchVO.setSearchCmpnyId(user.getCmpnyId());
		}

		try {
			if(StringUtils.isNotEmpty(searchCateCode3)) {
				searchVO.setSearchGoodsCtgryId(searchCateCode3);
			}else if(StringUtils.isNotEmpty(searchCateCode2)) {
				searchVO.setSearchGoodsCtgryId(searchCateCode2);
			}else if(StringUtils.isNotEmpty(searchCateCode1)) {
				searchVO.setSearchGoodsCtgryId(searchCateCode1);
			}

			/*if(StringUtils.isNotEmpty(searchVO.getSearchOrderField())) {
				if("HPC".equals(searchVO.getSearchOrderField())
						|| "DPC".equals(searchVO.getSearchOrderField())) {
					searchVO.setSearchOrderType("DESC");
				}
			}*/

			//????????????, ???????????? ??????
			if("ASC".equals(searchVO.getSearchOrderField2())){
				searchVO.setSearchOrderType("ASC");

			} else {
				searchVO.setSearchOrderType("DESC");
			}

			PaginationInfo paginationInfo = new PaginationInfo();
			if(searchVO.getPageUnit() <= 10) {
				searchVO.setPageUnit(propertiesService.getInt("gridPageUnit"));
			}
			this.setPagination(paginationInfo, searchVO);

			searchVO.setCmsAt("Y");

			List<?> resultList = goodsService.selectGoodsList(searchVO);
			jsonResult.put("list", resultList);

			int totalRecordCount = goodsService.selectGoodsListCnt(searchVO);
			paginationInfo.setTotalRecordCount(totalRecordCount);
			jsonResult.put("paginationInfo", paginationInfo);

			jsonResult.setSuccess(true);
		} catch(Exception e) {
			loggerError(LOGGER, e);
			jsonResult.setSuccess(false);
			jsonResult.setMessage(egovMessageSource.getMessage("fail.common.select")); //????????? ?????????????????????.
		}


		return jsonResult;
	}

	/**
	 * ?????? ?????? ?????? ????????????
	 * @param searchVO
	 * @param searchCateCode1
	 * @param searchCateCode2
	 * @param searchCateCode3
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/decms/shop/goods/goodsListExcel.do")
	public ModelAndView goodsListExcel(@ModelAttribute("searchVO") GoodsVO searchVO,
									   @RequestParam(name="searchCateCode1", required = false) String searchCateCode1,
									   @RequestParam(name="searchCateCode2", required = false) String searchCateCode2,
									   @RequestParam(name="searchCateCode3", required = false) String searchCateCode3, Model model) throws Exception {
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		Map<String, Object> map = new HashMap<String, Object>();

		if(EgovUserDetailsHelper.getAuthorities().contains("ROLE_SHOP")) {
			if (!EgovUserDetailsHelper.getAuthorities().contains("ROLE_ADMIN")) {
				searchVO.setSearchCmpnyId(user.getCmpnyId());
			}
			if(StringUtils.isNotEmpty(searchCateCode3)) {
				searchVO.setSearchGoodsCtgryId(searchCateCode3);
			}else if(StringUtils.isNotEmpty(searchCateCode2)) {
				searchVO.setSearchGoodsCtgryId(searchCateCode2);
			}else if(StringUtils.isNotEmpty(searchCateCode1)) {
				searchVO.setSearchGoodsCtgryId(searchCateCode1);
			}
		}

		searchVO.setRecordCountPerPage(Integer.MAX_VALUE);
		searchVO.setFirstIndex(0);
		List<?> resultList = goodsService.selectGoodsList(searchVO);
		map.put("dataList", resultList);
		map.put("template", "goods_list.xlsx");
		map.put("fileName", "????????????");

		return new ModelAndView("commonExcelView", map);
	}

	/**
	 * ?????? ?????? ???
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/decms/shop/goods/writeGoods.do", method = RequestMethod.GET)
	public String writeGoods(@ModelAttribute("searchVO") GoodsVO searchVO,
							 @ModelAttribute("copyGoodsId") String copyGoodsId, Model model) throws Exception {
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if(!EgovUserDetailsHelper.getAuthorities().contains("ROLE_EMPLOYEE")) {
			if(StringUtils.isEmpty(user.getCmpnyId())) { //?????? ????????? ????????? ?????????.
				return "redirect:/decms/index.do";
			}else {
				searchVO.setCmpnyId(user.getCmpnyId());
			}
		}
		//????????????
		ComDefaultCodeVO codeVO = new ComDefaultCodeVO();
		codeVO.setCodeId("CMS009");
		List<?> goodsKndCodeList = cmmUseService.selectCmmCodeDetail(codeVO);
		model.addAttribute("goodsKndCodeList", goodsKndCodeList);

		//??????????????????
		codeVO.setCodeId("CMS010");
		List<?> taxtSeCodeList = cmmUseService.selectCmmCodeDetail(codeVO);
		model.addAttribute("taxtSeCodeList", taxtSeCodeList);

		//?????????????????????
		codeVO.setCodeId("CMS011");
		List<?> dlvySeCodeList = cmmUseService.selectCmmCodeDetail(codeVO);
		model.addAttribute("dlvySeCodeList", dlvySeCodeList);

		//????????????_??? ??????
		codeVO.setCodeId("CMS012");
		List<?> dlvyCycleCtList = cmmUseService.selectCmmCodeDetail(codeVO);
		model.addAttribute("dlvyCycleCtList", dlvyCycleCtList);

		//??????????????????
		codeVO.setCodeId("CMS013");
		List<?> registSttusCodeList = cmmUseService.selectCmmCodeDetail(codeVO);
		model.addAttribute("registSttusCodeList", registSttusCodeList);

		//????????????????????????
		codeVO.setCodeId("CMS033");
		List<?> vchKindCodeList = cmmUseService.selectCmmCodeDetail(codeVO);
		model.addAttribute("vchKindCodeList", vchKindCodeList);

		//????????????????????????????????????
		codeVO.setCodeId("CMS034");
		List<?> vchPdTyCodeList = cmmUseService.selectCmmCodeDetail(codeVO);
		model.addAttribute("vchPdTyCodeList", vchPdTyCodeList);

		//????????????????????????
		codeVO.setCodeId("CMS035");
		List<?> goodsExpsrTyCode = cmmUseService.selectCmmCodeDetail(codeVO);
		model.addAttribute("goodsExpsrTyCode", goodsExpsrTyCode);


		//???????????? (ROOT)
		/*GoodsCtgryVO goodsCtgry = new GoodsCtgryVO();
		goodsCtgry.setSearchUpperGoodsCtgryId(ROOT_CTGRY_ID);
		List<?> cate1List = goodsCtgryService.selectGoodsCtgryList(goodsCtgry);
		model.addAttribute("cate1List", cate1List);*/

		/*//?????????
		if(StringUtils.isNotEmpty(searchVO.getCmpnyId())) {
			GoodsBrandVO goodsBrand = new GoodsBrandVO();
			goodsBrand.setFirstIndex(0);
			goodsBrand.setRecordCountPerPage(Integer.MAX_VALUE);
			goodsBrand.setSearchCmpnyId(user.getCmpnyId());
			List<GoodsBrandVO> brandList = goodsBrandService.selectGoodsBrandList(goodsBrand);
			model.addAttribute("brandList", brandList);
		}

		//????????? ??????
		if(StringUtils.isNotEmpty(searchVO.getCmpnyId())) {
			HdryCmpnyVO hdryCmpny = new HdryCmpnyVO();
			hdryCmpny.setSearchCmpnyId(searchVO.getCmpnyId());
			List<HdryCmpnyVO> hdryList = hdryCmpnyService.selectGoodsHdryList(hdryCmpny);
			model.addAttribute("hdryList", hdryList);
		}*/

		GoodsVO goods = new GoodsVO();
		if(StringUtils.isNotEmpty(copyGoodsId)) { // ????????? ????????? ?????????
			GoodsVO copyGoods = new GoodsVO();
			copyGoods.setGoodsId(copyGoodsId);
			goods = goodsService.selectGoods(copyGoods);

			if(!EgovUserDetailsHelper.getAuthorities().contains("ROLE_EMPLOYEE")) {
				if(!goods.getCmpnyId().equals(user.getCmpnyId())) { //??? ????????? ?????????
					return "redirect:/decms/index.do";
				}
			}

			/*List<GoodsItemVO> dGitemList = goods.getdGitemList();
			for(GoodsItemVO ivo : dGitemList) {
				ivo.setGitemId(null);
			}*/
			List<GoodsItemVO> aGitemList = goods.getaGitemList();
			for(GoodsItemVO ivo : aGitemList) {
				ivo.setGitemId(null);
			}
			List<GoodsItemVO> fGitemList = goods.getfGitemList();
			for(GoodsItemVO ivo : fGitemList) {
				ivo.setGitemId(null);
			}
			List<GoodsItemVO> qGitemList = goods.getqGitemList();
			for(GoodsItemVO ivo : qGitemList) {
				ivo.setGitemId(null);
			}

			List<GoodsItemVO> sGitemList = goods.getsGitemList();
			for(GoodsItemVO ivo : sGitemList) {
				ivo.setGitemId(null);
			}

			//????????????
			GoodsCtgryVO goodsCtgry = new GoodsCtgryVO();
			goodsCtgry.setGoodsCtgryId(goods.getGoodsCtgryId());
			EgovMap cateMap = goodsCtgryService.getGoodsCtgryDepthList(goodsCtgry, goods);
			model.addAttribute("cate1List", cateMap.get("cate1List"));
			model.addAttribute("cate2List", cateMap.get("cate2List"));
			model.addAttribute("cate3List", cateMap.get("cate3List"));

			goods.setGoodsId(null);
			for(GoodsImageVO evt : goods.getEvtImageList()) { // ???????????????
				evt.setGoodsImageNo(null);
			}
			for(GoodsImageVO gdc : goods.getGdcImageList()) { // ???????????????
				gdc.setGoodsImageNo(null);
			}
			for(GoodsImageVO gimg : goods.getGoodsImageList()) { // ???????????????
				gimg.setGoodsImageNo(null);
			}
			
			searchVO.setCmpnyId(goods.getCmpnyId());
		}else {
			//???????????? (ROOT)
			GoodsCtgryVO goodsCtgry = new GoodsCtgryVO();
			goodsCtgry.setSearchUpperGoodsCtgryId(ROOT_CTGRY_ID);
			List<?> cate1List = goodsCtgryService.selectGoodsCtgryList(goodsCtgry);
			model.addAttribute("cate1List", cate1List);
			
			if(!EgovUserDetailsHelper.getAuthorities().contains("ROLE_EMPLOYEE")) {
				goods.setCmpnyId(user.getCmpnyId());

				//?????????????????????
				PrtnrCmpnyVO prtnrCmpny = new PrtnrCmpnyVO();
				prtnrCmpny.setCmpnyId(user.getCmpnyId());
				List<PrtnrCmpnyVO> prtnrCmpnyList = prtnrCmpnyService.selectPrtnrCmpnyList(prtnrCmpny);
				goods.setPrtnrCmpnyList(prtnrCmpnyList);
			}
			goods.setGoodsKndCode("SBS"); //????????????
			goods.setBundleDlvyAt("N"); // ???????????? ?????????
			/*
			goods.setWmallRsrvmney(java.math.BigDecimal.ZERO); // ??????????????????
			goods.setWmallRsrvmneyRate(java.math.BigDecimal.ZERO); //????????????????????????
			goods.setB2cRsrvmney(java.math.BigDecimal.ZERO); // B2C?????????
			goods.setB2cRsrvmneyRate(java.math.BigDecimal.ZERO); // B2C???????????????
			*/
			goods.setGoodsRsrvmney(java.math.BigDecimal.ZERO); // ???????????????
			goods.setGoodsRsrvmneyRate(java.math.BigDecimal.ZERO); // ?????????????????????
			goods.setTaxtSeCode("TA01"); // ??????
			goods.setDlvySeCode("DS01"); // ??????
			goods.setBundleDlvyAt("Y"); // ????????????
			goods.setRegistSttusCode("R"); //??????
			goods.setOptnUseAt("N"); //??????????????????
			goods.setdOptnUseAt("N"); //????????????????????????
			goods.setaOptnUseAt("N"); //????????????????????????
			goods.setfOptnUseAt("N"); //???????????????????????????
			goods.setqOptnUseAt("N"); //????????????????????????
			goods.setDlvyPolicySeCode("DP02"); //????????????
			goods.setDlvyPolicyCn(EgovProperties.getProperty("GOODS.plicy.cn"));
			goods.setGoodsFeeRate(java.math.BigDecimal.ZERO); //????????????
			goods.setIslandDlvyPc(java.math.BigDecimal.ZERO); //???????????? ???????????????
			goods.setDlvySeCode("DS03"); //????????????
			goods.setBundleDlvyAt("N");
			goods.setSbscrptCycleSeCode("WEEK"); //????????????
			goods.setSbscrptSetleDay(3); //??????????????????????????????
			goods.setFrstOptnEssntlAt("N"); //???????????????????????????
			goods.setsOptnUseAt("N");//????????????????????????
		}
		model.addAttribute("goods", goods);

		//?????????
		if(StringUtils.isNotEmpty(searchVO.getCmpnyId())) {
			GoodsBrandVO goodsBrand = new GoodsBrandVO();
			goodsBrand.setFirstIndex(0);
			goodsBrand.setRecordCountPerPage(Integer.MAX_VALUE);
			goodsBrand.setSearchCmpnyId(user.getCmpnyId());
			List<GoodsBrandVO> brandList = goodsBrandService.selectGoodsBrandList(goodsBrand);
			model.addAttribute("brandList", brandList);
		}

		//????????? ??????
		if(StringUtils.isNotEmpty(searchVO.getCmpnyId())) {
			HdryCmpnyVO hdryCmpny = new HdryCmpnyVO();
			hdryCmpny.setSearchCmpnyId(searchVO.getCmpnyId());
			List<HdryCmpnyVO> hdryList = hdryCmpnyService.selectGoodsHdryList(hdryCmpny);
			model.addAttribute("hdryList", hdryList);
		}

		model.addAttribute("dlvyPolicyCn", EgovProperties.getProperty("GOODS.plicy.cn"));

		return "modoo/cms/shop/goods/info/goodsForm";
	}

	/**
	 * ?????? ??????
	 * @param searchVO
	 * @param goods
	 * @param bindingResult
	 * @param menuId
	 * @return
	 */
	@RequestMapping(value = "/decms/shop/goods/writeGoods.json", method = RequestMethod.POST)
	@ResponseBody
	public JsonResult writeGoods(@ModelAttribute("searchVO") GoodsVO searchVO,
								 @Valid GoodsVO goods, BindingResult bindingResult,
								 @RequestParam(value = "menuId") String menuId,
								 @RequestParam(value = "optionGrid", required = false) String optionGrid) throws Exception {
		JsonResult jsonResult = new JsonResult();
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		JSONArray jsonArray = null;

		if(optionGrid != null){
			jsonArray = (JSONArray) new JSONParser().parse(optionGrid);
		}


		try {
			/*
			if(!DoubleSubmitHelper.checkAndSaveToken()) {
				//this.vaildateMessage(egovMessageSource.getMessage("cms.fail.access"), jsonResult); // ????????? ???????????????.
				String redirectUrl = "/decms/shop/goods/goodsManage.do"
						+ "?menuId=" + menuId
						+ "&searchCondition" + searchVO.getSearchCondition()
						+ "&searchKeyword=" + searchVO.getSearchKeyword()
						+ "&searchCateCode1=" + searchVO.getSearchCateCode1()
						+ "&searchCateCode2=" + searchVO.getSearchCateCode2()
						+ "&searchCateCode3=" + searchVO.getSearchCateCode3()
						+ "&searchCmpnyId=" + searchVO.getSearchCmpnyId()
						+ "&searchRegistSttusCode=" + searchVO.getSearchRegistSttusCode();
				jsonResult.setRedirectUrl(redirectUrl);
			}else if(!this.isHasErrorsJson(bindingResult, jsonResult, "<br/>")) {
			*/

			if(goods.getGdcImageList() == null || goods.getGdcImageList().size() == 0) {
				jsonResult.setMessage("?????? ???????????? ?????? ???????????????.");
				jsonResult.setSuccess(false);
				return jsonResult;
			}else if(goods.getGoodsImageList() == null || goods.getGoodsImageList().size() == 0) {
				jsonResult.setMessage("?????? ???????????? ?????? ???????????????.");
				jsonResult.setSuccess(false);
				return jsonResult;
			}
			else if(goods.getHdryId()== null  || goods.getHdryId().length() == 0) {
				jsonResult.setMessage("???????????? ?????? ???????????????.");
				jsonResult.setSuccess(false);
				return jsonResult;
			}

			if(!this.isHasErrorsJson(bindingResult, jsonResult, "<br/>")) {

				this.setGoodsValue(goods);

				if(!EgovUserDetailsHelper.getAuthorities().contains("ROLE_EMPLOYEE")) { // ROLE_SHOP ?????? ?????? ??????
					goods.setCmpnyId(user.getCmpnyId());
					goods.setRegistSttusCode("R"); //????????????
				}

				goods.setFrstRegisterId(user.getUniqId());


				if(StringUtils.isEmpty(goods.getGoodsCtgryId())) {
					this.vaildateMessage(egovMessageSource.getMessage("NotEmpty.goodsVO.cateCode1"), jsonResult); // ??????????????? ???????????????.
				}else {

					goodsService.insertGoods(goods , jsonArray);
					jsonResult.setSuccess(true);
					jsonResult.setMessage(egovMessageSource.getMessage("success.common.insert")); // ??????????????? ?????????????????????.
					String redirectUrl = "/decms/shop/goods/goodsManage.do"
							+ "?menuId=" + menuId
							+ "&searchCondition" + searchVO.getSearchCondition()
							+ "&searchKeyword=" + searchVO.getSearchKeyword()
							+ "&searchCateCode1=" + searchVO.getSearchCateCode1()
							+ "&searchCateCode2=" + searchVO.getSearchCateCode2()
							+ "&searchCateCode3=" + searchVO.getSearchCateCode3()
							+ "&searchCmpnyId=" + searchVO.getSearchCmpnyId()
							+ "&searchCmpnyNm=" + searchVO.getSearchCmpnyNm()
							+ "&searchGoodsId=" + searchVO.getSearchGoodsId()
							+ "&pageIndex=" + searchVO.getPageIndex()
							+ "&searchRegistSttusCode=" + searchVO.getSearchRegistSttusCode();
					jsonResult.setRedirectUrl(redirectUrl);
				}
			}
		} catch(Exception e) {
			loggerError(LOGGER, e);
			jsonResult.setSuccess(false);
			jsonResult.setMessage(egovMessageSource.getMessage("fail.common.insert")); //????????? ?????????????????????.
		}

		return jsonResult;
	}

	/**
	 * ?????? ??????
	 * @param searchVO
	 * @return
	 */
	@RequestMapping(value = "/decms/shop/goods/goodsInfo.json")
	@ResponseBody
	public JsonResult goodsInfo(GoodsVO searchVO) {
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		JsonResult jsonResult = new JsonResult();

		try {
			if(StringUtils.isEmpty(searchVO.getGoodsId())) {
				this.vaildateMessage(egovMessageSource.getMessage("cms.fail.access"), jsonResult); // ????????? ???????????????.
				LOGGER.error("goodsId ??? ??????.");
			}else {
				GoodsVO goods = goodsService.selectGoods(searchVO);

				if(!EgovUserDetailsHelper.getAuthorities().contains("ROLE_EMPLOYEE")) { // ROLE_SHOP ?????? ?????? ??????
					if(!goods.getCmpnyId().equals(user.getCmpnyId())) { // ???????????? ????????? ?????????
						jsonResult.setMessage(egovMessageSource.getMessage("cms.fail.access")); //????????? ???????????????.
						jsonResult.setSuccess(false);
						return jsonResult;
					}
				}

				jsonResult.put("goods", goods);
				jsonResult.setSuccess(true);
			}
		} catch(Exception e) {
			loggerError(LOGGER, e);
			jsonResult.setSuccess(false);
			jsonResult.setMessage(egovMessageSource.getMessage("fail.common.select")); //????????? ?????????????????????.
		}

		return jsonResult;
	}

	/**
	 * ????????? ??????
	 * @param goods
	 */
	private void setGoodsValue(GoodsVO goods) {

		/*if(StringUtils.isEmpty(goods.getGoodsSetleSeCode())) {
			goods.setGoodsSetleSeCode("SBS"); // ????????????
		}*/

		//????????????
		if(StringUtils.isEmpty(goods.getSoldOutAt())) {
			goods.setSoldOutAt("N");
		}

		if(!"Y".equals(goods.getVchUseAt())){
			goods.setVchPdTy(null);
			goods.setVchCode(null);
			goods.setVchValidPd(null);
		}else{
			if("0".equals(goods.getVchCode()))goods.setVchCode(null);
			if("0".equals(goods.getVchPdTy()))goods.setVchPdTy(null);
			if("BHC".equals(goods.getVchCode())||"ETC".equals(goods.getVchCode())){
				goods.setVchValidPd("12");
			}
		}

		// ???????????? ??????
		if(StringUtils.isNotEmpty(goods.getCateCode3())) goods.setGoodsCtgryId(goods.getCateCode3());
		else if(StringUtils.isNotEmpty(goods.getCateCode2())) goods.setGoodsCtgryId(goods.getCateCode2());
		else if(StringUtils.isNotEmpty(goods.getCateCode1())) goods.setGoodsCtgryId(goods.getCateCode1());

		/*
		//????????? ?????????
		if(goods.getWmallPc() == null) goods.setWmallPc(java.math.BigDecimal.ZERO);
		if(goods.getWmallRsrvmney() == null) goods.setWmallRsrvmney(java.math.BigDecimal.ZERO);
		if(StringUtils.isEmpty(goods.getWmallRsrvmneyRateAt())) {
			goods.setWmallRsrvmneyRateAt("N");
			goods.setWmallRsrvmneyRate(java.math.BigDecimal.ZERO);
		}

		//B2C ?????????
		if(goods.getB2cPc() == null) goods.setB2cPc(java.math.BigDecimal.ZERO);
		if(goods.getB2cRsrvmney() == null) goods.setB2cRsrvmney(java.math.BigDecimal.ZERO);
		if(StringUtils.isEmpty(goods.getB2cRsrvmneyRateAt())) {
			goods.setB2cRsrvmneyRateAt("N");
			goods.setB2cRsrvmneyRate(java.math.BigDecimal.ZERO);
		}
		*/

		//?????? ?????????
		if(goods.getGoodsPc() == null) goods.setGoodsPc(java.math.BigDecimal.ZERO);
		if(goods.getGoodsRsrvmney() == null) goods.setGoodsRsrvmney(java.math.BigDecimal.ZERO);
		if(StringUtils.isEmpty(goods.getGoodsRsrvmneyRateAt())) {
			goods.setGoodsRsrvmneyRateAt("N");
			goods.setGoodsRsrvmneyRate(java.math.BigDecimal.ZERO);
		}

		//?????????ID
		if(StringUtils.isEmpty(goods.getBrandId())) goods.setBrandId(null);
		
		goods.setMakr(CommonUtils.unscript(goods.getMakr()));
		goods.setOrgplce(CommonUtils.unscript(goods.getOrgplce()));
		goods.setCrtfcMatter(CommonUtils.unscript(goods.getCrtfcMatter()));
		goods.setCnsltTelno(CommonUtils.unscript(goods.getCnsltTelno()));
		goods.setEvntWords(CommonUtils.unscript(goods.getEvntWords()));
		goods.setGoodsIntrcn(CommonUtils.unscript(goods.getGoodsIntrcn()));
		goods.setMngrMemo(CommonUtils.unscript(goods.getMngrMemo()));
		goods.setMvpSourcCn(CommonUtils.unscript(goods.getMvpSourcCn()));
		goods.setGoodsCn(CommonUtils.unscript(goods.getGoodsCn()));

		//????????????
		if("N".equals(goods.getOptnUseAt())) {
			goods.setdOptnUseAt("N");
			goods.setaOptnUseAt("N");
			goods.setfOptnUseAt("N");

		}

		// ?????? ?????????
		if("DS03".equals(goods.getDlvySeCode())) {
			goods.setDlvyPc(java.math.BigDecimal.ZERO);
			goods.setFreeDlvyPc(java.math.BigDecimal.ZERO);
		}

	}

	/**
	 * ?????? ?????? ???
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/decms/shop/goods/modifyGoods.do", method = RequestMethod.GET)
	public String modifyGoods(@ModelAttribute("searchVO") GoodsVO searchVO, Model model) throws Exception {
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		searchVO.setAdminPageAt("Y");
		GoodsVO goods = goodsService.selectGoods(searchVO);

		if(!EgovUserDetailsHelper.getAuthorities().contains("ROLE_EMPLOYEE")) { // ROLE_SHOP ?????? ?????? ??????
			if(!goods.getCmpnyId().equals(user.getCmpnyId())) { // ???????????? ????????? ?????????
				return "redirect:/decms/index.do";
			}

			// ??????????????? ???????????? ??????????????? ????????????/??????/????????? ????????? ????????? ???????????????.
			if(!"R".equals(goods.getRegistSttusCode())) { //?????? ????????? ?????????
				model.addAttribute("readOnlyAt", "Y");
			}
		}


		//????????????
		ComDefaultCodeVO codeVO = new ComDefaultCodeVO();
		codeVO.setCodeId("CMS009");
		List<?> goodsKndCodeList = cmmUseService.selectCmmCodeDetail(codeVO);
		model.addAttribute("goodsKndCodeList", goodsKndCodeList);

		//??????????????????
		codeVO.setCodeId("CMS010");
		List<?> taxtSeCodeList = cmmUseService.selectCmmCodeDetail(codeVO);
		model.addAttribute("taxtSeCodeList", taxtSeCodeList);

		//?????????????????????
		codeVO.setCodeId("CMS011");
		List<?> dlvySeCodeList = cmmUseService.selectCmmCodeDetail(codeVO);
		model.addAttribute("dlvySeCodeList", dlvySeCodeList);
		
		//????????????_??? ??????
		codeVO.setCodeId("CMS012");
		List<?> dlvyCycleCtList = cmmUseService.selectCmmCodeDetail(codeVO);
		model.addAttribute("dlvyCycleCtList", dlvyCycleCtList);
		
		//??????????????????
		codeVO.setCodeId("CMS013");
		List<?> registSttusCodeList = cmmUseService.selectCmmCodeDetail(codeVO);
		model.addAttribute("registSttusCodeList", registSttusCodeList);

		//????????????????????????
		codeVO.setCodeId("CMS033");
		List<?> vchKindCodeList = cmmUseService.selectCmmCodeDetail(codeVO);
		model.addAttribute("vchKindCodeList", vchKindCodeList);

		//????????????????????????????????????
		codeVO.setCodeId("CMS034");
		List<?> vchPdTyCodeList = cmmUseService.selectCmmCodeDetail(codeVO);
		model.addAttribute("vchPdTyCodeList", vchPdTyCodeList);

		//????????????????????????
		codeVO.setCodeId("CMS035");
		List<?> goodsExpsrTyCode = cmmUseService.selectCmmCodeDetail(codeVO);
		model.addAttribute("goodsExpsrTyCode", goodsExpsrTyCode);

		//????????????
		GoodsCtgryVO goodsCtgry = new GoodsCtgryVO();
		goodsCtgry.setGoodsCtgryId(goods.getGoodsCtgryId());
		EgovMap cateMap = goodsCtgryService.getGoodsCtgryDepthList(goodsCtgry, goods);
		model.addAttribute("cate1List", cateMap.get("cate1List"));
		model.addAttribute("cate2List", cateMap.get("cate2List"));
		model.addAttribute("cate3List", cateMap.get("cate3List"));

		//?????????
		GoodsBrandVO goodsBrand = new GoodsBrandVO();
		goodsBrand.setFirstIndex(0);
		goodsBrand.setRecordCountPerPage(Integer.MAX_VALUE);
		goodsBrand.setSearchCmpnyId(goods.getCmpnyId());
		List<GoodsBrandVO> brandList = goodsBrandService.selectGoodsBrandList(goodsBrand);
		model.addAttribute("brandList", brandList);

		//????????? ??????
		HdryCmpnyVO hdryCmpny = new HdryCmpnyVO();
		hdryCmpny.setSearchCmpnyId(goods.getCmpnyId());
		List<HdryCmpnyVO> hdryList = hdryCmpnyService.selectGoodsHdryList(hdryCmpny);
		model.addAttribute("hdryList", hdryList);

		//?????? ?????? -----------------------------------------------------------------
		if(StringUtils.isEmpty(goods.getSbscrptCycleSeCode())) {
			goods.setSbscrptCycleSeCode("MONTH");
		}

		CmpnyVO cmpny = new CmpnyVO();
		cmpny.setCmpnyId(goods.getCmpnyId());
		cmpny = cmpnyService.selectCmpny(cmpny);


		model.addAttribute("cmpnyDlvyPolicyCn", cmpny.getCmpnyDlvyPolicyCn());
		model.addAttribute("dlvyPolicyCn", EgovProperties.getProperty("GOODS.plicy.cn"));
		model.addAttribute("goods", goods);

		return "modoo/cms/shop/goods/info/goodsForm";
	}

	/**
	 * ?????? ??????
	 * @param searchVO
	 * @param goods
	 * @param bindingResult
	 * @param menuId
	 * @return
	 */
	@RequestMapping(value = "/decms/shop/goods/modifyGoods.json", method = RequestMethod.POST)
	@ResponseBody
	public JsonResult modifyGoods(@ModelAttribute("searchVO") GoodsVO searchVO,
								  @Valid GoodsVO goods, BindingResult bindingResult,
								  @RequestParam(value = "menuId") String menuId,
								  @RequestParam(value = "optionGrid",required = false) String optionGrid) throws Exception {
		JsonResult jsonResult = new JsonResult();
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		try {
			JSONArray jsonArray = (JSONArray) new JSONParser().parse(optionGrid);
			GoodsVO checkVO = goodsService.selectGoods(goods);
			if(!EgovUserDetailsHelper.getAuthorities().contains("ROLE_EMPLOYEE")) { // ROLE_SHOP ?????? ?????? ??????
				if(!checkVO.getCmpnyId().equals(user.getCmpnyId())) {
					jsonResult.setMessage(egovMessageSource.getMessage("cms.fail.accessDenied")); //?????? ????????? ????????????.
					jsonResult.setSuccess(false);
					return jsonResult;
				}

				if(!"R".equals(checkVO.getRegistSttusCode())) { //?????? ????????? ?????????
					//????????????
					goods.setGoodsKndCode(checkVO.getGoodsKndCode());

					//????????????
					goods.setSbscrptCycleSeCode(checkVO.getSbscrptCycleSeCode());
					goods.setSbscrptWeekCycle(checkVO.getSbscrptWeekCycle());
					goods.setSbscrptDlvyWd(checkVO.getSbscrptDlvyWd());
					goods.setSbscrptMinUseWeek(checkVO.getSbscrptMinUseWeek());

					goods.setSbscrptMtCycle(checkVO.getSbscrptMtCycle());
					goods.setSbscrptMinUseMt(checkVO.getSbscrptMinUseMt());
					goods.setSbscrptDlvyDay(checkVO.getSbscrptDlvyDay());

					//??????
					goods.setOptnUseAt(checkVO.getOptnUseAt());
					goods.setdOptnUseAt(checkVO.getdOptnUseAt()); //????????????
					goods.setdGitemList(checkVO.getdGitemList());
					goods.setaOptnUseAt(checkVO.getaOptnUseAt()); //????????????
					goods.setaGitemList(checkVO.getaGitemList());
					goods.setfOptnUseAt(checkVO.getfOptnUseAt()); //???????????????
					goods.setfGitemList(checkVO.getfGitemList());
					goods.setqOptnUseAt(checkVO.getqOptnUseAt()); //??????????????????
					goods.setqGitemList(checkVO.getqGitemList());

					goods.setFrstOptnEssntlAt(checkVO.getFrstOptnEssntlAt()); //??????????????? ?????? ?????? ??????

					goods.setGoodsPc(checkVO.getGoodsPc()); //?????????
					goods.setGoodsFeeRate(checkVO.getGoodsFeeRate()); // ????????????
					goods.setGoodsSplpc(checkVO.getGoodsSplpc()); // ?????????
					goods.setGoodsRsrvmney(checkVO.getGoodsRsrvmney()); //?????? ?????????
					goods.setGoodsRsrvmneyRateAt(checkVO.getGoodsRsrvmneyRateAt()); // ?????? ????????? ????????? ????????????
					goods.setGoodsRsrvmneyRate(checkVO.getGoodsRsrvmneyRate()); // ?????? ????????? ?????????
					goods.setTaxtSeCode(checkVO.getTaxtSeCode()); //??????/??????
					goods.setDlvyPolicySeCode(checkVO.getDlvyPolicySeCode()); // ????????????



					//TODO : ?????? ??? ???????????????.
					//goods.setIslandDlvyPc(checkVO.getIslandDlvyPc()); //???????????? ?????? ?????????
					//goods.setJejuDlvyPc(checkVO.getJejuDlvyPc()); //????????? ?????????

					goods.setDlvySeCode(checkVO.getDlvySeCode()); //??????????????????
					goods.setDlvyPc(checkVO.getDlvyPc()); // ?????????
					goods.setFreeDlvyPc(checkVO.getFreeDlvyPc()); //????????????????????????

					goods.setBundleDlvyAt(checkVO.getBundleDlvyAt()); // ??????????????????
					goods.setBundleDlvyCo(checkVO.getBundleDlvyCo()); // ??????????????????


				}
				goods.setMrktPc(checkVO.getMrktPc()); //?????????
				goods.setRegistSttusCode(checkVO.getRegistSttusCode()); //???????????? 
			}
			
			/*
			if(!DoubleSubmitHelper.checkAndSaveToken()) {
				//this.vaildateMessage(egovMessageSource.getMessage("cms.fail.access"), jsonResult); // ????????? ???????????????.
				String redirectUrl = "/decms/shop/goods/goodsManage.do"
						+ "?menuId=" + menuId
						+ "&searchCondition" + searchVO.getSearchCondition()
						+ "&searchKeyword=" + searchVO.getSearchKeyword()
						+ "&searchCateCode1=" + searchVO.getSearchCateCode1()
						+ "&searchCateCode2=" + searchVO.getSearchCateCode2()
						+ "&searchCateCode3=" + searchVO.getSearchCateCode3()
						+ "&searchCmpnyId=" + searchVO.getSearchCmpnyId()
						+ "&searchRegistSttusCode=" + searchVO.getSearchRegistSttusCode();
				jsonResult.setRedirectUrl(redirectUrl);
			}else if(!this.isHasErrorsJson(bindingResult, jsonResult, "<br/>")) {
			*/

			if(goods.getGdcImageList() == null || goods.getGdcImageList().size() == 0) {
				jsonResult.setMessage("?????? ???????????? ?????? ???????????????.");
				jsonResult.setSuccess(false);
				return jsonResult;
			}else if(goods.getGoodsImageList() == null || goods.getGoodsImageList().size() == 0) {
				jsonResult.setMessage("?????? ???????????? ?????? ???????????????.");
				jsonResult.setSuccess(false);
				return jsonResult;
			}else if(goods.getHdryId()== null || goods.getHdryId().length() == 0) {
				jsonResult.setMessage("???????????? ?????? ???????????????.");
				jsonResult.setSuccess(false);
				return jsonResult;
			}

			if(!this.isHasErrorsJson(bindingResult, jsonResult, "<br/>")) {

				this.setGoodsValue(goods);

				goods.setLastUpdusrId(user.getUniqId());
				goodsService.updateGoods(goods, jsonArray);

				jsonResult.setSuccess(true);
				jsonResult.setMessage(egovMessageSource.getMessage("success.common.update")); // ??????????????? ?????????????????????.
				String redirectUrl = "/decms/shop/goods/goodsManage.do"
						+ "?menuId=" + menuId
						+ "&searchCondition" + searchVO.getSearchCondition()
						+ "&searchKeyword=" + searchVO.getSearchKeyword()
						+ "&searchCateCode1=" + searchVO.getSearchCateCode1()
						+ "&searchCateCode2=" + searchVO.getSearchCateCode2()
						+ "&searchCateCode3=" + searchVO.getSearchCateCode3()
						+ "&searchCmpnyId=" + searchVO.getSearchCmpnyId()
						+ "&searchCmpnyNm=" + searchVO.getSearchCmpnyNm()
						+ "&searchGoodsId=" + searchVO.getSearchGoodsId()
						+ "&pageIndex=" + searchVO.getPageIndex()
						+ "&searchRegistSttusCode=" + searchVO.getSearchRegistSttusCode();
				jsonResult.setRedirectUrl(redirectUrl);
			}

		} catch(Exception e) {
			loggerError(LOGGER, e);
			jsonResult.setSuccess(false);
			jsonResult.setMessage(egovMessageSource.getMessage("fail.common.update")); //????????? ?????????????????????.
		}

		return jsonResult;
	}

	/**
	 * ?????? ??????
	 * @param goods
	 * @return
	 */
	@RequestMapping(value = "/decms/shop/goods/deleteGoods.json", method = RequestMethod.POST)
	@ResponseBody
	public JsonResult deleteGoods(GoodsVO goods) {
		JsonResult jsonResult = new JsonResult();
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		try {
			if(StringUtils.isEmpty(goods.getGoodsId())) {
				this.vaildateMessage(egovMessageSource.getMessage("cms.fail.access"), jsonResult); // ????????? ???????????????.
				LOGGER.error("goodsId ??? ??????.");
			}else {
				
				/* ???????????? : ???????????? ????????? ??? ?????? ???????????? ?????? ???????????????
				GoodsVO checkVO = goodsService.selectGoods(goods);
				if(!EgovUserDetailsHelper.getAuthorities().contains("ROLE_EMPLOYEE")) { // ROLE_SHOP ?????? ?????? ??????
					if(!checkVO.getCmpnyId().equals(user.getCmpnyId())) {
						jsonResult.setMessage(egovMessageSource.getMessage("cms.fail.accessDenied")); //?????? ????????? ????????????.
						jsonResult.setSuccess(false);
						return jsonResult;
					}
				}
				*/
				//?????? ????????? ?????? ?????? ???.
				if(!EgovUserDetailsHelper.getAuthorities().contains("ROLE_EMPLOYEE")) {
					jsonResult.setMessage(egovMessageSource.getMessage("cms.fail.accessDenied")); //?????? ????????? ????????????.
					jsonResult.setSuccess(false);
					return jsonResult;
				}


				goods.setLastUpdusrId(user.getUniqId());

				goodsService.deleteGoods(goods);
				jsonResult.setSuccess(true);
				jsonResult.setMessage(egovMessageSource.getMessage("success.common.delete")); //??????????????? ?????????????????????.
			}

		} catch(Exception e) {
			loggerError(LOGGER, e);
			jsonResult.setSuccess(false);
			jsonResult.setMessage(egovMessageSource.getMessage("fail.common.delete")); //????????? ?????????????????????.
		}

		return jsonResult;
	}

	/**
	 * ?????? ????????? ????????? ?????????
	 * @param multiRequest
	 * @return
	 */
	@RequestMapping(value = "/decms/shop/goods/uploadEvtImageFile.json", method = RequestMethod.POST)
	@ResponseBody
	public JsonResult uploadEvtImageFile(final MultipartHttpServletRequest multiRequest) {
		JsonResult jsonResult = new JsonResult();

		try {
			final List<MultipartFile> fileList = multiRequest.getFiles("atchFile");
			jsonResult.setSuccess(true);
			jsonResult.put("fileList", fileMngUtil.parseGoodsFileList(fileList, "EVT")); // ?????? ???????????????


		} catch(Exception e) {
			loggerError(LOGGER, e);
			jsonResult.setSuccess(false);
			jsonResult.setMessage(egovMessageSource.getMessage("errors.file.transfer")); //??????????????? ????????? ??????????????????.
		}

		return jsonResult;
	}

	/**
	 * ?????? ?????? ????????? ?????????
	 * @param multiRequest
	 * @return
	 */
	@RequestMapping(value = "/decms/shop/goods/uploadGdcImageFile.json", method = RequestMethod.POST)
	@ResponseBody
	public JsonResult uploadGdcImageFile(final MultipartHttpServletRequest multiRequest) {
		JsonResult jsonResult = new JsonResult();

		try {
			final List<MultipartFile> fileList = multiRequest.getFiles("atchFile");
			jsonResult.setSuccess(true);
			jsonResult.put("fileList", fileMngUtil.parseGoodsFileList(fileList, "GDC")); // ?????? ???????????????


		} catch(Exception e) {
			loggerError(LOGGER, e);
			jsonResult.setSuccess(false);
			jsonResult.setMessage(egovMessageSource.getMessage("errors.file.transfer")); //??????????????? ????????? ??????????????????.
		}

		return jsonResult;
	}
	
	/**
	 * ?????? ????????? ?????????
	 * @param multiRequest
	 * @return
	 */
	@RequestMapping(value = "/decms/shop/goods/uploadGnrImageFile.json", method = RequestMethod.POST)
	@ResponseBody
	public JsonResult uploadGnrImageFile(final MultipartHttpServletRequest multiRequest) {
		JsonResult jsonResult = new JsonResult();

		try {
			final List<MultipartFile> fileList = multiRequest.getFiles("atchFile");
			jsonResult.setSuccess(true);
			jsonResult.put("fileList", fileMngUtil.parseGoodsFileList(fileList, "GNR")); // ?????? ?????????


		} catch(Exception e) {
			loggerError(LOGGER, e);
			jsonResult.setSuccess(false);
			jsonResult.setMessage(egovMessageSource.getMessage("errors.file.transfer")); //??????????????? ????????? ??????????????????.
		}

		return jsonResult;
	}

	/**
	 * ?????? ?????? ????????? ?????????
	 * @param multiRequest
	 * @return
	 */
	@RequestMapping(value = "/decms/shop/goods/uploadLabelImageFile.json", method = RequestMethod.POST)
	@ResponseBody
	public JsonResult uploadLabelImageFile(final MultipartHttpServletRequest multiRequest,
										   @RequestParam(name="labelSn") String labelSn,
										   @RequestParam(name="goodsId") String goodsId) {
		JsonResult jsonResult = new JsonResult();

		try {
			final MultipartFile file = multiRequest.getFile("atchFile");
			jsonResult.setSuccess(true);
			GoodsLabelVO goodsLabelVO = new GoodsLabelVO();
			goodsLabelVO.setGoodsId(goodsId);
			goodsLabelVO.setLabelCn(labelSn);
			goodsLabelVO = goodsLabelService.selectGoodsLabel(goodsLabelVO);
			if(goodsLabelVO !=null)goodsLabelService.deleteGoodsLabel(goodsLabelVO);
			jsonResult.put("fileMap", fileMngUtil.parseGoodsLabelFile(file, labelSn)); // ?????? ???????????????

		} catch(Exception e) {
			loggerError(LOGGER, e);
			jsonResult.setSuccess(false);
			jsonResult.setMessage(egovMessageSource.getMessage("errors.file.transfer")); //??????????????? ????????? ??????????????????.
		}

		return jsonResult;
	}


	@RequestMapping(value = "/decms/shop/goods/modifyMultipleGoods.json", method = RequestMethod.POST)
	@ResponseBody
	public JsonResult modifyMultipleGoods(HttpServletRequest req) {
		JsonResult jsonResult = new JsonResult();

		String[] goodsIds = req.getParameterValues("goodsIds[]");
		String action = req.getParameter("action");

		try {
			for (String goodsId : goodsIds) {
				GoodsVO goods = new GoodsVO();
				goods.setGoodsId(goodsId);
				goods.setRegistSttusCode(action);
				goodsService.updateGoodsRegistSttus(goods);
			}

			jsonResult.setSuccess(true);
			jsonResult.setMessage(egovMessageSource.getMessage("success.common.update")); //??????????????? ?????????????????????.

		} catch(Exception e) {
			loggerError(LOGGER, e);
			jsonResult.setSuccess(false);
			jsonResult.setMessage(egovMessageSource.getMessage("fail.common.update")); //????????? ?????????????????????.
		}

		return jsonResult;
	}

	@RequestMapping(value="/decms/shop/goods/selectMainGoodsMaxSn.json")
	@ResponseBody
	public JsonResult selectMainGoodsCnt(HttpServletRequest req,@RequestParam(name = "searchGoodsCtgryId",required = true) String searchGoodsCtgryId){
		JsonResult jsonResult = new JsonResult();

		try {
			GoodsVO goodsVO = new GoodsVO();
			goodsVO.setSearchGoodsCtgryId(searchGoodsCtgryId);
			int mainGoodsMaxSn = goodsService.selectMainGoodsMaxSn(goodsVO);

			jsonResult.put("mainGoodsMaxSn",mainGoodsMaxSn);
			jsonResult.put("success",true);

		}catch (Exception e){
			e.printStackTrace();
			jsonResult.put("success",false);
		}
		return jsonResult;
	}
}
