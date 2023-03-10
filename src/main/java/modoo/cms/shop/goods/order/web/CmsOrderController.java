package modoo.cms.shop.goods.order.web;

import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
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
import org.springframework.web.servlet.ModelAndView;

import egovframework.com.cmm.ComDefaultCodeVO;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.CmmnDetailCode;
import egovframework.com.cmm.service.EgovCmmUseService;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import modoo.module.biztalk.service.BiztalkService;
import modoo.module.biztalk.service.BiztalkVO;
import modoo.module.common.service.JsonResult;
import modoo.module.common.web.CommonDefaultController;
import modoo.module.shop.cmpny.service.CmpnyService;
import modoo.module.shop.cmpny.service.CmpnyVO;
import modoo.module.shop.goods.ctgry.service.GoodsCtgryService;
import modoo.module.shop.goods.dlvy.service.OrderDlvyService;
import modoo.module.shop.goods.dlvy.service.OrderDlvyVO;
import modoo.module.shop.goods.hist.service.OrderReqHistService;
import modoo.module.shop.goods.info.service.GoodsCouponService;
import modoo.module.shop.goods.info.service.GoodsCouponVO;
import modoo.module.shop.goods.info.service.GoodsService;
import modoo.module.shop.goods.info.service.GoodsVO;
import modoo.module.shop.goods.order.service.OrderService;
import modoo.module.shop.goods.order.service.OrderVO;
import modoo.module.shop.goods.setle.service.OrderSetleService;
import modoo.module.system.log.conect.service.ConectLogVO;

@Controller("CmsOrderController")
public class CmsOrderController extends CommonDefaultController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(CmsOrderController.class);
	
	@Resource(name = "orderService")
	OrderService orderService;
	
	@Resource(name = "orderSetleService")
	OrderSetleService orderSetleService;
	
	@Resource(name = "orderDlvyService")
	OrderDlvyService orderDlvyService;
	
	@Resource(name = "goodsService")
	GoodsService goodsService;
	
	@Resource(name = "goodsCouponService")
	GoodsCouponService goodsCouponService;
	
	@Resource(name = "goodsCtgryService")
	GoodsCtgryService goodsCtgryService;
	
	@Resource(name="EgovCmmUseService")
	private EgovCmmUseService cmmUseService;
	
	@Resource(name="orderReqHistService")
	private OrderReqHistService orderReqHistService;
	
	@Resource(name = "biztalkService")
	private BiztalkService biztalkService;
	
	@Resource(name = "cmpnyService")
	private CmpnyService cmpnyService;

	/**
	 * ??????/??????
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/decms/shop/goods/orderDlvyManage.do")
	public String orderDlvyManage(@ModelAttribute("searchVO") OrderDlvyVO searchVO, Model model) throws Exception {
		ComDefaultCodeVO vo = new ComDefaultCodeVO();

		vo.setCodeId("CMS026");
		List<CmmnDetailCode> setleSttusCodeList = cmmUseService.selectCmmCodeDetail(vo);
		vo.setCodeId("CMS022");
		List<CmmnDetailCode> dlvySttusCodeList = cmmUseService.selectCmmCodeDetail(vo);
		vo.setCodeId("CMS021");
		List<CmmnDetailCode> orderSttusCodeList = cmmUseService.selectCmmCodeDetail(vo);
		
		model.addAttribute("setleSttusCodeList", setleSttusCodeList);
		model.addAttribute("dlvySttusCodeList", dlvySttusCodeList);
		model.addAttribute("orderSttusCodeList", orderSttusCodeList);

		return "modoo/cms/shop/goods/dlvy/orderDlvyManage";
	}
	
	/**
	 * ???????????? ?????? ??????
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/decms/shop/goods/orderDlvyHist.do")
	public String orderDlvyHist() throws Exception {

		return "modoo/cms/shop/goods/dlvy/orderDlvyHist";
	}
	
	/**
	 * ????????????
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/decms/shop/goods/orderStopManage.do")
	public String orderStopManage() throws Exception {

		return "modoo/cms/shop/goods/order/orderStopManage";
	}
	
	/**
	 * ????????????
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/decms/shop/goods/orderCancelManage.do")
	public String orderCancelManage() throws Exception {

		return "modoo/cms/shop/goods/order/orderCancelManage";
	}
	
	/**
	 * ????????????
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/decms/shop/goods/orderExchangeManage.do")
	public String orderExchangeManage() throws Exception {

		return "modoo/cms/shop/goods/order/orderExchangeManage";
	}
	
	/**
	 * ????????????
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/decms/shop/goods/orderRecallManage.do")
	public String orderRecallManage() throws Exception {

		return "modoo/cms/shop/goods/order/orderRecallManage";
	}

	/**
	 * ????????????
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/decms/shop/goods/orderFailManage.do")
	public String orderFailManage() throws Exception {

		return "modoo/cms/shop/goods/order/orderFailManage";
	}


	/**
	 * ??????/?????? > ?????? ??????
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/decms/shop/goods/getOrderStatusList.json")
	@ResponseBody
	public JsonResult getOrderStatusList(OrderDlvyVO searchVO,
			@RequestParam(name="searchGoodsCtgryId1", required = false) String searchCateCode1,
			@RequestParam(name="searchGoodsCtgryId2", required = false) String searchCateCode2,
			@RequestParam(name="searchGoodsCtgryId3", required = false) String searchCateCode3) throws Exception {
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		JsonResult jsonResult = new JsonResult();
		try {
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

				PaginationInfo paginationInfo = new PaginationInfo();
				searchVO.setPageUnit(propertiesService.getInt("gridPageUnit"));
				this.setPagination(paginationInfo, searchVO);
				
				List<?> resultList = orderDlvyService.selectOrderDlvyList(searchVO);
				jsonResult.put("list",  resultList);
				
				int totalRecordCount = orderDlvyService.selectOrderDlvyListCnt(searchVO);
				paginationInfo.setTotalRecordCount(totalRecordCount);
				jsonResult.put("paginationInfo", paginationInfo);

				// ????????????
				searchVO.setSearchSetleSttusCode("S");
				int cntSettle = orderDlvyService.selectOrderDlvyListCnt(searchVO);
				jsonResult.put("cntSettle", cntSettle);
				
				/* ???????????? */
				searchVO.setSearchSetleSttusCode(null);
				// ???????????????
				searchVO.setSearchDlvySttusCode("DLVY00");
				searchVO.setSearchSetleSttusCode("S");
				int cntDlvy = orderDlvyService.selectOrderDlvyListCnt(searchVO);
				jsonResult.put("cntDlvy", cntDlvy);
				
				// ???????????????
				searchVO.setSearchDlvySttusCode("DLVY01");
				searchVO.setSearchSetleSttusCode("S");
				int cntDlvy1 = orderDlvyService.selectOrderDlvyListCnt(searchVO);
				jsonResult.put("cntDlvy1", cntDlvy1);
				
				// ?????????
				searchVO.setSearchDlvySttusCode("DLVY02");
				searchVO.setSearchSetleSttusCode("S");
				int cntDlvy2 = orderDlvyService.selectOrderDlvyListCnt(searchVO);
				jsonResult.put("cntDlvy2", cntDlvy2);
				
				// ????????????
				searchVO.setSearchDlvySttusCode("DLVY03");
				searchVO.setSearchSetleSttusCode("S");
				int cntDlvy3 = orderDlvyService.selectOrderDlvyListCnt(searchVO);
				jsonResult.put("cntDlvy3", cntDlvy3);
				
				searchVO.setSearchDlvySttusCode(null);
				searchVO.setSearchSetleSttusCode("S");
				EgovMap stat = orderDlvyService.selectOrderStat(searchVO);
				//????????????
				jsonResult.put("orderCnt", stat.get("cnt"));
				//????????????
				jsonResult.put("orderAmount", stat.get("setleTotAmount"));
				
				jsonResult.setSuccess(true);
			}
		}catch(Exception e) {
			loggerError(LOGGER, e);
			jsonResult.setSuccess(false);
			jsonResult.setMessage(egovMessageSource.getMessage("fail.common.select")); //????????? ?????????????????????
		}
		
		return jsonResult;
	}
	
	@RequestMapping(value = "/decms/shop/goods/getOrderStatusListExcel.do")
	public ModelAndView getOrderStatusListExcel(@ModelAttribute("searchVO") OrderDlvyVO searchVO,
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
		List<?> resultList = orderDlvyService.selectOrderDlvyList(searchVO);
		map.put("dataList", resultList);
		map.put("template", "goods_order_dlvy_list.xlsx");
		map.put("fileName", "????????????");
		
		return new ModelAndView("commonExcelView", map);
	}
	
	
	/**
	 * ?????? ?????? > ??????/?????? > ????????? ????????????
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	
	@ResponseBody
	@RequestMapping(value = "/decms/shop/goods/getOrderDlvyHist.json", method=RequestMethod.POST)
	public JsonResult getOrderDlvyHist(OrderDlvyVO searchVO,
			@RequestParam(name="searchCateCode1", required = false) String searchCateCode1,
			@RequestParam(name="searchCateCode2", required = false) String searchCateCode2,
			@RequestParam(name="searchCateCode3", required = false) String searchCateCode3) throws Exception {
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		JsonResult jsonResult = new JsonResult();
		
		try {
			if(!EgovUserDetailsHelper.getAuthorities().contains("ROLE_EMPLOYEE")) {
				if(StringUtils.isEmpty(user.getCmpnyId())) { //?????? ????????? ????????? ?????????.
					jsonResult.setMessage(egovMessageSource.getMessage("cms.fail.not.cmpnyId")); //??????????????? ???????????????.
					jsonResult.setSuccess(false);
					return jsonResult;
				}
				searchVO.setSearchCmpnyId(user.getCmpnyId());
			}
			
			if(StringUtils.isNotEmpty(searchCateCode3)) {
				searchVO.setSearchGoodsCtgryId(searchCateCode3);
			}else if(StringUtils.isNotEmpty(searchCateCode2)) {
				searchVO.setSearchGoodsCtgryId(searchCateCode2);
			}else if(StringUtils.isNotEmpty(searchCateCode1)) {
				searchVO.setSearchGoodsCtgryId(searchCateCode1);
			}

			PaginationInfo paginationInfo = new PaginationInfo();
			searchVO.setPageUnit(propertiesService.getInt("gridPageUnit"));
			this.setPagination(paginationInfo, searchVO);

			List<?> resultList = orderDlvyService.selectOrderDlvyHist(searchVO);
			jsonResult.put("list",  resultList);
			
			int totalRecordCount = orderDlvyService.selectOrderDlvyHistCnt(searchVO);
			paginationInfo.setTotalRecordCount(totalRecordCount);
			jsonResult.put("paginationInfo", paginationInfo);
			
			jsonResult.setSuccess(true);
			
		}catch(Exception e) {
			loggerError(LOGGER, e);
			jsonResult.setSuccess(false);
			jsonResult.setMessage(egovMessageSource.getMessage("fail.common.select")); //????????? ?????????????????????
		}
		
		return jsonResult;
	}
	
	/**
	 * ?????? ?????? ??????
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	
	@ResponseBody
	@RequestMapping(value = "/decms/shop/goods/getOrderItems.json", method=RequestMethod.POST)
	public JsonResult getOrderItems(OrderVO searchVO) throws Exception {
		EgovUserDetailsHelper.getAuthenticatedUser();
		JsonResult jsonResult = new JsonResult();

		try {
			List<?> resultList = orderService.selectOrderItemList(searchVO);
			jsonResult.put("list",  resultList);			
			jsonResult.setSuccess(true);
			
		}catch(Exception e) {
			loggerError(LOGGER, e);
			jsonResult.setSuccess(false);
			jsonResult.setMessage(egovMessageSource.getMessage("fail.common.select")); //????????? ?????????????????????
		}
		
		return jsonResult;
	}
	
	/**
	 * ?????? ?????? ??????
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	
	@ResponseBody
	@RequestMapping(value = "/decms/shop/goods/getOrderCoupon.json", method=RequestMethod.POST)
	public JsonResult getOrderCoupon(OrderVO searchVO) throws Exception {
		EgovUserDetailsHelper.getAuthenticatedUser();
		JsonResult jsonResult = new JsonResult();

		try {
			GoodsCouponVO goodsCoupon = new GoodsCouponVO();
			goodsCoupon.setOrderNo(searchVO.getOrderNo());
			List<?> resultList = goodsCouponService.selectGoodsCouponList(goodsCoupon);
			jsonResult.put("list",  resultList);			
			jsonResult.setSuccess(true);
			
		}catch(Exception e) {
			loggerError(LOGGER, e);
			jsonResult.setSuccess(false);
			jsonResult.setMessage(egovMessageSource.getMessage("fail.common.select")); //????????? ?????????????????????
		}
		
		return jsonResult;
	}
	
	
	/**
	 * ????????????????????? ????????????????????? ??????
	 * @param searchVO
	 * @param bindingResult
	 * @return
	 */
	
	@ResponseBody
	@RequestMapping(value = "/decms/shop/goods/modifyDlvyStatus.do", method = RequestMethod.POST)
	public JsonResult modifyDlvyStatus(OrderDlvyVO searchVO, BindingResult bindingResult) {
		JsonResult jsonResult = new JsonResult();
		
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		searchVO.setLastUpdusrId(user.getUniqId());
		
		if (searchVO.getInvcNo() != null) {
			searchVO.setInvcNo(searchVO.getInvcNo().replaceAll("-", ""));
		}

		try {
			if(!this.isHasErrorsJson(bindingResult, jsonResult, "<br/>")) {
				orderDlvyService.updateDlvySttusCode(searchVO);
				jsonResult.setSuccess(true);
				jsonResult.setMessage(egovMessageSource.getMessage("success.common.update")); //????????? ?????????????????????.
			}
		} catch(Exception e) {
			LOGGER.error("Exception : " + e);
			e.printStackTrace();
			jsonResult.setSuccess(false);
			jsonResult.setMessage(egovMessageSource.getMessage("fail.common.update")); //????????? ?????????????????????.
		}
		
		return jsonResult;
	}
	
	/**
	 * ?????? ?????????????????? ??????
	 * @param searchVO
	 * @param bindingResult
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/decms/shop/goods/modifyExchangeStatus.do", method = RequestMethod.POST)
	public JsonResult modifyExchangeStatus(OrderDlvyVO searchVO, BindingResult bindingResult) {
		JsonResult jsonResult = new JsonResult();

		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		searchVO.setLastUpdusrId(user.getUniqId());
		
		try {
			if(!this.isHasErrorsJson(bindingResult, jsonResult, "<br/>")) {
				orderDlvyService.updateExchangeStatus(searchVO);
				jsonResult.setSuccess(true);
				jsonResult.setMessage(egovMessageSource.getMessage("success.common.update")); //????????? ?????????????????????.
			}
		} catch(Exception e) {
			LOGGER.error("Exception : " + e);
			jsonResult.setSuccess(false);
			jsonResult.setMessage(egovMessageSource.getMessage("fail.common.update")); //????????? ?????????????????????.
		}
		
		return jsonResult;
	}
	
	/**
	 * ???????????? ??????
	 * @param searchVO
	 * @param bindingResult
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/decms/shop/goods/modifyInvcNo.do", method = RequestMethod.POST)
	public JsonResult modifyInvcNo(OrderDlvyVO searchVO, BindingResult bindingResult) {
		JsonResult jsonResult = new JsonResult();
		
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		searchVO.setLastUpdusrId(user.getUniqId());
		searchVO.setDlvySttusCode("DLVY02");
		
		if (searchVO.getInvcNo() != null) {
			searchVO.setInvcNo(searchVO.getInvcNo().replaceAll("-", ""));
		}

		try {
			if(!this.isHasErrorsJson(bindingResult, jsonResult, "<br/>")) {
				orderDlvyService.updateInvcNo(searchVO);
				jsonResult.setSuccess(true);
				jsonResult.setMessage(egovMessageSource.getMessage("success.common.update")); //????????? ?????????????????????.

				/* ???????????? ?????? ????????? */
				OrderDlvyVO dlvyInfo = orderDlvyService.selectOrderDlvyByDlvyNo(searchVO);
				
				OrderVO orderVO = new OrderVO();
				orderVO.setOrderNo(dlvyInfo.getOrderNo());
				OrderVO orderInfo = orderService.selectOrder(orderVO);
				
				GoodsVO goods = new GoodsVO();
				goods.setGoodsId(orderInfo.getGoodsId());
				GoodsVO goodsInfo = goodsService.selectGoods(goods);

				BiztalkVO bizTalk = new BiztalkVO();
				bizTalk.setRecipient(orderInfo.getTelno());
				bizTalk.setTmplatCode("template_026");
				/*[????????? ??????] ???????????? ??????
				 * 
				 *???????????? ????????? ????????? ?????????????????????.
				 *
				 *???????????? : #{ORDERDE}
				 *???????????? : #{ORDERNO}
				 *????????? : #{PRODUCTNM}
				 *????????? : #{DLVYCMPNY}
				 *??????????????? : #{INVCNO}
				 */
				BiztalkVO template = biztalkService.selectBizTalkTemplate(bizTalk);
				String message = template.getTmplatCn();
				SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
				String orderDe = format.format(orderInfo.getOrderPnttm());
				message = message.replaceAll("#\\{ORDERDE\\}", orderDe);
				message = message.replaceAll("#\\{ORDERNO\\}", String.valueOf(orderInfo.getOrderNo()));
				message = message.replaceAll("#\\{PRODUCTNM\\}", goodsInfo.getGoodsNm());
				message = message.replaceAll("#\\{DLVYCMPNY\\}", goodsInfo.getHdryNm());
				message = message.replaceAll("#\\{INVCNO\\}", searchVO.getInvcNo());
				bizTalk.setMessage(message);
				
				BiztalkVO result = biztalkService.sendAlimTalk(bizTalk);
			}
			
		} catch(Exception e) {
			LOGGER.error("Exception : " + e);
			e.printStackTrace();
			jsonResult.setSuccess(false);
			jsonResult.setMessage(egovMessageSource.getMessage("fail.common.update")); //????????? ?????????????????????.
		}
		
		return jsonResult;
	}
	
	/**
	 * ??????, ??????, ?????? ????????????
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */

	@ResponseBody
	@RequestMapping(value = "/decms/shop/goods/getOrderReqList.json", method=RequestMethod.POST)
	public JsonResult getOrderCancelList(OrderDlvyVO searchVO) throws Exception {
		JsonResult jsonResult = new JsonResult();
		
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if (user != null) {
			searchVO.setSearchCmpnyId(user.getCmpnyId());
		}
		
		PaginationInfo paginationInfo = new PaginationInfo();

		this.setPagination(paginationInfo, searchVO);
		
		int totalRecordCount = orderDlvyService.selectOrderReqListCnt(searchVO); // ?????? ?????????
		paginationInfo.setTotalRecordCount(totalRecordCount);
		jsonResult.put("paginationInfo", paginationInfo);

		List<?> orderReqList = orderDlvyService.selectOrderReqList(searchVO);
		jsonResult.put("list", orderReqList);
		
		searchVO.setSearchListType(null);
		searchVO.setSearchReqTyCode("C01");
		int cancel01 = orderDlvyService.selectOrderReqListCnt(searchVO); //????????????????????????
		searchVO.setSearchReqTyCode("C02");
		int cancel02 = orderDlvyService.selectOrderReqListCnt(searchVO); //????????????????????????
		//searchVO.setSearchReqTyCode("C03");
		//int cancel03 = orderDlvyService.selectOrderReqListCnt(searchVO); //????????????????????????
		searchVO.setSearchReqTyCode("C04");
		int cancel04 = orderDlvyService.selectOrderReqListCnt(searchVO); //????????????????????????
		
		searchVO.setSearchReqTyCode("E01");
		int exchange01 = orderDlvyService.selectOrderReqListCnt(searchVO); //????????????????????????
		searchVO.setSearchReqTyCode("E02");
		int exchange02 = orderDlvyService.selectOrderReqListCnt(searchVO); //????????????????????????
		//searchVO.setSearchReqTyCode("E03");
		//int exchange03 = orderDlvyService.selectOrderDlvyListCnt(searchVO); //????????????????????????
		searchVO.setSearchReqTyCode("E04");
		int exchange04 = orderDlvyService.selectOrderReqListCnt(searchVO); //?????????????????????
		searchVO.setSearchReqTyCode("E05");
		int exchange05 = orderDlvyService.selectOrderReqListCnt(searchVO); //??????????????????
		
		searchVO.setSearchReqTyCode("R01");
		int recall01 = orderDlvyService.selectOrderReqListCnt(searchVO); //??????(??????)????????????
		//searchVO.setSearchReqTyCode("R02");
		//int recall02 = orderDlvyService.selectOrderReqListCnt(searchVO); //??????(??????)????????????
		//searchVO.setSearchReqTyCode("R03");
		//int recall03 = orderDlvyService.selectOrderReqListCnt(searchVO); //??????(??????)????????????
		searchVO.setSearchReqTyCode("R05");
		int recall04 = orderDlvyService.selectOrderReqListCnt(searchVO); //??????(??????)????????????
		
		searchVO.setSearchListType("STOP");
		searchVO.setSearchReqTyCode("T01");
		int stopReq = orderDlvyService.selectOrderReqListCnt(searchVO); // ???????????? ?????? ??????
		searchVO.setSearchReqTyCode("T02");
		int stopComplete = orderDlvyService.selectOrderReqListCnt(searchVO); // ???????????? ?????? ??????
		
		jsonResult.put("cancel01", cancel01);
		jsonResult.put("cancel02", cancel02);
		jsonResult.put("cancel04", cancel04);
		jsonResult.put("exchange01", exchange01);
		jsonResult.put("exchange02", exchange02);
		jsonResult.put("exchange04", exchange04);
		jsonResult.put("exchange05", exchange05);
		jsonResult.put("recall01", recall01);
		jsonResult.put("recall04", recall04);
		jsonResult.put("stopReq", stopReq);
		jsonResult.put("stopComplete", stopComplete);
		
		return jsonResult;
	}
	
	/**
	 * ??????, ??????, ?????? ?????? ?????? ??? ?????? ??????
	 * @param searchVO
	 * @param bindingResult
	 * @return
	 */
	
	@ResponseBody
	@RequestMapping(value = "/decms/shop/goods/modifyProcessStatus.do", method = RequestMethod.POST)
	public JsonResult modifyProcessStatus(HttpServletRequest req, OrderDlvyVO searchVO, BindingResult bindingResult) {

		/*2022-02-17 ?????? ?????? ??????
		JsonResult jsonResult = new JsonResult();
		
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		searchVO.setLastUpdusrId(user.getUniqId());
		OrderVO orderVO = new OrderVO();
		orderVO.setOrderNo(searchVO.getOrderNo());
		
		*//* ????????? ?????? ??????(????????? ?????? ????????????) *//*
		String mobileYn = "";
		String userAgent = req.getHeader("User-Agent").toUpperCase();
		
	    if(userAgent.indexOf("MOBILE") > -1) {
	        if(userAgent.indexOf("PHONE") == -1){
	        	mobileYn = "Y"; 
	        } else {
				mobileYn = "Y"; 
			}
	    } else {
	    	mobileYn = "N";
	    }
		
		try {
			
			if(!this.isHasErrorsJson(bindingResult, jsonResult, "<br/>")) {
				orderDlvyService.modifyProcessStatus(searchVO, mobileYn);
				jsonResult.setSuccess(true);
				jsonResult.setMessage(egovMessageSource.getMessage("success.common.update")); //????????? ?????????????????????.

				*//* ?????????????????? ????????? *//*
				System.out.println("-------------"+orderVO.toString());
				OrderVO orderInfo = orderService.selectOrder(orderVO);
				GoodsVO goods = new GoodsVO();
				goods.setGoodsId(orderInfo.getGoodsId());
				GoodsVO goodsInfo = goodsService.selectGoods(goods);
				
				BiztalkVO bizTalk = new BiztalkVO();
				
				if ("C04".equals(searchVO.getReqTyCode())) {
					bizTalk.setTmplatCode("template_003");
					*//* [???????????????] ????????? ?????????????????????.
					 * ???????????? : #{PRICE}
					 * ????????? : #{PRODUCTNAME}
					 *//*
				} else if ("E05".equals(searchVO.getReqTyCode())) { 
					bizTalk.setTmplatCode("template_007");
				} else if ("R05".equals(searchVO.getReqTyCode())) { 
					bizTalk.setTmplatCode("template_009");
				}
				BiztalkVO template = biztalkService.selectBizTalkTemplate(bizTalk);
				String message = template.getTmplatCn();
				message = message.replaceAll("#\\{PRICE\\}", String.valueOf(orderInfo.getTotAmount())+"???").replaceAll("#\\{PRODUCTNAME\\}", goodsInfo.getGoodsNm());
				message = message.replaceAll("#\\{TEL\\}", String.valueOf(goodsInfo.getCmpnyTelno()));
				bizTalk.setRecipient(orderInfo.getTelno());
				bizTalk.setMessage(message);
				
				BiztalkVO result = biztalkService.sendAlimTalk(bizTalk);
				
				if ("C04".equals(searchVO.getReqTyCode())) {			
					*//* ?????????????????? CP ????????? *//*
					CmpnyVO cmpny = new CmpnyVO();
					cmpny.setCmpnyId(goodsInfo.getCmpnyId());
					CmpnyVO cmpnyInfo = cmpnyService.selectCmpny(cmpny);
					
					bizTalk.setRecipient(cmpnyInfo.getChargerTelno());
					bizTalk.setTmplatCode("template_027");
					BiztalkVO templateCp = biztalkService.selectBizTalkTemplate(bizTalk);
					String messageCp = templateCp.getTmplatCn();
					messageCp = messageCp.replaceAll("#\\{PRODUCTNO\\}", String.valueOf(goodsInfo.getGoodsId())).replaceAll("#\\{PRODUCTNAME\\}", goodsInfo.getGoodsNm());
					messageCp = messageCp.replaceAll("#\\{CUSTOMER\\}", String.valueOf(orderInfo.getOrdrrNm()));
					messageCp = messageCp.replaceAll("#\\{TEL\\}", String.valueOf(goodsInfo.getCmpnyTelno()));
					bizTalk.setMessage(messageCp);
					*//* [???????????????] ????????? ?????????????????????. ????????? ????????? CP ????????? ???????????? [??????] ???????????? ???????????? ??? ????????????.
					* ???????????? : #{PRODUCTNO}
					* ????????? : #{PRODUCTNAME}
					* ????????? : #{CUSTOMER} (#{TEL})
					 *//*
					BiztalkVO resultCp = biztalkService.sendAlimTalk(bizTalk);
				}
				
			}
		} catch(Exception e) {
			LOGGER.error("Exception : " + e);
			jsonResult.setSuccess(false);
			jsonResult.setMessage(egovMessageSource.getMessage("fail.common.update")); //????????? ?????????????????????.
		}
		
		return jsonResult;*/

		JsonResult jsonResult = new JsonResult();
		searchVO.setClientIp(req.getRemoteAddr());
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		searchVO.setLastUpdusrId(user.getUniqId());
		OrderVO orderVO = new OrderVO();
		orderVO.setOrderNo(searchVO.getOrderNo());

		/* ????????? ?????? ??????(????????? ?????? ????????????) */
		String mobileYn = "";
		String userAgent = req.getHeader("User-Agent").toUpperCase();

		if(userAgent.indexOf("MOBILE") > -1) {
			if(userAgent.indexOf("PHONE") == -1){
				mobileYn = "Y";
			} else {
				mobileYn = "Y";
			}
		} else {
			mobileYn = "N";
		}

		try {

			if(!this.isHasErrorsJson(bindingResult, jsonResult, "<br/>")) {
				orderDlvyService.modifyProcessStatus(req, searchVO, mobileYn, jsonResult);
				jsonResult.setSuccess(true);
				jsonResult.setMessage(egovMessageSource.getMessage("success.common.update")); //????????? ?????????????????????.

				System.out.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ jsonResult Data:" + jsonResult.getData().toString());

				if ("C".equals(jsonResult.getData().get("setleSttusCode"))) {
					jsonResult.setMessage("?????? ????????? ?????? ??????????????? ??????????????? ?????????????????????. ????????? ????????? ????????? ?????? ???????????? ?????? 3~5????????? ????????? ????????? ???????????????.");

				/*	*//* ?????????????????? ????????? *//*
					//System.out.println("-------------"+orderVO.toString());
					OrderVO orderInfo = orderService.selectOrder(orderVO);
					GoodsVO goods = new GoodsVO();
					goods.setGoodsId(orderInfo.getGoodsId());
					GoodsVO goodsInfo = goodsService.selectGoods(goods);

					BiztalkVO bizTalk = new BiztalkVO();

					if ("C04".equals(searchVO.getReqTyCode())) {
						bizTalk.setTmplatCode("template_005");
						*//* 	[???????????????] ????????? ?????????????????????.
						 * ????????? : #{PRODUCTNAME}
						 *//*
					} else if ("E05".equals(searchVO.getReqTyCode())) {
						bizTalk.setTmplatCode("template_007");
					} else if ("R05".equals(searchVO.getReqTyCode())) {
						bizTalk.setTmplatCode("template_009");
					}
					BiztalkVO template = biztalkService.selectBizTalkTemplate(bizTalk);
					String message = template.getTmplatCn();
					message = message.replaceAll("#\\{PRICE\\}", String.valueOf(orderInfo.getTotAmount())+"???").replaceAll("#\\{PRODUCTNAME\\}", goodsInfo.getGoodsNm());
					message = message.replaceAll("#\\{TEL\\}", String.valueOf(goodsInfo.getCmpnyTelno()));
					bizTalk.setRecipient(orderInfo.getTelno());
					bizTalk.setMessage(message);

					BiztalkVO result = biztalkService.sendAlimTalk(bizTalk);

					*//** ???????????? ????????? **//*
					*//**
					 * [???????????????] ????????? ?????????????????????.
					 * ???????????? : #{PRICE}
					 * ????????????: #{ORDERNO}
					 *//*
					bizTalk.setTmplatCode("template_030");
					BiztalkVO template2 = biztalkService.selectBizTalkTemplate(bizTalk);
					message = template2.getTmplatCn();
					message = message.replaceAll("#\\{PRICE\\}", String.valueOf(orderInfo.getTotAmount())+"???").replaceAll("#\\{PRODUCTNAME\\}", goodsInfo.getGoodsNm());
					message = message.replaceAll("#\\{ORDERNO\\}", String.valueOf(orderInfo.getOrderNo()));
					bizTalk.setRecipient(orderInfo.getTelno());
					bizTalk.setMessage(message);
					BiztalkVO result2 = biztalkService.sendAlimTalk(bizTalk);

					if ("C04".equals(searchVO.getReqTyCode())) {
						*//* ?????????????????? CP ????????? *//*
						CmpnyVO cmpny = new CmpnyVO();
						cmpny.setCmpnyId(goodsInfo.getCmpnyId());
						CmpnyVO cmpnyInfo = cmpnyService.selectCmpny(cmpny);

						bizTalk.setRecipient(cmpnyInfo.getChargerTelno());
						bizTalk.setTmplatCode("template_034");
						BiztalkVO templateCp = biztalkService.selectBizTalkTemplate(bizTalk);
						String messageCp = templateCp.getTmplatCn();
						messageCp = messageCp.replaceAll("#\\{PRODUCTNAME\\}", goodsInfo.getGoodsNm());
						bizTalk.setMessage(messageCp);
						*//**
						 * [???????????????] ????????? ?????????????????????.
						 * (???????????? ????????? ?????? ????????? ?????? ?????? ?????? ?????? ???????????? ????????? ???????????????.)
						 * * ????????? : #{PRODUCTNAME}
						 *//*
						BiztalkVO resultCp = biztalkService.sendAlimTalk(bizTalk);
					}*/
				}

			}
		} catch(Exception e) {
			LOGGER.error("Exception : " + e);
			e.printStackTrace();
			jsonResult.setSuccess(false);
			jsonResult.setMessage(egovMessageSource.getMessage("fail.common.update")); //????????? ?????????????????????.
		}

		return jsonResult;
	}
	
	@ResponseBody
	@RequestMapping(value = "/decms/shop/goods/getOrderItemList.json", method=RequestMethod.POST)
	public JsonResult getOrderItemList(OrderDlvyVO searchVO) throws Exception {
		JsonResult jsonResult = new JsonResult();
		
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if (user != null) {
			searchVO.setSearchCmpnyId(user.getCmpnyId());	
		}

		List<?> orderReqList = orderDlvyService.selectOrderDlvyList(searchVO);
		jsonResult.put("list", orderReqList);
		
		return jsonResult;
	}

	/**
	 * ???????????? -> ??????????????? ??????
	 * @param dateVal
	 * @param orderNo
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "/decms/shop/goods/nextOrderDt.json", method=RequestMethod.POST)
	public JsonResult orderDtModify(@RequestParam(name="dateVal",required = true) String dateVal,
									@RequestParam(name= "orderNo",required = true) String orderNo) throws Exception {
		JsonResult jsonResult = new JsonResult();
		try {

			EgovMap map = new EgovMap();

			map.put("orderNo",orderNo);
			map.put("dateVal",dateVal);

			orderService.updateSbsNextDt(map);

			jsonResult.setSuccess(true);
			jsonResult.setMessage("?????????????????????.");

		}catch (Exception e){
			e.printStackTrace();
			jsonResult.setSuccess(false);
			jsonResult.setMessage("????????? ?????????????????????.");
		}

		return jsonResult;
	}

	/**
	 * ??????, ?????? ?????? ??????
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/decms/shop/goods/orderReason.do")
	public String orderReason() throws Exception {

		return "modoo/cms/shop/goods/order/orderReason";
	}
	
	/**
	 * ????????? ?????? ?????????
	 * @param codeId
	 * @param code
	 * @return
	 * @throws Exception
	 */
	
	public String getCodeNm(String codeId, String code) throws Exception {
		
		HashMap<String, String> codeMap = new HashMap<String, String>();
		ComDefaultCodeVO vo = new ComDefaultCodeVO();
		vo.setCodeId(codeId);
		vo.setCode(code);
		List<?> codeList = cmmUseService.selectCmmCodeDetail(vo);

		for (int i = 0; i<codeList.size(); i++) {
			CmmnDetailCode codeItem = (CmmnDetailCode) codeList.get(i);
			codeMap.put(codeItem.getCode(), codeItem.getCodeNm());
		}
		
		String codeNm = codeMap.get(code);
		
		return codeNm;
	}
	
}
